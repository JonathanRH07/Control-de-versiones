DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_submodulo_x_role_c`(
	IN  pr_id_role 		INT,
	OUT pr_message 		VARCHAR(250))
BEGIN
/*
	@SPName: 			sp_adm_submodulo_x_role_c
	@date: 				2016/09/02
	@description: 		Get systems by user
	@author: 			Alan Olivares
	@changes:
*/
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_submodulo_x_role_c';
	END;

	SELECT
		role.id_permiso_role,
		role.id_role,
		role.id_tipo_permiso,
		role.id_submodulo,
		sub.nombre_submodulo
	FROM suite_mig_conf.st_adm_tr_permiso_role role
	INNER JOIN suite_mig_conf.st_adm_tr_submodulo sub
		ON sub.id_submodulo = role.id_submodulo
	WHERE
		role.id_role = pr_id_role
	GROUP BY id_submodulo;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
