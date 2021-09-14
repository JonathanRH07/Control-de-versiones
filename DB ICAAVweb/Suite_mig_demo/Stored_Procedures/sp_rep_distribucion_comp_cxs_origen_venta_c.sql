DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_distribucion_comp_cxs_origen_venta_c`(
	IN 	pr_id_grupo_empresa 				INT,
    IN 	pr_id_sucursal						INT,
    IN  pr_id_moneda_reporte				INT,
    IN	pr_fecha_ini						DATE,
	IN	pr_fecha_fin						DATE,
	IN  pr_ini_pag							INT,
	IN  pr_fin_pag							INT,
    OUT	pr_message							VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_rep_distribucion_comp_cxs_origen_venta_c
	@fecha:			2020/01/21
	@descripción : 	Sp para poblar el modal del reporte de distribucion de ventas --> ORIGEN DE VENTAS comparativa (cxs vs ventas)
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

	DECLARE lo_sucursal						TEXT DEFAULT '';
    DECLARE lo_moneda						TEXT;
    DECLARE lo_moneda2						TEXT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_distribucion_comp_cxs_origen_venta_c';
	END ;

	/* -------------------------------------------------------------------- */

	DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_vent_ingreso;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_vent_egreso;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_vent_1;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_vent_2;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_ventas;
	DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_cxs_ingreso;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_cxs_egreso;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_cxs_1;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_cxs_2;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_cxs;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_total_1;
    DROP TABLE IF EXISTS tmp_distribucion_origen_ventas_total_2;

    /* -------------------------------------------------------------------- */

    /* VALIDAMOS SI SE CONSULTA UNA SUCURSAL EN ESPECIFICO */
    IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

	/* -------------------------------------------------------------------- */

    /* VALIDAMOS EL TIPO DE MONEDA QUE SE OBTIENE EL REPORTE */
    IF pr_id_moneda_reporte = 149 THEN -- DOLARES
		SET lo_moneda = '/tipo_cambio_usd';
        SET lo_moneda2 = 'acumulado_usd';
	ELSEIF pr_id_moneda_reporte = 49 THEN -- EUROS
		SET lo_moneda = '/tipo_cambio_eur';
        SET lo_moneda2 = 'acumulado_eur';
	ELSE -- MONEDA NACIONAL
		SET lo_moneda = '';
        SET lo_moneda2 = 'acumulado_moneda_base';
    END IF;

    /* -------------------------------------------------------------------- */

    #VENTAS
    SET @query_ingreso = CONCAT('
						CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_vent_ingreso
						SELECT
							origen.id_origen_venta,
							origen.cve clave_origen,
							origen.descripcion nombre_origen,
							SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')) ingreso_mes,
							IFNULL(acu_origen.',lo_moneda2,', 0) acumulado
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tr_origen_venta origen ON
							fac.id_origen = origen.id_origen_venta
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						LEFT JOIN ic_rep_tr_acumulado_origen_venta acu_origen ON
							origen.cve = acu_origen.cve_origen
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
                        AND serv.id_producto != 5
						AND serv.estatus = 1
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                        AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						AND fac.tipo_cfdi = ''I''
						GROUP BY origen.id_origen_venta');


    -- SELECT @query_ingreso;
	PREPARE stmt FROM @query_ingreso;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	SET @query_egreso = CONCAT('
						CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_vent_egreso
                        SELECT
							origen.id_origen_venta,
							origen.cve clave_origen,
							origen.descripcion nombre_origen,
							SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')) egreso_mes
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tr_origen_venta origen ON
							fac.id_origen = origen.id_origen_venta
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND serv.id_producto != 5
						AND serv.estatus = 1
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                        AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						AND fac.tipo_cfdi = ''E''
						GROUP BY origen.id_origen_venta');

	-- SELECT @query_egreso;
	PREPARE stmt FROM @query_egreso;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_vent_1
    SELECT
		ingreso.id_origen_venta,
		ingreso.clave_origen,
		ingreso.nombre_origen,
		IFNULL((IFNULL(ingreso.ingreso_mes, 0) - IFNULL(egreso_mes, 0)), 0)  neto_mes,
        IFNULL(ingreso.acumulado, 0) acumulado
	FROM tmp_distribucion_origen_ventas_vent_ingreso ingreso
	LEFT JOIN tmp_distribucion_origen_ventas_vent_egreso egreso ON
		ingreso.id_origen_venta = egreso.id_origen_venta;

	CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_vent_2
	SELECT
		IFNULL(ingreso.id_origen_venta, egreso.id_origen_venta) id_origen_venta,
		IFNULL(ingreso.clave_origen, egreso.clave_origen) clave_origen,
		IFNULL(ingreso.nombre_origen, egreso.nombre_origen) nombre_origen,
		IFNULL((IFNULL(ingreso.ingreso_mes, 0) - IFNULL(egreso_mes, 0)), 0)  neto_mes,
        IFNULL(ingreso.acumulado, 0) acumulado
	FROM tmp_distribucion_origen_ventas_vent_ingreso ingreso
	RIGHT JOIN tmp_distribucion_origen_ventas_vent_egreso egreso ON
		ingreso.id_origen_venta = egreso.id_origen_venta
	WHERE ingreso.id_origen_venta IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_distribucion_origen_ventas_vent_2;

    IF @lo_contador = 0 THEN
		CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_ventas
        SELECT *
		FROM tmp_distribucion_origen_ventas_vent_1;
	ELSE
		CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_ventas
		SELECT *
		FROM tmp_distribucion_origen_ventas_vent_1
        UNION
		SELECT *
		FROM tmp_distribucion_origen_ventas_vent_2;
    END IF;

	/* -------------------------------------------------------------------- */

    #CXS
    SET @query_ingreso_cxs = CONCAT('
						CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_cxs_ingreso
						SELECT
							origen.id_origen_venta,
							origen.cve clave_origen,
							origen.descripcion nombre_origen,
							SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')) ingreso_cxs_mes
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tr_origen_venta origen ON
							fac.id_origen = origen.id_origen_venta
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
                        AND serv.id_producto = 5
						AND serv.estatus = 1
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                        AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						AND fac.tipo_cfdi = ''I''
						GROUP BY origen.id_origen_venta');


    -- SELECT @query_ingreso_cxs;
	PREPARE stmt FROM @query_ingreso_cxs;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	SET @query_egreso_cxs = CONCAT('
						CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_cxs_egreso
                        SELECT
							origen.id_origen_venta,
							origen.cve clave_origen,
							origen.descripcion nombre_origen,
							SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')) egreso_cxs_mes
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tr_origen_venta origen ON
							fac.id_origen = origen.id_origen_venta
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND serv.id_producto = 5
						AND serv.estatus = 1
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                        AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						AND fac.tipo_cfdi = ''E''
						GROUP BY origen.id_origen_venta');

	-- SELECT @query_egreso_cxs;
	PREPARE stmt FROM @query_egreso_cxs;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_cxs_1
    SELECT
		ingreso.id_origen_venta,
        IFNULL(ingreso.clave_origen, egreso.clave_origen) clave_origen,
		IFNULL(ingreso.nombre_origen, egreso.nombre_origen) nombre_origen,
		IFNULL((IFNULL(ingreso.ingreso_cxs_mes, 0) - IFNULL(egreso_cxs_mes, 0)), 0)  neto_cxs_mes
	FROM tmp_distribucion_origen_ventas_cxs_ingreso ingreso
	LEFT JOIN tmp_distribucion_origen_ventas_cxs_egreso egreso ON
		ingreso.id_origen_venta = egreso.id_origen_venta;

	CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_cxs_2
	SELECT
		IFNULL(ingreso.id_origen_venta, egreso.id_origen_venta) id_origen_venta,
        IFNULL(ingreso.clave_origen, egreso.clave_origen) clave_origen,
		IFNULL(ingreso.nombre_origen, egreso.nombre_origen) nombre_origen,
		IFNULL((IFNULL(ingreso.ingreso_cxs_mes, 0) - IFNULL(egreso_cxs_mes, 0)), 0)  neto_cxs_mes
	FROM tmp_distribucion_origen_ventas_cxs_ingreso ingreso
	RIGHT JOIN tmp_distribucion_origen_ventas_cxs_egreso egreso ON
		ingreso.id_origen_venta = egreso.id_origen_venta
	WHERE ingreso.id_origen_venta IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_distribucion_origen_ventas_cxs_2;

    IF @lo_contador = 0 THEN
		CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_cxs
        SELECT *
		FROM tmp_distribucion_origen_ventas_cxs_1;
	ELSE
		CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_cxs
		SELECT *
		FROM tmp_distribucion_origen_ventas_cxs_1
        UNION
		SELECT *
		FROM tmp_distribucion_origen_ventas_cxs_2;
    END IF;

    /* -------------------------------------------------------------------- */

    CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_total_1
    SELECT
		ventas.id_origen_venta,
		ventas.clave_origen,
		ventas.nombre_origen,
		IFNULL(ventas.neto_mes, 0) neto_ventas_mes,
		IFNULL(cxs.neto_cxs_mes, 0) neto_cxs_mes,
		IFNULL((IFNULL(ventas.neto_mes, 0) + IFNULL(cxs.neto_cxs_mes, 0)), 0) totol_ingreso,
		IFNULL(ventas.acumulado, 0) acumulado
	FROM tmp_distribucion_origen_ventas_ventas ventas
	LEFT JOIN tmp_distribucion_origen_ventas_cxs cxs ON
		ventas.id_origen_venta = cxs.id_origen_venta;

    CREATE TEMPORARY TABLE tmp_distribucion_origen_ventas_total_2
	SELECT
		IFNULL(ventas.id_origen_venta, cxs.id_origen_venta) id_origen_venta,
		IFNULL(ventas.clave_origen, cxs.clave_origen) clave_origen,
		IFNULL(ventas.nombre_origen, cxs.nombre_origen) nombre_origen,
		IFNULL(ventas.neto_mes, 0) neto_ventas_mes,
		IFNULL(cxs.neto_cxs_mes, 0) neto_cxs_mes,
		IFNULL((IFNULL(ventas.neto_mes, 0) + IFNULL(cxs.neto_cxs_mes, 0)), 0) totol_ingreso,
		IFNULL(ventas.acumulado, 0) acumulado
	FROM tmp_distribucion_origen_ventas_ventas ventas
	RIGHT JOIN tmp_distribucion_origen_ventas_cxs cxs ON
		ventas.id_origen_venta = cxs.id_origen_venta
	WHERE ventas.id_origen_venta IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_distribucion_origen_ventas_total_2;

    IF @lo_contador = 0 THEN
        SELECT *
		FROM tmp_distribucion_origen_ventas_total_1
        ORDER BY totol_ingreso DESC
        LIMIT pr_ini_pag, pr_fin_pag;
	ELSE
		SELECT *
		FROM tmp_distribucion_origen_ventas_total_1
        UNION
		SELECT *
		FROM tmp_distribucion_origen_ventas_total_2
        ORDER BY totol_ingreso DESC
        LIMIT pr_ini_pag, pr_fin_pag;
    END IF;

    /* -------------------------------------------------------------------- */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
