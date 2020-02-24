DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_anticipos_cfdi_c`(
	IN  pr_id_grupo_empresa			INT,
    IN	pr_estatus					INT, /* 1=PENDIENTES DE APLICAR | 2=APLICADOS | 3=TODOS */
    IN  pr_fecha_ini				DATE,
    IN  pr_fecha_fin				DATE,
    IN	pr_id_moneda				INT,
    IN  pr_id_sucursal				INT,
    IN  pr_id_cliente				INT,
    -- IN  pr_tipo_reporte				INT, /* 1=CONCENTRADO | 2=ANALITICO */
    OUT pr_message 	  		 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_anticipos_cfdi_c
	@fecha:			03/05/2019
	@descripcion:	Sp para consultar el reporte de los anticipos en facturacion
	@autor: 		Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_sucursal				VARCHAR(150) DEFAULT '';
    DECLARE lo_cliente				VARCHAR(150) DEFAULT '';
	DECLARE lo_sum					VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_anticipos_cfdi_c';
	END ;

    /* VALIDAR SUCURSAL */
	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;
	/*
    IF pr_tipo_reporte = 1 THEN
		SET lo_sum = ('SUM');
    END IF;
     */
    /* ANTICIPOS PENDIENTE DE APLICAR APLICADOS */
    IF pr_estatus = 1 THEN
		SET @query = CONCAT('
							SELECT
								ant.id_anticipos,
                                fac.id_factura,
								CONCAT(ser.cve_serie,''-'',fac.fac_numero) referencia,
								cli.cve_cliente,
								cli.razon_social cliente,
								ant.fecha fecha_anticipo,
								',lo_sum,'(ant.anticipo_moneda_facturada) import_ant,
								mon.clave_moneda moneda_ant,
								ant.tipo_cambio,
								CASE
									WHEN ',pr_id_moneda,' = 149 THEN
										anticipo_usd
									WHEN ',pr_id_moneda,' = 49 THEN
										anticipo_eur
									ELSE
										ant.anticipo_moneda_base
								END import_ant_mn,
								CASE
									WHEN ',pr_id_moneda,' = 149 THEN
										((ant.anticipo_usd - ant.importe_aplicado_usd))
									WHEN ',pr_id_moneda,' = 49 THEN
										((ant.anticipo_eur - ant.importe_aplicado_eur))
									ELSE
										(ant.anticipo_moneda_base - ant.importe_aplicado_base)
								END saldo_x_apli_mn,
								det.nombre_pasajero,
								det.concepto,
								pay_form_cat.cve_forma_pago forma_pag,
								suc.cve_sucursal
							FROM ic_fac_tr_anticipos ant
							LEFT JOIN ic_fac_tr_anticipos_aplicacion ant_apli ON
								ant.id_anticipos = ant_apli.id_anticipos
							JOIN ic_fac_tr_factura fac ON
								ant.id_factura = fac.id_factura
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							JOIN ic_cat_tr_serie ser ON
								fac.id_serie = ser.id_serie
							JOIN ic_cat_tr_cliente cli ON
								fac.id_cliente = cli.id_cliente
							LEFT JOIN ct_glob_tc_moneda mon ON
								ant.id_moneda = mon.id_moneda
							LEFT JOIN ic_fac_tr_factura_forma_pago pay_form ON
								fac.id_factura = pay_form.id_factura
							LEFT JOIN ic_glob_tr_forma_pago pay_form_cat ON
								pay_form.id_forma_pago = pay_form_cat.id_forma_pago
							JOIN ic_cat_tr_sucursal suc ON
								fac.id_sucursal = suc.id_sucursal
							WHERE ant.importe_aplicado_moneda_facturada >= 0
                            AND ant.importe_aplicado_moneda_facturada < anticipo_moneda_facturada
							AND ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND ant.fecha >= ''',pr_fecha_ini,'''
							AND ant.fecha <= ''',pr_fecha_fin,'''
                            AND fac.id_cliente = ',pr_id_cliente,'
							',lo_sucursal,'
                            ','GROUP BY fac.id_factura'
                            );

    /* ANTICIPOS APLICADOS */
	ELSEIF pr_estatus = 2 THEN
        SET @query = CONCAT('
							SELECT
								ant.id_anticipos,
                                fac.id_factura,
								CONCAT(ser.cve_serie,''-'',fac.fac_numero) referencia,
								cli.cve_cliente,
								cli.razon_social cliente,
								ant.fecha fecha_anticipo,
								',lo_sum,'(ant.anticipo_moneda_facturada) import_ant,
								mon.clave_moneda moneda_ant,
								ant.tipo_cambio,
                                CASE
									WHEN ',pr_id_moneda,' = 149 THEN
										anticipo_usd
									WHEN ',pr_id_moneda,' = 49 THEN
										anticipo_eur
									ELSE
										ant.anticipo_moneda_base
								END import_ant_mn,
								CASE
									WHEN ',pr_id_moneda,' = 149 THEN
										((ant.anticipo_usd - ant.importe_aplicado_usd))
									WHEN ',pr_id_moneda,' = 49 THEN
										((ant.anticipo_eur - ant.importe_aplicado_eur))
									ELSE
										(ant.anticipo_moneda_base - ant.importe_aplicado_base)
								END saldo_x_apli_mn,
								det.nombre_pasajero,
								det.concepto,
								pay_form_cat.cve_forma_pago forma_pag,
								suc.cve_sucursal
							FROM ic_fac_tr_anticipos ant
							LEFT JOIN ic_fac_tr_anticipos_aplicacion ant_apli ON
								ant.id_anticipos = ant_apli.id_anticipos
							JOIN ic_fac_tr_factura fac ON
								ant.id_factura = fac.id_factura
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							JOIN ic_cat_tr_serie ser ON
								fac.id_serie = ser.id_serie
							JOIN ic_cat_tr_cliente cli ON
								fac.id_cliente = cli.id_cliente
							LEFT JOIN ct_glob_tc_moneda mon ON
								ant.id_moneda = mon.id_moneda
							LEFT JOIN ic_fac_tr_factura_forma_pago pay_form ON
								fac.id_factura = pay_form.id_factura
							LEFT JOIN ic_glob_tr_forma_pago pay_form_cat ON
								pay_form.id_forma_pago = pay_form_cat.id_forma_pago
							JOIN ic_cat_tr_sucursal suc ON
								fac.id_sucursal = suc.id_sucursal
							WHERE id_anticipos_aplicacion IS NOT NULL
							AND ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND ant_apli.fecha >= ''',pr_fecha_ini,'''
							AND ant_apli.fecha <= ''',pr_fecha_fin,'''
                            AND ant.fecha >= ''',pr_fecha_ini,'''
							AND ant.fecha <= ''',pr_fecha_fin,'''
							AND fac.id_cliente = ',pr_id_cliente,'
							',lo_sucursal,'
                            ','GROUP BY fac.id_factura'
                            );

    /* TODOS */
    ELSEIF pr_estatus = 3 THEN
		SET @query = CONCAT('
							SELECT
								ant.id_anticipos,
                                fac.id_factura,
								CONCAT(ser.cve_serie,''-'',fac.fac_numero) referencia,
								cli.cve_cliente,
								cli.razon_social cliente,
								ant.fecha fecha_anticipo,
								',lo_sum,'(ant.anticipo_moneda_facturada) import_ant,
								mon.clave_moneda moneda_ant,
								ant.tipo_cambio,
                                CASE
									WHEN ',pr_id_moneda,' = 149 THEN
										anticipo_usd
									WHEN ',pr_id_moneda,' = 49 THEN
										anticipo_eur
									ELSE
										ant.anticipo_moneda_base
								END import_ant_mn,
								CASE
									WHEN ',pr_id_moneda,' = 149 THEN
										((ant.anticipo_usd - ant.importe_aplicado_usd))
									WHEN ',pr_id_moneda,' = 49 THEN
										((ant.anticipo_eur - ant.importe_aplicado_eur))
									ELSE
										(ant.anticipo_moneda_base - ant.importe_aplicado_base)
								END saldo_x_apli_mn,
								det.nombre_pasajero,
								det.concepto,
								pay_form_cat.cve_forma_pago forma_pag,
								suc.cve_sucursal
							FROM ic_fac_tr_anticipos ant
							LEFT JOIN ic_fac_tr_anticipos_aplicacion ant_apli ON
								ant.id_anticipos = ant_apli.id_anticipos
							JOIN ic_fac_tr_factura fac ON
								ant.id_factura = fac.id_factura
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							JOIN ic_cat_tr_serie ser ON
								fac.id_serie = ser.id_serie
							JOIN ic_cat_tr_cliente cli ON
								fac.id_cliente = cli.id_cliente
							LEFT JOIN ct_glob_tc_moneda mon ON
								ant.id_moneda = mon.id_moneda
							LEFT JOIN ic_fac_tr_factura_forma_pago pay_form ON
								fac.id_factura = pay_form.id_factura
							LEFT JOIN ic_glob_tr_forma_pago pay_form_cat ON
								pay_form.id_forma_pago = pay_form_cat.id_forma_pago
							JOIN ic_cat_tr_sucursal suc ON
								fac.id_sucursal = suc.id_sucursal
							WHERE ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND ant.fecha >=  ''',pr_fecha_ini,'''
							AND ant.fecha <= ''',pr_fecha_fin,'''
							AND fac.id_cliente = ',pr_id_cliente,'
							',lo_sucursal,'
                            ','GROUP BY fac.id_factura'
                            );
    END IF;

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
