DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meta_venta_meses_c`(
	IN 	pr_id_meta_venta_tipo		INT,
    OUT pr_message 					VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_meta_venta_meses_c
		@fecha: 		07/10/2019
		@descripción:
		@autor : 		Yazbek Kido
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_meta_venta_meses_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tr_meta_venta_meses
	WHERE id_meta_venta_tipo = pr_id_meta_venta_tipo;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
