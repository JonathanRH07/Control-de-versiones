DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_session_u`(
    IN  pr_id_usuario					INT,
    IN  pr_session_id					VARCHAR(60),
    IN  pr_datos_session				json,
    OUT pr_affect_rows      			INT,
    OUT pr_message 	         			VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_usuario_session_u
	@fecha: 		29/12/2020
	@descripcion: 	SP para modificar los registros en la tabla st_adm_tr_usuario_sesion
	@autor: 		Yazbek Kido
	@cambios:


*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_adm_usuario_session_u';
        SET pr_affect_rows = 0;
	END;

	-- SET @query = CONCAT('UPDATE st_adm_tr_usuario_sesion SET fecha_mod = "',pr_timestamp,'" WHERE id_usuario = ? AND session_id="',pr_session_id,'" ');
    SET @query = CONCAT('UPDATE st_adm_tr_usuario_sesion SET datos_session = ''',pr_datos_session,''' WHERE id_usuario = ? AND session_id="',pr_session_id,'" ');

	PREPARE stmt
	FROM @query;

	SET @id_usuario = pr_id_usuario;
	EXECUTE stmt USING @id_usuario;

	#Devuelve el numero de registros afectados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;



	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
