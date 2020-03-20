DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_consultar_sistema`(
	IN  pr_id_sistema		INT(11),
	OUT pr_message 			VARCHAR(500))
BEGIN
/*
    @nombre:		sp_consultar_sistema
	@fecha: 		11/05/2017
	@descripcion : 	Sp de consulta de sp_consultar_sistema
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_consultar_sistema';
	END ;

	SELECT
		version,
        actualizacion
	FROM st_adm_tr_sistema
   	WHERE id_sistema=pr_id_sistema;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
