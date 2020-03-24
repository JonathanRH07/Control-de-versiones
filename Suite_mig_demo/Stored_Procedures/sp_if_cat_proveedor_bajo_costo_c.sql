DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_proveedor_bajo_costo_c`(
	IN  pr_id_grupo_empresa 	INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_proveedor_bajo_costo_c
		@fecha: 		10/02/2020
		@descripción: 	Sp paraobtener los proveedores de bajo costo
		@autor : 		Yazbek
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_proveedor_bajo_costo_c';
	END ;

		SELECT
			clave_aerolinea, cve_proveedor
		FROM ic_cat_tr_proveedor
        JOIN ic_cat_tr_proveedor_aero ON
        ic_cat_tr_proveedor_aero.id_proveedor = ic_cat_tr_proveedor.id_proveedor
        JOIN ct_glob_tc_aerolinea ON
        ct_glob_tc_aerolinea.codigo_bsp = ic_cat_tr_proveedor_aero.codigo_bsp
		WHERE
			ic_cat_tr_proveedor.estatus = 'ACTIVO'
		AND  ic_cat_tr_proveedor.id_grupo_empresa=pr_id_grupo_empresa AND ic_cat_tr_proveedor_aero.bajo_costo = "SI";


	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
