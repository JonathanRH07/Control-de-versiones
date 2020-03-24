DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_u`(
	IN  pr_id_factura 			INT(11),
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_id_sucursal 			INT(11),
	IN  pr_id_serie 			INT(11),
	IN  pr_id_cliente 			INT(11),
	IN  pr_id_centro_costo_n1 	VARCHAR(2000),
	IN  pr_id_centro_costo_n2 	VARCHAR(2000),
	IN  pr_id_centro_costo_n3 	VARCHAR(2000),
	IN  pr_id_vendedor_tit 		INT(11),
	IN  pr_id_vendedor_aux 		INT(11),
	IN  pr_id_moneda 			INT(11),
    IN  pr_id_status_cancelacion INT(11),
    IN  pr_razon_social			VARCHAR(255),
    IN  pr_nombre_comercial		VARCHAR(255),
	IN  pr_id_direccion 		INT(11),
    IN  pr_rfc					CHAR(20),
    IN  pr_tel					CHAR(30),
	IN  pr_id_usuario 			INT(11),
	IN  pr_id_origen 			INT(11),
	IN  pr_id_unidad_negocio 	INT(11),
	IN  pr_id_cuenta_contable 	INT(11),
    IN  pr_fecha_factura		DATE,
    IN  pr_hora_factura			TIME,
	IN  pr_tipo_cambio 			DECIMAL(15,4),
	IN  pr_solicito_cliente 	VARCHAR(100),
	IN  pr_total_moneda_facturada DECIMAL(13,2),
	IN  pr_total_moneda_base 	DECIMAL(13,2),
	IN  pr_nota 				VARCHAR(100),
	IN  pr_total_descuento 		DECIMAL(13,2),
	IN  pr_globalizador 		CHAR(6),
	IN  pr_descripcion_exten 	VARCHAR(255),
	IN  pr_estatus 				ENUM('ACTIVO','CANCELADA'),
    IN  pr_id_razon_cancelacion INT(11),
	IN  pr_motivo_cancelacion 	VARCHAR(255),
	IN  pr_aplica_contabilidad 	INT(1),
	IN  pr_fecha_cancelacion 	VARCHAR(100),
    IN  pr_fecha_solicitud_cancelacion	DATE,
    IN  pr_hora_solicitud_cancelacion	TIME,
	IN  pr_envio_electronico 	CHAR(1),
	IN  pr_tipo_formato 		CHAR(2),
    IN  pr_id_pnr_consecutivo	INT(11),
    IN  pr_pnr					CHAR(6),
	IN  pr_confirmacion_pac 	CHAR(5),
    IN  pr_email_envio 			VARCHAR(300),
	IN  pr_c_MetodoPago 		CHAR(3),
	IN  pr_c_UsoCFDI 			CHAR(3),
    IN  pr_cve_tipo_cfdi_ingreso	    CHAR(2),
    IN  pr_cve_tipo_serie		CHAR(4),
	OUT pr_affect_rows 			INT,
    OUT pr_message 	   			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_facturacion_u
		@fecha:			03/03/2017
		@descripcion:	SP para actualizar registros en el modulo de facturacion.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	# Declaración de variables.
    DECLARE lo_id_factura				VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_grupo_empresa			VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_sucursal 				VARCHAR(1000) DEFAULT '';
	DECLARE lo_id_serie					VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_cliente				VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_centro_costo_n1 		VARCHAR(1000) DEFAULT '';
	DECLARE lo_id_centro_costo_n2		VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_centro_costo_n3		VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_vendedor_tit 			VARCHAR(1000) DEFAULT '';
	DECLARE lo_id_vendedor_aux			VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_moneda				VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_status_can			VARCHAR(1000) DEFAULT '';
    DECLARE lo_razon_social				VARCHAR(300) DEFAULT '';
    DECLARE lo_nombre_comercial			VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_direccion 			VARCHAR(1000) DEFAULT '';
    DECLARE lo_rfc						VARCHAR(1000) DEFAULT '';
    DECLARE lo_tel						VARCHAR(1000) DEFAULT '';
	DECLARE lo_id_usuario				VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_origen				VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_unidad_negocio 		VARCHAR(1000) DEFAULT '';
	DECLARE lo_id_cuenta_contable		VARCHAR(1000) DEFAULT '';
    DECLARE lo_fecha_factura			VARCHAR(1000) DEFAULT '';
    DECLARE lo_hora_factura				VARCHAR(1000) DEFAULT '';
    DECLARE lo_tipo_cambio 				VARCHAR(1000) DEFAULT '';
	DECLARE lo_solicito_cliente			VARCHAR(1000) DEFAULT '';
    DECLARE lo_total_moneda_facturada	VARCHAR(1000) DEFAULT '';
    DECLARE lo_total_moneda_base 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_nota						VARCHAR(1000) DEFAULT '';
    DECLARE lo_total_descuento			VARCHAR(1000) DEFAULT '';
    DECLARE lo_globalizador 			VARCHAR(1000) DEFAULT '';
    DECLARE lo_descripcion_exten		VARCHAR(1000) DEFAULT '';
    DECLARE lo_estatus 					VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_razon_cancelacion		VARCHAR(1000) DEFAULT '';
    DECLARE lo_motivo_cancelacion		VARCHAR(1000) DEFAULT '';
    DECLARE lo_aplica_contabilidad 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_fecha_cancelacion		VARCHAR(1000) DEFAULT '';
    DECLARE lo_fecha_solicitud_cancelacion 	VARCHAR(1000) DEFAULT '';
    DECLARE lo_hora_solicitud_cancelacion 	VARCHAR(1000) DEFAULT '';
    DECLARE lo_envio_electronico 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_tipo_formato 			VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_pnr_consecutivo		VARCHAR(1000) DEFAULT '';
    DECLARE lo_pnr						VARCHAR(1000) DEFAULT '';
    DECLARE lo_confirmacion_pac 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_email_envio 				VARCHAR(1000) DEFAULT '';
	DECLARE lo_c_MetodoPago 			VARCHAR(1000) DEFAULT '';
	DECLARE lo_c_UsoCFDI 				VARCHAR(1000) DEFAULT '';
    DECLARE lo_cve_tipo_cfdi_ingreso    VARCHAR(1000) DEFAULT '';
    DECLARE lo_cve_tipo_serie			VARCHAR(1000) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR store sp_fac_facturacion_u';
        SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

    -- START TRANSACTION;

	IF pr_id_sucursal >0 THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = ', pr_id_sucursal,',');
	END IF;

    IF pr_id_serie >0 THEN
		SET lo_id_serie = CONCAT('id_serie = ', pr_id_serie,',');
	END IF;

    IF pr_id_cliente >0 THEN
		SET lo_id_cliente = CONCAT('id_cliente = ', pr_id_cliente,',');
	END IF;

    IF pr_id_centro_costo_n1 != '' THEN
		SET lo_id_centro_costo_n1 = CONCAT('id_centro_costo_n1 = ''', pr_id_centro_costo_n1,''',');
	END IF;

    IF pr_id_centro_costo_n2 != '' THEN
		SET lo_id_centro_costo_n2 = CONCAT('id_centro_costo_n2 = ''', pr_id_centro_costo_n2,''',');
	END IF;

    IF pr_id_centro_costo_n3 != '' THEN
		SET lo_id_centro_costo_n3 = CONCAT('id_centro_costo_n3 = ''', pr_id_centro_costo_n3,''',');
	END IF;

    IF pr_id_vendedor_tit >0 THEN
		SET lo_id_vendedor_tit = CONCAT('id_vendedor_tit = ', pr_id_vendedor_tit,',');
	END IF;

    IF pr_id_vendedor_aux >0 THEN
		SET lo_id_vendedor_aux = CONCAT('id_vendedor_aux = ', pr_id_vendedor_aux,',');
	END IF;

    IF pr_id_moneda >0 THEN
		SET lo_id_moneda = CONCAT('id_moneda = ', pr_id_moneda,',');
	END IF;

    IF pr_id_status_cancelacion >0 THEN
		SET lo_id_status_can = CONCAT('id_status_cancelacion = ', pr_id_status_cancelacion,',');
	END IF;

    IF pr_razon_social != '' THEN
		SET lo_razon_social = CONCAT('razon_social =  "', pr_razon_social, '",');
	END IF;

    IF pr_nombre_comercial != '' THEN
		SET lo_nombre_comercial = CONCAT('nombre_comercial =  "', pr_nombre_comercial, '",');
	END IF;

    IF pr_id_direccion >0 THEN
		SET lo_id_direccion = CONCAT('id_direccion = ', pr_id_direccion,',');
	END IF;

    IF pr_rfc !='' THEN
		SET lo_rfc = CONCAT('rfc = "', pr_rfc,'",');
	END IF;

    IF pr_tel >0 THEN
		SET lo_tel = CONCAT('tel = ', pr_tel,',');
	END IF;

    IF pr_id_origen >0 THEN
		SET lo_id_origen = CONCAT('id_origen = ', pr_id_origen,',');
	END IF;

    IF pr_id_unidad_negocio >0 THEN
		SET lo_id_unidad_negocio = CONCAT('id_unidad_negocio = ', pr_id_unidad_negocio,',');
	END IF;

    IF pr_id_cuenta_contable >0 THEN
		SET lo_id_cuenta_contable = CONCAT('id_cuenta_contable = ', pr_id_cuenta_contable,',');
	END IF;

    IF pr_fecha_factura > '0000-00-00' THEN
		SET lo_fecha_factura = CONCAT('fecha_factura = "', pr_fecha_factura,'",');
	END IF;

    IF pr_hora_factura > '00:00:00' THEN
		SET lo_hora_factura = CONCAT('hora_factura = "', pr_hora_factura,'",');
	END IF;

    IF pr_tipo_cambio >0 THEN
		SET lo_tipo_cambio = CONCAT('tipo_cambio = ', pr_tipo_cambio,',');
	END IF;

    IF pr_solicito_cliente != '' THEN
		SET lo_solicito_cliente = CONCAT('solicito_cliente =  "', pr_solicito_cliente, '",');
	END IF;

    IF pr_total_moneda_facturada >0 THEN
		SET lo_total_moneda_facturada = CONCAT('total_moneda_facturada = ', pr_total_moneda_facturada,',');
	END IF;

    IF pr_total_moneda_base >0 THEN
		SET lo_total_moneda_base = CONCAT('total_moneda_base = ', pr_total_moneda_base,',');
	END IF;

    IF pr_nota != '' THEN
		SET lo_nota = CONCAT('nota =  "', pr_nota, '",');
	END IF;

    IF pr_total_descuento >0 THEN
		SET lo_total_descuento = CONCAT('total_descuento = ', pr_total_descuento,',');
	END IF;

    IF pr_globalizador != '' THEN
		SET lo_globalizador = CONCAT('globalizador =  "', pr_globalizador, '",');
	END IF;

    IF pr_descripcion_exten != '' THEN
		SET lo_descripcion_exten = CONCAT('descripcion_exten =  "', pr_descripcion_exten, '",');
	END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus =  "', pr_estatus, '",');
	END IF;

    IF pr_id_razon_cancelacion >0 THEN
		SET lo_id_razon_cancelacion = CONCAT('id_razon_cancelacion = ', pr_id_razon_cancelacion,',');
	END IF;

	IF pr_motivo_cancelacion != '' THEN
		SET lo_motivo_cancelacion = CONCAT('motivo_cancelacion =  "', pr_motivo_cancelacion, '",');
	END IF;

    IF pr_aplica_contabilidad >0 THEN
		SET lo_aplica_contabilidad = CONCAT('aplica_contabilidad = ', pr_aplica_contabilidad,',');
	END IF;

	IF pr_fecha_cancelacion != '' THEN
		SET lo_fecha_cancelacion = CONCAT('fecha_cancelacion =  "', pr_fecha_cancelacion, '",');
	END IF;

    IF pr_fecha_solicitud_cancelacion > '0000-00-00' THEN
		SET lo_fecha_solicitud_cancelacion = CONCAT('fecha_solicitud_cancelacion = "', pr_fecha_solicitud_cancelacion,'",');
	END IF;

    IF pr_hora_solicitud_cancelacion > '00:00:00' THEN
		SET lo_hora_solicitud_cancelacion = CONCAT('hora_solicitud_cancelacion = "', pr_hora_solicitud_cancelacion,'",');
	END IF;

    IF pr_envio_electronico != '' THEN
		SET lo_envio_electronico = CONCAT('envio_electronico =  "', pr_envio_electronico, '",');
	END IF;

	IF pr_tipo_formato != '' THEN
		SET lo_tipo_formato = CONCAT('tipo_formato =  "', pr_tipo_formato, '",');
	END IF;

    IF pr_id_pnr_consecutivo != '' THEN
		SET lo_id_pnr_consecutivo = CONCAT(' id_pnr_consecutivo=  "', pr_id_pnr_consecutivo, '",');
	END IF;

    IF pr_pnr > 0 THEN
		SET lo_pnr = CONCAT(' pnr= ', pr_pnr, ',');
	END IF;

	IF pr_confirmacion_pac != '' THEN
		SET lo_confirmacion_pac = CONCAT('confirmacion_pac =  "', pr_confirmacion_pac, '",');
	END IF;

    IF pr_email_envio != '' THEN
		SET lo_email_envio = CONCAT('email_envio ="', pr_email_envio ,'",');
	END IF;

    IF pr_c_MetodoPago != '' THEN
		SET lo_c_MetodoPago = CONCAT('c_MetodoPago =  "', pr_c_MetodoPago, '",');
	END IF;

    IF pr_c_UsoCFDI != '' THEN
		SET lo_c_UsoCFDI = CONCAT('c_UsoCFDI =  "', pr_c_UsoCFDI, '",');
	END IF;

	IF pr_cve_tipo_cfdi_ingreso != '' THEN
		SET lo_cve_tipo_cfdi_ingreso = CONCAT('cve_tipo_cfdi_ingreso =  "', pr_cve_tipo_cfdi_ingreso, '",');
	END IF;

    IF pr_cve_tipo_serie != '' THEN
		SET lo_cve_tipo_serie = CONCAT('cve_tipo_serie =  "', pr_cve_tipo_serie, '",');
	END IF;

	SET @query = CONCAT('UPDATE ic_fac_tr_factura
						SET ',
							lo_id_sucursal,
							lo_id_serie,
                            lo_id_cliente,
							lo_id_centro_costo_n1,
                            lo_id_centro_costo_n2,
							lo_id_centro_costo_n3,
                            lo_id_vendedor_tit,
							lo_id_vendedor_aux,
                            lo_id_moneda,
                            lo_id_status_can,
                            lo_razon_social,
                            lo_nombre_comercial,
							lo_id_direccion,
                            lo_rfc,
                            lo_tel,
                            lo_id_origen,
							lo_id_unidad_negocio,
                            lo_id_cuenta_contable,
                            lo_fecha_factura,
                            lo_hora_factura,
                            lo_tipo_cambio,
							lo_solicito_cliente,
                            lo_total_moneda_facturada,
							lo_total_moneda_base,
                            lo_nota,
							lo_total_descuento,
                            lo_globalizador,
							lo_descripcion_exten,
                            lo_estatus,
                            lo_id_razon_cancelacion,
							lo_motivo_cancelacion,
                            lo_aplica_contabilidad,
							lo_fecha_cancelacion,
                            lo_fecha_solicitud_cancelacion,
                            lo_hora_solicitud_cancelacion,
                            lo_envio_electronico,
							lo_tipo_formato,
                            lo_id_pnr_consecutivo,
                            lo_pnr,
                            lo_confirmacion_pac,
                            lo_email_envio,
							lo_c_MetodoPago,
							lo_c_UsoCFDI,
                            lo_cve_tipo_cfdi_ingreso,
                            lo_cve_tipo_serie,
							' id_usuario=',pr_id_usuario,'
						WHERE id_factura = ?
						AND
						id_grupo_empresa=',pr_id_grupo_empresa,''
	);
-- select @query;
	PREPARE stmt FROM @query;
	SET @id_factura = pr_id_factura;
	EXECUTE stmt USING @id_factura;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
