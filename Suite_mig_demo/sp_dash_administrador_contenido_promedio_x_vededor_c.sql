DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_contenido_promedio_x_vededor_c`(
	IN	pr_id_grupo_empresa					INT,
	IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
	IN  pr_ini_pag							INT,
    IN  pr_fin_pag							INT,
    OUT pr_rows_tot_table					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_contenido_promedio_x_cxs_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(100);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_contenido_promedio_x_cxs_c';
	END;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_promedio_x_vendedor = CONCAT(
									'
                                    SELECT
										vend.nombre vendedor,
										SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total_cxs,
										COUNT(det.id_factura_detalle) no_servicios_cxs,
										((SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')))/COUNT(det.id_factura_detalle)) promedio_cxs
									FROM ic_fac_tr_factura fac
									JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									JOIN ic_cat_tr_vendedor vend ON
										fac.id_vendedor_tit = vend.id_vendedor
									JOIN ic_cat_tc_servicio serv ON
										det.id_servicio = serv.id_servicio
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND fac.id_sucursal = ',pr_id_sucursal,'
									AND fac.estatus != 2
									AND serv.id_producto = 5
									AND serv.estatus = 1
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
									GROUP BY vend.id_vendedor
									ORDER BY 2 DESC
                                    LIMIT ',pr_ini_pag,',',pr_fin_pag);

	-- SELECT @query_promedio_x_vendedor;
	PREPARE stmt FROM @query_promedio_x_vendedor;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @pr_rows_tot_table = 0;
	SET @query_promedio_cxs_x_vend_tot = CONCAT(
									'
                                    SELECT
										COUNT(*)
									INTO
										@pr_rows_tot_table
									FROM(
                                    SELECT
										COUNT(*)
									FROM ic_fac_tr_factura fac
									JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									JOIN ic_cat_tr_vendedor vend ON
										fac.id_vendedor_tit = vend.id_vendedor
									JOIN ic_cat_tc_servicio serv ON
										det.id_servicio = serv.id_servicio
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND fac.id_sucursal = ',pr_id_sucursal,'
									AND fac.estatus != 2
									AND serv.id_producto = 5
									AND serv.estatus = 1
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
									GROUP BY vend.id_vendedor) a');

	-- SELECT @query_promedio_cxs_x_vend_tot;
	PREPARE stmt FROM @query_promedio_cxs_x_vend_tot;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET pr_rows_tot_table = @pr_rows_tot_table;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
