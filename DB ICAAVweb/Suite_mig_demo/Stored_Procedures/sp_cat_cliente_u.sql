DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_u`(
	IN 	pr_id_cliente						INT,
	IN	pr_id_grupo_empresa					INT,
    IN 	pr_id_usuario						INT,
	IN 	pr_id_sucursal						INT,
	IN 	pr_id_corporativo 					INT,
	IN 	pr_id_vendedor 						INT,
	IN 	pr_rfc 								VARCHAR(13),
	IN  pr_razon_social 					VARCHAR(255),
	IN 	pr_tipo_persona 					CHAR(1),
	IN 	pr_nombre_comercial 				VARCHAR(255),
	IN 	pr_tipo_cliente 					ENUM('EVENTUAL','FIJO'),
	IN 	pr_telefono 						VARCHAR(15),
    IN 	pr_email							VARCHAR(255),
	IN 	pr_cve_gds 							VARCHAR(10),
	IN 	pr_datos_adicionales 				INT,
	IN 	pr_cuenta_pagos_fe 					VARCHAR(255),
	IN	pr_enviar_mail_boleto 				CHAR(1),
	IN 	pr_facturar_boleto 					CHAR(1),
    IN 	pr_facturar_boleto_automatico 		CHAR(1),
	IN 	pr_observaciones 					VARCHAR(55),
	IN 	pr_notas_factura 					VARCHAR(255),
	IN 	pr_envio_cfdi_portal				CHAR(1),
    IN  pr_id_cuenta_contable				INT,
    IN  pr_dias_credito						INT,
    IN  pr_limite_credito					DECIMAL(13,2),
    IN 	pr_complemento_ine					CHAR(1),
    IN  pr_fp_credito_agencia				CHAR(1),
	IN  pr_fp_contado						CHAR(1),
	IN  pr_fp_tc_cliente					CHAR(1),
	IN  pr_gr_credito_agencia				CHAR(1),
	IN  pr_gr_contado						CHAR(1),
	IN  pr_gr_tc_agencia					CHAR(1),
	IN  pr_gr_tc_cliente					CHAR(1),
    IN	pr_estatus 							ENUM('ACTIVO','INACTIVO'),
    OUT pr_affect_rows	        			INT,
	OUT pr_message		        			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_cliente_u
		@fecha:			22/12/2016
		@descripcion:	SP para actualizar registro de catalogo de clientes.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	# Declaración de variables.
	DECLARE lo_id_sucursal						VARCHAR(1000) DEFAULT '';
	DECLARE lo_id_corporativo 					VARCHAR(1000) DEFAULT '';
	DECLARE lo_id_vendedor 						VARCHAR(1000) DEFAULT '';
	DECLARE lo_rfc 								VARCHAR(1000) DEFAULT '';
	DECLARE lo_razon_social 					VARCHAR(1000) DEFAULT '';
	DECLARE lo_tipo_persona 					VARCHAR(1000) DEFAULT '';
	DECLARE lo_nombre_comercial 				VARCHAR(1000) DEFAULT '';
	DECLARE lo_tipo_cliente 					VARCHAR(1000) DEFAULT '';
	DECLARE lo_telefono 						VARCHAR(1000) DEFAULT '';
    DECLARE lo_email							VARCHAR(1000) DEFAULT '';
	DECLARE lo_cve_gds 							VARCHAR(1000) DEFAULT '';
	DECLARE lo_datos_adicionales 				VARCHAR(1000) DEFAULT '';
	DECLARE lo_cuenta_pagos_fe 					VARCHAR(1000) DEFAULT '';
	DECLARE	lo_enviar_mail_boleto 				VARCHAR(1000) DEFAULT '';
	DECLARE lo_facturar_boleto 					VARCHAR(1000) DEFAULT '';
    DECLARE lo_facturar_boleto_automatico		VARCHAR(1000) DEFAULT '';
	DECLARE lo_observaciones 					VARCHAR(1000) DEFAULT '';
	DECLARE lo_notas_factura 					VARCHAR(1000) DEFAULT '';
	DECLARE lo_envio_cfdi_portal				VARCHAR(1000) DEFAULT '';
    DECLARE	lo_estatus 							VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_cuenta_contable				VARCHAR(1000) DEFAULT '';
    DECLARE lo_dias_credito						VARCHAR(1000) DEFAULT '';
    DECLARE lo_limite_credito					VARCHAR(1000) DEFAULT '';
    DECLARE lo_complemento_ine					VARCHAR(1000) DEFAULT '';
	DECLARE lo_inserted_id 	    				VARCHAR(1000) DEFAULT '';
	DECLARE lo_valida_dir 						INT;
    DECLARE lo_fp_credito_agencia				VARCHAR(1000) DEFAULT '';
    DECLARE lo_fp_contado						VARCHAR(1000) DEFAULT '';
    DECLARE lo_fp_tc_cliente					VARCHAR(1000) DEFAULT '';
    DECLARE lo_gr_credito_agencia				VARCHAR(1000) DEFAULT '';
    DECLARE lo_gr_contado						VARCHAR(1000) DEFAULT '';
    DECLARE lo_gr_tc_agencia					VARCHAR(1000) DEFAULT '';
    DECLARE lo_gr_tc_cliente					VARCHAR(1000) DEFAULT '';
	DECLARE lo_id_empresa						INT;
    DECLARE lo_id_tipo_paquete					INT;


	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'CLIENTS.MESSAGE_ERROR_UPDATE_CLIENTE';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END ;*/

	SELECT
		id_empresa
	INTO
		lo_id_empresa
	FROM suite_mig_conf.st_adm_tr_grupo_empresa
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

	SELECT
		id_tipo_paquete
	INTO
		lo_id_tipo_paquete
	FROM suite_mig_conf.st_adm_tr_empresa
	WHERE id_empresa = lo_id_empresa;

    IF pr_id_sucursal > 0 THEN
		SET lo_id_sucursal = CONCAT(' id_sucursal = ', pr_id_sucursal,',');
	END IF;

    IF pr_id_corporativo != '' THEN
		SET lo_id_corporativo = CONCAT('id_corporativo  = ', pr_id_corporativo, ',');
    ELSE IF pr_id_corporativo = '' THEN
			SET lo_id_corporativo = CONCAT('id_corporativo  = NULL,');
		END IF;
	END IF;

    IF pr_id_vendedor != '' THEN
		SET lo_id_vendedor = CONCAT('id_vendedor  = ', pr_id_vendedor, ',');
    ELSE IF pr_id_vendedor = '' THEN
			SET lo_id_vendedor = CONCAT('id_vendedor  = NULL,');
		END IF;
	END IF;

    IF pr_rfc !='' THEN
		SET lo_rfc = CONCAT(' rfc = "', pr_rfc, '",');
	END IF;

    IF pr_razon_social !='' THEN
		SET lo_razon_social = CONCAT(' razon_social = "', pr_razon_social, '",');
	END IF;

    IF pr_tipo_persona !='' THEN
		SET lo_tipo_persona = CONCAT(' tipo_persona = "', pr_tipo_persona, '",');
	END IF;

	IF pr_nombre_comercial !='' THEN
		SET lo_nombre_comercial = CONCAT(' nombre_comercial = "', pr_nombre_comercial, '",');
	END IF;

    IF pr_tipo_cliente !='' THEN
		SET lo_tipo_cliente = CONCAT(' tipo_cliente = "', pr_tipo_cliente, '",');
	END IF;

    IF pr_telefono !='' THEN
		SET lo_telefono = CONCAT(' telefono = "', pr_telefono, '",');
	END IF;

    IF pr_email !='' THEN
		SET lo_email = CONCAT(' email = "', pr_email, '",');
	END IF;

	IF pr_cve_gds !='' THEN
		SET lo_cve_gds = CONCAT(' cve_gds = "', pr_cve_gds, '",');
	END IF;

    IF pr_datos_adicionales >= 0 THEN
		SET lo_datos_adicionales = CONCAT(' datos_adicionales = ', pr_datos_adicionales, ',');
	END IF;

	IF pr_cuenta_pagos_fe !='' THEN
		SET lo_cuenta_pagos_fe = CONCAT(' cuenta_pagos_fe = "', pr_cuenta_pagos_fe, '",');
	END IF;

	IF pr_enviar_mail_boleto !='' THEN
		SET lo_enviar_mail_boleto = CONCAT(' enviar_mail_boleto = "', pr_enviar_mail_boleto, '",');
	END IF;

	IF pr_facturar_boleto !='' THEN
		SET lo_facturar_boleto = CONCAT(' facturar_boleto = "', pr_facturar_boleto, '",');
	END IF;

	IF pr_facturar_boleto_automatico !='' THEN
		SET lo_facturar_boleto_automatico = CONCAT(' facturar_boleto_automatico = "', pr_facturar_boleto_automatico, '",');
	END IF;

    IF pr_observaciones IS NOT NULL THEN
		IF pr_observaciones = '' THEN
			SET lo_observaciones = CONCAT('observaciones  = "','','",');
		ELSE IF pr_observaciones != '' THEN
				SET lo_observaciones = CONCAT('observaciones  = "', pr_observaciones, '",');
			END IF;
		END IF;
	END IF;

	/*IF pr_observaciones ='null' THEN
		SET lo_observaciones = CONCAT('observaciones  ="','','",');
	END IF;*/

    IF pr_notas_factura IS NOT NULL THEN
		IF pr_notas_factura = '' THEN
			SET lo_notas_factura = CONCAT('notas_factura  ="','','",');
		ELSE IF pr_notas_factura != '' THEN
				SET lo_notas_factura = CONCAT('notas_factura  = "', pr_notas_factura, '",');
			END IF;
		END IF;
    END IF;

    /*IF pr_notas_factura ='null' THEN
		SET lo_notas_factura = CONCAT('notas_factura  ="','','",');
	END IF;*/

	IF pr_envio_cfdi_portal !='' THEN
		SET lo_envio_cfdi_portal = CONCAT(' envio_cfdi_portal = "', pr_envio_cfdi_portal, '",');
	END IF;

    IF pr_id_cuenta_contable = '' THEN
		SET lo_id_cuenta_contable = CONCAT('id_cuenta_contable  = "','','",');
	ELSE IF pr_id_cuenta_contable != '' THEN
			SET lo_id_cuenta_contable = CONCAT('id_cuenta_contable  = "', pr_id_cuenta_contable, '",');
        END IF;
	END IF;

	IF pr_id_cuenta_contable ='null' THEN
		SET lo_id_cuenta_contable = CONCAT('id_cuenta_contable  ="','','",');
	END IF;

    /* SI SE ELIGE LA OPCION DE CREDITO AGENCIA */
    /*
    IF pr_fp_credito_agencia != '' THEN
		IF pr_fp_credito_agencia = 'S' THEN

			SET lo_fp_credito_agencia = CONCAT(' fp_credito_agencia = ''',pr_fp_credito_agencia,''',');
		*/
			-- ---------------------------------------------------------------------------------
			IF pr_dias_credito != '' THEN
				SET lo_dias_credito = CONCAT('dias_credito  = ', pr_dias_credito, ',');
			ELSE IF pr_dias_credito = '' THEN
					SET lo_dias_credito = CONCAT('dias_credito  = NULL,');
				END IF;
			END IF;

			-- --------------------------------------------------------------------------------
			IF pr_limite_credito != '' THEN
				SET lo_limite_credito = CONCAT('limite_credito  = ', pr_limite_credito, ',');
			ELSE IF pr_limite_credito = '' THEN
					SET lo_limite_credito = CONCAT('limite_credito  = NULL,');
				END IF;
			END IF;
	/*
		ELSE

			SET lo_fp_credito_agencia = CONCAT(' fp_credito_agencia = ''',pr_fp_credito_agencia,''',');

		END IF;
	END IF;
    */

    IF pr_fp_contado != '' THEN
		SET lo_fp_contado = CONCAT(' fp_contado = ''',pr_fp_contado,''',');
    END IF;

	IF pr_fp_tc_cliente != '' THEN
		SET lo_fp_tc_cliente = CONCAT(' fp_tc_cliente = ''',pr_fp_tc_cliente,''',');
    END IF;

	IF pr_gr_credito_agencia != '' THEN
		SET lo_gr_credito_agencia = CONCAT(' gr_credito_agencia = ''',pr_gr_credito_agencia,''',');
    END IF;

	IF pr_gr_contado != '' THEN
		SET lo_gr_contado = CONCAT(' gr_contado = ''',pr_gr_contado,''',');
    END IF;

	IF pr_gr_tc_agencia != '' THEN
		SET lo_gr_tc_agencia = CONCAT(' gr_tc_agencia = ''',pr_gr_tc_agencia,''',');
    END IF;

	IF pr_gr_tc_cliente != '' THEN
		SET lo_gr_tc_cliente = CONCAT(' gr_tc_cliente = ''',pr_gr_tc_cliente,''',');
    END IF;

 /* ---------------------------------------------- */

	/*
	IF pr_dias_credito != '' THEN
		SET lo_dias_credito = CONCAT('dias_credito  = ', pr_dias_credito, ',');
	ELSE
		SET lo_dias_credito = CONCAT('dias_credito  = NULL,');
	END IF;
	*/

	/*
	IF pr_limite_credito != '' THEN
		SET lo_limite_credito = CONCAT('limite_credito  = ', pr_limite_credito, ',');
	ELSE
		SET lo_limite_credito = CONCAT('limite_credito  = NULL,');
	END IF;
	*/

	IF lo_id_tipo_paquete > 1 THEN
        IF pr_complemento_ine != '' THEN
			SET lo_complemento_ine = CONCAT(' complemento_ine = "', pr_complemento_ine, '",');
		END IF;
    END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT(' estatus = "', pr_estatus, '",');
    END IF;

	# Actualiza registros en tabla.
    SET @query = CONCAT(' UPDATE ic_cat_tr_cliente
							SET ' ,
							lo_id_sucursal,
							lo_id_corporativo,
							lo_id_vendedor,
							lo_rfc,
							lo_razon_social,
							lo_tipo_persona,
							lo_nombre_comercial,
							lo_tipo_cliente,
							lo_telefono,
							lo_email,
							lo_cve_gds,
							lo_datos_adicionales,
							lo_cuenta_pagos_fe,
							lo_enviar_mail_boleto,
							lo_facturar_boleto,
							lo_facturar_boleto_automatico,
							lo_observaciones,
							lo_notas_factura,
							lo_envio_cfdi_portal,
							lo_id_cuenta_contable,
							lo_dias_credito,
							lo_limite_credito,
							lo_complemento_ine,
                            lo_fp_credito_agencia,
                            lo_fp_contado,
                            lo_fp_tc_cliente,
                            lo_gr_credito_agencia,
                            lo_gr_contado,
                            lo_gr_tc_agencia,
                            lo_gr_tc_cliente,
							lo_estatus,
						  ' id_usuario=',pr_id_usuario
						,' , fecha_mod = sysdate()
					WHERE id_cliente = ?'
	);

    PREPARE stmt FROM @query;
	SET @id_cliente = pr_id_cliente;
    EXECUTE stmt USING @id_cliente;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
