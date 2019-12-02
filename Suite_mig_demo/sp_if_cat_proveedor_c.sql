DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_proveedor_c`(
	IN  pr_id_proveedor			INT,
	IN  pr_cve_proveedor		VARCHAR(10),
	IN  pr_id_grupo_empresa 	INT,
	IN  pr_codigo_bsp 			CHAR(10),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_proveedor_c
		@fecha: 		18/01/2018
		@descripción: 	Sp para consultar registros en la tabla proveedores
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_proveedor_c';
	END ;

    IF(pr_id_proveedor > 0 AND pr_id_grupo_empresa !='') THEN
		SELECT
			*
		FROM ic_cat_tr_proveedor
		WHERE id_proveedor=pr_id_proveedor
			AND ic_cat_tr_proveedor.estatus = 'ACTIVO'
			AND  ic_cat_tr_proveedor.id_grupo_empresa=pr_id_grupo_empresa ;
	END IF;

    IF(pr_cve_proveedor !='' AND pr_id_grupo_empresa !='') THEN
		SELECT
			*
		FROM ic_cat_tr_proveedor
		INNER JOIN ct_glob_tc_direccion
			ON ct_glob_tc_direccion.id_direccion=ic_cat_tr_proveedor.id_direccion
		INNER JOIN ct_glob_tc_pais
			ON ct_glob_tc_pais.cve_pais=ct_glob_tc_direccion.cve_pais
		INNER JOIN ic_cat_tr_proveedor_conf
			ON ic_cat_tr_proveedor_conf.id_proveedor=ic_cat_tr_proveedor.id_proveedor
		WHERE cve_proveedor=pr_cve_proveedor
			AND ic_cat_tr_proveedor.estatus = 'ACTIVO'
			AND  ic_cat_tr_proveedor.id_grupo_empresa=pr_id_grupo_empresa ;
	END IF;

    IF(pr_codigo_bsp !='' AND pr_id_grupo_empresa !='' ) THEN
		SELECT
			*
        FROM ic_cat_tr_proveedor
        INNER JOIN ic_cat_tr_proveedor_aero
			ON ic_cat_tr_proveedor_aero.id_proveedor=ic_cat_tr_proveedor.id_proveedor
		WHERE codigo_bsp=pr_codigo_bsp
        AND id_grupo_empresa=pr_id_grupo_empresa
        AND ic_cat_tr_proveedor.estatus = 'ACTIVO' ;
    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
