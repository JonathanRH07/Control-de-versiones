DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_formato_concetrado_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
    @nombre:		sp_cat_formato_concetrado_c
	@fecha: 		03/11/2016
	@descripcion : 	Sp de consulta de formato concentrado.
	@autor : 		Odeth Negrete
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_formato_concetrado_c';
	END ;

	SELECT
		nombre,
		codigo
    FROM
		ic_cat_tc_formato
    WHERE
		tipo_formato = 'CONCENTRADO';

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
