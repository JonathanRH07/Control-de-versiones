DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cliente_descuento_c`(
	IN  pr_id_cliente       INT,
	IN  pr_id_proveedor     INT,
	IN  pr_id_servicio      INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_cliente_descuento_c
		@fecha: 		11/02/2018
		@descripción:
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_descuento_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tr_cliente_descuento
	WHERE id_proveedor=pr_id_proveedor
    AND id_servicio=pr_id_servicio
    AND id_cliente=pr_id_cliente;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
