DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_centro_costo_v2_c`(
	IN  pr_id_cliente 	INT,
	OUT pr_message 	  	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_centro_costo_v2_c
	@fecha:			19/10/2017
	@descripcion:	Sp para consultar centro de costos por cliente.
	@autor: 		David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_centro_costo_v2_c';
	END ;

    SELECT *
		FROM ic_cat_tr_centro_costo
    WHERE id_cliente = pr_id_cliente;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
