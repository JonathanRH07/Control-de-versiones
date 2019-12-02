DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_superuser_contenido_x_vendedor_c`(
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
	@nombre:		sp_dash_superuser_contenido_x_vendedor_c
	@fecha:			31/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por dia
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(255);
	DECLARE lo_valida						INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_superuser_contenido_x_vendedor_c';
	END ;

    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

	DROP TABLE IF EXISTS tmp_ventas_x_vendedor_ing;
    DROP TABLE IF EXISTS tmp_ventas_x_vendedor_egr;
    DROP TABLE IF EXISTS tmp_ventas_x_vendedor_1;
    DROP TABLE IF EXISTS tmp_ventas_x_vendedor_2;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_vend_ing = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_ventas_x_vendedor_ing
				SELECT
					vendedor.id_vendedor,
					vendedor.nombre,
					vendedor.clave,
					IFNULL(SUM(((IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0)) - IFNULL(descuento',lo_moneda_reporte,', 0))), 0) total_venta
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tr_vendedor vendedor ON
					fac.id_vendedor_tit = vendedor.id_vendedor
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND fac.id_sucursal = ',pr_id_sucursal,'
				AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND fac.estatus != 2
				AND fac.tipo_cfdi = ''I''
				GROUP BY fac.id_vendedor_tit');

	-- SELECT @query_vend_ing;
	PREPARE stmt FROM @query_vend_ing;
	EXECUTE stmt;

	SET @query_vend_egr = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_ventas_x_vendedor_egr
				SELECT
					vendedor.id_vendedor,
					vendedor.nombre,
					vendedor.clave,
					IFNULL(SUM(((IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0)) - IFNULL(descuento',lo_moneda_reporte,', 0))), 0) total_venta
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tr_vendedor vendedor ON
					fac.id_vendedor_tit = vendedor.id_vendedor
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND fac.id_sucursal = ',pr_id_sucursal,'
				AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND fac.estatus != 2
				AND fac.tipo_cfdi = ''E''
				GROUP BY fac.id_vendedor_tit
                ');

	-- SELECT @query_vend_egr;
	PREPARE stmt FROM @query_vend_egr;
	EXECUTE stmt;

    SELECT
		COUNT(*)
	INTO
		lo_valida
	FROM tmp_ventas_x_vendedor_egr;

    CREATE TEMPORARY TABLE tmp_ventas_x_vendedor_1
	SELECT
		ingreso.id_vendedor,
		ingreso.clave,
		ingreso.nombre,
		IFNULL(ingreso.total_venta, 0) venta_mes,
		IFNULL(egreso.total_venta, 0) devolucion_mes,
		IFNULL(IFNULL(ingreso.total_venta, 0) - IFNULL(egreso.total_venta, 0), 0) venta_neta_mes,
		0 acumulado
	FROM tmp_ventas_x_vendedor_ing ingreso
	LEFT JOIN tmp_ventas_x_vendedor_egr egreso ON
		ingreso.id_vendedor = egreso.id_vendedor;

	CREATE TEMPORARY TABLE tmp_ventas_x_vendedor_2
	SELECT
		egreso.id_vendedor,
		egreso.clave,
        egreso.nombre,
		IFNULL(ingreso.total_venta, 0) venta_mes,
		IFNULL(egreso.total_venta, 0) devolucion_mes,
		IFNULL(IFNULL(ingreso.total_venta, 0) - IFNULL(egreso.total_venta, 0), 0) venta_neta_mes,
		0 acumulado
	FROM tmp_ventas_x_vendedor_ing ingreso
	RIGHT JOIN tmp_ventas_x_vendedor_egr egreso ON
		ingreso.id_vendedor = egreso.id_vendedor;

    IF lo_valida = 0 THEN
		SELECT *
        FROM tmp_ventas_x_vendedor_1
        ORDER BY venta_neta_mes DESC
        LIMIT pr_ini_pag, pr_fin_pag;
	ELSE
		SELECT *
        FROM tmp_ventas_x_vendedor_1
        UNION
        SELECT *
        FROM tmp_ventas_x_vendedor_2
        ORDER BY venta_neta_mes DESC
        LIMIT pr_ini_pag, pr_fin_pag;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @pr_rows_tot_table = 0;
    SET @query_vend_count = CONCAT(
				'
                SELECT
					COUNT(*)
				INTO
					@pr_rows_tot_table
				FROM(
					SELECT *
					FROM tmp_ventas_x_vendedor_1
					UNION
					SELECT *
					FROM tmp_ventas_x_vendedor_2) a');

	-- SELECT @query_vend_count;
	PREPARE stmt FROM @query_vend_count;
	EXECUTE stmt;


    SET pr_rows_tot_table = @pr_rows_tot_table;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
