DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_session_c`(
    IN  pr_id_usuario					INT,
    IN pr_sessiond_id					VARCHAR(500),
    OUT pr_message 	         			VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_usuario_session_i
	@fecha: 		28/12/2020
	@descripcion: 	SP para obtener los registros de la tabla st_adm_tr_usuario_sesion
	@autor: 		Yazbek Kido
	@cambios:

*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_adm_usuario_session_c';
	END;

    IF pr_sessiond_id != '' THEN
		SELECT * FROM st_adm_tr_usuario_sesion WHERE session_id = pr_sessiond_id order by fecha_mod DESC;
	ELSE
		SELECT * FROM st_adm_tr_usuario_sesion WHERE id_usuario = pr_id_usuario order by fecha_mod DESC;
	END IF;


	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';
END$$
DELIMITER ;
