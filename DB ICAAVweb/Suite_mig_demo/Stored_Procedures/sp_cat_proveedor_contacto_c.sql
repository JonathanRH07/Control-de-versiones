DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_contacto_c`(
	IN 	pr_id_proveedor		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_proveedor_c
		@fecha: 		20/01/2017
		@descripción:
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_proveedor_contacto_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tr_proveedor_contacto
	WHERE id_proveedor = pr_id_proveedor;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
