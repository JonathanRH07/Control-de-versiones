DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_producto_c`(
	IN  pr_cve_producto 	CHAR(5),
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_producto_c
		@fecha: 		18/01/2018
		@descripción: 	Sp para consultar registros en la tabla ic_cat_tc_producto
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_producto_c';
	END ;


	SELECT
		*
    FROM ic_cat_tc_producto
    WHERE cve_producto=pr_cve_producto;


	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
