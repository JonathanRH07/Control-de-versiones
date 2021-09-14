DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_sat_metodo_pago_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_glob_sat_metodo_pago_c
	@fecha: 		2017/05/15
	@descripción: 	Sp para obtenber los metodos de pago sat
	@autor :
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_sat_metodo_pago_c';
	END ;

	SELECT
		*
    FROM 	sat_metodo_pago;

	SET   pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
