DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_cons_bol_tipo_prov_c`(
	IN	pr_id_grupo_empresa			INT,
    OUT pr_message					VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_cons_bol_tipo_prov_c
	@fecha:			23/11/2018
	@descripcion:	SP para consultar registro en la tabla ic_cat_tc_tipo_proveedor
	@autor:			Jonathan Ramirez
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_cons_bol_tipo_prov_c';
	END ;

	SELECT
		tip_prov.id_tipo_proveedor,
		cve_tipo_proveedor,
		desc_tipo_proveedor
	FROM ic_cat_tc_tipo_proveedor tip_prov
	JOIN ic_cat_tr_proveedor prov ON
		tip_prov.id_tipo_proveedor = prov.id_tipo_proveedor
	JOIN ic_cat_tr_proveedor_conf prov_conf ON
		prov.id_proveedor = prov_conf.id_proveedor
	WHERE tip_prov.estatus_tipo_proveedor = 1
	AND prov_conf.inventario = 1
	AND prov.id_grupo_empresa = pr_id_grupo_empresa
	GROUP BY tip_prov.id_tipo_proveedor;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
