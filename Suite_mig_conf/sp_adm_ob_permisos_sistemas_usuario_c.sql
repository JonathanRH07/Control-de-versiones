DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_ob_permisos_sistemas_usuario_c`(
	IN  pr_id_usuario 	INT,
	-- IN	pr_id_empresa	INT,
	OUT pr_message 		VARCHAR(250))
BEGIN
/*
	@SPName: 			sp_adm_ob_permisos_sistemas_usuario_c
	@date: 				2016/09/02
	@description: 		Get systems by user
	@author: 			Alan Olivares
	@changes:
*/
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_ob_permisos_sistemas_usuario_c';
	END;

    SELECT
		distinct
		sis.id_sistema,
		sis.nom_sistema,
        UNCOMPRESS(pes.host_empresa_sistema) dbHost,
        UNCOMPRESS(pes.puerto_empresa_sistema) dbPort,
        UNCOMPRESS(pes.db_empresa_sistema) dbName,
        UNCOMPRESS(pes.usuario_empresa_sistema) dbUser,
        UNCOMPRESS(pes.password_empresa_sistema) dbPassword
	FROM
		st_adm_tr_usuario usu
	INNER JOIN st_adm_tr_grupo_empresa gem
		ON usu.id_grupo_empresa = gem.id_grupo_empresa
	INNER JOIN st_adm_tc_permiso_empresa_sistema pes
		ON pes.id_grupo_empresa = gem.id_grupo_empresa
	INNER JOIN st_adm_tr_sistema sis
		ON sis.id_sistema = pes.id_sistema
	INNER JOIN suite_mig_conf.st_adm_tr_controlador_sistema con
		ON con.id_sistema = sis.id_sistema
	WHERE usu.id_usuario = pr_id_usuario
    /*AND usu.id_empresa = pr_id_empresa*/;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
