DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_permiso_role_u`(
	IN 	pr_id_role		INT,
    OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_adm_permiso_role_u
	@fecha: 		2017/09/06
	@descripci贸n: 	Sp para leer el catalogo de permisos asignados a un role
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        SET pr_message = 'ERROR store sp_adm_permiso_role_u';
	SELECT
		*
	FROM
		st_adm_tr_permiso_role
	WHERE
		id_role= pr_id_role
	GROUP BY id_submodulo;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
