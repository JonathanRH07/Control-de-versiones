DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_aero_c`(
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
        SET pr_message = 'ERROR store sp_glob_pac_c';
	END ;

	SELECT
		pa.*,
        al.clave_aerolinea,
        al.id_aerolinea
	FROM ic_cat_tr_proveedor_aero pa
	LEFT JOIN	ct_glob_tc_aerolinea al ON
		al.codigo_bsp = pa.codigo_bsp
	WHERE id_proveedor = pr_id_proveedor;
	-- AND pa.codigo_bsp != '';

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
