DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_doc_serie_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
    @nombre:		sp_cat_doc_serie_c
	@fecha: 		20/09/2016
	@descripcion : 	Sp de consulta del catalogo tipo de series
	@autor : 		Odeth Negrete
	@cambios: 		20/10/2016	Se actualiza SP para consulta de tipo de series...	Carol Mejía
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_doc_serie_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tc_tipo_serie;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
