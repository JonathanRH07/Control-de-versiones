DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_cdfi_i`(
	IN  pr_id_grupo_empresa 		INT(11),
    IN  pr_id_pac					INT(11),
	IN  pr_series_electronica 		CHAR(1),
	IN  pr_validar_email_vendedor 	CHAR(1),
	IN  pr_asignar_impre_series_e 	CHAR(1),
	IN  pr_enviar_email_cancela 	CHAR(1),
	IN  pr_email_notificaciones 	VARCHAR(255),
	IN  pr_metodo_pago 				CHAR(5),
	IN  pr_uso_cfdi 				CHAR(5),
	IN  pr_regimen_fiscal_sat 		CHAR(5),
    IN  pr_enviar_factura 			CHAR(1),
    IN  pr_validar_campos 			CHAR(1),
    IN  pr_archivo_certificado  	VARCHAR(255),
	IN  pr_vigencia_desde   		TIMESTAMP,
	IN  pr_vigencia_hasta   		TIMESTAMP,
	IN  pr_avisame    				NUMERIC(2,0),
	IN  pr_no_certificado   		CHAR(20),
	IN  pr_archivo_llave  			VARCHAR(255),
	IN  pr_contrasena   			CHAR(255),
	IN  pr_rfc_eventuales  			CHAR(20),
	IN  pr_rfc_extranjero   		CHAR(20),
	IN  pr_certificado  			TEXT,
	IN  pr_portal_timbrado_valida 	CHAR(1),
	IN  pr_portal_timbrado_usuario  VARCHAR(255),
	IN  pr_portal_timbrado_pwd  	VARCHAR(255),
	IN  pr_archivo_pfx   			VARCHAR(255),
	IN  pr_fecha_sello  			TIMESTAMP,
	IN  pr_folio_sat   				VARCHAR(22),
    IN  pr_id_usuario				INT,
	-- IN  pr_certificado_2048  		char(1),
    OUT pr_inserted_id				INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_config_cfdi_i
	@fecha: 		21/03/2017
	@descripcion: 	SP para insertar registros en la tabla config_cdfi
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_adm_config_cfdi_i';
        SET pr_affect_rows = 0;
	END;

	#Valores default de parametros

    SET pr_id_pac 					= 4;
    SET pr_series_electronica 		= 'N';
    SET pr_validar_email_vendedor 	= 'S';
	SET pr_asignar_impre_series_e 	= 'S';
	SET pr_enviar_email_cancela 	= 'S';
	SET pr_email_notificaciones 	= '';
	SET pr_metodo_pago 				= 'PPD';
	SET pr_uso_cfdi 				= 'G03';
	SET pr_regimen_fiscal_sat 		= '601';
    SET pr_enviar_factura 			= 'S';
    SET pr_validar_campos 			= 'S';
    SET pr_archivo_certificado  	= '34@CSD10_AAA010101AAA.cer';
	SET pr_vigencia_desde   		= '';
	SET pr_vigencia_hasta   		= '';
	SET pr_avisame    				= 30;
	SET pr_no_certificado   		= '30001000000300023701';
	SET pr_archivo_llave  			= '34@CSD10_AAA010101AAA.key';
	SET pr_contrasena   			= '12345678a';
	SET pr_rfc_eventuales  			= 'XAXX010101000';
	SET pr_rfc_extranjero   		= 'XEXX010101000';
	SET pr_certificado  			= '-----BEGIN PUBLIC KEY-----
 MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiJX7vpDun2LkGPgbVi5i
 4+1/9w793I1fX2jrLnsKIpyAZgSo+pvzxwn8g8/IU8gW0F3FgmaqKTEzDEMdMiyi
 UjQYy+oQ7UGyiRwM4vhR8xm3s2ZhofU/w2P987nGfRvWpKdJ9AcZ08syBews+FpH
 r0dESxUQijAQwzm5yg0CtI3N6XhclTxf92ei6Zm9o7IJ28QLTvo3MHdQkDndkPXG
 +88R51R8B+PZ5pQJAlg+dOjJ/tMA4bPMaRfkQZyPELdh9xcbAbZ411tJvFKIAM/H
 pAAKCyUK7W/OYLPBACZ94dZC+KullxwnIP/yyF3vPt+/kD8bSDdoOWgzkBfADecN
 WwIDAQAB
 -----END PUBLIC KEY-----
 ';
	SET pr_portal_timbrado_valida 	= 'N';
	SET pr_portal_timbrado_usuario  = 'usrws_565';
	SET pr_portal_timbrado_pwd  	= 'G!6j7Wkv#0!XX';
	SET pr_archivo_pfx   			= '1@example.pfx';
	SET pr_fecha_sello  			= '';
	SET pr_folio_sat   				= '';

	INSERT INTO  suite_mig_conf.st_adm_tr_config_cfdi(
		id_grupo_empresa,
        id_pac,
        series_electronica,
        validar_email_vendedor,
        asignar_impre_series_e,
        enviar_email_cancela,
        email_notificaciones,
        metodo_pago,
        uso_cfdi,
        regimen_fiscal_sat,
        enviar_factura,
        validar_campos,
        archivo_certificado,
        vigencia_desde,
        vigencia_hasta,
        avisame,
        no_certificado,
        archivo_llave,
        contrasena,
        rfc_eventuales,
        rfc_extranjero,
        certificado,
        portal_timbrado_valida,
        portal_timbrado_usuario,
        portal_timbrado_pwd,
        archivo_pfx,
        fecha_sello,
        folio_sat,
        id_usuario
        -- certificado_2048
		)
	VALUES
		(
		pr_id_grupo_empresa,
        4,
        pr_series_electronica,
        pr_validar_email_vendedor,
        pr_asignar_impre_series_e,
        pr_enviar_email_cancela,
        pr_email_notificaciones,
        pr_metodo_pago,
        pr_uso_cfdi,
        pr_regimen_fiscal_sat,
        pr_enviar_factura,
        pr_validar_campos,
        pr_archivo_certificado,
        pr_vigencia_desde,
        pr_vigencia_hasta,
        pr_avisame,
        pr_no_certificado,
        pr_archivo_llave,
        pr_contrasena,
        pr_rfc_eventuales,
        pr_rfc_extranjero,
        pr_certificado,
        pr_portal_timbrado_valida,
        pr_portal_timbrado_usuario,
        pr_portal_timbrado_pwd,
        pr_archivo_pfx,
        pr_fecha_sello,
        pr_folio_sat,
        pr_id_usuario
        -- pr_certificado_2048
		);


	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';
END$$
DELIMITER ;
