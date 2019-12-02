DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_debito_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_fac_debito_c
	@fecha: 		2018/02/19
	@descripción: 	Sp para obtenber registros de las tablas ic_fac_tr_debito
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_debito_c';
	END ;

	SELECT
		*
	FROM
		ic_fac_tr_debito;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
