DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_estatus_boleto_c`(
	OUT pr_message 		VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_estatus_boleto
	@fecha:			13/11/2018
	@descripcion:	SP para consultar registro en la tabla ic_fac_tc_estatus_boleto
	@autor:			David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_estatus_boleto';
	END ;

    SELECT *
    FROM ic_fac_tc_estatus_boleto;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
