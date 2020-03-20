DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_cdfi_expiracion_c`(
	IN  pr_tipo					CHAR(10),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_adm_config_cdfi_valida_c
	@fecha: 		01/10/2019
	@descripcion : 	Sp que obtiene los registros del cfdi proximos a vencer o vencidos
	@autor : 		Yazbek Kido
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_config_cdfi_expiracion_c';
	END ;

    IF pr_tipo = 'PROX' THEN
		SELECT
			cfdi.vigencia_desde,
            cfdi.vigencia_hasta,
            cfdi.id_grupo_empresa,
            cfdi.id_config_cfdi,
            cfdi.avisame,
            cfdi.email_notificaciones,
            usr.correo email_superuser
		FROM st_adm_tr_config_cfdi cfdi
        LEFT JOIN st_adm_tr_usuario usr ON
			usr.id_grupo_empresa = cfdi.id_grupo_empresa AND usr.id_role = 1
		WHERE DATEDIFF(cfdi.vigencia_hasta, NOW()) < 33 AND
		(cfdi.email_vigencia_proxima = 'N' AND cfdi.email_vigencia_caduca = 'N');
	ELSE
		SELECT
			cfdi.vigencia_desde,
            cfdi.vigencia_hasta,
            cfdi.id_grupo_empresa,
            cfdi.id_config_cfdi,
            cfdi.avisame,
            cfdi.email_notificaciones,
            usr.correo email_superuser
		FROM st_adm_tr_config_cfdi cfdi
        LEFT JOIN st_adm_tr_usuario usr ON
			usr.id_grupo_empresa = cfdi.id_grupo_empresa AND usr.id_role = 1
		WHERE DATEDIFF(cfdi.vigencia_hasta, NOW()) < 2 AND cfdi.email_vigencia_caduca = 'N';
    END IF;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
