DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_role_u`(
	IN 	pr_id_role 				INT(11),
	IN 	pr_id_grupo_empresa 	INT(11),
	IN 	pr_nombre_role 			VARCHAR(50),
    IN  pr_id_usuario			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_role_u
	@fecha:			17/01/2017
	@descripcion:	SP para actualizar registros en la tabla st_adm_tc_accion_permiso
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_grupo_empresa 	VARCHAR(200) DEFAULT '';
	DECLARE lo_nombre_role 			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_role_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_grupo_empresa > 0 THEN
		SET lo_id_grupo_empresa = CONCAT('id_grupo_empresa = ', pr_id_grupo_empresa, ',');
	END IF;

    IF pr_nombre_role !='' THEN
		SET lo_nombre_role = CONCAT('nombre_role = "', pr_nombre_role, '",');
	END IF;

    # Checa si ya existe la clave.
    SET @queryTotalRows = CONCAT('
			 SELECT
			  COUNT(*)
			 INTO
			  @existe_duplicado
			 FROM suite_mig_conf.st_adm_tc_role
             LEFT JOIN suite_mig_conf.st_adm_tc_role_trans
				ON suite_mig_conf.st_adm_tc_role_trans.id_role = suite_mig_conf.st_adm_tc_role.id_role
			 WHERE (id_grupo_empresa = 7 OR id_grupo_empresa = 0)
             AND (suite_mig_conf.st_adm_tc_role.nombre_role = "',pr_nombre_role,'" OR suite_mig_conf.st_adm_tc_role_trans.nombre_role = "',pr_nombre_role,'")
             AND (suite_mig_conf.st_adm_tc_role.id_role != ',pr_id_role,') ' );

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    IF @existe_duplicado> 0 THEN
		SET @error_code = 'NAME_DUPLICATE';
		SET pr_message = 'ROLES.NAME_DUPLICATE';
		SET pr_affect_rows = 0;
		ROLLBACK;
	ELSE

	   SET @query = CONCAT('UPDATE st_adm_tc_role
							SET ',
								lo_id_grupo_empresa,
								lo_nombre_role,
								' id_usuario=',pr_id_usuario ,
								' , fecha_mod = sysdate()
							WHERE id_role = ?');

		PREPARE stmt FROM @query;

		SET @id_role= pr_id_role;
		EXECUTE stmt USING @id_role;

		#Devuelve el numero de registros insertados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		# Mensaje de ejecucion.
		SET pr_message = 'SUCCESS';

		COMMIT;
    END IF;
END$$
DELIMITER ;
