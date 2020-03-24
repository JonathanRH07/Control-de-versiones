DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_factura_detalle_imp_c`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_id_factura_detalle 	INT,
	IN  pr_cont 				INT,
	OUT pr_message 				VARCHAR(500),
	OUT pr_contador 			VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_factura_detalle_imp_c
		@fecha 		: 29/05/2017
		@descripcion: Sp para consutlar facturas detalle impuestos
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_detalle_imp_c';
	END ;

	SELECT
		id_factura_detalle_imp,
		id_factura_detalle,
		cat_imp.id_impuesto,
		cat_imp.cve_impuesto,
		cat_imp.desc_impuesto AS descripcion,
		cat_imp.tipo_valor_impuesto,
		cat_imp.cve_impuesto_cat,
		fac_det_imp.base_valor,
		fac_det_imp.base_valor_cantidad,
		fac_det_imp.valor_impuesto,
		fac_det_imp.cantidad,
		sat.c_Impuesto cve_impuesto_sat,
		imp_prov_unid.c_ClaveProdServ,
		sat_unidad.c_ClaveUnidad,
		sat_unidad.nombre sat_unidad_nombre,
		cat_imp.clase,
		cat_imp.tipo
	FROM ic_fac_tr_factura_detalle_imp fac_det_imp
	INNER JOIN ic_cat_tr_impuesto cat_imp ON
		cat_imp.id_impuesto = fac_det_imp.id_impuesto
	INNER JOIN ic_cat_tc_impuesto_categoria imp_cat ON
		imp_cat.cve_impuesto_cat = cat_imp.cve_impuesto_cat
	LEFT JOIN ic_cat_tr_impuesto_provee_unidad imp_prov_unid ON
		cat_imp.id_impuesto = imp_prov_unid.id_impuesto AND imp_prov_unid.id_grupo_empresa = pr_id_grupo_empresa
	LEFT JOIN sat_impuestos sat ON
		sat.descripcion = imp_cat.cve_impuesto_cat
	LEFT JOIN sat_unidades_medida sat_unidad ON
		sat_unidad.id_unidad = imp_prov_unid.id_unidad
	WHERE fac_det_imp.id_factura_detalle = pr_id_factura_detalle;

	# Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';
    SET pr_contador 	= pr_cont;
END$$
DELIMITER ;
