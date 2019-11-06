DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_cdfi_u`(
	IN  pr_id_config_cfdi 			INT(11),
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
	IN  pr_id_usuario		  		INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_config_cdfi_u
	@fecha: 		21/03/2017
	@descripcion: 	SP para actualizar registro en la tabla st_adm_tr_config_cdfi
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE  lo_series_electronica 		VARCHAR(1000) DEFAULT '';
    DECLARE  lo_id_pac 					VARCHAR(1000) DEFAULT '';
	DECLARE  lo_validar_email_vendedor 	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_asignar_impre_series_e 	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_enviar_email_cancela 	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_email_notificaciones 	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_metodo_pago 			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_uso_cfdi 				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_regimen_fiscal_sat 		VARCHAR(1000) DEFAULT '';
    DECLARE  lo_enviar_factura 			VARCHAR(100) DEFAULT '';
    DECLARE  lo_validar_campos 			VARCHAR(100) DEFAULT '';
    DECLARE  lo_archivo_certificado  	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_vigencia_desde   		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_vigencia_hasta   		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_avisame    				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_no_certificado   		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_archivo_llave  			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_contrasena   			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_rfc_eventuales  		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_rfc_extranjero   		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_certificado  			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_portal_timbrado_valida 	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_portal_timbrado_usuario VARCHAR(1000) DEFAULT '';
	DECLARE  lo_portal_timbrado_pwd  	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_archivo_pfx   			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_fecha_sello  			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_folio_sat   			VARCHAR(1000) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR store sp_adm_config_cdfi_u';
        SET pr_affect_rows = 0;
	END;

	IF pr_series_electronica != ''  THEN
		SET lo_series_electronica  = CONCAT(' series_electronica = "', pr_series_electronica , '",');
	END IF;

    IF pr_id_pac > 0 THEN
		SET lo_id_pac = CONCAT(' id_pac = "', pr_id_pac , '",');
	END IF;

    IF pr_validar_email_vendedor != '' THEN
		SET lo_validar_email_vendedor = CONCAT(' validar_email_vendedor = "', pr_validar_email_vendedor, '",');
	END IF;

    IF pr_asignar_impre_series_e != ''  THEN
		SET lo_asignar_impre_series_e = CONCAT(' asignar_impre_series_e = "', pr_asignar_impre_series_e, '",');
	END IF;

    IF pr_enviar_email_cancela != ''  THEN
		SET lo_enviar_email_cancela = CONCAT(' enviar_email_cancela = "', pr_enviar_email_cancela, '",');
	END IF;

    IF pr_email_notificaciones != '' THEN
		SET lo_email_notificaciones = CONCAT(' email_notificaciones = "', pr_email_notificaciones, '",');
	END IF;

    IF pr_metodo_pago != ''  THEN
		SET lo_metodo_pago = CONCAT(' metodo_pago = "', pr_metodo_pago, '",');
	END IF;

    IF pr_uso_cfdi !='' THEN
		SET lo_uso_cfdi = CONCAT(' uso_cfdi = "', pr_uso_cfdi, '",');
	END IF;

    IF pr_regimen_fiscal_sat > 0 THEN
		SET lo_regimen_fiscal_sat = CONCAT(' regimen_fiscal_sat = "', pr_regimen_fiscal_sat, '",');
	END IF;

    IF pr_enviar_factura != '' THEN
		SET lo_enviar_factura = CONCAT(' enviar_factura = "', pr_enviar_factura, '",');
	END IF;

    IF pr_validar_campos != '' THEN
		SET lo_validar_campos = CONCAT(' validar_campos = "', pr_validar_campos, '",');
	END IF;

    IF pr_archivo_certificado != ''  THEN
		SET lo_archivo_certificado = CONCAT(' archivo_certificado = "', pr_archivo_certificado, '",');
	END IF;

	IF pr_vigencia_desde != '0000-00-00'  THEN
		SET lo_vigencia_desde = CONCAT(' vigencia_desde = "', pr_vigencia_desde, '",');
	END IF;

	IF pr_vigencia_hasta != '0000-00-00' THEN
		SET lo_vigencia_hasta = CONCAT(' vigencia_hasta = "', pr_vigencia_hasta, '",
										 email_vigencia_proxima = ''N'',
                                         email_vigencia_caduca = ''N'',');
	END IF;

    IF pr_avisame > 0 THEN
		SET lo_avisame = CONCAT(' avisame= ', pr_avisame, ',');
	END IF;

    IF pr_no_certificado != '' THEN
		SET lo_no_certificado = CONCAT(' no_certificado= "', pr_no_certificado, '",');
	END IF;

    IF pr_archivo_llave != '' THEN
		SET lo_archivo_llave = CONCAT(' archivo_llave= "', pr_archivo_llave, '",');
	END IF;

    IF pr_contrasena != '' THEN
		SET lo_contrasena = CONCAT(' contrasena= "', pr_contrasena, '",');
	END IF;

    IF pr_rfc_eventuales != '' THEN
		SET lo_rfc_eventuales = CONCAT(' rfc_eventuales= "', pr_rfc_eventuales, '",');
	END IF;

    IF pr_rfc_extranjero != '' THEN
		SET lo_rfc_extranjero = CONCAT(' rfc_extranjero= "', pr_rfc_extranjero, '",');
	END IF;

    IF pr_certificado != '' THEN
		SET lo_certificado = CONCAT(' certificado= "', pr_certificado, '",');
	END IF;

    IF pr_portal_timbrado_valida != '' THEN
		SET lo_portal_timbrado_valida = CONCAT(' portal_timbrado_valida= "', pr_portal_timbrado_valida, '",');
	END IF;

    IF pr_portal_timbrado_usuario != '' THEN
		SET lo_portal_timbrado_usuario = CONCAT(' portal_timbrado_usuario= "', pr_portal_timbrado_usuario, '",');
	END IF;

    IF pr_portal_timbrado_pwd != '' THEN
		SET lo_portal_timbrado_pwd = CONCAT(' portal_timbrado_pwd= "', pr_portal_timbrado_pwd, '",');
	END IF;

    IF pr_archivo_pfx != '' THEN
		SET lo_archivo_pfx = CONCAT(' archivo_pfx= "', pr_archivo_pfx, '",');
	END IF;

    IF pr_fecha_sello > '0000-00-00' THEN
		SET lo_fecha_sello = CONCAT(' fecha_sello= "', pr_fecha_sello, '",');
	END IF;

    IF pr_folio_sat != '' THEN
		SET lo_folio_sat = CONCAT(' folio_sat= "', pr_folio_sat, '",');
	END IF;
    /*
    IF pr_certificado_2048  !=''  THEN
		SET lo_certificado_2048 = CONCAT(' certificado_2048= "', pr_certificado_2048, '",');
	END IF;
	*/
	SET @query = CONCAT('UPDATE suite_mig_conf.st_adm_tr_config_cfdi
							SET ',
							lo_series_electronica,
                            lo_id_pac,
                            lo_validar_email_vendedor,
                            lo_asignar_impre_series_e,
                            lo_enviar_email_cancela,
                            lo_email_notificaciones,
                            lo_metodo_pago,
                            lo_uso_cfdi,
                            lo_regimen_fiscal_sat,
                            lo_enviar_factura,
                            lo_validar_campos,
                            lo_archivo_certificado,
                            lo_vigencia_desde,
                            lo_vigencia_hasta,
                            lo_avisame,
                            lo_no_certificado,
                            lo_archivo_llave,
                            lo_contrasena,
                            lo_rfc_eventuales,
                            lo_rfc_extranjero,
                            lo_certificado,
                            lo_portal_timbrado_valida,
                            lo_portal_timbrado_usuario,
                            lo_portal_timbrado_pwd,
                            lo_archivo_pfx,
                            lo_fecha_sello,
                            lo_folio_sat,
							' id_usuario=',pr_id_usuario,
							' ,fecha_mod  = sysdate()
                            WHERE id_config_cfdi = ? AND id_grupo_empresa = ',pr_id_grupo_empresa);

    -- SELECT @query;
    PREPARE stmt FROM @query;
	SET @id_conf = pr_id_config_cfdi;
	EXECUTE stmt USING @id_conf;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
