DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_debito_c`(
	IN  pr_id_factura 		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_debito_c
		@fecha:			25/07/2018
		@descripcion:	Sp para consutar la tabla de ic_fac_tr_debito
		@autor: 		Carol Mejia
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_debito_c';
	END ;

	SELECT
		  debito.*,
          factura.fecha_factura
	FROM  ic_fac_tr_debito debito LEFT JOIN ic_fac_tr_factura factura
		  ON debito.id_factura = factura.id_factura
	WHERE debito.id_factura = pr_id_factura;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
