DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_emails_u`(
	IN  pr_id_config_emails 			INT(11),
    IN  pr_id_grupo_empresa 			INT(11),
	IN  pr_email_facturacion_usuario 	VARCHAR(100),
    IN  pr_email_facturacion_password 	VARCHAR(100),
    IN  pr_email_facturacion_host 		VARCHAR(100),
    IN  pr_email_facturacion_puerto 	VARCHAR(10),
    IN  pr_email_cobranza_usuario 		VARCHAR(100),
    IN  pr_email_cobranza_password 		VARCHAR(100),
    IN  pr_email_cobranza_host 			VARCHAR(100),
    IN  pr_email_cobranza_puerto 		VARCHAR(10),
    IN  pr_id_usuario 					VARCHAR(10),
    OUT pr_affect_rows      			INT,
	OUT pr_message 	         			VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_config_emails_u
	@fecha: 		18/07/2019
	@descripcion: 	SP para actualizar registro en st_adm_tr_config_emails
	@autor: 		Yazbek Kido
	@cambios:
*/

	DECLARE lo_email_facturacion_usuario		VARCHAR(200) DEFAULT '';
    DECLARE lo_email_facturacion_password 		VARCHAR(200) DEFAULT '';
    DECLARE lo_email_facturacion_host 			VARCHAR(200) DEFAULT '';
	DECLARE lo_email_facturacion_puerto			VARCHAR(200) DEFAULT '';
    DECLARE lo_email_cobranza_usuario			VARCHAR(200) DEFAULT '';
	DECLARE lo_email_cobranza_password			VARCHAR(200) DEFAULT '';
    DECLARE lo_email_cobranza_host				VARCHAR(200) DEFAULT '';
	DECLARE lo_email_cobranza_puerto			VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_config_emails_u';
        SET pr_affect_rows = 0;
	END;


    IF pr_email_facturacion_usuario != '' THEN
		SET lo_email_facturacion_usuario = CONCAT('email_facturacion_usuario =  "', pr_email_facturacion_usuario, '",');
	END IF;

    IF pr_email_facturacion_password != '' THEN
		SET lo_email_facturacion_password = CONCAT('email_facturacion_password =  "', pr_email_facturacion_password, '",');
	END IF;

    IF pr_email_facturacion_host != '' THEN
		SET lo_email_facturacion_host = CONCAT('email_facturacion_host =  "', pr_email_facturacion_host, '",');
	END IF;

    IF pr_email_facturacion_puerto != '' THEN
		SET lo_email_facturacion_puerto = CONCAT('email_facturacion_puerto =  "', pr_email_facturacion_puerto, '",');
	END IF;

    IF pr_email_cobranza_usuario != '' THEN
		SET lo_email_cobranza_usuario = CONCAT('email_cobranza_usuario =  "', pr_email_cobranza_usuario, '",');
	END IF;

    IF pr_email_cobranza_password != '' THEN
		SET lo_email_cobranza_password = CONCAT('email_cobranza_password =  "', pr_email_cobranza_password, '",');
	END IF;

    IF pr_email_cobranza_host != '' THEN
		SET lo_email_cobranza_host = CONCAT('email_cobranza_host =  "', pr_email_cobranza_host, '",');
	END IF;

    IF pr_email_cobranza_puerto != '' THEN
		SET lo_email_cobranza_puerto = CONCAT('email_cobranza_puerto =  "', pr_email_cobranza_puerto, '",');
	END IF;


	SET @query = CONCAT('UPDATE st_adm_tr_config_emails
								SET ',
								lo_email_facturacion_usuario,
								lo_email_facturacion_password,
                                lo_email_facturacion_host,
								lo_email_facturacion_puerto,
                                lo_email_cobranza_usuario,
								lo_email_cobranza_password,
                                lo_email_cobranza_host,
                                lo_email_cobranza_puerto,
                                ' id_usuario=',pr_id_usuario ,
								' , fecha_mod  = sysdate()
							WHERE id_config_emails = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa,'');

	PREPARE stmt
	FROM @query;

	SET @id_config_emails = pr_id_config_emails;
	EXECUTE stmt USING @id_config_emails;
	#Devuelve el numero de registros afectados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
