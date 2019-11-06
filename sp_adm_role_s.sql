DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_role_s`(
	IN  pr_id_grupo_empresa 	INT,
	IN  pr_id_role 				INT,
    IN  pr_id_idioma 			INT,
    IN  pr_search_type 			VARCHAR(50),
	IN  pr_consulta 			VARCHAR(255),
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_adm_role_s
		@fecha: 		24/07/2019
		@descripcion : 	Sp de consulta autocomplete de roles
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_role_s';
	END ;

    IF pr_id_role > 0 THEN
		SELECT
			role.id_role,
			role.id_grupo_empresa,
			IFNULL(trans.nombre_role, role.nombre_role) as nombre_role,
			role.id_usuario
		FROM suite_mig_conf.st_adm_tc_role role
        left join suite_mig_conf.st_adm_tc_role_trans trans
			on trans.id_role=role.id_role AND trans.id_idioma = pr_id_idioma
        WHERE role.id_role = pr_id_role
        AND (role.id_grupo_empresa = pr_id_grupo_empresa OR role.id_grupo_empresa = 0);
    ELSEIF pr_search_type = 'mensajes' THEN
		SELECT
			 role.id_role,
			 IFNULL(trans.nombre_role, role.nombre_role) as nombre_role
		FROM suite_mig_conf.st_adm_tc_role role
        left join suite_mig_conf.st_adm_tc_role_trans trans
			on trans.id_role=role.id_role AND trans.id_idioma = pr_id_idioma
		WHERE   IFNULL(trans.nombre_role, role.nombre_role)  LIKE CONCAT('%',pr_consulta,'%')
        AND (role.id_grupo_empresa = pr_id_grupo_empresa OR role.id_grupo_empresa = 0);
	ELSE
		SELECT
			 role.id_role,
			 IFNULL(trans.nombre_role, role.nombre_role) as nombre_role
		FROM suite_mig_conf.st_adm_tc_role role
        left join suite_mig_conf.st_adm_tc_role_trans trans
			on trans.id_role=role.id_role AND trans.id_idioma = pr_id_idioma
		WHERE role.nombre_role LIKE CONCAT('%',pr_consulta,'%')
        AND role.id_grupo_empresa = pr_id_grupo_empresa  OR role.id_grupo_empresa = 0
		LIMIT 50;
	END IF;

	SET pr_message = 'SUCCESS';

    END$$
DELIMITER ;
