DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_bsp_grafica_x_semestre_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    IN	pr_id_idioma						INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_ventas_graf_x_semestre_c
	@fecha:			29/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por mes
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(255);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_bsp_grafica_x_semestre_c';
	END ;

	/* DESARROLLO */
    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/fac.tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/fac.tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

    /* BORRAMOS LAS TABLAS TEMPORALES */
    DROP TEMPORARY TABLE IF EXISTS tmp_neto_airlines_actual;
    DROP TEMPORARY TABLE IF EXISTS tmp_neto_airlines_actual_ingreso;
    DROP TEMPORARY TABLE IF EXISTS tmp_neto_airlines_actual_egreso;
    DROP TEMPORARY TABLE IF EXISTS tmp_neto_airlines_anterior;
    DROP TEMPORARY TABLE IF EXISTS tmp_neto_airlines_anterior_ingreso;
    DROP TEMPORARY TABLE IF EXISTS tmp_neto_airlines_anterior_egreso;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	/* AÑO ACTUAL */
    SET @queryairac_ing = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_neto_airlines_actual_ingreso
					SELECT
						fac.fecha_factura,
						IFNULL(SUM((tarifa_moneda_base',lo_moneda_reporte,')),0) monto_moneda_base
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					AND id_sucursal = ',pr_id_sucursal,'
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(NOW(), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), ''%Y-%m'')
					AND tipo_cfdi = ''I''
					AND fac.estatus != 2
					AND vuelos.clave_linea_aerea IS NOT NULL
					GROUP BY DATE_FORMAT(fac.fecha_factura, ''%Y-%m'')');

	-- SELECT @queryairac_ing;
	PREPARE stmt FROM @queryairac_ing;
	EXECUTE stmt;

    /* AÑO ACTUAL */
    SET @queryairac_egr = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_neto_airlines_actual_egreso
					SELECT
						fac.fecha_factura,
						IFNULL(SUM((tarifa_moneda_base',lo_moneda_reporte,')),0) monto_moneda_base
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					AND id_sucursal = ',pr_id_sucursal,'
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') <= DATE_FORMAT(NOW(), ''%Y-%m'')
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), ''%Y-%m'')
					AND tipo_cfdi = ''E''
					AND fac.estatus != 2
					AND vuelos.clave_linea_aerea IS NOT NULL
					GROUP BY DATE_FORMAT(fac.fecha_factura, ''%Y-%m'')');

	-- SELECT @queryairac_egr;
	PREPARE stmt FROM @queryairac_egr;
	EXECUTE stmt;

    SET @queryairac = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_neto_airlines_actual
					SELECT
						DATE_FORMAT(NOW(), ''%Y'') anio_actual,
						mes.mes,
						IFNULL(SUM(venta_neta_moneda_base),0) monto
					FROM
					(SELECT
						ingreso.fecha_factura,
						(IFNULL(ingreso.monto_moneda_base, 0) - IFNULL(egreso.monto_moneda_base, 0)) venta_neta_moneda_base
					FROM tmp_neto_airlines_actual_ingreso ingreso
					LEFT JOIN tmp_neto_airlines_actual_egreso egreso ON
						ingreso.fecha_factura = egreso.fecha_factura) a
					JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes');

	-- SELECT @queryairac;
	PREPARE stmt FROM @queryairac;
	EXECUTE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	/* AÑO ANTERIOR */
    SET @queryairant_ing = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_neto_airlines_anterior_ingreso
					SELECT
						fac.fecha_factura,
						IFNULL(SUM((tarifa_moneda_base',lo_moneda_reporte,')),0) monto_moneda_base
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					AND id_sucursal = ',pr_id_sucursal,'
					AND fac.fecha_factura > DATE_FORMAT(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL 6 MONTH), ''%Y-%m'')
					AND fac.fecha_factura <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), ''%Y-%m'')
					AND tipo_cfdi = ''I''
					AND fac.estatus != 2
					AND vuelos.clave_linea_aerea IS NOT NULL
					GROUP BY DATE_FORMAT(fac.fecha_factura, ''%Y-%m'')');

	-- SELECT @queryairant_ing;
	PREPARE stmt FROM @queryairant_ing;
	EXECUTE stmt;

    SET @queryairant_egr = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_neto_airlines_anterior_egreso
					SELECT
						fac.fecha_factura,
						IFNULL(SUM((tarifa_moneda_base',lo_moneda_reporte,')),0) monto_moneda_base
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					AND id_sucursal = ',pr_id_sucursal,'
					AND fac.fecha_factura > DATE_FORMAT(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL 6 MONTH), ''%Y-%m'')
					AND fac.fecha_factura <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), ''%Y-%m'')
					AND tipo_cfdi = ''E''
					AND fac.estatus != 2
					AND vuelos.clave_linea_aerea IS NOT NULL
					GROUP BY DATE_FORMAT(fac.fecha_factura, ''%Y-%m'')');

	-- SELECT @queryairant_egr;
	PREPARE stmt FROM @queryairant_egr;
	EXECUTE stmt;

    SET @queryairant = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_neto_airlines_anterior
					SELECT
						DATE_FORMAT(DATE_SUB(NOW(),INTERVAL 1 YEAR), ''%Y'')  anio_anterior,
						mes.mes,
						IFNULL(SUM(venta_neta_moneda_base),0) monto
					FROM
					(SELECT
						ingreso.fecha_factura,
						(IFNULL(ingreso.monto_moneda_base, 0) - IFNULL(egreso.monto_moneda_base, 0)) venta_neta_moneda_base
					FROM tmp_neto_airlines_anterior_ingreso ingreso
					LEFT JOIN tmp_neto_airlines_anterior_egreso egreso ON
						ingreso.fecha_factura = egreso.fecha_factura) a
					RIGHT JOIN ct_glob_tc_meses mes ON
						DATE_FORMAT(fecha_factura, ''%m'') = mes.num_mes
					WHERE mes.id_idioma = ',pr_id_idioma,'
					GROUP BY mes.num_mes');

	-- SELECT @queryairant;
	PREPARE stmt FROM @queryairant;
	EXECUTE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		a.mes,
		a.anio_actual,
		a.monto importe_actual_neto,
		b.anio_anterior,
		b.monto importe_anterior_neto
	FROM tmp_neto_airlines_actual a
	LEFT JOIN tmp_neto_airlines_anterior b ON
		a.mes = b.mes;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
