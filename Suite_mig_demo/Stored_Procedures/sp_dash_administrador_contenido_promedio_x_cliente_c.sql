DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_contenido_promedio_x_cliente_c`(
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
	@nombre:		sp_dash_administrador_contenido_usuarios_conectados_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(100);
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_contenido_usuarios_conectados_c';
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

    DROP TABLE IF EXISTS tmp_compras_ing;
    DROP TABLE IF EXISTS tmp_compras_egr;
    DROP TABLE IF EXISTS tmp_compras1;
    DROP TABLE IF EXISTS tmp_compras2;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_promedio_x_cliente_ing = CONCAT(
									'
                                    CREATE TEMPORARY TABLE tmp_compras_ing
									SELECT
										fac.id_cliente,
										cli.razon_social cliente,
										SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total,
										COUNT(det.id_factura_detalle) no_servicios
									FROM ic_fac_tr_factura fac
									JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									JOIN ic_cat_tr_cliente cli ON
										fac.id_cliente = cli.id_cliente
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									',lo_sucursal,'
									AND fac.estatus != 2
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
                                    AND tipo_cfdi = ''I''
									GROUP BY cli.id_cliente
									ORDER BY 2 DESC');

	-- SELECT @query_promedio_x_cliente_ing;
	PREPARE stmt FROM @query_promedio_x_cliente_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @query_promedio_x_cliente_egr = CONCAT(
									'
                                    CREATE TEMPORARY TABLE tmp_compras_egr
									SELECT
										fac.id_cliente,
										cli.razon_social cliente,
										SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total,
										COUNT(det.id_factura_detalle) no_servicios
									FROM ic_fac_tr_factura fac
									JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									JOIN ic_cat_tr_cliente cli ON
										fac.id_cliente = cli.id_cliente
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									',lo_sucursal,'
									AND fac.estatus != 2
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
                                    AND tipo_cfdi = ''E''
									GROUP BY cli.id_cliente
									ORDER BY 2 DESC');

	-- SELECT @query_promedio_x_cliente_egr;
	PREPARE stmt FROM @query_promedio_x_cliente_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


    CREATE TEMPORARY TABLE tmp_compras1
    SELECT
		ingreso.id_cliente,
		ingreso.cliente,
		IFNULL((IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0) total,
		IFNULL((IFNULL(ingreso.no_servicios, 0) - IFNULL(egreso.no_servicios, 0)), 0) no_servicios
	FROM tmp_compras_ing ingreso
	LEFT JOIN tmp_compras_egr egreso ON
		ingreso.id_cliente = egreso.id_cliente;

    CREATE TEMPORARY TABLE tmp_compras2
	SELECT
		IFNULL(ingreso.id_cliente, egreso.id_cliente) id_cliente,
		IFNULL(ingreso.cliente, egreso.cliente) cliente,
		IFNULL((IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0) total,
		IFNULL((IFNULL(ingreso.no_servicios, 0) - IFNULL(egreso.no_servicios, 0)), 0) no_servicios
	FROM tmp_compras_ing ingreso
	RIGHT JOIN tmp_compras_egr egreso ON
		ingreso.id_cliente = egreso.id_cliente
	WHERE ingreso.id_cliente IS NULL;


    SELECT
		COUNT(*)
	INTO
		@lo_cont
	FROM tmp_compras2;

    IF @lo_cont = 0 THEN
		SELECT
			cliente,
			IFNULL(total, 0) total,
			IFNULL(no_servicios, 0) no_servicios,
			IFNULL((IFNULL(total, 0)/IFNULL(no_servicios, 0)), 0) promedio
		FROM tmp_compras1
        LIMIT pr_ini_pag, pr_fin_pag;
	ELSE
		SELECT
			cliente,
			IFNULL(total, 0) total,
			IFNULL(no_servicios, 0) no_servicios,
			IFNULL((IFNULL(total, 0)/IFNULL(no_servicios, 0)), 0) promedio
		FROM (
			SELECT *
			FROM tmp_compras1
			UNION
			SELECT *
			FROM tmp_compras2) a
		LIMIT pr_ini_pag, pr_fin_pag;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	IF @lo_cont = 0 THEN
		SELECT
			COUNT(*)
		INTO
			pr_rows_tot_table
		FROM tmp_compras1;
	ELSE
		SELECT
			COUNT(*)
		INTO
			pr_rows_tot_table
		FROM (
			SELECT *
			FROM tmp_compras1
			UNION
			SELECT *
			FROM tmp_compras2) a;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
