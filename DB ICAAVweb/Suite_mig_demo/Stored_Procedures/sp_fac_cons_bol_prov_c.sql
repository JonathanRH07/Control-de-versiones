DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_cons_bol_prov_c`(
	IN	pr_id_grupo_empresa			INT,
    IN	pr_id_tipo_proveedor		INT,
    OUT pr_message					VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_cons_bol_prov_c
	@fecha:			23/11/2018
	@descripcion:	SP para consultar registro en la tabla ic_cat_tc_tipo_proveedor
	@autor:			Jonathan Ramirez
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_cons_bol_prov_c';
	END ;

    SELECT
		prov.id_proveedor,
		prov.nombre_comercial
	FROM ic_cat_tr_proveedor prov
	JOIN ic_cat_tr_proveedor_conf prov_conf ON
		prov.id_proveedor = prov_conf.id_proveedor
	WHERE prov.id_grupo_empresa = pr_id_grupo_empresa
	AND prov.id_tipo_proveedor = pr_id_tipo_proveedor
	AND prov_conf.inventario = 1
	ORDER BY prov.nombre_comercial ASC;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
