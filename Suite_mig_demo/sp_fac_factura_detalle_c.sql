DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_detalle_c`(
	IN  pr_id_factura 		INT(11),
    IN  pr_order_by			VARCHAR(45),
	OUT pr_message			VARCHAR(5000))
BEGIN

    DECLARE  lo_order_by			VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_detalle_c';
	END ;

    IF pr_order_by > '' THEN
		SET lo_order_by = pr_order_by;
	ELSE
		SET lo_order_by = 'num_servicios';
	END IF;


	SELECT
		id_factura_detalle,
		id_factura,
		id_prov_tpo_serv,
		id_boleto,
		id_factura_cxs,
		id_grupo_fit,
		ic_cat_tr_proveedor.id_proveedor AS serv_id_proveedor,
		ic_cat_tr_proveedor.cve_proveedor AS serv_clave_proveedor,
		ic_cat_tr_proveedor.nombre_comercial AS serv_desc_proveedor,
        ic_cat_tr_proveedor.rfc AS rfc_prov,
        ic_cat_tr_proveedor.razon_social AS razon_social_prov,
		CAT_prov_conf.inventario AS serv_prov_inventario,
		CAT_tipo_prov.cve_tipo_proveedor AS serv_cve_tipo_proveedor,
        dir.calle AS calle_prov,
        dir.codigo_postal AS cp_prov,
        dir.colonia AS colonia_prov,
        dir.cve_pais AS pais_prov,
        dir.estado AS estado_prov,
        dir.municipio AS municipio_prov,
        dir.num_exterior AS exterior_prov,
        (SELECT CASE WHEN dir.num_interior = "null" THEN "" ELSE dir.num_interior END) AS interior_prov,
		ic_cat_tc_servicio.id_servicio AS serv_id_servicio,
		ic_cat_tc_servicio.cve_servicio AS serv_clave_servicio,
		ic_cat_tc_servicio.descripcion AS serv_desc_servicio,
		ic_cat_tc_servicio.c_ClaveProdServ AS serv_c_ClaveProdServ,
		clave_prod_serv_sat,
		clave_prod_serv_desc_sat,
		numero_boleto,
		concepto,
		nombre_pasajero,
		tarifa_moneda_base,
		tarifa_moneda_facturada,
		comision_agencia,
		porc_comision_agencia,
		descuento,
		comision_titular,
		porc_comision_titular,
		comision_auxiliar,
		porc_comision_auxiliar,
		suma_impuestos,
		iva_comision,
		porc_iva_comision,
		boleto_contra,
		la_contra,
		numero_boleto_contra,
		boleto_conjunto,
		id_prov_num_cta,
		id_prov_num_cta_resul,
		porc_descuento,
		iva_descuento,
		importe_credito,
		numero_tarjeta,
		referencia_cxp,
		numero_bol_cxs,
		bol_electronico,
		id_regla,
		comision_cedida,
		clave_reservacion,
		boleto_facturado,
		facturar_agencia,
		emd,
		importe_markup,
		porc_markup,
		num_servicios,
        ic_fac_tr_factura_detalle.id_unidad_medida,
        cve_unidad_medida,
		clave_unidad_sat,
        sat_uni.nombre AS nombre_unidad_sat,
		cuenta_ingreso,
		cuenta_ingreso_porcentaje,
		impuesto_x_pagar,
		cantidad,
        nc_rembolso,
        nc_tipo_remb,
        complemento_terceros,
        prod.cve_producto
	FROM
		ic_fac_tr_factura_detalle
	INNER JOIN ic_cat_tr_proveedor ON
		ic_cat_tr_proveedor.id_proveedor = ic_fac_tr_factura_detalle.id_proveedor
	INNER JOIN ic_cat_tr_proveedor_conf AS CAT_prov_conf
		ON ic_cat_tr_proveedor.id_proveedor = CAT_prov_conf.id_proveedor
	INNER JOIN ic_cat_tc_servicio ON
		ic_cat_tc_servicio.id_servicio= ic_fac_tr_factura_detalle.id_servicio
	LEFT JOIN ic_cat_tc_tipo_proveedor AS CAT_tipo_prov
		ON CAT_tipo_prov.id_tipo_proveedor = ic_cat_tr_proveedor.id_tipo_proveedor
	LEFT JOIN ic_cat_tc_unidad_medida AS unidad
		ON unidad.id_unidad_medida = ic_fac_tr_factura_detalle.id_unidad_medida
	LEFT JOIN sat_unidades_medida AS sat_uni
		ON sat_uni.c_ClaveUnidad = ic_fac_tr_factura_detalle.clave_unidad_sat
	LEFT JOIN ct_glob_tc_direccion AS dir
		ON dir.id_direccion = ic_cat_tr_proveedor.id_direccion
	LEFT JOIN ic_cat_tc_producto AS prod
		ON ic_cat_tc_servicio.id_producto = prod.id_producto
	WHERE
		id_factura=pr_id_factura
	ORDER BY lo_order_by;

	SET pr_message	= 'SUCCESS';

END$$
DELIMITER ;
