DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_sat_regimen_fiscal_c`(
	OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_sat_regimen_fiscal_c
	@fecha: 		18/05/2017
	@descripción: 	Sp para consultar el regimen fiscal
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_sat_regimen_fiscal_c';
	END ;

	SELECT
		*
	FROM
		sat_regimen_fiscal;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
