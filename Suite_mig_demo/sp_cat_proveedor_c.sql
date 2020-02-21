DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_c`(
	 IN  pr_id_grupo_empresa	INT,
     IN  pr_id_proveedor		INT,
     OUT pr_message				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_glob_proveedor_c
	@fecha: 		07/08/2018
	@descripción: 	Muestra los proveedores
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_producto_c';
	END ;

	SELECT
				 prov.id_proveedor
				,prov.id_tipo_proveedor
				,prov.id_direccion
				,prov.id_sucursal
                ,prov.id_sat_tipo_tercero
				,prov.id_sat_tipo_operacion
                ,prov.cve_proveedor
				,prov.tipo_proveedor_operacion
				,prov.tipo_persona
				,prov.rfc
				,prov.razon_social
				,prov.nombre_comercial
				,prov.email
				,prov.porcentaje_prorrateo
				,prov.estatus
                ,prov.fecha_mod
                ,(SELECT CASE WHEN prov.email = "null" THEN "" ELSE prov.email END) email
				,(SELECT CASE WHEN prov.concepto_pago = "null" THEN "" ELSE prov.concepto_pago END) concepto_pago
                ,(SELECT CASE WHEN prov.telefono = "null" THEN "" ELSE prov.telefono END) telefono
                ,tip_prov.cve_tipo_proveedor
                ,CONCAT("GTIPPROV.",tip_prov.cve_tipo_proveedor) as etiqueta_tipprov
				,conf.inventario
				-- ,conf.linea_aerea
				,conf.ctrl_comisiones
				,conf.no_contab_comision
				,(SELECT CASE WHEN conf.num_dias_credito = 0 THEN "" ELSE conf.num_dias_credito END) num_dias_credito
                ,tip_ope.origen
				,dir.cve_pais
				,dir.codigo_postal
                ,CONCAT(usuario.nombre_usuario," ",usuario.paterno_usuario) usuario_mod
                ,tip_prov.desc_tipo_proveedor
			FROM ic_cat_tr_proveedor prov
			INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
				ON usuario.id_usuario=prov.id_usuario
			INNER JOIN ct_glob_tc_direccion dir
				ON dir.id_direccion= prov.id_direccion
			LEFT JOIN ic_glob_tc_tipo_ope_sat tip_ope
				ON tip_ope.id_sat_tipo_operacion= prov.id_sat_tipo_operacion
			LEFT JOIN ic_cat_tc_tipo_proveedor tip_prov
				ON tip_prov.id_tipo_proveedor= prov.id_tipo_proveedor
			LEFT JOIN ic_cat_tr_proveedor_conf conf
				ON conf.id_proveedor=prov.id_proveedor
			WHERE
				prov.id_grupo_empresa = pr_id_grupo_empresa AND
                prov.id_proveedor = pr_id_proveedor AND
                prov.estatus = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
