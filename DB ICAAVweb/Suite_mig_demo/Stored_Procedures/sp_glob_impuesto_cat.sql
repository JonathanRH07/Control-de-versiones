DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_impuesto_cat`(
	IN pr_cve_pais 	 	CHAR(4),
	OUT pr_message 		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_impuesto_cat
		@fecha: 		09/11/2016
		@descripcion : 	Sp de consulta del CATALOGO IMPUESTO CATEGORIA por PAIS
		@autor : 		Shani Glez
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

    BEGIN
        SET pr_message = 'ERROR store sp_glob_impuesto_cat';
	END ;

	SELECT
		cve_impuesto_cat
	FROM ic_cat_tc_impuesto_categoria
	WHERE
		cve_pais = pr_cve_pais
	;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
