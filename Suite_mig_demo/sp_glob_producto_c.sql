DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_producto_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_glob_producto_c
	@fecha: 		2016/08/19
	@descripción: 	Sp para obtenber las monedas.
	@autor : 		Alan Olivares
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_producto_c';
	END ;

	SELECT
		id_producto,
        descripcion as desc_producto
	FROM
		ic_cat_tc_producto
	WHERE
		estatus = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
