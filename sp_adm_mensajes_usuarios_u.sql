DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_mensajes_usuarios_u`(
    IN  pr_id_mensaje			INT,
    IN  pr_leido				CHAR(1),
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_mensajes_usuarios_u
	@fecha:			17/01/2017
	@descripcion:	SP para actualizar registros en la tabla st_adm_tr_alertas_usuarios
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

	IF pr_leido != '' THEN
		SET lo_leido = CONCAT('leido = "', pr_leido, '" ');
	END IF;

   SET @query = CONCAT('UPDATE st_adm_tr_alertas_usuarios
						SET ',
							lo_leido,
							' , fecha_mod = sysdate()
						WHERE id_alerta_usuarios = ?');

	PREPARE stmt FROM @query;

	SET @id_mensaje= pr_id_mensaje;
	EXECUTE stmt USING @id_mensaje;

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
