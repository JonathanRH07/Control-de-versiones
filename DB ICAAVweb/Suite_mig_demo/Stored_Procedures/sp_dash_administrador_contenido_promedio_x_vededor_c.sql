DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_contenido_promedio_x_vededor_c`(
	IN	pr_id_grupo_empresa					INT,
	IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
	IN  pr_ini_pag							INT,
    IN  pr_fin_pag							INT,
    OUT pr_rows_tot_table					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_contenido_promedio_x_cxs_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(100);
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_contenido_promedio_x_cxs_c';
	END;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_x_vendedor_ing;
    DROP TABLE IF EXISTS tmp_x_vendedor_egr;
    DROP TABLE IF EXISTS tmp_x_vendedor_1;
    DROP TABLE IF EXISTS tmp_x_vendedor_2;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_promedio_x_vendedor_ing = CONCAT(
									'
                                    CREATE TEMPORARY TABLE tmp_x_vendedor_ing
                                    SELECT
										vend.id_vendedor,
										vend.nombre vendedor,
										SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total_cxs,
										COUNT(det.id_factura_detalle) no_servicios_cxs
									FROM ic_fac_tr_factura fac
									JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									JOIN ic_cat_tr_vendedor vend ON
										fac.id_vendedor_tit = vend.id_vendedor
									JOIN ic_cat_tc_servicio serv ON
										det.id_servicio = serv.id_servicio
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									',lo_sucursal,'
									AND fac.estatus != 2
									AND serv.id_producto = 5
									AND serv.estatus = 1
                                    AND fac.tipo_cfdi = ''I''
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
									GROUP BY vend.id_vendedor
									ORDER BY 1 DESC');

	-- SELECT @query_promedio_x_vendedor_ing;
	PREPARE stmt FROM @query_promedio_x_vendedor_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @query_promedio_x_vendedor_egr = CONCAT(
									'
                                    CREATE TEMPORARY TABLE tmp_x_vendedor_egr
                                    SELECT
										vend.id_vendedor,
										vend.nombre vendedor,
										SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total_cxs,
										COUNT(det.id_factura_detalle) no_servicios_cxs
									FROM ic_fac_tr_factura fac
									JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									JOIN ic_cat_tr_vendedor vend ON
										fac.id_vendedor_tit = vend.id_vendedor
									JOIN ic_cat_tc_servicio serv ON
										det.id_servicio = serv.id_servicio
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									',lo_sucursal,'
									AND fac.estatus != 2
									AND serv.id_producto = 5
									AND serv.estatus = 1
                                    AND fac.tipo_cfdi = ''E''
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
									GROUP BY vend.id_vendedor
									ORDER BY 1 DESC');

	-- SELECT @query_promedio_x_vendedor_egr;
	PREPARE stmt FROM @query_promedio_x_vendedor_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_x_vendedor_1
    SELECT
		ingreso.vendedor,
        IFNULL(((IFNULL(ingreso.total_cxs, 0) - IFNULL(egreso.total_cxs, 0))), 0) total_cxs,
        IFNULL(((IFNULL(ingreso.no_servicios_cxs, 0) - IFNULL(egreso.no_servicios_cxs, 0))), 0) no_servicios_cxs
    FROM tmp_x_vendedor_ing ingreso
    LEFT JOIN tmp_x_vendedor_egr egreso ON
		ingreso.id_vendedor = egreso.id_vendedor;

    CREATE TEMPORARY TABLE tmp_x_vendedor_2
	SELECT
		IFNULL(ingreso.vendedor, egreso.vendedor) vendedor,
        IFNULL(((IFNULL(ingreso.total_cxs, 0) - IFNULL(egreso.total_cxs, 0))), 0) total_cxs,
        IFNULL(((IFNULL(ingreso.no_servicios_cxs, 0) - IFNULL(egreso.no_servicios_cxs, 0))), 0) no_servicios_cxs
    FROM tmp_x_vendedor_ing ingreso
    RIGHT JOIN tmp_x_vendedor_egr egreso ON
		ingreso.id_vendedor = egreso.id_vendedor
	WHERE ingreso.id_vendedor IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
    FROM tmp_x_vendedor_2;

    IF @lo_contador = 0 THEN
		SELECT
			vendedor,
			total_cxs,
			no_servicios_cxs,
			IFNULL((IFNULL(total_cxs, 0)/ IFNULL(no_servicios_cxs, 0)), 0) promedio_cxs
        FROM tmp_x_vendedor_1
        LIMIT pr_ini_pag, pr_fin_pag;
	ELSE
		SELECT
			vendedor,
			total_cxs,
			no_servicios_cxs,
			IFNULL((IFNULL(total_cxs, 0)/ IFNULL(no_servicios_cxs, 0)), 0) promedio_cxs
		FROM(
		SELECT *
		FROM tmp_x_vendedor_1
		UNION
		SELECT *
		FROM tmp_x_vendedor_2) a
        LIMIT pr_ini_pag, pr_fin_pag;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    IF @lo_contador = 0 THEN
		SELECT
			COUNT(*)
		INTO
			pr_rows_tot_table
        FROM tmp_x_vendedor_1;
	ELSE
		SELECT
			COUNT(*)
		INTO
			pr_rows_tot_table
        FROM (
		SELECT *
        FROM tmp_x_vendedor_1
        UNION
        SELECT *
        FROM tmp_x_vendedor_2) a;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
