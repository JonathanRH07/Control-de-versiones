DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_forma_pago_c`(
	OUT pr_message 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_gds_producto_c
	@fecha: 		2018/08/22
	@descripción: 	Sp para obtenber los servicios.
	@autor : 		Yazbek Kido
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_forma_pago_c';
	END ;

	SELECT
		*
	FROM ic_gds_tc_forma_pago;

    SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
