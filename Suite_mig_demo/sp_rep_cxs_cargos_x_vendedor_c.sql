DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_cxs_cargos_x_vendedor_c`(
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
    @nombre:		sp_rep_cxs_cargos_x_vendedor_c
	@fecha:			2019/08/27
	@descripción : 	Stored procedure para consultar los cargos por servicio desglosados en tipo.
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

	DECLARE lo_sucursal					VARCHAR(500) DEFAULT '';
    DECLARE lo_moneda					VARCHAR(100);
    DECLARE lo_valida					INT;
    DECLARE lo_totalvend				DECIMAL(15,2);
    DECLARE lo_totalvend2				DECIMAL(15,2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_cxs_cargos_x_vendedor_c';
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
    DROP TABLE IF EXISTS tmp_ventas_vend_ingreso;
    DROP TABLE IF EXISTS tmp_ventas_vend_egreso;
    DROP TABLE IF EXISTS tmp_cxs;
    DROP TABLE IF EXISTS tmp_cxs_ingreso;
    DROP TABLE IF EXISTS tmp_cxs_egreso;
    DROP TABLE IF EXISTS tmp_tota_x_vendedor1;
    DROP TABLE IF EXISTS tmp_tota_x_vendedor2;

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    /* TOTAL VENTAS */
    SET @queryventas_cxs_ing = CONCAT(
							'
							CREATE TEMPORARY TABLE tmp_ventas_vend_ingreso
							SELECT
								id_vendedor_tit,
								cve_vendedor,
								nombre,
								SUM(tarifa_facturada) tarifa_facturada,
								SUM(no_servicios) no_servicios
							FROM(
								SELECT
									fac.id_factura,
									fac.id_vendedor_tit,
									vend.clave cve_vendedor,
									vend.nombre nombre,
									SUM((IFNULL(tarifa_moneda_base',lo_moneda,', 0.00) + IFNULL(importe_markup',lo_moneda,', 0.00) - IFNULL(descuento',lo_moneda,', 0.00))) tarifa_facturada,
									COUNT(det.id_servicio) no_servicios
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								LEFT JOIN ic_cat_tr_vendedor vend ON
									fac.id_vendedor_tit = vend.id_vendedor
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_sucursal,'
								AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
								AND fac.fecha_factura <= ''',pr_fecha_fin,'''
								AND serv.id_producto != 5
								AND serv.estatus = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''I''
								GROUP BY fac.id_factura
								ORDER BY vend.clave) a
							GROUP BY a.id_vendedor_tit');

    -- SELECT @queryventas_cxs_ing;
	PREPARE stmt FROM @queryventas_cxs_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* TOTAL VENTAS */
    SET @queryventas_cxs_egr = CONCAT(
							'
							CREATE TEMPORARY TABLE tmp_ventas_vend_egreso
							SELECT
								id_vendedor_tit,
								cve_vendedor,
								nombre,
								SUM(tarifa_facturada) tarifa_facturada,
								SUM(no_servicios) no_servicios
							FROM(
								SELECT
									fac.id_factura,
									fac.id_vendedor_tit,
									vend.clave cve_vendedor,
									vend.nombre nombre,
									SUM((IFNULL(tarifa_moneda_base',lo_moneda,', 0.00) + IFNULL(importe_markup',lo_moneda,', 0.00) - IFNULL(descuento',lo_moneda,', 0.00))) tarifa_facturada,
									COUNT(det.id_servicio) no_servicios
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								LEFT JOIN ic_cat_tr_vendedor vend ON
									fac.id_vendedor_tit = vend.id_vendedor
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_sucursal,'
								AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
								AND fac.fecha_factura <= ''',pr_fecha_fin,'''
								AND serv.id_producto != 5
								AND serv.estatus = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''E''
								GROUP BY fac.id_factura
								ORDER BY vend.clave) b
							GROUP BY b.id_vendedor_tit
							');

	-- SELECT @queryventas_cxs_egr;
	PREPARE stmt FROM @queryventas_cxs_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_ventas
	SELECT
		ingreso.id_vendedor_tit,
		ingreso.cve_vendedor,
		ingreso.nombre,
		(IFNULL(SUM(ingreso.tarifa_facturada), 0) - IFNULL(SUM(egreso.tarifa_facturada), 0)) tarifa_facturada,
		(IFNULL(SUM(ingreso.no_servicios), 0) - IFNULL(SUM(egreso.no_servicios), 0)) no_servicios
	FROM tmp_ventas_vend_ingreso ingreso
	LEFT JOIN tmp_ventas_vend_egreso egreso ON
		ingreso.id_vendedor_tit = egreso.id_vendedor_tit
	GROUP BY ingreso.id_vendedor_tit;

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    /* TOTAL DE CXS */
    SET @querycxs_total_ing = CONCAT(
							'
							CREATE TEMPORARY TABLE tmp_cxs_ingreso
                            SELECT
								id_factura,
								id_vendedor_tit,
								cve_vendedor,
								nombre,
								SUM(importe_cxs) importe_cxs,
								SUM(numero_cxs) numero_cxs
							FROM(
								SELECT
									fac.id_factura,
									fac.id_vendedor_tit,
									vend.clave cve_vendedor,
									vend.nombre nombre,
									SUM((IFNULL(tarifa_moneda_base',lo_moneda,', 0.00) + IFNULL(importe_markup',lo_moneda,', 0.00) - IFNULL(descuento',lo_moneda,', 0.00))) importe_cxs,
									COUNT(det.id_servicio) numero_cxs
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								JOIN ic_cat_tr_vendedor vend ON
									fac.id_vendedor_tit = vend.id_vendedor
								WHERE fac.id_grupo_empresa =  ',pr_id_grupo_empresa,'
								',lo_sucursal,'
								AND serv.id_producto = 5
								AND serv.estatus = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''I''
								AND fac.fecha_factura >=   ''',pr_fecha_ini,'''
								AND fac.fecha_factura <=  ''',pr_fecha_fin,'''
								GROUP BY fac.id_factura
								ORDER BY vend.clave) a
							GROUP BY a.id_vendedor_tit');

	-- SELECT @querycxs_total_ing;
	PREPARE stmt FROM @querycxs_total_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @querycxs_total_egr = CONCAT(
							'
							CREATE TEMPORARY TABLE tmp_cxs_egreso
							SELECT
								id_factura,
								id_vendedor_tit,
								cve_vendedor,
								nombre,
								SUM(importe_cxs) importe_cxs,
								SUM(numero_cxs) numero_cxs
							FROM(
								SELECT
									fac.id_factura,
									fac.id_vendedor_tit,
									vend.clave cve_vendedor,
									vend.nombre nombre,
									SUM((IFNULL(tarifa_moneda_base',lo_moneda,', 0.00) + IFNULL(importe_markup',lo_moneda,', 0.00) - IFNULL(descuento',lo_moneda,', 0.00))) importe_cxs,
									COUNT(det.id_servicio) numero_cxs
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								JOIN ic_cat_tr_vendedor vend ON
									fac.id_vendedor_tit = vend.id_vendedor
								WHERE fac.id_grupo_empresa =  ',pr_id_grupo_empresa,'
								',lo_sucursal,'
								AND serv.id_producto = 5
								AND serv.estatus = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''E''
								AND fac.fecha_factura >=   ''',pr_fecha_ini,'''
								AND fac.fecha_factura <=  ''',pr_fecha_fin,'''
								GROUP BY fac.id_factura
								ORDER BY vend.clave) b
							GROUP BY b.id_vendedor_tit');

	-- SELECT @querycxs_total_egr;
	PREPARE stmt FROM @querycxs_total_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_cxs
	SELECT
		ingreso.id_vendedor_tit,
		ingreso.cve_vendedor,
		ingreso.nombre,
		(IFNULL(ingreso.importe_cxs, 0) - IFNULL(egreso.importe_cxs, 0)) importe_cxs,
		(IFNULL(ingreso.numero_cxs, 0) - IFNULL(egreso.numero_cxs, 0)) numero_cxs
	FROM tmp_cxs_ingreso ingreso
	LEFT JOIN tmp_cxs_egreso egreso ON
		ingreso.id_vendedor_tit = egreso.id_vendedor_tit;

	/* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    CREATE TEMPORARY TABLE tmp_tota_x_vendedor1
    SELECT
		IFNULL(vent.id_vendedor_tit, cxs.id_vendedor_tit) id_vendedor_tit,
		IFNULL(vent.cve_vendedor, cxs.cve_vendedor) cve_vendedor,
		IFNULL(vent.nombre, cxs.nombre) nombre,
		IFNULL(vent.tarifa_facturada, 0.00) tarifa_facturada,
		IFNULL(vent.no_servicios, 0) no_servicios,
		IFNULL((IFNULL(vent.tarifa_facturada, 0.00) / IFNULL(vent.no_servicios, 0) ) , 0.00) promedio_servicios,
		IFNULL(cxs.importe_cxs, 0.00) importe_cxs,
		IFNULL(cxs.numero_cxs, 0) numero_cxs,
		IFNULL((IFNULL(cxs.importe_cxs, 0.00)  / IFNULL(cxs.numero_cxs, 0)), 0.00) promedio_cxs
	FROM tmp_ventas vent
	LEFT JOIN tmp_cxs cxs ON
		vent.id_vendedor_tit = cxs.id_vendedor_tit
    ORDER BY importe_cxs DESC;

	CREATE TEMPORARY TABLE tmp_tota_x_vendedor2
    SELECT
		IFNULL(vent.id_vendedor_tit, cxs.id_vendedor_tit) id_vendedor_tit,
		IFNULL(vent.cve_vendedor, cxs.cve_vendedor) cve_vendedor,
		IFNULL(vent.nombre, cxs.nombre) nombre,
		vent.tarifa_facturada tarifa_facturada,
		vent.no_servicios no_servicios,
		(IFNULL(vent.tarifa_facturada, 0.00) / IFNULL(vent.no_servicios, 0) ) promedio_servicios,
		cxs.importe_cxs importe_cxs,
		cxs.numero_cxs numero_cxs,
		(IFNULL(cxs.importe_cxs, 0.00)  / IFNULL(cxs.numero_cxs, 0)) promedio_cxs
	FROM tmp_ventas vent
	RIGHT JOIN tmp_cxs cxs ON
		vent.id_vendedor_tit = cxs.id_vendedor_tit
	WHERE vent.id_vendedor_tit IS NULL
	ORDER BY importe_cxs DESC;

    SELECT
		COUNT(*)
	INTO
		lo_valida
    FROM tmp_tota_x_vendedor2
    WHERE id_vendedor_tit IS NOT NULL;

    SELECT
		(SUM(tarifa_facturada) + SUM(importe_cxs))
	INTO
		lo_totalvend
    FROM tmp_tota_x_vendedor1;

    SELECT
		(SUM(tarifa_facturada) + SUM(importe_cxs))
	INTO
		lo_totalvend2
    FROM tmp_tota_x_vendedor2;

    IF lo_valida = 0 THEN
		SELECT
			id_vendedor_tit,
			cve_vendedor,
			nombre,
			IFNULL(tarifa_facturada, 0.00) tarifa_facturada,
			IFNULL(no_servicios, 0) no_servicios,
			IFNULL(promedio_servicios, 0.00) promedio_servicios,
			IFNULL(importe_cxs, 0.00) importe_cxs,
			IFNULL(numero_cxs, 0) numero_cxs,
			IFNULL(promedio_cxs, 0.00) promedio_cxs,
			IFNULL((importe_cxs/lo_totalvend)*100, 0) porcentaje_cxs_venta
		FROM tmp_tota_x_vendedor1;
	ELSE
		SELECT
			id_vendedor_tit,
			cve_vendedor,
			nombre,
			IFNULL(tarifa_facturada, 0.00) tarifa_facturada,
			IFNULL(no_servicios, 0) no_servicios,
			IFNULL(promedio_servicios, 0.00) promedio_servicios,
			IFNULL(importe_cxs, 0.00) importe_cxs,
			IFNULL(numero_cxs, 0) numero_cxs,
			IFNULL(promedio_cxs, 0.00) promedio_cxs,
			IFNULL((importe_cxs/lo_totalvend)*100, 0) porcentaje_cxs_venta
		FROM tmp_tota_x_vendedor1
		UNION
		SELECT
			id_vendedor_tit,
			cve_vendedor,
			nombre,
			IFNULL(tarifa_facturada, 0.00) tarifa_facturada,
			IFNULL(no_servicios, 0) no_servicios,
			IFNULL(promedio_servicios, 0.00) promedio_servicios,
			IFNULL(importe_cxs, 0.00) importe_cxs,
			IFNULL(numero_cxs, 0) numero_cxs,
			IFNULL(promedio_cxs, 0.00) promedio_cxs,
			IFNULL((importe_cxs/lo_totalvend2)*100, 0) porcentaje_cxs_venta
		FROM tmp_tota_x_vendedor2;
    END IF;

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
