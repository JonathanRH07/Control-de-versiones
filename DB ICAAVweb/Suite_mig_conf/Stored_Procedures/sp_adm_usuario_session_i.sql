DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_session_i`(
    IN  pr_id_usuario					INT,
    IN  pr_session_id					VARCHAR(60),
    OUT pr_inserted_id					INT,
    OUT pr_affect_rows      			INT,
    OUT pr_message 	         			VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_usuario_session_i
	@fecha: 		28/12/2020
	@descripcion: 	SP para insertar registros en la tabla st_adm_tr_usuario_sesion
	@autor: 		Yazbek Kido
	@cambios:

*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_adm_usuario_session_i';
        SET pr_affect_rows = 0;
	END;

    DELETE FROM st_adm_tr_usuario_sesion
    WHERE id_usuario = pr_id_usuario;


	INSERT INTO  suite_mig_conf.st_adm_tr_usuario_sesion(
		id_usuario,
        session_id
		)
	VALUES
		(
		pr_id_usuario,
        pr_session_id
		);


	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';
END$$
DELIMITER ;
