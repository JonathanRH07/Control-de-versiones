DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_emails_i`(
	IN  pr_id_grupo_empresa 		INT(11),
	IN  pr_email_facturacion_usuario 	VARCHAR(100),
    IN  pr_email_facturacion_password 	VARCHAR(100),
    IN  pr_email_facturacion_host 		VARCHAR(100),
    IN  pr_email_facturacion_puerto 	VARCHAR(10),
    IN  pr_email_cobranza_usuario 		VARCHAR(100),
    IN  pr_email_cobranza_password 		VARCHAR(100),
    IN  pr_email_cobranza_host 			VARCHAR(100),
    IN  pr_email_cobranza_puerto 		VARCHAR(10),
    IN  pr_email_cxp_usuario 			VARCHAR(100),
    IN  pr_email_cxp_password 			VARCHAR(100),
    IN  pr_email_cxp_host 				VARCHAR(100),
    IN  pr_email_cxp_puerto 			VARCHAR(10),
    IN  pr_id_usuario					INT,
    OUT pr_inserted_id					INT,
    OUT pr_affect_rows      			INT,
    OUT pr_message 	         			VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_config_emails_i
	@fecha: 		18/07/2019
	@descripcion: 	SP para insertar registros en la tabla st_adm_tr_config_emails
	@autor: 		Yazbek Kido
	@cambios:

*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_adm_config_emails_i';
        SET pr_affect_rows = 0;
	END;

	INSERT INTO  suite_mig_conf.st_adm_tr_config_emails(
		id_grupo_empresa,
        email_facturacion_usuario,
		email_facturacion_password,
        email_facturacion_host,
        email_facturacion_puerto,
        email_cobranza_usuario,
        email_cobranza_password,
        email_cobranza_host,
        email_cobranza_puerto,
        email_cxp_usuario,
        email_cxp_password,
        email_cxp_host,
        email_cxp_puerto,
        id_usuario
		)
	VALUES
		(
		pr_id_grupo_empresa,
        pr_email_facturacion_usuario,
		pr_email_facturacion_password,
        pr_email_facturacion_host,
        pr_email_facturacion_puerto,
        pr_email_cobranza_usuario,
        pr_email_cobranza_password,
        pr_email_cobranza_host,
        pr_email_cobranza_puerto,
        pr_email_cxp_usuario,
        pr_email_cxp_password,
        pr_email_cxp_host,
        pr_email_cxp_puerto,
        pr_id_usuario
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
