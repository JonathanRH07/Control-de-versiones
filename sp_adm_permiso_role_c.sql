DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_permiso_role_c`(
	IN 	pr_id_submodulo	INT,
    IN 	pr_id_role		INT,
    OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_adm_permiso_role_c
	@fecha: 		2017/09/06
	@descripci贸n: 	Sp para obtenber los permisos roles
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_id_submodulo     	VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_permiso_role_c';
	END ;

    IF pr_id_submodulo > 0 THEN
		SET lo_id_submodulo = CONCAT(' AND role.id_submodulo =  ', pr_id_submodulo);
    END IF;

    SET @query = CONCAT('SELECT
							role.*,
							permiso.nom_tipo_permiso,
							submodulo.clave_submodulo
						FROM st_adm_tr_permiso_role role
						JOIN st_adm_tr_submodulo submodulo ON
							submodulo.id_submodulo = role.id_submodulo
						JOIN st_adm_tc_tipo_permiso permiso ON
							permiso.id_tipo_permiso = role.id_tipo_permiso
						WHERE role.id_role=',pr_id_role,
						lo_id_submodulo
	);

	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;


	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
