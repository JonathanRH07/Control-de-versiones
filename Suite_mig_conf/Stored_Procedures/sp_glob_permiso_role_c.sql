DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_permiso_role_c`(
	IN  pr_id_role		INT(11),
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_permiso_role_c
	@fecha: 		16/03/2017
	@descripcion : 	Sp de consulta de permiso_role
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_permiso_role_c';
	END ;

	SELECT
		per_role.id_permiso_role,
		per_role.id_role,
        role.nombre_role,
		per_role.id_tipo_permiso,
        tip_perm.nom_tipo_permiso,
		per_role.id_submodulo,
        submod.nombre_submodulo
	FROM st_adm_tr_permiso_role per_role
    INNER JOIN st_adm_tc_role role
		ON role.id_role = per_role.id_role
	INNER JOIN st_adm_tc_tipo_permiso tip_perm
		ON tip_perm.id_tipo_permiso = per_role.id_tipo_permiso
	INNER JOIN st_adm_tr_submodulo submod
		ON submod.id_submodulo = per_role.id_submodulo
	WHERE per_role.id_role=1;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
