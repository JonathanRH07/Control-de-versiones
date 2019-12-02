DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_pac_c`(
	OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_proveedor_c
	@fecha: 		20/01/2017
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_pac_c';
	END ;

	SELECT
		*
	FROM
		ct_glob_tc_pac

	WHERE  estatus = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
