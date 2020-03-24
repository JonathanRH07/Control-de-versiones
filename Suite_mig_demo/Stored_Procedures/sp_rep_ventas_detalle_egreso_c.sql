DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_ventas_detalle_egreso_c`(
	IN  pr_id_grupo_empresa					INT,
	IN	pr_id_sucursal						INT,
    IN	pr_año								VARCHAR(4),
    IN	pr_mes								VARCHAR(2),
    IN	pr_tipo_reporte						INT,
    IN	pr_consulta							INT,
    OUT pr_message 	  						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_detalle_egreso_c
	@fecha:			04/12/2018
	@descripcion:	Sp para consultar el desgloce de las ventas por cliente por mes (Notas de credito) |REPOORTE VENTAS TOTALES|
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_fecha 						VARCHAR(7);
    DECLARE lo_consulta						VARCHAR(200);
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_detalle_egreso_c';
	END ;

    /* DESARROLLO */
    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    DROP TEMPORARY TABLE IF EXISTS tmp_detalles_egreso_total;
	DROP TEMPORARY TABLE IF EXISTS tmp_detalles_egreso_tua;
	DROP TEMPORARY TABLE IF EXISTS tmp_detalles_egreso_iva;
	DROP TEMPORARY TABLE IF EXISTS tmp_detalles_egreso_otros;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	/* VALIDAR AÑO */
    IF pr_mes = '' THEN
		SET lo_fecha = DATE_FORMAT(SYSDATE(),'%Y-%m');
	ELSE
		SET lo_fecha = CONCAT(pr_año,'-',pr_mes);
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	IF pr_tipo_reporte > 0 THEN
		/* CLIENTE */
		IF pr_tipo_reporte = 1 THEN
			IF pr_consulta != 'id_cliente' THEN
				SET lo_consulta = CONCAT('AND fac.id_cliente = ',pr_consulta);
			END IF;
		/* VENDEDOR */
		ELSEIF pr_tipo_reporte = 2 THEN
			IF pr_consulta != 'id_vendedor' THEN
				SET lo_consulta = CONCAT('AND fac.id_vendedor_tit = ',pr_consulta);
			END IF;
		/* PROVEEDOR */
		ELSEIF pr_tipo_reporte = 3 THEN
			IF pr_consulta != 'id_proveedor' THEN
				SET lo_consulta = CONCAT('AND det.id_proveedor = ',pr_consulta);
			END IF;
		/* SERVICIO */
		ELSEIF pr_tipo_reporte = 4 THEN
			IF pr_consulta != 'id_servicio' THEN
				SET lo_consulta = CONCAT('AND det.id_servicio = ',pr_consulta);
			END IF;
		END IF;
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT(' AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	/* EGRESO (NOTAS DE CREDITO) */
	SET @query1 = CONCAT('
						CREATE TEMPORARY TABLE tmp_detalles_egreso_total
						SELECT
							fac.id_factura,
							det.id_factura_detalle,
							fac.fecha_factura,
							CONCAT(ser.cve_serie,''-'',fac.fac_numero) factura,
							det.nombre_pasajero nombre_pax,
							det.concepto,
							prov.cve_proveedor,
							det.tarifa_moneda_base tarifa_facturada,
							bol.numero_bol boleto
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
						WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = ''',lo_fecha,'''
						AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
                        ',lo_consulta,'
						AND tipo_cfdi = ''E''
						AND fac.estatus != ''CANCELADA''
						GROUP BY det.id_factura_detalle');

	-- SELECT @query1;
	PREPARE stmt FROM @query1;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


	SET @query2 = CONCAT('
						CREATE TEMPORARY TABLE tmp_detalles_egreso_tua
						SELECT
							det.id_factura_detalle,
							SUM(fac_imp.cantidad) tua
						FROM ic_fac_tr_factura fac
						LEFT JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
							det.id_factura_detalle = fac_imp.id_factura_detalle
						LEFT JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_glob_tr_boleto bol ON
							det.id_boleto = bol.id_boletos
						WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = ''',lo_fecha,'''
						AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
                        ',lo_consulta,'
						AND tipo_cfdi = ''E''
						AND fac.estatus != ''CANCELADA''
						AND fac_imp.id_impuesto = 5
						GROUP BY det.id_factura_detalle
                        ');

	-- SELECT @query2;
	PREPARE stmt FROM @query2;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @query3 = CONCAT('
						CREATE TEMPORARY TABLE tmp_detalles_egreso_iva
						SELECT
							det.id_factura_detalle,
							SUM(fac_imp.cantidad) iva
						FROM ic_fac_tr_factura fac
						LEFT JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
							det.id_factura_detalle = fac_imp.id_factura_detalle
						LEFT JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_glob_tr_boleto bol ON
							det.id_boleto = bol.id_boletos
						WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = ''',lo_fecha,'''
						AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
                        ',lo_consulta,'
						AND tipo_cfdi = ''E''
						AND fac.estatus != ''CANCELADA''
						AND fac_imp.id_impuesto = 2
						GROUP BY det.id_factura_detalle
                        ');

	-- SELECT @query3;
	PREPARE stmt FROM @query3;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	SET @query4 = CONCAT('
						CREATE TEMPORARY TABLE tmp_detalles_egreso_otros
						SELECT
							det.id_factura_detalle,
							SUM(fac_imp.cantidad) otros
						FROM ic_fac_tr_factura fac
						LEFT JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
							det.id_factura_detalle = fac_imp.id_factura_detalle
						LEFT JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_glob_tr_boleto bol ON
							det.id_boleto = bol.id_boletos
						WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = ''',lo_fecha,'''
						AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
                        ',lo_consulta,'
						AND tipo_cfdi = ''E''
						AND fac.estatus != ''CANCELADA''
						AND fac_imp.id_impuesto NOT IN (2,5)
						GROUP BY det.id_factura_detalle
                        ');

	-- SELECT @query4;
	PREPARE stmt FROM @query4;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	SELECT
		total.id_factura_detalle,
		total.fecha_factura,
		total.factura,
		total.nombre_pax,
		total.concepto ,
		total.cve_proveedor,
		IFNULL(total.tarifa_facturada,0) tarifa_facturada,
		IFNULL(iva.iva,0) iva,
		IFNULL(tua.tua,0) tua,
		IFNULL(otros.otros,0) otros,
		IFNULL(IFNULL(total.tarifa_facturada,0) + IFNULL(iva.iva,0) + IFNULL(tua.tua,0) + IFNULL(otros.otros,0),0) total_servicio,
		total.boleto
	FROM tmp_detalles_egreso_total total
	LEFT JOIN tmp_detalles_egreso_iva iva ON
		total.id_factura_detalle = iva.id_factura_detalle
	LEFT JOIN tmp_detalles_egreso_tua tua ON
		total.id_factura_detalle = tua.id_factura_detalle
	LEFT JOIN tmp_detalles_egreso_otros otros ON
		total.id_factura_detalle = otros.id_factura_detalle
	ORDER BY 1 DESC, factura DESC;

	/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
