DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_detalle_u`(
	IN  pr_id_factura_detalle 				INT(11),
	IN  pr_id_factura 						INT(11),
	IN  pr_id_prov_tpo_serv 				INT(11),
	IN  pr_id_boleto 						INT(11),
	IN  pr_id_factura_cxs 					INT(11),
    IN  pr_id_grupo_fit 					CHAR(10),
    IN  pr_id_proveedor 					INT(11),
    IN  pr_id_servicio 						INT(11),
	IN  pr_consecutivo 						INT(11),
	IN  pr_clave_prod_serv_sat 				CHAR(15),
	IN  pr_clave_prod_serv_desc_sat 		VARCHAR(100),
	IN  pr_numero_boleto 					VARCHAR(15),
	IN  pr_concepto 						VARCHAR(100),
	IN  pr_nombre_pasajero 					VARCHAR(30),
	IN  pr_tarifa_moneda_base 				DECIMAL(15,2),
	IN  pr_tarifa_moneda_facturada 			DECIMAL(15,2),
	IN  pr_comision_agencia 				DECIMAL(15,2), --
	IN  pr_porc_comision_agencia 			DECIMAL(5,2),  --
	IN  pr_descuento 						DECIMAL(15,2), --
	IN  pr_comision_titular 				DECIMAL(15,2), --
	IN  pr_porc_comision_titular 			DECIMAL(5,2),  --
	IN  pr_comision_auxiliar 				DECIMAL(15,2),  --
	IN  pr_porc_comision_auxiliar 			DECIMAL(5,2), --
	IN  pr_suma_impuestos 					DECIMAL(15,2),
	IN  pr_iva_comision 					DECIMAL(15,2),
	IN  pr_porc_iva_comision 				DECIMAL(5,2),
	IN  pr_boleto_contra 					CHAR(1),
	IN  pr_la_contra 						CHAR(2),
	IN  pr_numero_boleto_contra 			VARCHAR(15),
	IN  pr_boleto_conjunto 					CHAR(1),
	IN  pr_id_prov_num_cta 					INT(11),
	IN  pr_id_prov_num_cta_resul 			INT(11),
	IN  pr_porc_descuento 					DECIMAL(5,2), --
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
	IN  pr_importe_markup 					DECIMAL(15,2), --
	IN  pr_porc_markup 						DECIMAL(5,2), --
	IN  pr_num_servicios 					INT(11),
	IN  pr_id_unidad_medida 				INT,
	IN  pr_clave_unidad_sat 				CHAR(4),
	IN  pr_cuenta_ingreso 					VARCHAR(20),
	IN  pr_cuenta_ingreso_porcentaje 		DECIMAL(5,2),
	IN  pr_impuesto_x_pagar 				DECIMAL(16,6),
    IN  pr_cantidad							INT(11),
    IN  pr_nc_tipo_remb						ENUM('CREDITO','EFECTIVO'),
    IN  pr_nc_rembolso						ENUM('SI','NO'),
    IN	pr_complemento_terceros				CHAR(1),
	IN  pr_id_usuario 						INT(11),
	OUT pr_affect_rows 						INT,
    OUT pr_message 	   						VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_factura_detalle_u
		@fecha 		: 03/03/2017
		@descripcion: SP para actualizar registros en el modulo de facturacion.
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/

	# Declaración de variables.
	DECLARE  lo_id_factura_detalle 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_id_factura 						VARCHAR(100) DEFAULT '';
	DECLARE  lo_id_prov_tpo_serv 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_id_boleto 						VARCHAR(100) DEFAULT '';
	DECLARE  lo_id_factura_cxs 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_id_grupo_fit 					VARCHAR(100) DEFAULT '';
    DECLARE  lo_id_proveedor 					VARCHAR(100) DEFAULT '';
    DECLARE  lo_id_servicio 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_consecutivo 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_clave_prod_serv_sat 			VARCHAR(100) DEFAULT '';
	DECLARE  lo_clave_prod_serv_desc_sat 		VARCHAR(100) DEFAULT '';
	DECLARE  lo_numero_boleto 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_concepto 						VARCHAR(100) DEFAULT '';
	DECLARE  lo_nombre_pasajero 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_tarifa_moneda_base 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_tarifa_moneda_facturada 		VARCHAR(100) DEFAULT '';
	DECLARE  lo_comision_agencia 				VARCHAR(100) DEFAULT ''; --
	DECLARE  lo_porc_comision_agencia 			VARCHAR(100) DEFAULT ''; --
	DECLARE  lo_descuento 						VARCHAR(100) DEFAULT '';
	DECLARE  lo_comision_titular 				VARCHAR(100) DEFAULT ''; --
	DECLARE  lo_porc_comision_titular 			VARCHAR(100) DEFAULT ''; --
	DECLARE  lo_comision_auxiliar 				VARCHAR(100) DEFAULT ''; --
	DECLARE  lo_porc_comision_auxiliar 			VARCHAR(100) DEFAULT ''; --
	DECLARE  lo_suma_impuestos 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_iva_comision 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_porc_iva_comision 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_boleto_contra 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_la_contra 						VARCHAR(100) DEFAULT '';
	DECLARE  lo_numero_boleto_contra 			VARCHAR(100) DEFAULT '';
	DECLARE  lo_boleto_conjunto 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_id_prov_num_cta 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_id_prov_num_cta_resul 			VARCHAR(100) DEFAULT '';
	DECLARE  lo_porc_descuento 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_iva_descuento 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_importe_credito 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_numero_tarjeta 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_referencia_cxp 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_numero_bol_cxs 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_bol_electronico 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_id_regla 						VARCHAR(100) DEFAULT '';
	DECLARE  lo_comision_cedida 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_clave_reservacion 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_boleto_facturado 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_facturar_agencia 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_importe_markup 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_porc_markup 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_num_servicios 					VARCHAR(100) DEFAULT '';
    DECLARE  lo_id_unidad_medida				VARCHAR(100) DEFAULT '';
	DECLARE  lo_clave_unidad_sat 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_cuenta_ingreso 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_cuenta_ingreso_porcentaje 		VARCHAR(100) DEFAULT '';
	DECLARE  lo_impuesto_x_pagar 				VARCHAR(100) DEFAULT '';
    DECLARE  lo_cantidad						VARCHAR(100) DEFAULT '';
	DECLARE  lo_id_usuario 						VARCHAR(100) DEFAULT '';
    DECLARE  lo_nc_rembolso 					VARCHAR(100) DEFAULT '';
    DECLARE	 lo_complemento_terceros			VARCHAR(100) DEFAULT '';
    DECLARE  lo_nc_tipo_remb					VARCHAR(100) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_detalle_u';
        SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

    -- START TRANSACTION;

	IF pr_id_prov_tpo_serv != '' THEN
		SET lo_id_prov_tpo_serv = CONCAT(' id_prov_tpo_serv = "', pr_id_prov_tpo_serv, '",');
	END IF;

    IF pr_id_boleto != '' THEN
		SET lo_id_boleto = CONCAT(' id_boleto = "', pr_id_boleto, '",');
	END IF;

    IF pr_id_factura_cxs != '' THEN
		SET lo_id_factura_cxs = CONCAT(' id_factura_cxs = "', pr_id_factura_cxs, '",');
	END IF;

    IF pr_id_grupo_fit != '' THEN
		SET lo_id_grupo_fit = CONCAT(' id_grupo_fit = "', pr_id_grupo_fit, '",');
	END IF;

    IF pr_id_proveedor >0 THEN
		SET lo_id_proveedor = CONCAT(' id_proveedor = ', pr_id_proveedor, ',');
	END IF;

    IF pr_id_servicio >0  THEN
		SET lo_id_servicio = CONCAT(' id_servicio = ', pr_id_servicio, ',');
	END IF;

    IF pr_consecutivo != '' THEN
		SET lo_consecutivo = CONCAT(' consecutivo = "', pr_consecutivo, '",');
	END IF;

    IF pr_clave_prod_serv_sat != '' THEN
		SET lo_clave_prod_serv_sat = CONCAT(' clave_prod_serv_sat = "', pr_clave_prod_serv_sat, '",');
	END IF;

    IF pr_clave_prod_serv_desc_sat != '' THEN
		SET lo_clave_prod_serv_desc_sat = CONCAT(' clave_prod_serv_desc_sat = "', pr_clave_prod_serv_desc_sat, '",');
	END IF;

    IF pr_numero_boleto != '' THEN
		SET lo_numero_boleto = CONCAT(' numero_boleto = "', pr_numero_boleto, '",');
	END IF;

    IF pr_concepto != '' THEN
		SET lo_concepto = CONCAT(' concepto = "', pr_concepto, '",');
	END IF;

    IF pr_nombre_pasajero != '' THEN
		SET lo_nombre_pasajero = CONCAT(' nombre_pasajero = "', pr_nombre_pasajero, '",');
	END IF;

    IF pr_tarifa_moneda_base != '' THEN
		SET lo_tarifa_moneda_base = CONCAT(' tarifa_moneda_base = "', pr_tarifa_moneda_base, '",');
	END IF;

    IF pr_tarifa_moneda_facturada != '' THEN
		SET lo_tarifa_moneda_facturada = CONCAT(' tarifa_moneda_facturada = "', pr_tarifa_moneda_facturada, '",');
	END IF;

    IF pr_comision_agencia IS NOT NULL THEN
		SET lo_comision_agencia = CONCAT(' comision_agencia = ', pr_comision_agencia, ',');
	END IF;

    IF pr_porc_comision_agencia IS NOT NULL THEN
		SET lo_porc_comision_agencia = CONCAT(' porc_comision_agencia = ', pr_porc_comision_agencia, ',');
	END IF;

    IF pr_descuento > 0 THEN
		SET lo_descuento = CONCAT(' descuento = ', pr_descuento, ',');
	END IF;

    /* IF pr_descuento ='' THEN
		SET lo_descuento = CONCAT(' descuento =NULL ,');
	END IF;*/

    IF pr_comision_titular > 0 THEN
		SET lo_comision_titular = CONCAT(' comision_titular = ', pr_comision_titular, ',');
	END IF;

    IF pr_porc_comision_titular > 0 THEN
		SET lo_porc_comision_titular = CONCAT(' porc_comision_titular = ', pr_porc_comision_titular, ',');
	END IF;

    IF pr_comision_auxiliar > 0 THEN
		SET lo_comision_auxiliar = CONCAT(' comision_auxiliar = ', pr_comision_auxiliar, ',');
	END IF;

    IF pr_porc_comision_auxiliar  > 0 THEN
		SET lo_porc_comision_auxiliar = CONCAT(' porc_comision_auxiliar = ', pr_porc_comision_auxiliar, ',');
	END IF;

    IF pr_suma_impuestos != '' THEN
		SET lo_suma_impuestos = CONCAT(' suma_impuestos = "', pr_suma_impuestos, '",');
	END IF;

    IF pr_iva_comision != '' THEN
		SET lo_iva_comision = CONCAT(' iva_comision = "', pr_iva_comision, '",');
	END IF;

    IF pr_porc_iva_comision != '' THEN
		SET lo_porc_iva_comision = CONCAT(' porc_iva_comision = "', pr_porc_iva_comision, '",');
	END IF;

    IF pr_boleto_contra != '' THEN
		SET lo_boleto_contra = CONCAT(' boleto_contra = "', pr_boleto_contra, '",');
	END IF;

    IF pr_la_contra != '' THEN
		SET lo_la_contra = CONCAT(' la_contra = "', pr_la_contra, '",');
	END IF;

    IF pr_numero_boleto_contra != '' THEN
		SET lo_numero_boleto_contra = CONCAT(' numero_boleto_contra = "', pr_numero_boleto_contra, '",');
	END IF;

    IF pr_boleto_conjunto != '' THEN
		SET lo_boleto_conjunto = CONCAT(' boleto_conjunto = "', pr_boleto_conjunto, '",');
	END IF;

    IF pr_id_prov_num_cta != '' THEN
		SET lo_id_prov_num_cta = CONCAT(' id_prov_num_cta = "', pr_id_prov_num_cta, '",');
	END IF;

    IF pr_id_prov_num_cta_resul != '' THEN
		SET lo_id_prov_num_cta_resul = CONCAT(' id_prov_num_cta_resul = "', pr_id_prov_num_cta_resul, '",');
	END IF;

    IF pr_porc_descuento != '' THEN
		SET lo_porc_descuento = CONCAT(' porc_descuento = "', pr_porc_descuento, '",');
	END IF;

    /*IF pr_porc_descuento ='' THEN
		SET lo_porc_descuento = CONCAT(' porc_descuento = NULL ,');
	END IF;*/

    IF pr_iva_descuento != '' THEN
		SET lo_iva_descuento = CONCAT(' iva_descuento = "', pr_iva_descuento, '",');
	END IF;

    IF pr_importe_credito != '' THEN
		SET lo_importe_credito = CONCAT(' importe_credito = "', pr_importe_credito, '",');
	END IF;

    IF pr_numero_tarjeta != '' THEN
		SET lo_numero_tarjeta = CONCAT(' numero_tarjeta = "', pr_numero_tarjeta, '",');
	END IF;

    IF pr_referencia_cxp != '' THEN
		SET lo_referencia_cxp = CONCAT(' referencia_cxp = "', pr_referencia_cxp, '",');
	END IF;

    IF pr_numero_bol_cxs != '' THEN
		SET lo_numero_bol_cxs = CONCAT(' numero_bol_cxs = "', pr_numero_bol_cxs, '",');
	END IF;

    IF pr_bol_electronico != '' THEN
		SET lo_bol_electronico = CONCAT(' bol_electronico = "', pr_bol_electronico, '",');
	END IF;

    IF pr_id_regla != '' THEN
		SET lo_id_regla = CONCAT(' id_regla = "', pr_id_regla, '",');
	END IF;

    IF pr_comision_cedida != '' THEN
		SET lo_comision_cedida = CONCAT(' comision_cedida = "', pr_comision_cedida, '",');
	END IF;

	IF pr_clave_reservacion != '' THEN
		SET lo_clave_reservacion = CONCAT(' clave_reservacion = "', pr_clave_reservacion, '",');
	END IF;

	IF pr_boleto_facturado != '' THEN
		SET lo_boleto_facturado = CONCAT(' boleto_facturado = "', pr_boleto_facturado, '",');
	END IF;

	IF pr_facturar_agencia != '' THEN
		SET lo_facturar_agencia = CONCAT(' facturar_agencia = "', pr_facturar_agencia, '",');
	END IF;

	IF pr_importe_markup != '' THEN
		SET lo_importe_markup = CONCAT(' importe_markup = "', pr_importe_markup, '",');
	END IF;

    /*IF pr_importe_markup = '' THEN
		SET lo_importe_markup = CONCAT(' importe_markup = NULL ,');
	END IF;*/

	IF pr_porc_markup != '' THEN
		SET lo_porc_markup = CONCAT(' porc_markup = "', pr_porc_markup, '",');
	END IF;

    /*IF pr_porc_markup = '' THEN
		SET lo_porc_markup = CONCAT(' porc_markup = NULL ,');
	END IF;*/

	IF pr_num_servicios != '' THEN
		SET lo_num_servicios = CONCAT(' num_servicios = "', pr_num_servicios, '",');
	END IF;

	IF pr_id_unidad_medida > 0 THEN
		SET lo_id_unidad_medida = CONCAT(' id_unidad_medida = "', pr_id_unidad_medida, '",');
	END IF;

    IF pr_clave_unidad_sat != '' THEN
		SET lo_clave_unidad_sat = CONCAT(' clave_unidad_sat = "', pr_clave_unidad_sat, '",');
	END IF;

	IF pr_cuenta_ingreso != '' THEN
		SET lo_cuenta_ingreso = CONCAT(' cuenta_ingreso = "', pr_cuenta_ingreso, '",');
	END IF;

    IF pr_cuenta_ingreso_porcentaje != '' THEN
		SET lo_cuenta_ingreso_porcentaje = CONCAT(' cuenta_ingreso_porcentaje = "', pr_cuenta_ingreso_porcentaje, '",');
	END IF;

	IF pr_impuesto_x_pagar != '' THEN
		SET lo_impuesto_x_pagar = CONCAT(' impuesto_x_pagar = "', pr_impuesto_x_pagar, '",');
	END IF;

    IF pr_cantidad >0 THEN
		SET lo_cantidad = CONCAT(' cantidad = ', pr_cantidad, ',');
	END IF;

    IF pr_nc_rembolso > 0 THEN
		SET lo_nc_rembolso = CONCAT(' nc_rembolso = ''', pr_nc_rembolso, ''',');
	END IF;

	IF pr_complemento_terceros != '' THEN
		SET lo_complemento_terceros = CONCAT(' complemento_terceros = ''',pr_complemento_terceros,''',');
    END IF;

	IF pr_nc_tipo_remb > 0 THEN
		SET lo_nc_tipo_remb = CONCAT(' nc_tipo_remb = ''', pr_nc_tipo_remb, ''',');
	END IF;

	SET @query = CONCAT('UPDATE ic_fac_tr_factura_detalle
						SET ',
							lo_id_prov_tpo_serv,
							lo_id_boleto,
                            lo_id_factura_cxs,
							lo_id_grupo_fit,
                            lo_id_proveedor,
                            lo_id_servicio,
                            lo_consecutivo,
							lo_clave_prod_serv_sat,
                            lo_clave_prod_serv_desc_sat,
							lo_numero_boleto,
                            lo_concepto,
							lo_nombre_pasajero,
                            lo_tarifa_moneda_base,
							lo_tarifa_moneda_facturada,
                            lo_comision_agencia,
							lo_porc_comision_agencia,
                            lo_descuento,
							lo_comision_titular,
                            lo_porc_comision_titular,
							lo_comision_auxiliar,
                            lo_porc_comision_auxiliar,
							lo_suma_impuestos,
                            lo_iva_comision,
							lo_porc_iva_comision,
                            lo_boleto_contra,
							lo_la_contra,
                            lo_numero_boleto_contra,
							lo_boleto_conjunto,
                            lo_id_prov_num_cta,
							lo_id_prov_num_cta_resul,
                            lo_porc_descuento,
							lo_iva_descuento,
                            lo_importe_credito,
							lo_numero_tarjeta,
                            lo_referencia_cxp,
							lo_numero_bol_cxs,
							lo_bol_electronico,
                            lo_id_regla,
							lo_comision_cedida,
                            lo_clave_reservacion,
							lo_boleto_facturado,
                            lo_facturar_agencia,
                            lo_importe_markup,
							lo_porc_markup,
                            lo_num_servicios,
                            lo_id_unidad_medida,
							lo_clave_unidad_sat,
							lo_cuenta_ingreso,
                            lo_cuenta_ingreso_porcentaje,
							lo_impuesto_x_pagar,
                            lo_cantidad,
                            lo_nc_rembolso,
                            lo_complemento_terceros,
                            lo_nc_tipo_remb,
							' id_usuario =',pr_id_usuario,'
						WHERE id_factura_detalle = ?'
	);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	SET @id_factura_detalle = pr_id_factura_detalle;
	EXECUTE stmt USING @id_factura_detalle;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
