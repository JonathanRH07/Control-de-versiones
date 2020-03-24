DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_pac_u`(
	IN 	pr_id_pac 				INT(11),
	IN 	pr_cve_pac 				CHAR(3),
	IN 	pr_nombre 				VARCHAR(45),
	IN 	pr_url_timbrado 		VARCHAR(500),
	IN 	pr_login_timbrado 		VARCHAR(45),
	IN 	pr_password_timbrado 	VARCHAR(45),
	IN 	pr_estatus 				ENUM('ACTIVO','INACTIVO'),
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_pac_u
	@fecha:			23/01/2017
	@descripcion:	SP para actualizar registros en glob_pac
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_nombre 					VARCHAR(200) DEFAULT '';
	DECLARE lo_url_timbrado 			VARCHAR(200) DEFAULT '';
	DECLARE lo_login_timbrado 			VARCHAR(200) DEFAULT '';
	DECLARE lo_password_timbrado 		VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus 					VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_pac_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_nombre !='' THEN
		SET lo_nombre = CONCAT('nombre = "', pr_nombre, '",');
	END IF;

    IF pr_url_timbrado > 0 THEN
		SET lo_url_timbrado = CONCAT('url_timbrado = "', pr_url_timbrado, '",');
	END IF;

    IF pr_login_timbrado > 0 THEN
		SET lo_login_timbrado = CONCAT('login_timbrado = "', pr_login_timbrado, '",');
	END IF;

    IF pr_password_timbrado > 0 THEN
		SET lo_password_timbrado = CONCAT('password_timbrado = "', pr_password_timbrado, '",');
	END IF;

    IF pr_estatus !=''  THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '"');
	END IF;

	SET @query = CONCAT('UPDATE ct_glob_tc_pac
							SET ',
								lo_nombre,
								lo_url_timbrado,
								lo_login_timbrado,
								lo_password_timbrado,
								lo_estatus,
								' WHERE id_pac = ?');

	PREPARE stmt FROM @query;

	SET @id_pac= pr_id_pac;
	EXECUTE stmt USING @id_pac;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
