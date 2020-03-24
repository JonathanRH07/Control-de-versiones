DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_i`(
	IN	pr_id_grupo_empresa					INT,
    IN 	pr_id_usuario						INT,
	IN 	pr_id_sucursal						INT,
	IN 	pr_id_corporativo 					INT,
	IN 	pr_id_vendedor 						INT,
    IN 	pr_id_direccion						INT,
	IN 	pr_rfc 								VARCHAR(13),
	IN 	pr_cve_cliente 						VARCHAR(45),
	IN  pr_razon_social 					VARCHAR(255),
	IN 	pr_tipo_persona 					CHAR(1),
	IN 	pr_nombre_comercial 				VARCHAR(255),
	IN 	pr_tipo_cliente 					ENUM('EVENTUAL','FIJO'),
	IN 	pr_telefono 						VARCHAR(15),
    IN 	pr_email							VARCHAR(255),
	IN 	pr_cve_gds 							VARCHAR(10),
	IN 	pr_datos_adicionales 				INT(11),
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
    OUT pr_inserted_id						INT,
    OUT pr_affect_rows	    				INT,
	OUT pr_message		    				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_clientes_i
		@fecha:			03/01/2017
		@descripcion:	SP para agregar registros en la tabla de clientes.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_corporativo		VARCHAR(10) DEFAULT NULL;
    DECLARE	lo_vendedor			VARCHAR(10) DEFAULT NULL;
    DECLARE	lo_id_direccion		VARCHAR(10) DEFAULT NULL;
    DECLARE lo_id_empresa		INT;
    DECLARE lo_id_tipo_paquete	INT;
    DECLARE lo_complemento_ine	CHAR(1) DEFAULT 'N';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'CLIENTS.MESSAGE_ERROR_CREATE_CLIENTE';
		SET pr_affect_rows = 0;
        #CALL sp_glob_direccion2_d(pr_id_direccion);
		ROLLBACK;
	END;

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

    IF lo_id_tipo_paquete > 1 THEN
		SET lo_complemento_ine = pr_complemento_ine;
    END IF;

	IF pr_id_corporativo != '' THEN
		SET lo_corporativo = pr_id_corporativo;
	END IF;

    IF pr_id_vendedor != 0 THEN
		SET lo_vendedor = pr_id_vendedor;
	END IF;

	IF pr_id_direccion = 0 THEN
		SET lo_id_direccion = NULL;
	ELSE
		SET lo_id_direccion=pr_id_direccion;
	END IF;

	CALL sp_help_get_row_count_params(
			'ic_cat_tr_cliente',
			pr_id_grupo_empresa,
			CONCAT(' cve_cliente =  "', pr_cve_cliente,'" '),
			@has_relations_with_client, pr_message
	);

	IF @has_relations_with_client > 0 THEN
		SET @error_code = 'DUPLICATED_CODE';
		SET pr_message =  'ERROR.CVE_DUPLICATE';/*CONCAT('{"error": "4002", "code": "CLIENT.', @error_code, '", "count": ',(@has_relations_with_client),'}');*/
		SET pr_affect_rows = 0;
		CALL sp_glob_direccion2_d(pr_id_direccion);
		ROLLBACK;
	ELSE

        INSERT INTO ic_cat_tr_cliente (
			id_grupo_empresa,
			id_usuario,
			id_sucursal,
			id_corporativo,
			id_vendedor,
			id_direccion,
            id_cuenta_contable,
			rfc,
			cve_cliente,
			razon_social,
			tipo_persona,
			nombre_comercial,
			tipo_cliente,
			telefono,
            email,
			cve_gds,
			datos_adicionales,
			cuenta_pagos_fe,
			enviar_mail_boleto,
			facturar_boleto,
            facturar_boleto_automatico,
			observaciones,
			notas_factura,
			envio_cfdi_portal,
            dias_credito,
            limite_credito,
            complemento_ine,
			fp_credito_agencia,
			fp_contado,
			fp_tc_cliente,
			gr_credito_agencia,
			gr_contado,
			gr_tc_agencia,
			gr_tc_cliente,
            fecha_creacion
		) VALUES (
            pr_id_grupo_empresa,
			pr_id_usuario,
			pr_id_sucursal,
			lo_corporativo,
			lo_vendedor,
			lo_id_direccion,
            pr_id_cuenta_contable,
			pr_rfc,
			pr_cve_cliente,
			pr_razon_social,
			pr_tipo_persona,
			pr_nombre_comercial,
			pr_tipo_cliente,
			pr_telefono,
            pr_email,
			pr_cve_gds,
			pr_datos_adicionales,
			pr_cuenta_pagos_fe,
			pr_enviar_mail_boleto,
			pr_facturar_boleto,
            pr_facturar_boleto_automatico,
			pr_observaciones,
			pr_notas_factura,
			pr_envio_cfdi_portal,
            pr_dias_credito,
            pr_limite_credito,
            lo_complemento_ine,
            pr_fp_credito_agencia,
            pr_fp_contado,
            pr_fp_tc_cliente,
            pr_gr_credito_agencia,
            pr_gr_contado,
            pr_gr_tc_agencia,
            pr_gr_tc_cliente,
            NOW()
		);

		SET pr_inserted_id 	= @@identity;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		# Mensaje de ejecución.
		SET pr_message = 'SUCCESS';

	END IF;
END$$
DELIMITER ;
