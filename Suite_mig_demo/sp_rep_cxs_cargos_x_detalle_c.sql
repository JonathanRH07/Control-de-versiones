DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_cxs_cargos_x_detalle_c`(
	IN 	pr_id_grupo_empresa 			INT,
    IN 	pr_id_sucursal					INT,
    IN	pr_tipo							INT,
    IN  pr_id_consulta					INT,
    IN  pr_id_moneda					INT,
    IN	pr_fecha_ini					DATE,
	IN	pr_fecha_fin					DATE,
    OUT	pr_message						VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_rep_cxs_cargos_x_detalle_c
	@fecha:			2019/08/27
	@descripción : 	Stored procedure para consultar los cargos por servicio desglosados en tipo.
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

    DECLARE lo_sucursal					VARCHAR(500) DEFAULT '';
    DECLARE lo_moneda					VARCHAR(100);
	DECLARE lo_consulta					VARCHAR(500);
    DECLARE lo_order					VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_cxs_cargos_x_detalle_c';
	END ;

    /* VALIDAMOS SI SE CONSULTA UNA SUCURSAL EN ESPECIFICO */
    IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

    /* VALIDAMOS EL TIPO DE MONEDA QUE SE OBTIENE EL REPORTE */
    IF pr_id_moneda = 149 THEN -- DOLARES
		SET lo_moneda = '/tipo_cambio_usd';
	ELSEIF pr_id_moneda = 49 THEN -- EUROS
		SET lo_moneda = '/tipo_cambio_eur';
	ELSE -- MONEDA NACIONAL
		SET lo_moneda = '';
    END IF;

    /*
    TIPOS DE CONSULTA
    1)- CLIENTE
    2)- VENDEDOR
    3)- SERVICIO
    */

    /* VALIDAMOS EL TIPO DE CONSULTA */
    IF pr_tipo = 1 THEN
		SET lo_consulta = CONCAT(' AND fac.id_cliente = ',pr_id_consulta,' ');
	ELSEIF pr_tipo = 2 THEN
		SET lo_consulta = CONCAT(' AND fac.id_vendedor_tit = ',pr_id_consulta,' ');
	ELSE
		SET lo_consulta = CONCAT('');
        SET lo_order = ' ORDER BY fac.fecha_factura, factura ASC';
	END IF;

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    /* DETALLE POR CLIENTE */
    SET @querydetcli = CONCAT(
						'
						SELECT
							fac.fecha_factura,
							CONCAT(serie.cve_serie, ''-'',fac.fac_numero) factura,
							cli.cve_cliente,
							vend.clave cve_vendedor,
							det.nombre_pasajero,
							prov.cve_proveedor,
							serv.cve_servicio,
							IFNULL((IFNULL(tarifa_moneda_base',lo_moneda,', 0.00) + IFNULL(importe_markup',lo_moneda,', 0.00) - IFNULL(descuento',lo_moneda,', 0.00)), 0.00) importe_cxs,
							det.numero_boleto referencia,
							serv.descripcion concepto_serv
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						JOIN ic_cat_tr_cliente cli ON
							fac.id_cliente = cli.id_cliente
						JOIN ic_cat_tr_serie serie ON
							fac.id_serie = serie.id_serie
						JOIN ic_cat_tr_vendedor vend ON
							fac.id_vendedor_tit = vend.id_vendedor
						JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						',lo_consulta,'
						AND serv.id_producto = 5
						AND serv.estatus = 1
                        AND fac.estatus != 2
                        -- AND fac.tipo_cfdi = ''I''
						AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
						AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						GROUP BY det.id_factura_detalle ','
						',lo_order);

	-- SELECT @querydetcli;
	PREPARE stmt FROM @querydetcli;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /*
    SET @querydetcli = CONCAT(
						'
						SELECT
							fac.fecha_factura,
							CONCAT(serie.cve_serie, ''-'',fac.fac_numero) factura,
							cli.cve_cliente,
							vend.clave cve_vendedor,
							det.nombre_pasajero,
							prov.cve_proveedor,
							serv.cve_servicio,
							((tarifa_moneda_base + importe_markup - descuento)) importe_cxs,
							det.numero_boleto referencia,
							serv.descripcion concepto_serv
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						JOIN ic_cat_tr_cliente cli ON
							fac.id_cliente = cli.id_cliente
						JOIN ic_cat_tr_serie serie ON
							fac.id_serie = serie.id_serie
						JOIN ic_cat_tr_vendedor vend ON
							fac.id_vendedor_tit = vend.id_vendedor
						JOIN ic_cat_tr_proveedor prov ON
							det.id_proveedor = prov.id_proveedor
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						',lo_consulta,'
						AND serv.id_producto = 5
						AND serv.estatus = 1
                        AND fac.estatus != 2
                        AND fac.tipo_cfdi = ''I''
						AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
						AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						GROUP BY det.id_factura_detalle ','
						',lo_order);

	-- SELECT @querydetcli;
	PREPARE stmt FROM @querydetcli;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    */

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
