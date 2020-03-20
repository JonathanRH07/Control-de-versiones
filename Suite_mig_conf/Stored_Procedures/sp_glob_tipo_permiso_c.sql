DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipo_permiso_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_tipo_permiso_c
	@fecha: 		16/03/2017
	@descripcion : 	Sp de consulta de tipo_permiso
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_tipo_permiso_c';
	END ;

	SELECT
		*
	FROM
		st_adm_tc_tipo_permiso;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
