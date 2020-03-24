DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_ventas_contenido_x_clientes_inactivos_c`(
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
	@nombre:		sp_dash_ventas_contenido_x_clientes_inactivos_c
	@fecha:			20/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por mes
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_moneda_reporte				VARCHAR(255);
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_ventas_contenido_x_clientes_inactivos_c';
	END ;

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

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_1;
    DROP TABLE IF EXISTS tmp_2;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_1 = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_1
				SELECT
					fac.id_factura,
					fac.id_cliente,
					cli.razon_social,
					fecha_factura,
					hora_factura,
					IFNULL((total_moneda_base',lo_moneda_reporte,') , 0) total_moneda_base
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tr_cliente cli ON
					fac.id_cliente = cli.id_cliente
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
                AND fac.hora_factura IS NOT NULL
                AND fac.estatus != 2
                AND cli.estatus = 1
                AND fac.tipo_cfdi = ''I''
				AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), ''%Y-%m-%d'')
                AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 12 MONTH), ''%Y-%m-%d'')
				-- GROUP BY fac.id_cliente
                ORDER BY fac.fecha_factura DESC');

	-- SELECT @query_1;
	PREPARE stmt FROM @query_1;
	EXECUTE stmt;

    SET @query_2 = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_2
				SELECT
					fac.id_factura,
					fac.id_cliente,
					cli.razon_social,
					fecha_factura,
					hora_factura,
					IFNULL((total_moneda_base',lo_moneda_reporte,') , 0) total_moneda_base
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tr_cliente cli ON
					fac.id_cliente = cli.id_cliente
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
                AND fac.hora_factura IS NOT NULL
                AND fac.estatus != 2
                AND cli.estatus = 1
                AND fac.tipo_cfdi = ''I''
                AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), ''%Y-%m-%d'')
				AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') <= DATE_FORMAT(NOW(), ''%Y-%m-%d'')
				-- GROUP BY fac.id_cliente
                ORDER BY fac.fecha_factura DESC');

	-- SELECT @query_2;
	PREPARE stmt FROM @query_2;
	EXECUTE stmt;

    SELECT
		razon_social cliente,
		fecha_factura fecha_ult,
		total_moneda_base monto
	FROM (
	SELECT
		a.*
	FROM tmp_1 a
	LEFT JOIN tmp_2 b ON
		a.id_cliente = b.id_cliente
	ORDER BY a.id_factura DESC ) a
	GROUP BY a.id_cliente
    ORDER BY a.fecha_factura DESC
	LIMIT pr_ini_pag, pr_fin_pag;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @pr_rows_tot_table = 0;
    SET @querycount = CONCAT(
					'
                    SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM (
                    SELECT
						razon_social cliente,
						fecha_factura fecha_ult,
						total_moneda_base monto
					FROM (
					SELECT
						a.*
					FROM tmp_1 a
					LEFT JOIN tmp_2 b ON
						a.id_cliente = b.id_cliente
					WHERE b.id_cliente IS NULL
					ORDER BY a.id_factura DESC ) a
					GROUP BY a.id_cliente
					ORDER BY a.fecha_factura DESC) a');

	-- SELECT @querycount;
	PREPARE stmt FROM @querycount;
	EXECUTE stmt;

    SET pr_rows_tot_table = @pr_rows_tot_table;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
