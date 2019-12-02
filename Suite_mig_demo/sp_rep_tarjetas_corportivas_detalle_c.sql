DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_tarjetas_corportivas_detalle_c`(
	IN  pr_id_tc_corporativa				INT,
	IN  pr_id_factura						INT,
    IN  pr_fecha_ini						DATE,
    IN  pr_fecha_fin						DATE,
    OUT pr_message 	  						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_tarjetas_corportivas_detalle_c
	@fecha:			22/04/2019
	@descripcion:	Sp para consultar el detalle de las operaciones realizadas con las tarjetas corporativas
	@autor: 		Jonathan Ramirez
	@
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_tarjetas_corportivas_detalle_c';
	END ;

	DROP TEMPORARY TABLE IF EXISTS tmp_rep_tarjetas_op_1;
    DROP TEMPORARY TABLE IF EXISTS tmp_rep_tarjetas_op_2;

	SET @query = CONCAT('CREATE TEMPORARY TABLE tmp_rep_tarjetas_op_1
						SELECT
							fac.id_factura,
							det.id_factura_detalle,
							serv.cve_servicio servicio,
							airline.clave_aerolinea linea_aer,
							det.concepto,
							det.numero_boleto boleto,
							det.tarifa_moneda_facturada,
							mon.clave_moneda moneda,
							fac.tipo_cambio,
							det.tarifa_moneda_base,
							cxs.importe_tc,
							mon.clave_moneda,
							cxs.importe_moneda_base
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_fac_tr_compras_x_servicio cxs ON
							fac.id_factura = cxs.id_factura
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_cat_tr_proveedor_aero prov_aer ON
							prov.id_proveedor = prov_aer.id_proveedor
						LEFT JOIN ct_glob_tc_aerolinea airline ON
							prov_aer.codigo_bsp = airline.codigo_bsp
						LEFT JOIN ct_glob_tc_moneda mon ON
							fac.id_moneda = mon.id_moneda
						WHERE cxs.id_tc_corporativa = ',pr_id_tc_corporativa,'
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
						AND fac.fecha_factura <= ''',pr_fecha_fin,'''
                        AND fac.id_factura = ',pr_id_factura,'
						GROUP BY det.id_factura_detalle');

   	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

   SET @query1 = CONCAT('CREATE TEMPORARY TABLE tmp_rep_tarjetas_op_2
						SELECT
							imp.id_factura_detalle,
							SUM(imp.cantidad) imp_cantidad
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_fac_tr_compras_x_servicio cxs ON
							fac.id_factura = cxs.id_factura
						LEFT JOIN ic_fac_tr_factura_detalle_imp imp ON
							det.id_factura_detalle = imp.id_factura_detalle
						WHERE cxs.id_tc_corporativa = ',pr_id_tc_corporativa,'
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
						AND fac.fecha_factura <= ''',pr_fecha_fin,'''
                        AND fac.id_factura = ',pr_id_factura,'
						GROUP BY det.id_factura_detalle');

	-- SELECT @query1;
	PREPARE stmt FROM @query1;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT
		a.id_factura,
		a.id_factura_detalle,
		a.servicio,
		a.linea_aer,
		a.concepto,
		a.boleto,
		(a.tarifa_moneda_facturada + b.imp_cantidad) importe_fac,
		a.moneda,
		a.tipo_cambio,
		(a.tarifa_moneda_base + b.imp_cantidad) importe_moneda_nacional,
		a.importe_tc importe_cargo,
		a.clave_moneda,
		a.importe_moneda_base importe_mn
	FROM tmp_rep_tarjetas_op_1 a
	LEFT JOIN tmp_rep_tarjetas_op_2 b ON
		a.id_factura_detalle = b.id_factura_detalle;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
