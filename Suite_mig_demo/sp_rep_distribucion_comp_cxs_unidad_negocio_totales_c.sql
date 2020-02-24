DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_distribucion_comp_cxs_unidad_negocio_totales_c`(
	IN 	pr_id_grupo_empresa 				INT,
    IN 	pr_id_sucursal						INT,
    IN  pr_id_moneda_reporte				INT,
    IN	pr_fecha_ini						DATE,
	IN	pr_fecha_fin						DATE,
    OUT	pr_message							VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_rep_distribucion_comp_cxs_unidad_negocio_totales_c
	@fecha:			2020/02/07
	@descripción : 	Sp para poblar el modal de totales del reporte de distribucion de ventas --> UNIDAD DE NEGOCIO comparativa (cxs vs ventas)
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

	DECLARE lo_sucursal						TEXT DEFAULT '';
    DECLARE lo_moneda						TEXT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_distribucion_comp_cxs_unidad_negocio_totales_c';
	END ;

	/* -------------------------------------------------------------------- */

	DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_vent_ingreso_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_vent_egreso_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_vent_1_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_vent_2_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_ventas_tot;
	DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_cxs_ingreso_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_cxs_egreso_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_cxs_1_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_cxs_2_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_cxs_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_total_1_tot;
    DROP TABLE IF EXISTS tmp_distribucion_unidad_negocio_total_2_tot;

    /* -------------------------------------------------------------------- */

    /* VALIDAMOS SI SE CONSULTA UNA SUCURSAL EN ESPECIFICO */
    IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

	/* -------------------------------------------------------------------- */

    /* VALIDAMOS EL TIPO DE MONEDA QUE SE OBTIENE EL REPORTE */
    IF pr_id_moneda_reporte = 149 THEN -- DOLARES
		SET lo_moneda = '/tipo_cambio_usd';
	ELSEIF pr_id_moneda_reporte = 49 THEN -- EUROS
		SET lo_moneda = '/tipo_cambio_eur';
	ELSE -- MONEDA NACIONAL
		SET lo_moneda = '';
    END IF;

    /* -------------------------------------------------------------------- */

    #VENTAS
    SET @query_ingreso = CONCAT('
						CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_vent_ingreso_tot
						SELECT
							unidad.id_unidad_negocio,
							SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')) ingreso_mes
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tc_unidad_negocio unidad ON
							fac.id_unidad_negocio = unidad.id_unidad_negocio
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
                        AND serv.id_producto != 5
						AND serv.estatus = 1
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                        AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						AND fac.tipo_cfdi = ''I''
						GROUP BY unidad.id_unidad_negocio');


    -- SELECT @query_ingreso;
	PREPARE stmt FROM @query_ingreso;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	SET @query_egreso = CONCAT('
						CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_vent_egreso_tot
                        SELECT
							unidad.id_unidad_negocio,
							SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')) egreso_mes
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tc_unidad_negocio unidad ON
							fac.id_unidad_negocio = unidad.id_unidad_negocio
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND serv.id_producto != 5
						AND serv.estatus = 1
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                        AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						AND fac.tipo_cfdi = ''E''
						GROUP BY unidad.id_unidad_negocio');

	-- SELECT @query_egreso;
	PREPARE stmt FROM @query_egreso;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_vent_1_tot
    SELECT
		ingreso.id_unidad_negocio,
		IFNULL((IFNULL(ingreso.ingreso_mes, 0) - IFNULL(egreso_mes, 0)), 0)  neto_mes
	FROM tmp_distribucion_unidad_negocio_vent_ingreso_tot ingreso
	LEFT JOIN tmp_distribucion_unidad_negocio_vent_egreso_tot egreso ON
		ingreso.id_unidad_negocio = egreso.id_unidad_negocio;

	CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_vent_2_tot
	SELECT
		IFNULL(ingreso.id_unidad_negocio, egreso.id_unidad_negocio) id_unidad_negocio,
		IFNULL((IFNULL(ingreso.ingreso_mes, 0) - IFNULL(egreso_mes, 0)), 0)  neto_mes
	FROM tmp_distribucion_unidad_negocio_vent_ingreso_tot ingreso
	RIGHT JOIN tmp_distribucion_unidad_negocio_vent_egreso_tot egreso ON
		ingreso.id_unidad_negocio = egreso.id_unidad_negocio
	WHERE ingreso.id_unidad_negocio IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_distribucion_unidad_negocio_vent_2_tot;

    IF @lo_contador = 0 THEN
		CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_ventas_tot
        SELECT *
		FROM tmp_distribucion_unidad_negocio_vent_1_tot;
	ELSE
		CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_ventas_tot
		SELECT *
		FROM tmp_distribucion_unidad_negocio_vent_1_tot
        UNION
		SELECT *
		FROM tmp_distribucion_unidad_negocio_vent_2_tot;
    END IF;

	/* -------------------------------------------------------------------- */

    #CXS
    SET @query_ingreso_cxs = CONCAT('
						CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_cxs_ingreso_tot
						SELECT
							unidad.id_unidad_negocio,
							SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')) ingreso_cxs_mes
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tc_unidad_negocio unidad ON
							fac.id_unidad_negocio = unidad.id_unidad_negocio
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
                        AND serv.id_producto = 5
						AND serv.estatus = 1
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                        AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						AND fac.tipo_cfdi = ''I''
						GROUP BY unidad.id_unidad_negocio');


    -- SELECT @query_ingreso_cxs;
	PREPARE stmt FROM @query_ingreso_cxs;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	SET @query_egreso_cxs = CONCAT('
						CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_cxs_egreso_tot
                        SELECT
							unidad.id_unidad_negocio,
							SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')) egreso_cxs_mes
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tc_unidad_negocio unidad ON
							fac.id_unidad_negocio = unidad.id_unidad_negocio
						JOIN ic_cat_tc_servicio serv ON
							det.id_servicio = serv.id_servicio
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND serv.id_producto = 5
						AND serv.estatus = 1
						AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                        AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						AND fac.tipo_cfdi = ''E''
						GROUP BY unidad.id_unidad_negocio');

	-- SELECT @query_egreso_cxs;
	PREPARE stmt FROM @query_egreso_cxs;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_cxs_1_tot
    SELECT
		ingreso.id_unidad_negocio,
		IFNULL((IFNULL(ingreso.ingreso_cxs_mes, 0) - IFNULL(egreso_cxs_mes, 0)), 0)  neto_cxs_mes
	FROM tmp_distribucion_unidad_negocio_cxs_ingreso_tot ingreso
	LEFT JOIN tmp_distribucion_unidad_negocio_cxs_egreso_tot egreso ON
		ingreso.id_unidad_negocio = egreso.id_unidad_negocio;

	CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_cxs_2_tot
	SELECT
		IFNULL(ingreso.id_unidad_negocio, egreso.id_unidad_negocio) id_unidad_negocio,
		IFNULL((IFNULL(ingreso.ingreso_cxs_mes, 0) - IFNULL(egreso_cxs_mes, 0)), 0)  neto_cxs_mes
	FROM tmp_distribucion_unidad_negocio_cxs_ingreso_tot ingreso
	RIGHT JOIN tmp_distribucion_unidad_negocio_cxs_egreso_tot egreso ON
		ingreso.id_unidad_negocio = egreso.id_unidad_negocio
	WHERE ingreso.id_unidad_negocio IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_distribucion_unidad_negocio_cxs_2_tot;

    IF @lo_contador = 0 THEN
		CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_cxs_tot
        SELECT *
		FROM tmp_distribucion_unidad_negocio_cxs_1_tot;
	ELSE
		CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_cxs_tot
		SELECT *
		FROM tmp_distribucion_unidad_negocio_cxs_1_tot
        UNION
		SELECT *
		FROM tmp_distribucion_unidad_negocio_cxs_2_tot;
    END IF;

    /* -------------------------------------------------------------------- */

    CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_total_1_tot
    SELECT
		ventas.id_unidad_negocio,
		IFNULL(ventas.neto_mes, 0) neto_ventas_mes,
		IFNULL(cxs.neto_cxs_mes, 0) neto_cxs_mes,
		IFNULL((IFNULL(ventas.neto_mes, 0) + IFNULL(cxs.neto_cxs_mes, 0)), 0) totol_ingreso
	FROM tmp_distribucion_unidad_negocio_ventas_tot ventas
	LEFT JOIN tmp_distribucion_unidad_negocio_cxs_tot cxs ON
		ventas.id_unidad_negocio = cxs.id_unidad_negocio;

    CREATE TEMPORARY TABLE tmp_distribucion_unidad_negocio_total_2_tot
	SELECT
		IFNULL(ventas.id_unidad_negocio, cxs.id_unidad_negocio) id_unidad_negocio,
		IFNULL(ventas.neto_mes, 0) neto_ventas_mes,
		IFNULL(cxs.neto_cxs_mes, 0) neto_cxs_mes,
		IFNULL((IFNULL(ventas.neto_mes, 0) + IFNULL(cxs.neto_cxs_mes, 0)), 0) totol_ingreso
	FROM tmp_distribucion_unidad_negocio_ventas_tot ventas
	RIGHT JOIN tmp_distribucion_unidad_negocio_cxs_tot cxs ON
		ventas.id_unidad_negocio = cxs.id_unidad_negocio
	WHERE ventas.id_unidad_negocio IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_distribucion_unidad_negocio_total_2_tot;

    IF @lo_contador = 0 THEN
        SELECT
			SUM(neto_ventas_mes) neto_ventas_mes,
			SUM(neto_cxs_mes) neto_cxs_mes,
			SUM(totol_ingreso) totol_ingreso
		FROM tmp_distribucion_unidad_negocio_total_1_tot;
	ELSE
		SELECT
			SUM(a.neto_ventas_mes) neto_ventas_mes,
			SUM(a.neto_cxs_mes) neto_cxs_mes,
			SUM(a.totol_ingreso) totol_ingreso
		FROM(
			SELECT *
			FROM tmp_distribucion_unidad_negocio_total_1_tot
			UNION
			SELECT *
			FROM tmp_distribucion_unidad_negocio_total_2_tot) a;
    END IF;

    /* -------------------------------------------------------------------- */

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
