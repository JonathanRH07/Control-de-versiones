DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_cons_bol_modal_fac_detalle_c`(
    IN  pr_id_boleto				INT,
	OUT pr_affect_rows	       		INT,
    OUT pr_message					VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_cons_bol_modal_fac_detalle_c
	@fecha:			20/11/2018
	@descripcion:	SP para consultar registro en la tabla ic_fac_tc_tipo_consulta_boleto
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_cons_bol_dotacion_c';
	END ;

    IF pr_id_boleto > 0 THEN
		SET @query = CONCAT('SELECT
								fac.id_factura,
								det.id_factura_detalle,
								CONCAT(seri.cve_serie,'' - '',fac.fac_numero) factura,
								suc.cve_sucursal sucursal,
								fac.fecha_factura,
								bol.fecha_emision,
								fac.pnr,
								bol.conjunto,
								CONCAT(pro.cve_proveedor,'' - '',pro.nombre_comercial) proveedor,
								CONCAT(vuel.clave_linea_aerea, '' - '', airline.nombre_aerolinea) linea_aerea,
								ser.descripcion servicio,
								det.nombre_pasajero pasajero,
								det.concepto ruta,
								vuel.fecha_salida,
								vuel.fecha_regreso,
								cli.nombre_comercial cliente,
								cent_cost_n1.datos cent_cost_n1,
								cent_cost_n2.datos cent_cost_n2,
								cent_cost_n3.datos cent_cost_n3,
								vend_tit.nombre vendedor_tit,
								vend_aux.nombre vendedor_aux,
								uni_neg.desc_unidad_negocio unidad_negocio,
								ori.descripcion origen_venta,
								fit.desc_grupo_fit proyecto,
								(SELECT desc_forma_pago FROM ic_glob_tr_forma_pago WHERE id_forma_pago = fac_payform.id_forma_pago LIMIT 1) forma_pago,
								IFNULL(det.tarifa_moneda_facturada,0) tarifa_neta,
								IFNULL(det.importe_markup,0) margen_beneficio,
								(IFNULL(det.tarifa_moneda_facturada,0) + IFNULL(det.importe_markup,0)) tarifa_moneda_base,
								IFNULL(det.descuento,0) descuento,
								IFNULL(det.iva_descuento,0) iva_descuento
							FROM ic_fac_tr_factura_detalle det
							LEFT JOIN ic_glob_tr_boleto bol ON
								bol.id_boletos = det.id_boleto
							LEFT JOIN ic_fac_tr_factura fac ON
								det.id_factura = fac.id_factura
							LEFT JOIN ic_cat_tc_servicio ser ON
								det.id_servicio = ser.id_servicio
							LEFT JOIN ic_cat_tr_serie seri ON
								fac.id_serie = seri.id_serie
							LEFT JOIN ic_cat_tr_sucursal suc ON
								fac.id_sucursal = suc.id_sucursal
							LEFT JOIN ic_cat_tr_proveedor pro ON
								bol.id_proveedor = pro.id_proveedor
							LEFT JOIN ic_glob_tr_inventario_boletos inv_bol ON
								bol.id_inventario = inv_bol.id_inventario_boletos
							LEFT JOIN ic_gds_tr_vuelos vuel ON
								vuel.id_factura_detalle = det.id_factura_detalle
							LEFT JOIN ct_glob_tc_aerolinea airline ON
								vuel.clave_linea_aerea = airline.clave_aerolinea
							LEFT JOIN ic_cat_tr_cliente cli ON
								fac.id_cliente = cli.id_cliente
							LEFT JOIN ic_cat_tr_vendedor vend_tit ON
								fac.id_vendedor_tit = vend_tit.id_vendedor
							LEFT JOIN ic_cat_tr_vendedor vend_aux ON
								fac.id_vendedor_aux = vend_aux.id_vendedor
							LEFT JOIN ic_cat_tr_origen_venta ori ON
								fac.id_origen = ori.id_origen_venta
							LEFT JOIN ic_cat_tr_centro_costo cent_cost_n1 ON
								IFNULL(SUBSTRING(fac.id_centro_costo_n1, 21, 2), 0) = cent_cost_n1.id_centro_costo
							LEFT JOIN ic_cat_tr_centro_costo cent_cost_n2 ON
								IFNULL(SUBSTRING(fac.id_centro_costo_n2, 21, 2), 0) = cent_cost_n2.id_centro_costo
							LEFT JOIN ic_cat_tr_centro_costo cent_cost_n3 ON
								IFNULL(SUBSTRING(fac.id_centro_costo_n3, 21, 2), 0) = cent_cost_n3.id_centro_costo
							LEFT JOIN ic_fac_tc_grupo_fit fit ON
								det.id_grupo_fit = fit.id_grupo_fit
							LEFT JOIN ic_fac_tr_factura_forma_pago fac_payform ON
								fac.id_factura = fac_payform.id_factura
							LEFT JOIN ic_cat_tc_unidad_negocio uni_neg ON
								fac.id_unidad_negocio = uni_neg.id_unidad_negocio
							WHERE det.id_boleto =',pr_id_boleto);


		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
    ELSE
		SET pr_message = 'ERROR store sp_fac_cons_bol_dotacion_c';
    END IF;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
