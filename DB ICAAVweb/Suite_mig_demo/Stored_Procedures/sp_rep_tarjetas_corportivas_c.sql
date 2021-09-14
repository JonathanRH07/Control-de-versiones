DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_tarjetas_corportivas_c`(
	IN  pr_id_tc_corporativa				INT,
	IN  pr_fecha_ini						DATE,
    IN  pr_fecha_fin						DATE,
    OUT pr_message 	  						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_tarjetas_corportivas_c
	@fecha:			22/04/2019
	@descripcion:	Sp para consultar operaciones realizadas con las tarjetas corporativas
	@autor: 		Jonathan Ramirez
	@
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_tarjetas_corportivas_c';
	END ;

	SET @query = CONCAT('
						SELECT
							fac.id_factura,
							fac.fecha_factura fecha,
							suc.cve_sucursal sucursal,
							ser.cve_serie serie,
							fac.fac_numero no_factura,
							prov.razon_social proveedor,
							cli.razon_social cliente,
							ven.nombre vendedor,
							SUM(fac.total_moneda_facturada) importe_servicios,
							mon.clave_moneda moneda,
							fac.tipo_cambio,
							SUM(fac.total_moneda_base) importe_moneda_nacional,
							cxs.importe_tc importe_cargo,
							mon.clave_moneda,
							cxs.importe_moneda_base_tc,
							CASE
								WHEN cxc.saldo_moneda_base = 0 THEN
									''PAGADA''
								WHEN cxc.saldo_moneda_base < 0 THEN
									''PAGO PARCIAL''
								WHEN cxc.saldo_moneda_base IS NULL THEN
									''SIN PAGO''
								ELSE
									''SIN PAGO''
							END estatus_cxc
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_fac_tr_compras_x_servicio cxs ON
							fac.id_factura = cxs.id_factura
						JOIN ic_cat_tr_sucursal suc ON
							fac.id_sucursal = suc.id_sucursal
						JOIN ic_cat_tr_serie ser ON
							fac.id_serie = ser.id_serie
						JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						JOIN ic_cat_tr_cliente cli ON
							fac.id_cliente = cli.id_cliente
						JOIN ic_cat_tr_vendedor ven ON
							fac.id_vendedor_tit = ven.id_vendedor
						JOIN ct_glob_tc_moneda mon ON
							fac.id_moneda = mon.id_moneda
						JOIN ic_glob_tr_cxc cxc ON
							fac.id_factura = cxc.id_factura
						WHERE cxs.id_tc_corporativa = ',pr_id_tc_corporativa,'
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
						AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						GROUP BY fac.id_factura
						ORDER BY 1 ASC, 3 ASC, 4 ASC');

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
