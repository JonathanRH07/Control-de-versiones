DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_contenido_promedio_x_cliente_c`(
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
	@nombre:		sp_dash_administrador_contenido_usuarios_conectados_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(100);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_contenido_usuarios_conectados_c';
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

    SET @query_promedio_x_cliente = CONCAT(
									'
									SELECT
										cli.razon_social cliente,
										SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total,
										COUNT(det.id_factura_detalle) no_servicios,
										(SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,'))/COUNT(det.id_factura_detalle)) promedio
									FROM ic_fac_tr_factura fac
									JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									JOIN ic_cat_tr_cliente cli ON
										fac.id_cliente = cli.id_cliente
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND fac.id_sucursal = ',pr_id_sucursal,'
									AND fac.estatus != 2
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
									GROUP BY cli.id_cliente
									ORDER BY 2 DESC
                                    LIMIT ',pr_ini_pag,',',pr_fin_pag);

	-- SELECT @query_promedio_x_cliente;
	PREPARE stmt FROM @query_promedio_x_cliente;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET @pr_rows_tot_table = 0;
    SET @query_promedio_cli_count = CONCAT(
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
									JOIN ic_cat_tr_cliente cli ON
										fac.id_cliente = cli.id_cliente
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND fac.id_sucursal = ',pr_id_sucursal,'
									AND fac.estatus != 2
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
									GROUP BY cli.id_cliente) a');

	-- SELECT @query_promedio_cli_count;
	PREPARE stmt FROM @query_promedio_cli_count;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET pr_rows_tot_table = @pr_rows_tot_table;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
