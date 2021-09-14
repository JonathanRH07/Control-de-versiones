DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_pagos_con_tc_c`(
	IN	pr_id_grupo_empresa	 				INT,
    IN	pr_id_sucursal		 				INT,
    IN	pr_id_cliente		 				INT,
    IN	pr_fecha_ini		     			DATE,
    IN	pr_fecha_fin		     			DATE,
	OUT pr_rows_tot_table 	 				INT,
    OUT pr_message 	  		 				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_pagos_con_tc_c
	@fecha:			10/08/2018
	@descripcion:	Sp para consultar los pagos recibidos y pagados con tarjeta de credito
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_cliente						VARCHAR(200) DEFAULT '';
    DECLARE lo_sucursal 					VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_pagos_con_tc_c';
	END ;

    IF pr_id_cliente > 0 THEN
		SET lo_cliente = CONCAT('AND fac.id_cliente = ',pr_id_cliente);
    END IF;

	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    DROP TABLE IF EXISTS tmp_tarjetas_general;

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    SET @n = 0;
    SET @query = CONCAT('
						CREATE TEMPORARY TABLE tmp_tarjetas_general
						SELECT
							@n := (@n + 1) id,
                            cxc.id_cxc,
							fac.id_factura,
							fecha_factura fecha_factura,
							ser.cve_serie serie,
							fac.fac_numero no_factura,
							prov.cve_proveedor proveedor,
							vuelos.clave_linea_aerea linea_aerea,
							det.numero_boleto no_boleto,
							det.numero_tarjeta forma_pago,
							fac.total_moneda_base tarifa_servicio,
							det.importe_credito importe_aplicado,
							tar.importe_tc importe_x_aplicar,
							det.concepto,
							cxc.saldo_moneda_base saldo_cxc,
							COUNT(*) no_formas_pago,
							cli.cve_cliente cliente,
							suc.cve_sucursal sucursal
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_fac_tr_compras_x_servicio tar ON
							fac.id_factura = tar.id_factura
						JOIN ic_cat_tr_serie ser ON
							fac.id_serie = ser.id_serie
						LEFT JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						LEFT JOIN ic_gds_tr_vuelos vuelos ON
							det.id_factura_detalle = vuelos.id_factura_detalle
						LEFT JOIN ic_glob_tr_cxc cxc ON
							fac.id_factura = cxc.id_factura
						JOIN ic_cat_tr_cliente cli ON
							fac.id_cliente = cli.id_cliente
						JOIN ic_cat_tr_sucursal suc ON
							fac.id_sucursal = suc.id_sucursal
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						',lo_cliente,'
                        AND fac.estatus != 2
						AND fecha_factura >= ''',pr_fecha_ini,'''
						AND fecha_factura <= ''',pr_fecha_fin,'''
						GROUP BY fac.id_factura
						ORDER BY 1 ASC');

	-- SELECT @query;
    PREPARE stmt FROM @query;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
	SET @n = 0;

	SELECT
		id_cxc,
		id_factura,
		fecha_factura,
		serie,
		no_factura,
		proveedor,
		linea_aerea,
		no_boleto,
		forma_pago,
		tarifa_servicio,
		importe_aplicado,
		importe_x_aplicar,
		concepto,
		saldo_cxc,
		no_formas_pago,
		1 no_foma_pago_tc,
		cliente,
		sucursal
	FROM tmp_tarjetas_general
	GROUP BY id_factura;

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	SELECT
		COUNT(*)
	INTO
		pr_rows_tot_table
	FROM(
		SELECT *
		FROM tmp_tarjetas_general
		GROUP BY id_factura) a;

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
