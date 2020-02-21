DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_contenido_promedio_x_cxs_c`(
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

    DROP TABLE IF EXISTS tmp_promedio_cxs_ing;
    DROP TABLE IF EXISTS tmp_promedio_cxs_egr;
    DROP TABLE IF EXISTS tmp_promedio_cxs_1;
    DROP TABLE IF EXISTS tmp_promedio_cxs_2;
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

    /* INGRESOS */
    SET @query_promedio_x_cxs_i = CONCAT(
									'
                                    CREATE TEMPORARY TABLE tmp_promedio_cxs_ing
                                    SELECT
										fac.id_cliente,
										cli.razon_social cliente,
										SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total_cxs,
										COUNT(det.id_factura_detalle) no_servicios_cxs
									FROM ic_fac_tr_factura fac
									JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									JOIN ic_cat_tr_cliente cli ON
										fac.id_cliente = cli.id_cliente
									JOIN ic_cat_tc_servicio serv ON
										det.id_servicio = serv.id_servicio
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									',lo_sucursal,'
									AND fac.estatus != 2
									AND serv.id_producto = 5
									AND serv.estatus = 1
									AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
                                    AND fac.tipo_cfdi = ''I''
									GROUP BY cli.id_cliente
									ORDER BY 2 DESC');

	-- SELECT @query_promedio_x_cxs_i;
	PREPARE stmt FROM @query_promedio_x_cxs_i;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* EGRESOS */
	SET @query_promedio_x_cxs_e = CONCAT(
									'
									CREATE TEMPORARY TABLE tmp_promedio_cxs_egr
                                    SELECT
										fac.id_cliente,
										cli.razon_social cliente,
										SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total_cxs,
										COUNT(det.id_factura_detalle) no_servicios_cxs
									FROM ic_fac_tr_factura fac
									JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									JOIN ic_cat_tr_cliente cli ON
										fac.id_cliente = cli.id_cliente
									JOIN ic_cat_tc_servicio serv ON
										det.id_servicio = serv.id_servicio
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									',lo_sucursal,'
									AND fac.estatus != 2
									AND serv.id_producto = 5
									AND serv.estatus = 1
									AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
                                    AND fac.tipo_cfdi = ''E''
									GROUP BY cli.id_cliente
									ORDER BY 2 DESC');

	-- SELECT @query_promedio_x_cxs_e;
	PREPARE stmt FROM @query_promedio_x_cxs_e;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    CREATE TEMPORARY TABLE tmp_promedio_cxs_1
	SELECT
		ingreso.cliente,
		(IFNULL(ingreso.total_cxs, 0) - IFNULL(egreso.total_cxs, 0)) total_cxs,
		(IFNULL(ingreso.no_servicios_cxs, 0) - IFNULL(egreso.no_servicios_cxs, 0)) no_servicios_cxs
	FROM tmp_promedio_cxs_ing ingreso
	LEFT JOIN tmp_promedio_cxs_egr egreso ON
		ingreso.id_cliente = egreso.id_cliente;

	CREATE TEMPORARY TABLE tmp_promedio_cxs_2
	SELECT
		IFNULL(ingreso.cliente, egreso.cliente) cliente,
		(IFNULL(ingreso.total_cxs, 0) - IFNULL(egreso.total_cxs, 0)) total_cxs,
		(IFNULL(ingreso.no_servicios_cxs, 0) - IFNULL(egreso.no_servicios_cxs, 0)) no_servicios_cxs
	FROM tmp_promedio_cxs_ing ingreso
	RIGHT JOIN tmp_promedio_cxs_egr egreso ON
		ingreso.id_cliente = egreso.id_cliente
	WHERE ingreso.id_cliente IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
    FROM tmp_promedio_cxs_2;

    IF @lo_contador = 0 THEN
		SELECT
			cliente,
			total_cxs,
			no_servicios_cxs,
			(total_cxs / no_servicios_cxs) promedio_cxs
        FROM tmp_promedio_cxs_1
        LIMIT pr_ini_pag,pr_fin_pag;
	ELSE
		SELECT
			cliente,
			total_cxs,
			no_servicios_cxs,
			(total_cxs / no_servicios_cxs) promedio_cxs
        FROM tmp_promedio_cxs_1
        UNION
        SELECT
			cliente,
			total_cxs,
			no_servicios_cxs,
			(total_cxs / no_servicios_cxs) promedio_cxs
        FROM tmp_promedio_cxs_2
        LIMIT pr_ini_pag,pr_fin_pag;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	IF @lo_contador = 0 THEN
		SELECT
			COUNT(*)
		INTO
			pr_rows_tot_table
        FROM tmp_promedio_cxs_1;
	ELSE
		SELECT
			COUNT(*)
		INTO
			pr_rows_tot_table
		FROM(
			SELECT *
			FROM tmp_promedio_cxs_1
			UNION
			SELECT *
			FROM tmp_promedio_cxs_2) a;
    END IF;


    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	 # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
