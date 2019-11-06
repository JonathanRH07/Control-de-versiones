DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_ob_permisos_sistemas_grupo_empresa_c`(
	IN  pr_id_grupo_empresa 	INT,
	OUT pr_message 				VARCHAR(250))
BEGIN
/*
	@SPName: 			sp_adm_ob_permisos_sistemas_grupo_empresa_c
	@date: 				2016/09/02
	@description: 		Get systems by enterprise id
	@author: 			Alan Olivares
	@changes:
*/
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_ob_permisos_sistemas_grupo_empresa_c';
	END;

    SELECT
		sis.id_sistema,
		sis.nom_sistema
	FROM st_adm_tr_grupo_empresa gem
	INNER JOIN st_adm_tc_permiso_empresa_sistema pes
		ON pes.id_grupo_empresa = gem.id_grupo_empresa
	INNER JOIN st_adm_tr_sistema sis
		ON sis.id_sistema = pes.id_sistema
	WHERE gem.id_grupo_empresa = pr_id_grupo_empresa;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
