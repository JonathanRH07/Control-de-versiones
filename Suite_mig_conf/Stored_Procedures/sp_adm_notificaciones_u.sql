DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_notificaciones_u`(
    IN  pr_id_usuario			INT,
    IN  pr_id_notificacion		INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_notificaciones_u
	@fecha:			13/10/20179
	@descripcion:	SP para actualizar registros en la tabla st_adm_tr_notificaciones
	@autor:			Yazbek Kido
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_leido 			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_mensajes_usuarios_u';
		ROLLBACK;
	END;

	START TRANSACTION;

    IF pr_id_notificacion > 0 THEN
	   SET @query = CONCAT('UPDATE st_adm_tr_notificaciones
							SET leido = "S", fecha_mod = sysdate()
							WHERE id_notificacion = ?');

		PREPARE stmt FROM @query;

		SET @id_notificacion= pr_id_notificacion;
		EXECUTE stmt USING @id_notificacion;
	else

	   SET @query = CONCAT('UPDATE st_adm_tr_notificaciones
							SET leido = "S", fecha_mod = sysdate()
							WHERE id_usuario = ? AND leido = "N"');

		PREPARE stmt FROM @query;

		SET @id_usuario= pr_id_usuario;
		EXECUTE stmt USING @id_usuario;
    END IF;

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
