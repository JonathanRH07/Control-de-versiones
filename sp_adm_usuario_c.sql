DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_c`(
	IN  pr_id_usuario		INT(11),
	OUT pr_message 			VARCHAR(500))
BEGIN
/*
    @nombre:		sp_adm_usuario_c
	@fecha: 		16/03/2017
	@descripcion : 	Sp de consulta usuarios
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_c';
	END ;

	SELECT
		*
	FROM suite_mig_conf.st_adm_tr_usuario
    WHERE id_usuario=pr_id_usuario;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
