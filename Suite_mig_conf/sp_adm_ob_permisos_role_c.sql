DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_ob_permisos_role_c`(
	IN  pr_id_role 		INT,
	OUT pr_message 		VARCHAR(250))
BEGIN
/*
	@SPName: 			sp_adm_ob_permisos_role_c
	@date: 				2016/09/02
	@description: 		Get permissions systems by role id
	@author: 			Alan Olivares
	@changes:
*/
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_ob_permisos_role_c';
	END;

	SELECT
		sis.id_sistema,
		sis.nom_sistema,
        acp.id_tipo_permiso,
		CONCAT(sis.nom_sistema,'\\Controller\\', con.nom_controlador, '\\', IFNULL(acp.nom_accion,'')) resource
	FROM
		suite_mig_conf.st_adm_tr_sistema sis
	INNER JOIN suite_mig_conf.st_adm_tc_modulo mo
		ON mo.id_sistema = sis.id_sistema
	INNER JOIN suite_mig_conf.st_adm_tr_submodulo smo
		ON mo.id_modulo = smo.id_modulo
	INNER JOIN suite_mig_conf.st_adm_tr_controlador_sistema con
		ON	con.id_sistema = sis.id_sistema
	INNER JOIN suite_mig_conf.st_adm_tc_accion_permiso acp
		ON acp.id_controlador = con.id_controlador
		AND acp.id_submodulo = smo.id_submodulo
	INNER JOIN suite_mig_conf.st_adm_tc_tipo_permiso tip
		ON tip.id_tipo_permiso = acp.id_tipo_permiso
	INNER JOIN st_adm_tr_permiso_role pro
		ON pro.id_submodulo 	= smo.id_submodulo
        AND pro.id_tipo_permiso = acp.id_tipo_permiso
	INNER JOIN st_adm_tc_role rol
		ON pro.id_role = rol.id_role
	WHERE rol.id_role = pr_id_role;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
