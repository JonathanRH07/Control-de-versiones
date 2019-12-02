DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_gds_c`(
	OUT pr_message 	  		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_cat_forma_pago_gds_c
	@fecha:			02/08/2018
	@descripcion:	Sp para consultar las formas de pago gds
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_forma_pago_gds_c';
	END ;
       /* Desarrollo */

	SELECT  *
	FROM ic_gds_tr_forma_pago;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
