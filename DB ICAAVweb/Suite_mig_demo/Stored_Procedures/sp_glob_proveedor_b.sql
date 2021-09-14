DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_proveedor_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN 	pr_id_proveedor				INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre:		sp_glob_proveedor_c
	@fecha:			28/11/2016
	@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo sucursal.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_b';
	END ;


	IF (pr_id_proveedor != '' ) THEN

	SELECT
		prov.id_proveedor,
		prov.id_tipo_proveedor,
		tip_prov.cve_tipo_proveedor,
		prov.id_direccion,
		prov.id_sucursal,
		conf.inventario,
		-- conf.linea_aerea,
		conf.ctrl_comisiones,
		conf.no_contab_comision,
		prov.id_sat_tipo_tercero,
		prov.id_sat_tipo_operacion,
		tip_ope.origen,
		prov.cve_proveedor,
		prov.tipo_proveedor_operacion,
		prov.tipo_persona,
		prov.rfc,
		prov.razon_social,
		prov.nombre_comercial,
		(SELECT CASE WHEN prov.telefono = "null" THEN "" ELSE prov.telefono END) telefono,
		prov.email,
		(SELECT CASE WHEN prov.email = "null" THEN "" ELSE prov.email END) email,
		prov.concepto_pago,
		prov.porcentaje_prorrateo,
		prov.estatus,
		dir.cve_pais,
		dir.codigo_postal,
		prov.fecha_mod,
		concat(usuario.nombre_usuario," ",
		usuario.paterno_usuario) usuario_mod
	FROM ic_cat_tr_proveedor prov
		INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
			ON usuario.id_usuario=prov.id_usuario
		INNER JOIN ct_glob_tc_direccion dir
			on dir.id_direccion= prov.id_direccion
		LEFT JOIN ic_glob_tc_tipo_ope_sat tip_ope
			ON tip_ope.id_sat_tipo_operacion= prov.id_sat_tipo_operacion
		INNER JOIN ic_cat_tc_tipo_proveedor tip_prov ON tip_prov.id_tipo_proveedor= prov.id_tipo_proveedor
		INNER JOIN ic_cat_tr_proveedor_conf conf
			ON conf.id_proveedor=prov.id_proveedor
	WHERE prov.id_grupo_empresa = pr_id_grupo_empresa
    AND prov.id_proveedor=pr_id_proveedor;

	SET pr_message 	   = 'SUCCESS';
	END IF;
END$$
DELIMITER ;
