DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_impuesto_c`(
	-- IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_cve_impuesto 		CHAR(10),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_impuesto_c
	@fecha: 		03/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_impuesto_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tr_impuesto
	WHERE cve_impuesto = pr_cve_impuesto;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
