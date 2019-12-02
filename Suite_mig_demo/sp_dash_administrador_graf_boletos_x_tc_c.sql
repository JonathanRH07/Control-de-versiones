DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_graf_boletos_x_tc_c`(
	IN	pr_id_grupo_empresa					INT,
	IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_graf_boletos_x_tc_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_contador_con_tarjeta			INT;
    DECLARE lo_contador_sin_tarjeta			INT;
    DECLARE lo_moneda_reporte				VARCHAR(75);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_graf_boletos_x_tc_c';
	END;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_cxs_ingreso;
    DROP TABLE IF EXISTS tmp_cxs_egreso;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET @querycxs_ing = CONCAT(
						'
                        CREATE TEMPORARY TABLE tmp_cxs_ingreso
						SELECT
							serv.cve_servicio,
							serv.descripcion,
							COUNT(*) no_cargos,
							IFNULL(SUM(tarifa_moneda_base',lo_moneda_reporte,') + SUM(importe_markup',lo_moneda_reporte,') - SUM(descuento',lo_moneda_reporte,'), 0) total
						FROM ic_cat_tc_servicio serv
						JOIN ic_fac_tr_factura_detalle det ON
							serv.id_servicio = det.id_servicio
						JOIN ic_fac_tr_factura fac ON
							det.id_factura = fac.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND serv.id_producto = 5
						AND serv.estatus = 1
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND fac.estatus != 2
						AND fac.tipo_cfdi = ''I''
                        AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						GROUP BY serv.descripcion;');

	-- SELECT @querycxs_ing;
	PREPARE stmt FROM @querycxs_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET @querycxs_egr = CONCAT(
						'
                        CREATE TEMPORARY TABLE tmp_cxs_egreso
						SELECT
							serv.cve_servicio,
							serv.descripcion,
							COUNT(*) no_cargos,
							IFNULL(SUM(tarifa_moneda_base',lo_moneda_reporte,') + SUM(importe_markup',lo_moneda_reporte,') - SUM(descuento',lo_moneda_reporte,'), 0) total
						FROM ic_cat_tc_servicio serv
						JOIN ic_fac_tr_factura_detalle det ON
							serv.id_servicio = det.id_servicio
						JOIN ic_fac_tr_factura fac ON
							det.id_factura = fac.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND serv.id_producto = 5
						AND serv.estatus = 1
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND fac.estatus != 2
						AND fac.tipo_cfdi = ''E''
                        AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						GROUP BY serv.descripcion;');

	-- SELECT @querycxs_egr;
	PREPARE stmt FROM @querycxs_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		ingreso.cve_servicio,
		ingreso.descripcion,
		(IFNULL(ingreso.no_cargos, 0) - IFNULL(egreso.no_cargos, 0)) no_cargos,
		(IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)) total
	FROM tmp_cxs_ingreso ingreso
	LEFT JOIN tmp_cxs_egreso egreso ON
		ingreso.cve_servicio = egreso.cve_servicio;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
