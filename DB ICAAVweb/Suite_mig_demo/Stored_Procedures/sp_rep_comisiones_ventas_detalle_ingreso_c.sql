DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_comisiones_ventas_detalle_ingreso_c`(
	IN	pr_id_grupo_empresa		INT,
    IN	pr_id_vendedor			INT,
	IN	pr_tipo_fecha			INT, /* 1-Fecha de emision | 2-Fecha de vencimiento | 3-Fecha de pago */
    IN	pr_fecha_ini			DATE,
    IN	pr_fecha_fin			DATE,
    IN	pr_fecha_pago_ini		DATE, /* SOLO EN CASO DE PAGO (3) */
    IN	pr_fecha_pago_fin		DATE, /* SOLO EN CASO DE PAGO (3) */
    OUT pr_message 	  			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_comisiones_ventas_detalle_c
	@fecha:			28/02/2019
	@descripcion:	Sp para consultar el detalle de las ventas por vendedor y sus comisiones
	@autor: 		Jonathan Ramirez
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_comisiones_ventas_detalle_c';
	END;

    DROP TABLE IF EXISTS tmp_report_comisiones_detalle_emision_ing;
    DROP TABLE IF EXISTS tmp_report_comisiones_vencimiento_ing;
    DROP TABLE IF EXISTS tmp_report_comisiones_detalle_pago_ing;

	IF pr_tipo_fecha > 0 THEN

        /* TIPO DE FECHA 'EMISION' */
		IF pr_tipo_fecha = 1 THEN

			SET @queryemisioning = CONCAT('CREATE TEMPORARY TABLE tmp_report_comisiones_detalle_emision_ing
											SELECT
												fac.id_factura,
												ser.cve_serie serie,
												fac.fac_numero fac_nc,
												cxc.fecha_emision,
												cxc.fecha_vencimiento,
												DATEDIFF(SYSDATE(),cxc.fecha_vencimiento) dias_venc,
												cxc.saldo_facturado saldo_fac,
												cli.cve_cliente cliente,
												cli.nombre_comercial cliente_nombre,
												fac_det.nombre_pasajero,
												prov.cve_proveedor proveedor,
												serv.cve_servicio servicio,
												airline.clave_aerolinea linea_aer,
												fac_det.numero_boleto,
												fac_det.concepto concepto_ruta,
												fac.total_moneda_base tarifa,
												SUM(fac_imp.cantidad) impuestos,
												(fac_det.comision_agencia) + (fac_det.tarifa_moneda_base * fac_det.porc_comision_agencia)/100 importe_comis,
												(tarifa_moneda_base * porc_comision_agencia)/100 * (porc_comision_titular/100) +
												(comision_agencia * (porc_comision_titular/100)) +
												(tarifa_moneda_base * porc_comision_agencia)/100 * (porc_comision_auxiliar/100) +
												(comision_agencia * (porc_comision_auxiliar/100)) porcentaje_comis,
												(comision_titular) + (comision_auxiliar) cuota_fija,
												(((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_titular))/100) +
												(comision_agencia * (porc_comision_titular/100)) +
												((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_auxiliar))/100) +
												(comision_agencia * (porc_comision_auxiliar/100))) + ((comision_titular) + (comision_auxiliar)) comision_neta
											FROM ic_fac_tr_factura fac
											JOIN ic_fac_tr_factura_detalle fac_det ON
												fac.id_factura = fac_det.id_factura
											JOIN ic_cat_tr_vendedor vend ON
												fac.id_vendedor_tit = vend.id_vendedor
											JOIN ic_cat_tr_plan_comision plan_comis ON
												vend.id_comision = plan_comis.id_plan_comision
											LEFT JOIN ic_glob_tr_cxc cxc ON
												fac.id_factura = cxc.id_factura
											LEFT JOIN ic_glob_tr_cxc_detalle cxc_det ON
												cxc.id_cxc = cxc_det.id_cxc
											LEFT JOIN ic_fac_tr_pagos pag ON
												cxc_det.id_pago = pag.id_pago
											LEFT JOIN ic_cat_tr_serie ser ON
												fac.id_serie = ser.id_serie
											LEFT JOIN ic_cat_tr_cliente cli ON
												fac.id_cliente = cli.id_cliente
											LEFT JOIN ic_cat_tr_proveedor prov ON
												fac_det.id_proveedor = prov.id_proveedor
											LEFT JOIN ic_cat_tc_servicio serv ON
												fac_det.id_servicio =  serv.id_servicio
											LEFT JOIN ic_cat_tr_proveedor_aero prov_aer ON
												prov.id_proveedor = prov_aer.id_proveedor
											LEFT JOIN ct_glob_tc_aerolinea airline ON
												prov_aer.codigo_bsp = airline.codigo_bsp
											LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
												fac_det.id_factura_detalle = fac_imp.id_factura_detalle
											WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
											AND fac.fecha_factura >= ''',pr_fecha_ini,'''
											AND fac.fecha_factura <= ''',pr_fecha_fin,'''
											AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
											AND fac.id_vendedor_tit = ',pr_id_vendedor,'
											AND fac.tipo_cfdi = ''I''
											GROUP BY fac_det.id_factura_detalle');

			-- SELECT @queryemisioning;
            PREPARE stmt FROM @queryemisioning;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

			SELECT
				id_factura,
				serie,
				fac_nc,
				fecha_emision,
				fecha_vencimiento,
				dias_venc,
				IFNULL(saldo_fac,0) saldo_fac,
				cliente,
				cliente_nombre,
				nombre_pasajero,
				proveedor,
				servicio,
				linea_aer,
				numero_boleto,
				concepto_ruta,
				IFNULL(tarifa,0) tarifa,
				IFNULL(impuestos,0) impuestos,
				IFNULL(importe_comis,0) importe_comis,
				IFNULL(porcentaje_comis,0) porcentaje_comis,
				IFNULL(cuota_fija,0) cuota_fija,
				IFNULL(comision_neta,0) comision_neta
			FROM tmp_report_comisiones_detalle_emision_ing;

		/* TIPO DE FECHA 'VENCIMIENTO' */
		ELSEIF pr_tipo_fecha = 2 THEN

			SET @queryvencimientoing = CONCAT('CREATE TEMPORARY TABLE tmp_report_comisiones_vencimiento_ing
												SELECT
													fac.id_factura,
													ser.cve_serie serie,
													fac.fac_numero fac_nc,
													cxc.fecha_emision,
													cxc.fecha_vencimiento,
													DATEDIFF(SYSDATE(),cxc.fecha_vencimiento) dias_venc,
													cxc.saldo_facturado saldo_fac,
													cli.cve_cliente cliente,
													cli.nombre_comercial cliente_nombre,
													fac_det.nombre_pasajero,
													prov.cve_proveedor proveedor,
													serv.cve_servicio servicio,
													airline.clave_aerolinea linea_aer,
													fac_det.numero_boleto,
													fac_det.concepto concepto_ruta,
													fac.total_moneda_base tarifa,
													SUM(fac_imp.cantidad) impuestos,
													(fac_det.comision_agencia) + (fac_det.tarifa_moneda_base * fac_det.porc_comision_agencia)/100 importe_comis,
													(tarifa_moneda_base * porc_comision_agencia)/100 * (porc_comision_titular/100) +
													(comision_agencia * (porc_comision_titular/100)) +
													(tarifa_moneda_base * porc_comision_agencia)/100 * (porc_comision_auxiliar/100) +
													(comision_agencia * (porc_comision_auxiliar/100)) porcentaje_comis,
													(comision_titular) + (comision_auxiliar) cuota_fija,
													(((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_titular))/100) +
													(comision_agencia * (porc_comision_titular/100)) +
													((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_auxiliar))/100) +
													(comision_agencia * (porc_comision_auxiliar/100))) + ((comision_titular) + (comision_auxiliar)) comision_neta
												FROM ic_fac_tr_factura fac
												JOIN ic_fac_tr_factura_detalle fac_det ON
													fac.id_factura = fac_det.id_factura
												JOIN ic_cat_tr_vendedor vend ON
													fac.id_vendedor_tit = vend.id_vendedor
												JOIN ic_cat_tr_plan_comision plan_comis ON
													vend.id_comision = plan_comis.id_plan_comision
												LEFT JOIN ic_glob_tr_cxc cxc ON
													fac.id_factura = cxc.id_factura
												LEFT JOIN ic_glob_tr_cxc_detalle cxc_det ON
													cxc.id_cxc = cxc_det.id_cxc
												LEFT JOIN ic_fac_tr_pagos pag ON
													cxc_det.id_pago = pag.id_pago
												LEFT JOIN ic_cat_tr_serie ser ON
													fac.id_serie = ser.id_serie
												LEFT JOIN ic_cat_tr_cliente cli ON
													fac.id_cliente = cli.id_cliente
												LEFT JOIN ic_cat_tr_proveedor prov ON
													fac_det.id_proveedor = prov.id_proveedor
												LEFT JOIN ic_cat_tc_servicio serv ON
													fac_det.id_servicio =  serv.id_servicio
												LEFT JOIN ic_cat_tr_proveedor_aero prov_aer ON
													prov.id_proveedor = prov_aer.id_proveedor
												LEFT JOIN ct_glob_tc_aerolinea airline ON
													prov_aer.codigo_bsp = airline.codigo_bsp
												LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
													fac_det.id_factura_detalle = fac_imp.id_factura_detalle
                                                WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
												AND cxc.fecha_vencimiento >= ''',pr_fecha_ini,'''
												AND cxc.fecha_vencimiento <= ''',pr_fecha_fin,'''
												AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
                                                AND fac.id_vendedor_tit = ',pr_id_vendedor,'
												AND fac.tipo_cfdi = ''I''
												AND DATEDIFF(SYSDATE(),cxc.fecha_vencimiento) > 0
												GROUP BY fac_det.id_factura_detalle');

            -- SELECT @queryvencimientoing;
            PREPARE stmt FROM @queryvencimientoing;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

			SELECT
				id_factura,
				serie,
				fac_nc,
				fecha_emision,
				fecha_vencimiento,
				dias_venc,
				IFNULL(saldo_fac,0) saldo_fac,
				cliente,
				cliente_nombre,
				nombre_pasajero,
				proveedor,
				servicio,
				linea_aer,
				numero_boleto,
				concepto_ruta,
				IFNULL(tarifa,0) tarifa,
				IFNULL(impuestos,0) impuestos,
				IFNULL(importe_comis,0) importe_comis,
				IFNULL(porcentaje_comis,0) porcentaje_comis,
				IFNULL(cuota_fija,0) cuota_fija,
				IFNULL(comision_neta,0) comision_neta
			FROM tmp_report_comisiones_vencimiento_ing;

        /* TIPO DE FECHA 'PAGO' */
		ELSEIF  pr_tipo_fecha = 3 THEN

			SET @querypagoing = CONCAT('CREATE TEMPORARY TABLE tmp_report_comisiones_detalle_pago_ing
										SELECT
											fac.id_factura,
											ser.cve_serie serie,
											fac.fac_numero fac_nc,
											cxc.fecha_emision,
											cxc.fecha_vencimiento,
											DATEDIFF(SYSDATE(),cxc.fecha_vencimiento) dias_venc,
											cxc.saldo_facturado saldo_fac,
											cli.cve_cliente cliente,
											cli.nombre_comercial cliente_nombre,
											fac_det.nombre_pasajero,
											prov.cve_proveedor proveedor,
											serv.cve_servicio servicio,
											airline.clave_aerolinea linea_aer,
											fac_det.numero_boleto,
											fac_det.concepto concepto_ruta,
											fac.total_moneda_base tarifa,
											SUM(fac_imp.cantidad) impuestos,
											(fac_det.comision_agencia) + (fac_det.tarifa_moneda_base * fac_det.porc_comision_agencia)/100 importe_comis,
											(tarifa_moneda_base * porc_comision_agencia)/100 * (porc_comision_titular/100) +
											(comision_agencia * (porc_comision_titular/100)) +
											(tarifa_moneda_base * porc_comision_agencia)/100 * (porc_comision_auxiliar/100) +
											(comision_agencia * (porc_comision_auxiliar/100)) porcentaje_comis,
											(comision_titular) + (comision_auxiliar) cuota_fija,
											(((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_titular))/100) +
											(comision_agencia * (porc_comision_titular/100)) +
											((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_auxiliar))/100) +
											(comision_agencia * (porc_comision_auxiliar/100))) + ((comision_titular) + (comision_auxiliar)) comision_neta
										FROM ic_fac_tr_factura fac
										JOIN ic_fac_tr_factura_detalle fac_det ON
											fac.id_factura = fac_det.id_factura
										JOIN ic_cat_tr_vendedor vend ON
											fac.id_vendedor_tit = vend.id_vendedor
										JOIN ic_cat_tr_plan_comision plan_comis ON
											vend.id_comision = plan_comis.id_plan_comision
										LEFT JOIN ic_glob_tr_cxc cxc ON
											fac.id_factura = cxc.id_factura
										LEFT JOIN ic_glob_tr_cxc_detalle cxc_det ON
											cxc.id_cxc = cxc_det.id_cxc
										LEFT JOIN ic_fac_tr_pagos pag ON
											cxc_det.id_pago = pag.id_pago
										LEFT JOIN ic_cat_tr_serie ser ON
											fac.id_serie = ser.id_serie
										LEFT JOIN ic_cat_tr_cliente cli ON
											fac.id_cliente = cli.id_cliente
										LEFT JOIN ic_cat_tr_proveedor prov ON
											fac_det.id_proveedor = prov.id_proveedor
										LEFT JOIN ic_cat_tc_servicio serv ON
											fac_det.id_servicio =  serv.id_servicio
										LEFT JOIN ic_cat_tr_proveedor_aero prov_aer ON
											prov.id_proveedor = prov_aer.id_proveedor
										LEFT JOIN ct_glob_tc_aerolinea airline ON
											prov_aer.codigo_bsp = airline.codigo_bsp
										LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
											fac_det.id_factura_detalle = fac_imp.id_factura_detalle
                                        WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
										AND fac.id_vendedor_tit = ',pr_id_vendedor,'
										AND pag.fecha >= ''',pr_fecha_pago_ini,'''
										AND pag.fecha <= ''',pr_fecha_pago_fin,'''
										AND fac.fecha_factura >= ''',pr_fecha_ini,'''
										AND fac.fecha_factura <= ''',pr_fecha_fin,'''
										AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
										AND fac.tipo_cfdi = ''I''
										AND cxc.saldo_facturado = 0
										GROUP BY fac_det.id_factura_detalle');

			-- SELECT @querypagoing;
            PREPARE stmt FROM @querypagoing;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

			SELECT
				id_factura,
				serie,
				fac_nc,
				fecha_emision,
				fecha_vencimiento,
				dias_venc,
				IFNULL(saldo_fac,0) saldo_fac,
				cliente,
				cliente_nombre,
				nombre_pasajero,
				proveedor,
				servicio,
				linea_aer,
				numero_boleto,
				concepto_ruta,
				IFNULL(tarifa,0) tarifa,
				IFNULL(impuestos,0) impuestos,
				IFNULL(importe_comis,0) importe_comis,
				IFNULL(porcentaje_comis,0) porcentaje_comis,
				IFNULL(cuota_fija,0) cuota_fija,
				IFNULL(comision_neta,0) comision_neta
			FROM tmp_report_comisiones_detalle_pago_ing;

        END IF;

    END IF;

    /* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
