DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meta_venta_tipo_c`(
	IN 	pr_id_meta_venta			INT,
    OUT pr_message 					VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_meta_venta_tipo_c
		@fecha: 		07/10/2019
		@descripción:
		@autor : 		Yazbek Kido
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_meta_venta_tipo_c';
	END ;

	SELECT
		tipo.*,
        vend_suc.nombre nom_sucursal,
        vend.id_sucursal vendedor_id_sucursal,
        vend.nombre nom_vendedor,
        vend.clave clave
	FROM
		ic_cat_tr_meta_venta_tipo tipo
	LEFT JOIN  ic_cat_tr_vendedor vend ON
		vend.id_vendedor = tipo.id_vendedor
	LEFT JOIN  ic_cat_tr_sucursal vend_suc ON
		vend_suc.id_sucursal = vend.id_sucursal

	WHERE tipo.id_meta_venta = pr_id_meta_venta;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
