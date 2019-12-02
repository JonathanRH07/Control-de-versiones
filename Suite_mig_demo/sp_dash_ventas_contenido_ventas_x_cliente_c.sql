DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_ventas_contenido_ventas_x_cliente_c`(
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
	@nombre:		sp_dash_ventas_contenido_ventas_x_cliente_c
	@fecha:			20/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por dia
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_moneda_reporte				VARCHAR(150);
    DECLARE lo_moneda_reporte2				VARCHAR(150);
    DECLARE lo_moneda_reporte3				VARCHAR(150);
    DECLARE lo_moneda_reporte4				VARCHAR(150);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_ventas_contenido_ventas_x_cliente_c';
	END ;

    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	DROP TABLE IF EXISTS tmp_ventas_x_cliente_ing;
    DROP TABLE IF EXISTS tmp_ventas_x_cliente_egr;
    DROP TABLE IF EXISTS tmp_ventas_x_cliente1;
    DROP TABLE IF EXISTS tmp_ventas_x_cliente2;

  /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
    SET @queryxcliente_ing = CONCAT(
						'
						CREATE TEMPORARY TABLE tmp_ventas_x_cliente_ing
						SELECT
							cli.id_cliente,
							cli.cve_cliente clave,
							cli.razon_social nombre,
							SUM(((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,')) venta_mes
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tr_cliente cli ON
							fac.id_cliente = cli.id_cliente
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						AND fac.estatus != 2
						AND tipo_cfdi = ''I''
						GROUP BY cli.id_cliente');

	-- SELECT @queryxcliente_ing;
	PREPARE stmt FROM @queryxcliente_ing;
	EXECUTE stmt;

    SET @queryxcliente_egr = CONCAT(
						'
                        CREATE TEMPORARY TABLE tmp_ventas_x_cliente_egr
						SELECT
							cli.id_cliente,
							cli.cve_cliente clave,
							cli.razon_social nombre,
							SUM(((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,')) devolucion_mes
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_cat_tr_cliente cli ON
							fac.id_cliente = cli.id_cliente
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						AND fac.estatus != 2
						AND tipo_cfdi = ''E''
						GROUP BY cli.id_cliente');

	-- SELECT @queryxcliente_egr;
	PREPARE stmt FROM @queryxcliente_egr;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_ventas_x_cliente1
    SELECT
		ingreso.id_cliente,
		ingreso.clave,
		ingreso.nombre,
		IFNULL(ingreso.venta_mes, 0) venta_mes,
		IFNULL(egreso.devolucion_mes, 0) devolucion_mes,
		(IFNULL(ingreso.venta_mes, 0) - IFNULL(egreso.devolucion_mes, 0)) venta_neta_mes,
		0 acumulado
	FROM tmp_ventas_x_cliente_ing ingreso
	LEFT JOIN tmp_ventas_x_cliente_egr egreso ON
		ingreso.id_cliente = egreso.id_cliente
	ORDER BY venta_neta_mes DESC;

    CREATE TEMPORARY TABLE tmp_ventas_x_cliente2
	SELECT
		IFNULL(ingreso.id_cliente, egreso.id_cliente) id_cliente,
		IFNULL(ingreso.clave, egreso.clave) clave,
		IFNULL(ingreso.nombre, egreso.nombre) nombre,
		IFNULL(ingreso.venta_mes, 0) venta_mes,
		IFNULL(egreso.devolucion_mes, 0) devolucion_mes,
		(IFNULL(ingreso.venta_mes, 0) - IFNULL(egreso.devolucion_mes, 0)) venta_neta_mes,
		0 acumulado
	FROM tmp_ventas_x_cliente_ing ingreso
	RIGHT JOIN tmp_ventas_x_cliente_egr egreso ON
		ingreso.id_cliente = egreso.id_cliente
	WHERE ingreso.id_cliente IS NULL
	ORDER BY venta_neta_mes DESC;

    SELECT
		COUNT(*)
	INTO
		@lo_contador_ventas
	FROM tmp_ventas_x_cliente2;

	IF @lo_contador_ventas = 0 THEN
		SELECT *
        FROM tmp_ventas_x_cliente1
        LIMIT pr_ini_pag, pr_fin_pag;
	ELSE
		SELECT *
        FROM tmp_ventas_x_cliente1
        UNION
        SELECT *
        FROM tmp_ventas_x_cliente2
        LIMIT pr_ini_pag, pr_fin_pag;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	IF @lo_contador_ventas = 0 THEN
		SELECT
			COUNT(*)
        INTO
			pr_rows_tot_table
        FROM tmp_ventas_x_cliente1;
	ELSE
		SELECT
			COUNT(*)
		INTO
			pr_rows_tot_table
		FROM(
			SELECT *
			FROM tmp_ventas_x_cliente1
			UNION
			SELECT *
			FROM tmp_ventas_x_cliente2) a;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
