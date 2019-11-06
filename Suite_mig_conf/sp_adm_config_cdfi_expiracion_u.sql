DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_cdfi_expiracion_u`(
	IN  pr_id_config_cfdi 				INT(11),
	IN  pr_id_grupo_empresa 			INT(11),
    IN  pr_email_vigencia_caduca 		CHAR(1),
    IN  pr_email_vigencia_proxima 		CHAR(1),
    OUT pr_affect_rows	        		INT,
	OUT pr_message 						VARCHAR(500))
BEGIN
/*
    @nombre:		sp_adm_config_cdfi_expiracion_u
	@fecha: 		01/10/2019
	@descripcion : 	Sp que actualiza los valores de las banderas de envio de notificaciones
	@autor : 		Yazbek Kido
*/
	DECLARE  lo_email_vigencia_caduca  			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_email_vigencia_proxima   		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_config_cdfi_expiracion_u';
        ROLLBACK;
	END ;

    START TRANSACTION;

    IF pr_email_vigencia_caduca != '' THEN
		SET lo_email_vigencia_caduca = CONCAT(' email_vigencia_caduca= "', pr_email_vigencia_caduca, '",');
	END IF;

    IF pr_email_vigencia_proxima != '' THEN
		SET lo_email_vigencia_proxima = CONCAT(' email_vigencia_proxima= "', pr_email_vigencia_proxima, '",');
	END IF;

	 SET @query = CONCAT('UPDATE suite_mig_conf.st_adm_tr_config_cfdi
							SET ',
							lo_email_vigencia_caduca,
                            lo_email_vigencia_proxima,
                            ' id_config_cfdi=',pr_id_config_cfdi,
							' WHERE id_config_cfdi = ? AND id_grupo_empresa = ',pr_id_grupo_empresa);

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

    COMMIT;
END$$
DELIMITER ;
