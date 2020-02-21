DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_ventas_graf_x_semestre_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    IN	pr_id_idioma						INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_ventas_graf_x_semestre_c
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
    DROP TABLE IF EXISTS tmp_neto_ventas_actual;
    DROP TABLE IF EXISTS tmp_neto_ventas_actual_ing;
    DROP TABLE IF EXISTS tmp_neto_ventas_actual_egr;
    DROP TABLE IF EXISTS tmp_neto_ventas_anterior;
    DROP TABLE IF EXISTS tmp_neto_ventas_anterior_ing;
    DROP TABLE IF EXISTS tmp_neto_ventas_anterior_egr;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* AÑO ACTUAL */
    SET @queryac_ing = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_neto_ventas_actual_ing
					SELECT
						DATE_FORMAT(NOW(), ''%Y'') anio_actual,
						mes.mes,
						IFNULL(SUM(((IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0)) - IFNULL(descuento',lo_moneda_reporte,', 0))),0) monto,
                        mes.num_mes
					FROM(
					SELECT
						fecha_factura,
                        fac.tipo_cambio_usd,
                        fac.tipo_cambio_eur,
						det.*
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND estatus != 2
					AND tipo_cfdi = ''I''
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(NOW(), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), ''%Y-%m'')
                    ORDER BY fecha_factura ASC) a
					JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes');

	-- SELECT @queryac_ing;
	PREPARE stmt FROM @queryac_ing;
	EXECUTE stmt;

    SET @queryac_egr = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_neto_ventas_actual_egr
					SELECT
						DATE_FORMAT(NOW(), ''%Y'') anio_actual,
						mes.mes,
						IFNULL(SUM(((IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0)) - IFNULL(descuento',lo_moneda_reporte,', 0))),0) monto
					FROM(
					SELECT
						fecha_factura,
                        fac.tipo_cambio_usd,
                        fac.tipo_cambio_eur,
						det.*
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND estatus != 2
					AND tipo_cfdi = ''E''
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(NOW(), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), ''%Y-%m'')
                    ORDER BY fecha_factura ASC) a
					JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes');

	-- SELECT @queryac_egr;
	PREPARE stmt FROM @queryac_egr;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_neto_ventas_actual
	SELECT
		ingreso.num_mes,
		ingreso.anio_actual,
		ingreso.mes,
		(IFNULL(ingreso.monto, 0) - IFNULL(egreso.monto, 0)) monto
	FROM tmp_neto_ventas_actual_ing ingreso
	LEFT JOIN tmp_neto_ventas_actual_egr egreso ON
		ingreso.anio_actual = egreso.anio_actual
	AND ingreso.mes = egreso.mes
	ORDER BY ingreso.num_mes ASC;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	/* AÑO ANTERIOR */
    SET @queryant_ing = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_neto_ventas_anterior_ing
					SELECT
						DATE_FORMAT(NOW(), ''%Y'') anio_anterior,
						mes.mes,
						IFNULL(SUM(((IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0)) - IFNULL(descuento',lo_moneda_reporte,', 0))),0) monto,
                        mes.num_mes
					FROM(
					SELECT
						fecha_factura,
                        fac.tipo_cambio_usd,
                        fac.tipo_cambio_eur,
						det.*
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND estatus != 2
					AND tipo_cfdi = ''I''
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL 6 MONTH), ''%Y-%m'')
                    ORDER BY fecha_factura ASC) a
					JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes');

	-- SELECT @queryant_ing;
	PREPARE stmt FROM @queryant_ing;
	EXECUTE stmt;

    SET @queryant_egr = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_neto_ventas_anterior_egr
					SELECT
						DATE_FORMAT(NOW(), ''%Y'') anio_anterior,
						mes.mes,
						IFNULL(SUM(((IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0)) - IFNULL(descuento',lo_moneda_reporte,', 0))),0) monto
					FROM(
					SELECT
						fecha_factura,
                        fac.tipo_cambio_usd,
                        fac.tipo_cambio_eur,
						det.*
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND estatus != 2
					AND tipo_cfdi = ''E''
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL 6 MONTH), ''%Y-%m'')
                    ORDER BY fecha_factura ASC) a
					JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes');

	-- SELECT @queryant_egr;
	PREPARE stmt FROM @queryant_egr;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_neto_ventas_anterior
	SELECT
		ingreso.num_mes,
		ingreso.anio_anterior,
		ingreso.mes,
		(IFNULL(ingreso.monto, 0) - IFNULL(egreso.monto, 0)) monto
	FROM tmp_neto_ventas_anterior_ing ingreso
	LEFT JOIN tmp_neto_ventas_anterior_egr egreso ON
		ingreso.anio_anterior = egreso.anio_anterior
	AND ingreso.mes = egreso.mes
    ORDER BY ingreso.num_mes ASC ;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		a.mes,
		a.anio_actual,
		IFNULL(a.monto, 0) importe_actual_neto,
		IFNULL(b.anio_anterior, a.anio_actual) anio_anterior,
		IFNULL(b.monto, 0) importe_anterior_neto
	FROM tmp_neto_ventas_actual a
	LEFT JOIN tmp_neto_ventas_anterior b ON
		a.mes = b.mes
	ORDER BY a.num_mes;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
