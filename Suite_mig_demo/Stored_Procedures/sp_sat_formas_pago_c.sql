DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_sat_formas_pago_c`(
	IN  pr_c_FormaPago  VARCHAR(2),
    OUT pr_message 		VARCHAR(500)
)
BEGIN

	/*
	@nombre:		sp_sat_bancos_c
	@fecha: 		2018/02/19
	@descripción: 	Sp para obtenber registros de las tablas sat_formas_pago
	@autor : 		David Roldan Solares
	@cambios:
	*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_sat_bancos_c';
	END ;

	SELECT *
	FROM sat_formas_pago
    WHERE c_FormaPago = pr_c_FormaPago;

	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
