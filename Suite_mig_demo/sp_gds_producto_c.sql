DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_producto_c`(
	OUT pr_message 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_gds_producto_c
	@fecha: 		2018/05/07
	@descripción: 	Sp para obtenber los servicios.
	@autor : 		Alan Olivares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_producto_c';
	END ;

	SELECT
		id_producto,
        cve_producto,
		descripcion
	FROM ic_cat_tc_producto
	WHERE id_producto IN (1,2,3,4);

    SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
