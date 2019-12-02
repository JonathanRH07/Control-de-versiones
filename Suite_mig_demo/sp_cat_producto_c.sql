DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_producto_c`(
	 OUT pr_message	VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_glob_proveedor_c
	@fecha: 		07/08/2018
	@descripción: 	Muestra los productos
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_producto_c';
	END ;

	SELECT *
	FROM ic_cat_tc_producto;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
