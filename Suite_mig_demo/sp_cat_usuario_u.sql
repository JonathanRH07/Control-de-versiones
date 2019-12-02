DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_usuario_u`(
	IN	pr_id_usuario			INT(11),
    IN  pr_id_grupo_empresa		INT(11),
    IN 	pr_id_role				INT(11),
    IN  pr_usuario 	     		VARCHAR(100),
    IN  pr_password_usuario     VARCHAR(256),
	IN 	pr_nombre_usuario       VARCHAR(45),
	IN  pr_paterno_usuario      VARCHAR(45),
	IN 	pr_materno_usuario      VARCHAR(45),
	IN	pr_registra_usuario     VARCHAR(100),
    IN	pr_estatus_usuario		int(1),
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_usuario_u
	@fecha: 		15/12/2016
	@descripcion: 	SP para actualizar registro en catalogo usuarios.
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE	lo_id_role 				VARCHAR(1000) DEFAULT '';
    DECLARE lo_usuario 				VARCHAR(1000) DEFAULT '';
    DECLARE lo_password_usuario 	VARCHAR(1000) DEFAULT '';
    DECLARE lo_nombre_usuario 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_paterno_usuario 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_materno_usuario 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_estatus_usuario 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_registra_usuario 	VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_cat_usuario_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
    START TRANSACTION;

	# Falta validar que el usuario no se este usando en otras tablas

	IF pr_id_role  >0  THEN
		SET lo_id_role = CONCAT('id_role = "', pr_id_role, '",');
	END IF;

	IF pr_usuario != '' THEN
		SET lo_usuario = CONCAT(' usuario = "', pr_usuario, '",');
	END IF;

	IF pr_password_usuario != '' THEN
		SET lo_password_usuario = CONCAT(' password_usuario = "', pr_password_usuario, '",');
	END IF;

	IF pr_nombre_usuario != '' THEN
		SET lo_nombre_usuario = CONCAT(' nombre_usuario = "', pr_nombre_usuario, '",');
	END IF;

	IF  pr_paterno_usuario != '' THEN
		SET  lo_paterno_usuario = CONCAT(' paterno_usuario  = "', pr_paterno_usuario, '",');
	END IF;

    IF  pr_materno_usuario != '' THEN
		SET  lo_materno_usuario = CONCAT(' materno_usuario  = "', pr_materno_usuario, '",');
	END IF;

    IF  pr_estatus_usuario != '' THEN
		SET  lo_estatus_usuario = CONCAT(' estatus_usuario  = "', pr_estatus_usuario, '",');
	END IF;

     IF  pr_registra_usuario != '' THEN
		SET  lo_registra_usuario = CONCAT(' registra_usuario  = "', pr_registra_usuario, '",');
	END IF;

	SET @query = CONCAT('UPDATE suite_mig_conf.st_adm_tr_usuario
							SET ',
								lo_id_role,
								lo_usuario,
								lo_password_usuario,
								lo_nombre_usuario,
								lo_paterno_usuario,
								lo_materno_usuario,
								lo_estatus_usuario,
								lo_registra_usuario,
								'fecha_registro_usuario  = sysdate()
						WHERE id_usuario = ?');

	PREPARE stmt FROM @query;

	SET @id_usuario= pr_id_usuario;
	EXECUTE stmt USING @id_usuario;

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
