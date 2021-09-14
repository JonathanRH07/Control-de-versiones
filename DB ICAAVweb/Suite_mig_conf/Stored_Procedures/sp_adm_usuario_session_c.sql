DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_session_c`(
    IN  pr_id_usuario					INT,
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

	SELECT * FROM st_adm_tr_usuario_sesion WHERE id_usuario = pr_id_usuario order by fecha_mod DESC;


	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';
END$$
DELIMITER ;
