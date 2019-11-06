DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_role_i`(
	IN 	pr_id_grupo_empresa 	INT(11),
	IN 	pr_nombre_role 			VARCHAR(50),
    IN  pr_id_usuario			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_role_i
	@fecha:			17/01/2017
	@descripcion:	SP para agregar registros en la tabla st_adm_tc_role
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_inserted_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ROLES.MESSAGE_ERROR_CREATE_ROLES';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    # Checa si ya existe la clave.
    SET @queryTotalRows = CONCAT('
			 SELECT
			  COUNT(*)
			 INTO
			  @existe_duplicado
			 FROM suite_mig_conf.st_adm_tc_role
             LEFT JOIN suite_mig_conf.st_adm_tc_role_trans
				ON suite_mig_conf.st_adm_tc_role_trans.id_role = suite_mig_conf.st_adm_tc_role.id_role
			 WHERE (id_grupo_empresa = ',pr_id_grupo_empresa,' OR id_grupo_empresa = 0)
             AND (suite_mig_conf.st_adm_tc_role.nombre_role = "',pr_nombre_role,'" OR suite_mig_conf.st_adm_tc_role_trans.nombre_role = "',pr_nombre_role,'")');

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	IF @existe_duplicado> 0 THEN
		SET @error_code = 'NAME_DUPLICATE';
		SET pr_message = 'ROLES.NAME_DUPLICATE';
		SET pr_affect_rows = 0;
		ROLLBACK;
	ELSE

		INSERT INTO st_adm_tc_role (
			id_grupo_empresa,
			nombre_role,
			id_usuario
			)
		VALUES
			(
			pr_id_grupo_empresa,
			pr_nombre_role,
			pr_id_usuario
			);

		SET lo_inserted_id 	= @@identity;

		SET pr_inserted_id 	= lo_inserted_id;

		SELECT COUNT(*) INTO pr_affect_rows FROM st_adm_tc_role where id_role=pr_inserted_id;
		#Devuelve mensaje de ejecucion
		SET pr_message = 'SUCCESS';
		COMMIT;
	END IF;
END$$
DELIMITER ;
