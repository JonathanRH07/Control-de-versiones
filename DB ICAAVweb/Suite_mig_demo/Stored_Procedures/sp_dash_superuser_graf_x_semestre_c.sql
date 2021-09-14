DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_superuser_graf_x_semestre_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    IN	pr_id_idioma						INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_superuser_graf_x_semestre_c
	@fecha:			20/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por mes
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_moneda_reporte				VARCHAR(255);
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_ventas_graf_x_semestre_c';
	END ;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	/* DESARROLLO */
    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* BORRAMOS LAS TABLAS TEMPORALES */
    DROP TABLE IF EXISTS tmp_comisiones_ingreso;
    DROP TABLE IF EXISTS tmp_comisiones_egreso;
    DROP TABLE IF EXISTS tmp_comisiones;
    DROP TABLE IF EXISTS tmp_cxs_ingreso;
    DROP TABLE IF EXISTS tmp_cxs_egreso;
    DROP TABLE IF EXISTS tmp_cxs;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
	/* COMISIONES INGRESO */
	SET @querycomis_ing = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_comisiones_ingreso
					SELECT
						DATE_FORMAT(NOW(), ''%Y'') anio_actual,
						mes.mes,
                        IFNULL(SUM(IFNULL(comision_agencia',lo_moneda_reporte,', 0)), 0) importe_comision,
                        mes.num_mes
					FROM
					(SELECT
						fac.*,
						det.comision_agencia,
						det.tarifa_moneda_base,
						det.comision_titular,
                        det.comision_auxiliar
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
                    AND serv.id_producto != 5
					AND fac.estatus != 2
                    AND serv.estatus = 1
					AND tipo_cfdi = ''I''
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(NOW(), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), ''%Y-%m'')
                    ORDER BY fac.fecha_factura ASC ) a
					JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(a.fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes');

	-- SELECT @querycomis_ing;
	PREPARE stmt FROM @querycomis_ing;
	EXECUTE stmt;

    /* COMISIONES EGRESO */
	SET @querycomis_eg = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_comisiones_egreso
					SELECT
						DATE_FORMAT(NOW(), ''%Y'') anio_actual,
						mes.mes,
						IFNULL(SUM(IFNULL(comision_agencia',lo_moneda_reporte,', 0)), 0) importe_comision
					FROM
					(SELECT
						fac.*,
						det.comision_agencia,
						det.tarifa_moneda_base,
						det.comision_titular,
                        det.comision_auxiliar
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
                    AND serv.id_producto != 5
					AND fac.estatus != 2
                    AND serv.estatus = 1
					AND tipo_cfdi = ''E''
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(NOW(), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), ''%Y-%m'')
                    ORDER BY fac.fecha_factura ASC ) a
					JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(a.fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes');

	-- SELECT @querycomis_eg;
	PREPARE stmt FROM @querycomis_eg;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_comisiones
    SELECT
		ingreso.num_mes,
		ingreso.anio_actual,
		ingreso.mes,
		(IFNULL(ingreso.importe_comision, 0.00) - IFNULL(egreso.importe_comision, 0.00)) importe_comision
	FROM tmp_comisiones_ingreso ingreso
	LEFT JOIN tmp_comisiones_egreso egreso ON
		ingreso.anio_actual = egreso.anio_actual
	AND ingreso.mes = egreso.mes
    ORDER BY ingreso.num_mes;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* CXS INGRESO */
	SET @querycxs_ing = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_cxs_ingreso
					SELECT
						DATE_FORMAT(NOW(), ''%Y'') anio_actual,
						mes.mes,
						IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))),0) importe_cxs,
                        mes.num_mes
					FROM(
					SELECT
						det.*,
                        fac.tipo_cambio_usd,
                        fac.tipo_cambio_eur,
                        fac.fecha_factura
					FROM ic_cat_tc_servicio serv
					JOIN ic_fac_tr_factura_detalle det ON
						serv.id_servicio = det.id_servicio
					JOIN ic_fac_tr_factura fac ON
						det.id_factura = fac.id_factura
					WHERE serv.id_producto = 5
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND fac.estatus != 2
					AND serv.estatus = 1
                    AND fac.tipo_cfdi = ''I''
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(NOW(), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), ''%Y-%m'')
                    ORDER BY fac.fecha_factura ASC ) a
					JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(a.fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes;
					');

	-- SELECT @querycxs_ing;
	PREPARE stmt FROM @querycxs_ing;
	EXECUTE stmt;

	 /* CXS EGRESO */
	SET @querycxs_egr = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_cxs_egreso
					SELECT
						DATE_FORMAT(NOW(), ''%Y'') anio_actual,
						mes.mes,
						IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))),0) importe_cxs
					FROM(
					SELECT
						det.*,
                        fac.tipo_cambio_usd,
                        fac.tipo_cambio_eur,
                        fac.fecha_factura
					FROM ic_cat_tc_servicio serv
					JOIN ic_fac_tr_factura_detalle det ON
						serv.id_servicio = det.id_servicio
					JOIN ic_fac_tr_factura fac ON
						det.id_factura = fac.id_factura
					WHERE serv.id_producto = 5
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND fac.estatus != 2
					AND serv.estatus = 1
                    AND fac.tipo_cfdi = ''E''
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(NOW(), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), ''%Y-%m'')
                    ORDER BY fac.fecha_factura ASC ) a
					JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(a.fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes;
					');

	-- SELECT @querycxs_egr;
	PREPARE stmt FROM @querycxs_egr;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_cxs
    SELECT
		ingreso.num_mes,
		ingreso.anio_actual,
		ingreso.mes,
		(IFNULL(ingreso.importe_cxs, 0.00) - IFNULL(egreso.importe_cxs, 0.00)) importe_cxs
	FROM tmp_cxs_ingreso ingreso
	LEFT JOIN tmp_cxs_egreso egreso ON
		ingreso.anio_actual = egreso.anio_actual
	AND ingreso.mes = egreso.mes
    ORDER BY ingreso.num_mes;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		comisiones.anio_actual,
		comisiones.mes,
		IFNULL(importe_comision, 0) importe_comision,
		IFNULL(importe_cxs, 0) importe_cxs
	FROM tmp_comisiones comisiones
	LEFT JOIN tmp_cxs cxs ON
		comisiones.mes = cxs.mes
	ORDER BY comisiones.num_mes;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
