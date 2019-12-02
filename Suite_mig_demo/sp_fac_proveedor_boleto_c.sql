DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_proveedor_boleto_c`(
	IN  pr_id_grupo_empresa	INT,
    OUT pr_message 			VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_fac_proveedor_boleto_c
	@fecha:			13/11/2018
	@descripcion:	SP muestra la clave del proveedor para el modulo de boletos
	@autor:			David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_proveedor_boleto_c';
	END ;

    SELECT
		DISTINCT(pro.cve_proveedor),
        cve_tipo_proveedor,
		desc_tipo_proveedor
	FROM ic_cat_tr_proveedor pro
	JOIN ic_cat_tc_tipo_proveedor tpro ON
		 pro.id_tipo_proveedor = tpro.id_tipo_proveedor
	JOIN ic_cat_tr_proveedor_conf con ON
		 pro.id_proveedor  = con.id_proveedor
	WHERE pro.id_grupo_empresa = pr_id_grupo_empresa
	AND   con.inventario = 1;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
