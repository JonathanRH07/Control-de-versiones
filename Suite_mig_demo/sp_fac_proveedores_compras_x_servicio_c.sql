DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_proveedores_compras_x_servicio_c`(
	IN  pr_id_factura					INT,
    OUT pr_message 	  					VARCHAR(500)
    )
BEGIN
/*
	@nombre:		sp_fac_proveedores_compras_x_servicio_c
	@fecha:			22/04/2019
	@descripcion:	Sp para consultar operaciones en la tabla
	@autor: 		Jonathan Ramirez
	@
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_proveedores_compras_x_servicio_c';
	END ;

	SELECT
		id_compras_x_servicio,
		cxs.id_grupo_empresa,
		cxs.id_tc_corporativa,
		cxs.id_factura,
		cxs.id_proveedor,
        prov.cve_proveedor serv_clave_proveedor,
		cxs.id_moneda,
		cxs.no_tarjeta_credito,
		cxs.propietario_tc,
		cxs.importe_tc,
		cxs.importe_moneda_base_tc,
		cxs.forma_pago_prov_efectivo,
		cxs.importe_efectivo,
		cxs.importe_moneda_base_efectivo,
		cxs.fecha_cargo,
		cxs.fecha_corte,
		cxs.importe,
		mon.clave_moneda,
		cxs.tipo_cambio,
		cxs.importe_moneda_base,
		tc.no_tarjeta
	FROM ic_cat_tr_proveedor prov
    LEFT JOIN ic_fac_tr_compras_x_servicio cxs ON
		prov.id_proveedor = cxs.id_proveedor
	LEFT JOIN ct_glob_tc_moneda mon ON
		cxs.id_moneda = mon.id_moneda
	LEFT JOIN ic_gds_tc_corporativa tc ON
		cxs.id_tc_corporativa = tc.id_tc_corporativa
	WHERE cxs.id_factura = pr_id_factura;

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
