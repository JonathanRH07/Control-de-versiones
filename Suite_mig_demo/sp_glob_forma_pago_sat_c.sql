DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_forma_pago_sat_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre: 	   sp_glob_forma_pago_sat_c
	@fecha: 	  2016/08/25
	@descripción: Get all coins with ACTIVE status.
	@autor:		  Alan Olivares
	@cambios
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_forma_pago_sat_c';
	END ;

	SELECT
		c_FormaPago,
        descripcion
	FROM
		sat_formas_pago;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
