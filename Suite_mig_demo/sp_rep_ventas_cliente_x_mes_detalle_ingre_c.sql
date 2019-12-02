DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_ventas_cliente_x_mes_detalle_ingre_c`(
	IN	pr_id_grupo_empresa		INT,
    IN	pr_id_moneda			INT,
    IN	pr_fecha				VARCHAR(7),
    IN  pr_id_sucursal 			INT,
    IN	pr_id_cliente			INT,
	OUT pr_rows_tot_table 		INT,
	OUT pr_message 	  			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_cliente_x_mes_detalle_ingre_c
	@fecha:			09/08/2018
	@descripcion:	Sp para consultar el desgloce de las ventas por cliente por mes (facturas)
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_sucursal			VARCHAR(100) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_cliente_x_mes_detalle_ingre_c';
	END ;

	/* Desarrollo */
    DROP TEMPORARY TABLE IF EXISTS tmp_detalles_ingreso_total;
	DROP TEMPORARY TABLE IF EXISTS tmp_detalles_ingreso_tua;
	DROP TEMPORARY TABLE IF EXISTS tmp_detalles_ingreso_iva;
	DROP TEMPORARY TABLE IF EXISTS tmp_detalles_ingreso_otros;
    DROP TEMPORARY TABLE IF EXISTS tmp_detalles_ingreso_isr;

    IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

    /*-------------------------------------------------------------------------------*/

    /* TOTAL */
    SET @query1 = CONCAT('
						CREATE TEMPORARY TABLE tmp_detalles_ingreso_total
						SELECT
							fac.id_factura,
							det.id_factura_detalle,
							fac.fecha_factura,
							CONCAT(ser.cve_serie,''-'',fac.fac_numero) factura,
							det.nombre_pasajero nombre_pax,
							det.concepto,
							prov.cve_proveedor,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									(det.tarifa_moneda_base / fac.tipo_cambio_usd)
								WHEN ',pr_id_moneda,' = 49 THEN
									(det.tarifa_moneda_base / fac.tipo_cambio_eur)
								ELSE
									det.tarifa_moneda_base
							END tarifa_facturada,
							bol.numero_bol boleto,
                            det.importe_markup
						FROM ic_fac_tr_factura fac
						LEFT JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
							det.id_factura_detalle = fac_imp.id_factura_detalle
						LEFT JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_glob_tr_boleto bol ON
							det.id_boleto = bol.id_boletos
						LEFT JOIN ic_cat_tr_serie ser ON
							fac.id_serie = ser.id_serie
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_cliente = ',pr_id_cliente,'
                        ',lo_sucursal,'
						AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = ''',pr_fecha,'''
						AND fac.estatus != ''CANCELADA''
						AND tipo_cfdi = ''I''
						GROUP BY det.id_factura_detalle;'
						);

	-- SELECT @query1;
	PREPARE stmt FROM @query1;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /*-------------------------------------------------------------------------------*/

    /* IVA */
    SET @query2 = CONCAT('
						CREATE TEMPORARY TABLE tmp_detalles_ingreso_iva
						SELECT
							det.id_factura_detalle,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									(fac_imp.cantidad / fac.tipo_cambio_usd)
								WHEN ',pr_id_moneda,' = 49 THEN
									(fac_imp.cantidad / fac.tipo_cambio_eur)
								ELSE
									fac_imp.cantidad
							END iva
						FROM ic_fac_tr_factura fac
						LEFT JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
							det.id_factura_detalle = fac_imp.id_factura_detalle
						LEFT JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_glob_tr_boleto bol ON
							det.id_boleto = bol.id_boletos
						LEFT JOIN ic_cat_tr_serie ser ON
							fac.id_serie = ser.id_serie
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_cliente = ',pr_id_cliente,'
                        ',lo_sucursal,'
						AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = ''',pr_fecha,'''
						AND fac_imp.id_impuesto = 2
						AND fac.estatus != ''CANCELADA''
						AND tipo_cfdi = ''I''
						GROUP BY det.id_factura_detalle;
						');

	-- SELECT @query2;
	PREPARE stmt FROM @query2;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /*-------------------------------------------------------------------------------*/

    SET @query3 = CONCAT('
						CREATE TEMPORARY TABLE tmp_detalles_ingreso_tua
						SELECT
							det.id_factura_detalle,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									(fac_imp.cantidad / fac.tipo_cambio_usd)
								WHEN ',pr_id_moneda,' = 49 THEN
									(fac_imp.cantidad / fac.tipo_cambio_eur)
								ELSE
									fac_imp.cantidad
							END tua
						FROM ic_fac_tr_factura fac
						LEFT JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
							det.id_factura_detalle = fac_imp.id_factura_detalle
						LEFT JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_glob_tr_boleto bol ON
							det.id_boleto = bol.id_boletos
						LEFT JOIN ic_cat_tr_serie ser ON
							fac.id_serie = ser.id_serie
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_cliente = ',pr_id_cliente,'
                        ',lo_sucursal,'
						AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = ''',pr_fecha,'''
						AND fac_imp.id_impuesto = 5
						AND fac.estatus != ''CANCELADA''
						AND tipo_cfdi = ''I''
						GROUP BY det.id_factura_detalle;
						');

	-- SELECT @query3;
	PREPARE stmt FROM @query3;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /*-------------------------------------------------------------------------------*/

    SET @query4 = CONCAT('
						CREATE TEMPORARY TABLE tmp_detalles_ingreso_otros
						SELECT
							det.id_factura_detalle,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									(fac_imp.cantidad / fac.tipo_cambio_usd)
								WHEN ',pr_id_moneda,' = 49 THEN
									(fac_imp.cantidad / fac.tipo_cambio_eur)
								ELSE
									fac_imp.cantidad
							END otros
						FROM ic_fac_tr_factura fac
						LEFT JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
							det.id_factura_detalle = fac_imp.id_factura_detalle
						LEFT JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_glob_tr_boleto bol ON
							det.id_boleto = bol.id_boletos
						LEFT JOIN ic_cat_tr_serie ser ON
							fac.id_serie = ser.id_serie
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_cliente = ',pr_id_cliente,'
                        ',lo_sucursal,'
						AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = ''',pr_fecha,'''
						AND fac_imp.id_impuesto NOT IN (5,2,4)
						AND fac.estatus != ''CANCELADA''
						AND tipo_cfdi = ''I''
						GROUP BY det.id_factura_detalle;
						');

	-- SELECT @query4;
	PREPARE stmt FROM @query4;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /*-------------------------------------------------------------------------------*/

        SET @query5 = CONCAT('
						CREATE TEMPORARY TABLE tmp_detalles_ingreso_isr
						SELECT
							det.id_factura_detalle,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									(fac_imp.cantidad / fac.tipo_cambio_usd)
								WHEN ',pr_id_moneda,' = 49 THEN
									(fac_imp.cantidad / fac.tipo_cambio_eur)
								ELSE
									fac_imp.cantidad
							END isr
						FROM ic_fac_tr_factura fac
						LEFT JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
							det.id_factura_detalle = fac_imp.id_factura_detalle
						LEFT JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_glob_tr_boleto bol ON
							det.id_boleto = bol.id_boletos
						LEFT JOIN ic_cat_tr_serie ser ON
							fac.id_serie = ser.id_serie
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_cliente = ',pr_id_cliente,'
                        ',lo_sucursal,'
						AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = ''',pr_fecha,'''
						AND fac_imp.id_impuesto = 4
						AND fac.estatus != ''CANCELADA''
						AND tipo_cfdi = ''I''
						GROUP BY det.id_factura_detalle;
						');

	-- SELECT @query5;
	PREPARE stmt FROM @query5;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /*-------------------------------------------------------------------------------*/

	SELECT
		total.id_factura_detalle,
		total.fecha_factura,
		total.factura,
		total.nombre_pax,
		total.concepto ,
		total.cve_proveedor,
		IFNULL(SUM(total.tarifa_facturada + IFNULL(total.importe_markup,0) - IFNULL(isr.isr,0)),0) tarifa_facturada,
		IFNULL(SUM(iva.iva),0) iva,
		IFNULL(SUM(tua.tua),0) tua,
		IFNULL(SUM(otros.otros),0) otros,
		IFNULL(SUM(IFNULL(total.tarifa_facturada,0) + IFNULL(iva.iva,0) + IFNULL(tua.tua,0) + IFNULL(otros.otros,0) + IFNULL(total.importe_markup,0) - IFNULL(isr.isr,0)),0) total_servicio,
		total.boleto
	FROM tmp_detalles_ingreso_total total
	LEFT JOIN tmp_detalles_ingreso_iva iva ON
		total.id_factura_detalle = iva.id_factura_detalle
	LEFT JOIN tmp_detalles_ingreso_tua tua ON
		total.id_factura_detalle = tua.id_factura_detalle
	LEFT JOIN tmp_detalles_ingreso_otros otros ON
		total.id_factura_detalle = otros.id_factura_detalle
	LEFT JOIN tmp_detalles_ingreso_isr isr ON
		total.id_factura_detalle = isr.id_factura_detalle
	GROUP BY total.id_factura_detalle
    ORDER BY 1 DESC, factura DESC;

    /*-------------------------------------------------------------------------------*/

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
