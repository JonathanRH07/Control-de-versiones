DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_reportes_graf_comparativa_cxs_ventas_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_reportes_graf_comparativa_cxs_ventas_c
	@fecha:			01/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda					VARCHAR(150);
    DECLARE lo_total_ventas				DECIMAL(15,2);
    DECLARE lo_total_cargos				DECIMAL(15,2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_reportes_indicadores_c';
	END;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
        SET lo_moneda = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
        SET lo_moneda = '/tipo_cambio_usd';
	ELSE
		SET lo_moneda = '';
    END IF;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* TOTAL VENTAS */
    SET @lo_total_ventas_ing = 0;
    SET @queryventas_ing = CONCAT(
				'
				SELECT
					IFNULL((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento',lo_moneda,'), 0)
				INTO
					@lo_total_ventas_ing
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND fac.id_sucursal = ',pr_id_sucursal,'
				AND serv.id_producto != 5
				AND serv.estatus = 1
				AND fac.estatus != 2
				AND fac.tipo_cfdi = ''I''
                AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @queryventas_ing;
	PREPARE stmt FROM @queryventas_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	SET @lo_total_ventas_egr = 0;
    SET @queryventas_egr = CONCAT(
				'
				SELECT
					IFNULL((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento',lo_moneda,'), 0)
				INTO
					@lo_total_ventas_egr
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND fac.id_sucursal = ',pr_id_sucursal,'
				AND serv.id_producto != 5
				AND serv.estatus = 1
				AND fac.estatus != 2
				AND fac.tipo_cfdi = ''E''
                AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @queryventas_egr;
	PREPARE stmt FROM @queryventas_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_total_ventas = (@lo_total_ventas_ing - @lo_total_ventas_egr);

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    /* TOTAL DE CXS */
    SET @lo_total_cargos_ing = 0;
    SET @querycxs_ing = CONCAT(
				'
				SELECT
					IFNULL((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento',lo_moneda,'),0)
				INTO
					@lo_total_cargos_ing
				FROM ic_cat_tc_servicio serv
				JOIN ic_fac_tr_factura_detalle det ON
					serv.id_servicio = det.id_servicio
				JOIN ic_fac_tr_factura fac ON
					det.id_factura = fac.id_factura
				WHERE serv.id_producto = 5
				AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND fac.id_sucursal = ',pr_id_sucursal,'
                AND serv.estatus = 1
				AND fac.estatus != 2
				AND fac.tipo_cfdi = ''I''
				AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'') ');

	-- SELECT @querycxs_ing;
	PREPARE stmt FROM @querycxs_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	SET @lo_total_cargos_egr = 0;
    SET @querycxs_egr = CONCAT(
				'
				SELECT
					IFNULL((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento',lo_moneda,'),0)
				INTO
					@lo_total_cargos_egr
				FROM ic_cat_tc_servicio serv
				JOIN ic_fac_tr_factura_detalle det ON
					serv.id_servicio = det.id_servicio
				JOIN ic_fac_tr_factura fac ON
					det.id_factura = fac.id_factura
				WHERE serv.id_producto = 5
				AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND fac.id_sucursal = ',pr_id_sucursal,'
                AND serv.estatus = 1
				AND fac.estatus != 2
				AND fac.tipo_cfdi = ''E''
				AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'') ');

	-- SELECT @querycxs_egr;
	PREPARE stmt FROM @querycxs_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_total_cargos = (@lo_total_cargos_ing - @lo_total_cargos_egr);

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    SELECT
		lo_total_ventas,
        lo_total_cargos;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
