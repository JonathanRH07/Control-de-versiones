DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_cxs_cargos_x_cliente_c`(
	IN 	pr_id_grupo_empresa 			INT,
    -- IN  pr_periodo						ENUM('DIARIO', 'SEMANAL', 'MENSUAL', 'BIMESTRAL', 'TRIMESTRAL', 'SEMESTRAL', 'ANUAL'),
    IN 	pr_id_sucursal					INT,
    IN  pr_id_moneda					INT,
    IN	pr_fecha_ini					DATE,
	IN	pr_fecha_fin					DATE,
    OUT	pr_message						VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_rep_cxs_cargos_x_cliente_c
	@fecha:			2019/08/27
	@descripción : 	Stored procedure para consultar los cargos por servicio desglosados en tipo.
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

	DECLARE lo_sucursal					VARCHAR(500) DEFAULT '';
    DECLARE lo_moneda					VARCHAR(100);
    DECLARE lo_valida					INT;
    DECLARE lo_total					DECIMAL(15,2);
	DECLARE lo_total2					DECIMAL(15,2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_cxs_cargos_x_cliente_c';
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

    DROP TABLE IF EXISTS tmp_ventas;
    DROP TABLE IF EXISTS tmp_ventas_ingreso;
    DROP TABLE IF EXISTS tmp_ventas_egreso;
    DROP TABLE IF EXISTS tmp_cxs;
    DROP TABLE IF EXISTS tmp_cxs_ingreso;
    DROP TABLE IF EXISTS tmp_cxs_egreso;
    DROP TABLE IF EXISTS tmp_x_cliente_1;
    DROP TABLE IF EXISTS tmp_x_cliente_2;

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    /* TOTAL VENTAS */
    SET @queryventas_cxs_ingresos = CONCAT(
							'
							CREATE TEMPORARY TABLE tmp_ventas_ingreso
							SELECT
								id_factura,
								id_cliente,
								cve_cliente,
								nombre,
								IFNULL(SUM(tarifa_facturada), 0.00) tarifa_facturada,
								IFNULL(SUM(no_servicios), 0) no_servicios
							FROM(
								SELECT
									fac.id_factura,
									fac.id_cliente,
									cli.cve_cliente,
									cli.razon_social nombre,
									SUM((IFNULL(tarifa_moneda_base',lo_moneda,', 0.00) + IFNULL(importe_markup',lo_moneda,', 0.00) - IFNULL(descuento',lo_moneda,', 0.00))) tarifa_facturada,
									COUNT(det.id_servicio) no_servicios
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								LEFT JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								JOIN ic_cat_tr_cliente cli ON
									fac.id_cliente = cli.id_cliente
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_sucursal,'
								AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
								AND fac.fecha_factura <= ''',pr_fecha_fin,'''
								AND serv.id_producto != 5
								AND serv.estatus = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''I''
								GROUP BY fac.id_cliente
								ORDER BY cli.cve_cliente) a
                            GROUP BY a.id_cliente');

    -- SELECT @queryventas_cxs_ingresos;
	PREPARE stmt FROM @queryventas_cxs_ingresos;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* TOTAL VENTAS */
    SET @queryventas_cxs_egresos = CONCAT(
							'
							CREATE TEMPORARY TABLE tmp_ventas_egreso
							SELECT
								id_cliente,
								cve_cliente,
								nombre,
								IFNULL(SUM(tarifa_facturada), 0.00) tarifa_facturada,
								IFNULL(SUM(no_servicios), 0) no_servicios
							FROM(
								SELECT
									fac.id_factura,
									fac.id_cliente,
									cli.cve_cliente,
									cli.razon_social nombre,
									SUM((IFNULL(tarifa_moneda_base',lo_moneda,', 0.00) + IFNULL(importe_markup',lo_moneda,', 0.00) - IFNULL(descuento',lo_moneda,', 0.00))) tarifa_facturada,
									COUNT(det.id_servicio) no_servicios
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								JOIN ic_cat_tr_cliente cli ON
									fac.id_cliente = cli.id_cliente
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_sucursal,'
								AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
								AND fac.fecha_factura <= ''',pr_fecha_fin,'''
								AND serv.id_producto != 5
								AND serv.estatus = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''E''
								GROUP BY fac.id_cliente
								ORDER BY cli.cve_cliente) b
							GROUP BY b.id_cliente');

    -- SELECT @queryventas_cxs_egresos;
	PREPARE stmt FROM @queryventas_cxs_egresos;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	CREATE TEMPORARY TABLE tmp_ventas
	SELECT
		ingreso.id_cliente,
		ingreso.cve_cliente,
		ingreso.nombre,
		(IFNULL(SUM(ingreso.tarifa_facturada), 0) - IFNULL(SUM(egreso.tarifa_facturada), 0)) tarifa_facturada,
		(IFNULL(SUM(ingreso.no_servicios), 0) - IFNULL(SUM(egreso.no_servicios), 0)) no_servicios
	FROM tmp_ventas_ingreso ingreso
	LEFT JOIN tmp_ventas_egreso egreso ON
		ingreso.id_cliente = egreso.id_cliente
	GROUP BY ingreso.id_cliente;

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    /* TOTAL DE CXS */
    SET @querycxs_total_ingreso = CONCAT(
							'
							CREATE TEMPORARY TABLE tmp_cxs_ingreso
							SELECT
								id_factura,
								id_cliente,
								cve_cliente,
								nombre,
								IFNULL(SUM(importe_cxs), 0.00) importe_cxs,
								IFNULL(SUM(numero_cxs) ,0) numero_cxs
							FROM(
								SELECT
									fac.id_factura,
									fac.id_cliente,
									cli.cve_cliente,
									cli.razon_social nombre,
									SUM((IFNULL(tarifa_moneda_base',lo_moneda,', 0.00) + IFNULL(importe_markup',lo_moneda,', 0.00) - IFNULL(descuento',lo_moneda,', 0.00))) importe_cxs,
									COUNT(det.id_servicio) numero_cxs
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								JOIN ic_cat_tr_cliente cli ON
									fac.id_cliente = cli.id_cliente
								WHERE fac.id_grupo_empresa =  ',pr_id_grupo_empresa,'
								',lo_sucursal,'
								AND serv.id_producto = 5
								AND serv.estatus = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''I''
								AND fac.fecha_factura >= ''',pr_fecha_ini,'''
								AND fac.fecha_factura <= ''',pr_fecha_fin,'''
								GROUP BY fac.id_cliente
								ORDER BY cli.cve_cliente) a
							GROUP BY a.id_cliente');

	-- SELECT @querycxs_total_ingreso;
	PREPARE stmt FROM @querycxs_total_ingreso;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* TOTAL DE CXS */
    SET @querycxs_total_egreso = CONCAT(
							'
							CREATE TEMPORARY TABLE tmp_cxs_egreso
							SELECT
								id_factura,
								id_cliente,
								cve_cliente,
								nombre,
								IFNULL(SUM(importe_cxs), 0.00) importe_cxs,
								IFNULL(SUM(numero_cxs) ,0) numero_cxs
							FROM(
								SELECT
									fac.id_factura,
									fac.id_cliente,
									cli.cve_cliente,
									cli.razon_social nombre,
									SUM((IFNULL(tarifa_moneda_base',lo_moneda,', 0.00) + IFNULL(importe_markup',lo_moneda,', 0.00) - IFNULL(descuento',lo_moneda,', 0.00))) importe_cxs,
									COUNT(det.id_servicio) numero_cxs
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								JOIN ic_cat_tr_cliente cli ON
									fac.id_cliente = cli.id_cliente
								WHERE fac.id_grupo_empresa =  ',pr_id_grupo_empresa,'
								',lo_sucursal,'
								AND serv.id_producto = 5
								AND serv.estatus = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''E''
								AND fac.fecha_factura >=   ''',pr_fecha_ini,'''
								AND fac.fecha_factura <=  ''',pr_fecha_fin,'''
								GROUP BY fac.id_cliente
								ORDER BY cli.cve_cliente) b
							GROUP BY b.id_cliente');

	-- SELECT @querycxs_total_egreso;
	PREPARE stmt FROM @querycxs_total_egreso;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_cxs
	SELECT
		ingreso.id_cliente,
        ingreso.cve_cliente,
        ingreso.nombre,
		(IFNULL(ingreso.importe_cxs, 0) - IFNULL(egreso.importe_cxs, 0)) importe_cxs,
		(IFNULL(ingreso.numero_cxs, 0) - IFNULL(egreso.numero_cxs, 0)) numero_cxs
	FROM tmp_cxs_ingreso ingreso
	LEFT JOIN tmp_cxs_egreso egreso ON
		ingreso.id_cliente = egreso.id_cliente
	GROUP BY ingreso.id_cliente;

	/* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

   /*
    SELECT
		vent.id_cliente,
		vent.cve_cliente,
		vent.nombre,
		IFNULL(vent.tarifa_facturada, 0) tarifa_facturada,
		IFNULL(vent.no_servicios, 0) no_servicios,
		IFNULL(vent.promedio_servicios, 0) promedio_servicios,
		IFNULL(cxs.importe_cxs, 0) importe_cxs,
		IFNULL(cxs.numero_cxs, 0) numero_cxs,
		IFNULL(cxs.promedio_cxs, 0) promedio_cxs,
		IFNULL(((promedio_cxs*100) / promedio_servicios), 0) porcentaje_cxs_venta
	FROM tmp_ventas vent
	LEFT JOIN tmp_cxs cxs ON
		vent.id_cliente = cxs.id_cliente
	GROUP BY vent.id_factura
    ORDER BY importe_cxs DESC;
    */

    CREATE TEMPORARY TABLE tmp_x_cliente_1
	SELECT
		IFNULL(vent.id_cliente, cxs.id_cliente) id_cliente,
		IFNULL(vent.cve_cliente, cxs.cve_cliente) cve_cliente,
		IFNULL(vent.nombre, cxs.nombre) nombre,
		IFNULL(vent.tarifa_facturada, 0.00) tarifa_facturada,
		IFNULL(vent.no_servicios, 0) no_servicios,
		(IFNULL(vent.tarifa_facturada, 0.00) / IFNULL(vent.no_servicios, 0)) promedio_servicios,
		IFNULL(cxs.importe_cxs, 0.00) importe_cxs,
		IFNULL(cxs.numero_cxs, 0) numero_cxs,
		IFNULL(IFNULL(cxs.importe_cxs, 0) / IFNULL(cxs.numero_cxs, 0), 0.00) promedio_cxs
	FROM tmp_ventas vent
	LEFT JOIN tmp_cxs cxs ON
		vent.id_cliente = cxs.id_cliente
	ORDER BY importe_cxs DESC;

    CREATE TEMPORARY TABLE tmp_x_cliente_2
	SELECT
		IFNULL(vent.id_cliente, cxs.id_cliente) id_cliente,
		IFNULL(vent.cve_cliente, cxs.cve_cliente) cve_cliente,
		IFNULL(vent.nombre, cxs.nombre) nombre,
		SUM(vent.tarifa_facturada) tarifa_facturada,
		SUM(vent.no_servicios) no_servicios,
		(SUM(vent.tarifa_facturada) / SUM(vent.no_servicios)) promedio_servicios,
		SUM(cxs.importe_cxs)importe_cxs,
		SUM(cxs.numero_cxs) numero_cxs,
		(SUM(cxs.importe_cxs) / SUM(cxs.numero_cxs)) promedio_cxs
	FROM tmp_ventas vent
	RIGHT JOIN tmp_cxs cxs ON
		vent.id_cliente = cxs.id_cliente
	WHERE vent.id_cliente IS NULL
	ORDER BY importe_cxs DESC;

    SELECT
		COUNT(*)
	INTO
		lo_valida
    FROM tmp_x_cliente_2
    WHERE id_cliente IS NOT NULL;

    SELECT
		(SUM(tarifa_facturada) + SUM(importe_cxs))
	INTO
		lo_total
    FROM tmp_x_cliente_1;

    SELECT
		(SUM(tarifa_facturada) + SUM(importe_cxs))
	INTO
		lo_total2
    FROM tmp_x_cliente_2;

    IF lo_valida = 0 THEN
		SELECT
			id_cliente,
			cve_cliente,
			nombre,
			IFNULL(tarifa_facturada, 0.00) tarifa_facturada,
			IFNULL(no_servicios, 0) no_servicios,
			IFNULL(promedio_servicios, 0.00) promedio_servicios,
			IFNULL(importe_cxs, 0.00) importe_cxs,
			IFNULL(numero_cxs, 0) numero_cxs,
			IFNULL(promedio_cxs, 0.00) promedio_cxs,
			IFNULL((importe_cxs/lo_total)*100, 0) porcentaje_cxs_venta
		FROM tmp_x_cliente_1;
	ELSE
		SELECT
			id_cliente,
			cve_cliente,
			nombre,
			IFNULL(tarifa_facturada, 0.00) tarifa_facturada,
			IFNULL(no_servicios, 0) no_servicios,
			IFNULL(promedio_servicios, 0.00) promedio_servicios,
			IFNULL(importe_cxs, 0.00) importe_cxs,
			IFNULL(numero_cxs, 0) numero_cxs,
			IFNULL(promedio_cxs, 0.00) promedio_cxs,
			IFNULL((importe_cxs/lo_total)*100, 0) porcentaje_cxs_venta
		FROM tmp_x_cliente_1
		UNION
		SELECT
			id_cliente,
			cve_cliente,
			nombre,
			IFNULL(tarifa_facturada, 0.00) tarifa_facturada,
			IFNULL(no_servicios, 0) no_servicios,
			IFNULL(promedio_servicios, 0.00) promedio_servicios,
			IFNULL(importe_cxs, 0.00) importe_cxs,
			IFNULL(numero_cxs, 0) numero_cxs,
			IFNULL(promedio_cxs, 0.00) promedio_cxs,
			IFNULL((importe_cxs/lo_total)*100, 0) porcentaje_cxs_venta
		FROM tmp_x_cliente_2;
    END IF;

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
