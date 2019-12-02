DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_ine_ent_fed_c`(
	IN  pr_cve_entidad_federativa 	CHAR(3),
    OUT pr_message 					VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_ine_ent_fed_c
	@fecha: 		04/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_ine_ent_fed_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tc_ine_ent_fed
	WHERE cve_entidad_federativa = pr_cve_entidad_federativa;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
