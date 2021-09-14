DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_detalle_i`(
	IN  pr_id_factura 						INT(11),
	IN  pr_id_prov_tpo_serv 				INT(11),
	IN  pr_id_boleto 						INT(11),
	IN  pr_id_factura_cxs 					INT(11),
	IN  pr_id_grupo_fit 					CHAR(10),
    IN  pr_id_proveedor 					INT(11),
    IN  pr_id_servicio 						INT(11),
	IN  pr_clave_prod_serv_sat 				CHAR(15),
	IN  pr_clave_prod_serv_desc_sat 		VARCHAR(100),
	IN  pr_numero_boleto 					VARCHAR(15),
	IN  pr_concepto 						VARCHAR(100),
	IN  pr_nombre_pasajero 					VARCHAR(30),
	IN  pr_tarifa_moneda_base 				DECIMAL(15,2),
	IN  pr_comision_agencia 				DECIMAL(15,2),
	IN  pr_porc_comision_agencia 			DECIMAL(5,2),
	IN  pr_descuento 						DECIMAL(15,2),
	IN  pr_comision_titular 				DECIMAL(15,2),
	IN  pr_porc_comision_titular 			DECIMAL(5,2),
	IN  pr_comision_auxiliar 				DECIMAL(15,2),
	IN  pr_porc_comision_auxiliar 			DECIMAL(5,2),
	IN  pr_suma_impuestos 					DECIMAL(15,2),
	IN  pr_iva_comision 					DECIMAL(15,2),
	IN  pr_porc_iva_comision 				DECIMAL(5,2),
	IN  pr_boleto_contra 					CHAR(1),
	IN  pr_la_contra 						CHAR(2),
	IN  pr_numero_boleto_contra 			VARCHAR(15),
	IN  pr_boleto_conjunto 					CHAR(1),
	IN  pr_id_prov_num_cta 					INT(11),
	IN  pr_id_prov_num_cta_resul 			INT(11),
	IN  pr_porc_descuento 					DECIMAL(5,2),
	IN  pr_iva_descuento 					DECIMAL(15,2),
	IN  pr_importe_credito 					DECIMAL(15,2),
	IN  pr_numero_tarjeta 					VARCHAR(100),
	IN  pr_referencia_cxp 					CHAR(15),
	IN  pr_numero_bol_cxs 					CHAR(15),
	IN  pr_bol_electronico 					INT(11),
	IN  pr_id_regla 						INT(11),
	IN  pr_comision_cedida 					DECIMAL(8,2),
	IN  pr_clave_reservacion 				VARCHAR(10),
	IN  pr_boleto_facturado 				CHAR(1),
	IN  pr_facturar_agencia 				CHAR(1),
    IN  pr_emd								CHAR(1),
	IN  pr_importe_markup 					DECIMAL(15,2),
	IN  pr_porc_markup 						DECIMAL(5,2),
	IN  pr_num_servicios 					INT(11),
    IN  pr_id_unidad_medida					INT,
	IN  pr_clave_unidad_sat 				CHAR(4),
	IN  pr_cuenta_ingreso 					VARCHAR(20),
	IN  pr_cuenta_ingreso_porcentaje 		DECIMAL(5,2),
	IN  pr_impuesto_x_pagar 				DECIMAL(16,6),
    IN  pr_cantidad							INT(11),
	IN  pr_id_usuario 						INT(11),
    IN  pr_contador 						INT(11),
    IN  pr_tarifa_moneda_facturada			DECIMAL(15,2),
    IN  pr_nc_tipo_remb						ENUM('CREDITO','EFECTIVO'),
    IN  pr_nc_rembolso						ENUM('SI','NO'),
	IN  pr_complemento_terceros				CHAR(1),
    OUT pr_inserted_id						INT,
    OUT pr_affect_rows	    				INT,
	OUT pr_message		    				VARCHAR(500),
    OUT pr_cont 							INT)
BEGIN
	/*
		@nombre 	: sp_fac_factura_detalle_i
		@fecha 		: 02/03/2017
		@descripcion: SP para agregar registros en la tabla de facturas cfdi.
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_detalle_i';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;
/*
	CALL sp_help_get_row_count_params_bill(
			'ic_fac_tr_factura',
			pr_id_grupo_empresa,
            pr_id_sucursal,
			CONCAT(' fac_numero =  "', pr_fac_numero,'" '),
			@has_relations_with_bill, pr_message
	);

	IF @has_relations_with_bill > 0 THEN
		SET @error_code = 'DUPLICATED_No_FACTURA';
		SET pr_message = CONCAT('{"error": "4002", "code": "FACTURA.', @error_code, '", "count": ',(@has_relations_with_bill),'}');
		SET pr_affect_rows = 0;
		ROLLBACK;
	ELSE
*/
        INSERT INTO ic_fac_tr_factura_detalle (
			id_factura,
            id_prov_tpo_serv,
            id_boleto,
            id_factura_cxs,
            id_grupo_fit,
            id_proveedor,
            id_servicio,
            clave_prod_serv_sat,
            clave_prod_serv_desc_sat,
            numero_boleto,
            concepto,
            nombre_pasajero,
            tarifa_moneda_base,
            comision_agencia,
            porc_comision_agencia,
            descuento,
            comision_titular,
            porc_comision_titular,
            comision_auxiliar,
            porc_comision_auxiliar,
            suma_impuestos,
            iva_comision,
            porc_iva_comision,
            boleto_contra,
            la_contra,
            numero_boleto_contra,
            boleto_conjunto,
            id_prov_num_cta,
            id_prov_num_cta_resul,
            porc_descuento,
            iva_descuento,
            importe_credito,
            numero_tarjeta,
            referencia_cxp,
            numero_bol_cxs,
            bol_electronico,
            id_regla,
            comision_cedida,
            clave_reservacion,
            boleto_facturado,
            facturar_agencia,
            emd,
            importe_markup,
            porc_markup,
            num_servicios,
            id_unidad_medida,
            clave_unidad_sat,
            cuenta_ingreso,
            cuenta_ingreso_porcentaje,
            impuesto_x_pagar,
            cantidad,
            tarifa_moneda_facturada,
            nc_tipo_remb,
            nc_rembolso,
            complemento_terceros,
            id_usuario
		) VALUES (
            pr_id_factura,
            pr_id_prov_tpo_serv,
            pr_id_boleto,
            pr_id_factura_cxs,
            pr_id_grupo_fit,
            pr_id_proveedor,
            pr_id_servicio,
            pr_clave_prod_serv_sat,
            pr_clave_prod_serv_desc_sat,
            pr_numero_boleto,
            pr_concepto,
            pr_nombre_pasajero,
            pr_tarifa_moneda_base,
            pr_comision_agencia,
            pr_porc_comision_agencia,
            pr_descuento,
            pr_comision_titular,
            pr_porc_comision_titular,
            pr_comision_auxiliar,
            pr_porc_comision_auxiliar,
            pr_suma_impuestos,
            pr_iva_comision,
            pr_porc_iva_comision,
            pr_boleto_contra,
            pr_la_contra,
            pr_numero_boleto_contra,
            pr_boleto_conjunto,
            pr_id_prov_num_cta,
            pr_id_prov_num_cta_resul,
            pr_porc_descuento,
            pr_iva_descuento,
            pr_importe_credito,
            pr_numero_tarjeta,
            pr_referencia_cxp,
            pr_numero_bol_cxs,
            pr_bol_electronico,
            pr_id_regla,
            pr_comision_cedida,
            pr_clave_reservacion,
            pr_boleto_facturado,
            pr_facturar_agencia,
            pr_emd,
            pr_importe_markup,
            pr_porc_markup,
            pr_num_servicios,
            pr_id_unidad_medida,
            pr_clave_unidad_sat,
            pr_cuenta_ingreso,
            pr_cuenta_ingreso_porcentaje,
            pr_impuesto_x_pagar,
            pr_cantidad,
            pr_tarifa_moneda_facturada,
            pr_nc_tipo_remb,
            pr_nc_rembolso,
            pr_complemento_terceros,
            pr_id_usuario
		);
		SET pr_inserted_id 	= @@identity;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		# Mensaje de ejecución.
		SET pr_message = 'SUCCESS';
        SET pr_cont = pr_contador;
		-- COMMIT;
	-- END IF;
END$$
DELIMITER ;
