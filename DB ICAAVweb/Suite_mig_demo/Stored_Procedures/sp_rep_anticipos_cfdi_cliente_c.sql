DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_anticipos_cfdi_cliente_c`(
	IN  pr_id_grupo_empresa			INT,
    IN	pr_estatus					INT, /* 1=PENDIENTES DE APLICAR | 2=APLICADOS | 3=TODOS */
    IN  pr_fecha_ini				DATE,
    IN  pr_fecha_fin				DATE,
    IN	pr_id_moneda				INT,
    IN  pr_id_sucursal				INT,
    IN  pr_id_cliente				INT,
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

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_anticipos_cfdi_cliente_c';
	END ;

    /* VALIDAR SUCURSAL */
	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

	/* VALIDAR CLIENTE */
	IF pr_id_cliente > 0 THEN
		SET lo_cliente = CONCAT('AND fac.id_cliente =',pr_id_cliente);
    END IF;

    /* ANTICIPOS PENDIENTE DE APLICAR APLICADOS */
    IF pr_estatus = 1 THEN
		SET @query = CONCAT('
							SELECT
								fac.id_cliente,
								cli.cve_cliente,
								cli.razon_social cliente
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
							LEFT JOIN sat_formas_pago pay_form_sat ON
								pay_form.id_forma_pago_sat = pay_form_sat.c_FormaPago
							JOIN ic_cat_tr_sucursal suc ON
								fac.id_sucursal = suc.id_sucursal
							WHERE ant.importe_aplicado_moneda_facturada >= 0
                            AND ant.importe_aplicado_moneda_facturada < anticipo_moneda_facturada
							AND ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND ant.fecha >= ''',pr_fecha_ini,'''
							AND ant.fecha<= ''',pr_fecha_fin,'''
                            ',lo_sucursal,'
							',lo_cliente,'
                            GROUP BY fac.id_cliente'
                            );

    /* ANTICIPOS APLICADOS */
	ELSEIF pr_estatus = 2 THEN
        SET @query = CONCAT('
							SELECT
								fac.id_cliente,
								cli.cve_cliente,
								cli.razon_social cliente
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
							LEFT JOIN sat_formas_pago pay_form_sat ON
								pay_form.id_forma_pago_sat = pay_form_sat.c_FormaPago
							JOIN ic_cat_tr_sucursal suc ON
								fac.id_sucursal = suc.id_sucursal
							WHERE id_anticipos_aplicacion IS NOT NULL
							AND ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND ant_apli.fecha >= ''',pr_fecha_ini,'''
							AND ant_apli.fecha <= ''',pr_fecha_fin,'''
							AND ant.fecha >= ''',pr_fecha_ini,'''
							AND ant.fecha <= ''',pr_fecha_fin,'''
							',lo_sucursal,'
							',lo_cliente,'
                            GROUP BY fac.id_cliente'
                            );

    /* TODOS */
    ELSEIF pr_estatus = 3 THEN
		SET @query = CONCAT('
							SELECT
								fac.id_cliente,
								cli.cve_cliente,
								cli.razon_social cliente
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
							LEFT JOIN sat_formas_pago pay_form_sat ON
								pay_form.id_forma_pago_sat = pay_form_sat.c_FormaPago
							JOIN ic_cat_tr_sucursal suc ON
								fac.id_sucursal = suc.id_sucursal
							WHERE ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND ant.fecha >=  ''',pr_fecha_ini,'''
							AND ant.fecha <= ''',pr_fecha_fin,'''
							',lo_sucursal,'
							',lo_cliente,'
                            GROUP BY fac.id_cliente'
                            );
    END IF;

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
