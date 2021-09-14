DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_emails_c`(
	IN  pr_id_grupo_empresa		INT(11),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_adm_config_emails_c
	@fecha: 		18/07/2019
	@descripcion : 	Sp de consulta configuracion de emails
	@autor : 		Yazbek Kido
*/
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_config_emails_c';
	END ;*/

	SELECT
		st_adm_tr_config_emails.*,
        emp.comercial_empresa,
        st_adm_tr_config_emails.fecha_mod fecha_mod,
			concat(usuario.nombre_usuario," ",
			usuario.paterno_usuario) usuario_mod
	FROM st_adm_tr_config_emails
    INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
		ON usuario.id_usuario=st_adm_tr_config_emails.id_usuario
	JOIN suite_mig_conf.st_adm_tr_grupo_empresa grup_empr
		ON grup_empr.id_grupo_empresa = pr_id_grupo_empresa
	JOIN suite_mig_conf.st_adm_tr_empresa emp ON
		grup_empr.id_empresa = emp.id_empresa

    WHERE st_adm_tr_config_emails.id_grupo_empresa=pr_id_grupo_empresa;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
