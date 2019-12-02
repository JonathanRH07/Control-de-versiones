DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cuentas_contables_c`(
	IN 	pr_id_cuenta_contable	INT,
    OUT pr_message 				VARCHAR(500))
BEGIN

/*
	@nombre:		sp_cat_cuentas_contables_c
	@fecha: 		2017/03/02
	@descripción: 	Sp para obtenber las cuentas contables.
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cuentas_contables_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tc_cuenta_contable
	WHERE estatus = 1
	AND id_cuenta_contable= pr_id_cuenta_contable;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
