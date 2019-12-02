DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_proveedor_c`(
	IN  pr_id_grupo_empresa 	INT,
    IN 	pr_id_tipo_prov			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_proveedor_c
	@fecha: 		20/01/2017
	@descripción: 	Sp para obtener registros de proveedor.
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_proveedor_c';
	END ;

	IF pr_id_tipo_prov = '' THEN
		SELECT
			prov.id_proveedor,
			prov.id_tipo_proveedor,
			tip_prov.desc_tipo_proveedor,
			prov.id_sucursal,
            prov.rfc,
			suc.nombre,
			prov.cve_proveedor,
			prov.razon_social,
			prov.nombre_comercial,
			tip_prov.cve_tipo_proveedor,
            prov.id_direccion,
            prov_conf.inventario
		FROM
			ic_cat_tr_proveedor prov
			INNER JOIN ic_cat_tc_tipo_proveedor tip_prov
				ON tip_prov.id_tipo_proveedor= prov.id_tipo_proveedor
			INNER JOIN ic_cat_tr_sucursal suc
				ON suc.id_sucursal=prov.id_sucursal
			LEFT JOIN ic_cat_tr_proveedor_conf prov_conf
				ON prov_conf.id_proveedor = prov.id_proveedor
		WHERE  prov.id_grupo_empresa  = pr_id_grupo_empresa
		AND    prov.estatus = 1;
	ELSE
		SELECT
			prov.id_proveedor,
			prov.id_tipo_proveedor,
			tip_prov.desc_tipo_proveedor,
			prov.id_sucursal,
            prov.rfc,
			suc.nombre,
			prov.cve_proveedor,
			prov.razon_social,
			prov.nombre_comercial,
			tip_prov.cve_tipo_proveedor,
            prov.id_direccion,
            prov_conf.inventario
		FROM
			ic_cat_tr_proveedor prov
			INNER JOIN ic_cat_tc_tipo_proveedor tip_prov
				ON tip_prov.id_tipo_proveedor= prov.id_tipo_proveedor
			INNER JOIN ic_cat_tr_sucursal suc
				ON suc.id_sucursal=prov.id_sucursal
			LEFT JOIN ic_cat_tr_proveedor_conf prov_conf
				ON prov_conf.id_proveedor = prov.id_proveedor
		WHERE  prov.id_grupo_empresa  = pr_id_grupo_empresa
        AND    prov.id_tipo_proveedor = pr_id_tipo_prov
		AND    prov.estatus = 1;
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
