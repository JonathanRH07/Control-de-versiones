DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_sat_paises_c`(
	IN  pr_c_Pais 			CHAR(3),
    OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_sat_paises_c
	@fecha: 		04/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_sat_paises_c';
	END ;

	SELECT
		*
	FROM
		sat_paises
	WHERE c_Pais = pr_c_Pais;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
