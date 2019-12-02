DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_bsp_grafica_comparativa_x_dia_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_bsp_grafica_comparativa_x_dia_c
	@fecha:			20/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por dia
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/
	DECLARE lo_moneda_reporte				VARCHAR(255);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_bsp_grafica_comparativa_x_dia_c';
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

    DROP TABLE IF EXISTS tmp_boletos_nac_ing;
    DROP TABLE IF EXISTS tmp_boletos_nac_egr;
	DROP TABLE IF EXISTS tmp_boletos_nac_1;
    DROP TABLE IF EXISTS tmp_boletos_nac_2;
	DROP TABLE IF EXISTS tmp_boletos_nac;
    DROP TABLE IF EXISTS tmp_boletos_inter_ing;
    DROP TABLE IF EXISTS tmp_boletos_inter_egr;
    DROP TABLE IF EXISTS tmp_boletos_inter_1;
    DROP TABLE IF EXISTS tmp_boletos_inter_2;
    DROP TABLE IF EXISTS tmp_boletos_inter;
    DROP TABLE IF EXISTS tmp_total_1;
    DROP TABLE IF EXISTS tmp_total_2;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* CONSULTA BOLETOS NACIONALES */
    SET @querycompnac_ing = CONCAT(
								'
                                CREATE TEMPORARY TABLE tmp_boletos_nac_ing
								SELECT
									fac.id_factura,
									fecha_factura,
									IFNULL(SUM(tarifa_moneda_base',lo_moneda_reporte,'), 0.00) total
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_gds_tr_vuelos vuelos ON
									det.id_factura_detalle = vuelos.id_factura_detalle
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND fac.id_sucursal = ',pr_id_sucursal,'
								AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
								AND serv.alcance = 1
								AND serv.id_producto = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''I''
								AND vuelos.clave_linea_aerea IS NOT NULL
								GROUP BY fac.fecha_factura;');

	-- SELECT @querycompnac_ing;
	PREPARE stmt FROM @querycompnac_ing;
	EXECUTE stmt;

    SET @querycompnac_egr = CONCAT(
								'
                                CREATE TEMPORARY TABLE tmp_boletos_nac_egr
								SELECT
									fac.id_factura,
									fecha_factura,
									IFNULL(SUM(tarifa_moneda_base',lo_moneda_reporte,'), 0.00) total
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_gds_tr_vuelos vuelos ON
									det.id_factura_detalle = vuelos.id_factura_detalle
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND fac.id_sucursal = ',pr_id_sucursal,'
								-- AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
								AND serv.alcance = 1
								AND serv.id_producto = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''E''
								AND vuelos.clave_linea_aerea IS NOT NULL
								GROUP BY fac.fecha_factura;');

	-- SELECT @querycompnac_egr;
	PREPARE stmt FROM @querycompnac_egr;
	EXECUTE stmt;

	CREATE TEMPORARY TABLE tmp_boletos_nac_1
    SELECT
		ingreso.id_factura,
        ingreso.fecha_factura,
        IFNULL((IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0) total
    FROM tmp_boletos_nac_ing ingreso
	LEFT JOIN tmp_boletos_nac_egr egreso ON
		ingreso.fecha_factura = egreso.fecha_factura;

	CREATE TEMPORARY TABLE tmp_boletos_nac_2
	SELECT
		IFNULL(ingreso.id_factura, egreso.id_factura) id_factura,
		IFNULL(ingreso.fecha_factura, egreso.fecha_factura) fecha_factura,
		IFNULL((IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0) total
	FROM tmp_boletos_nac_ing ingreso
	RIGHT JOIN tmp_boletos_nac_egr egreso ON
		ingreso.fecha_factura = egreso.fecha_factura
	WHERE ingreso.id_factura IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador_nac
	FROM tmp_boletos_nac_2;

    IF @lo_contador_nac = 0 THEN
        CREATE TEMPORARY TABLE tmp_boletos_nac
        SELECT
			id_factura,
            fecha_factura,
            total
		FROM tmp_boletos_nac_1;
	ELSE
		CREATE TEMPORARY TABLE tmp_boletos_nac
		SELECT
			id_factura,
            fecha_factura,
            total
		FROM tmp_boletos_nac_1
		UNION
		SELECT
			id_factura,
            fecha_factura,
            total
		FROM tmp_boletos_nac_2;
	END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* CONSULTA BOLETOS INTERNACIONALES */
    SET @querycompinter_ing = CONCAT(
								'
                                CREATE TEMPORARY TABLE tmp_boletos_inter_ing
								SELECT
									fac.id_factura,
									fecha_factura,
									IFNULL(SUM(tarifa_moneda_base',lo_moneda_reporte,'), 0.00) total
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_gds_tr_vuelos vuelos ON
									det.id_factura_detalle = vuelos.id_factura_detalle
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND fac.id_sucursal = ',pr_id_sucursal,'
								AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
								AND serv.alcance = 2
								AND serv.id_producto = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''I''
								AND vuelos.clave_linea_aerea IS NOT NULL
								GROUP BY fac.fecha_factura;');

	-- SELECT @querycompinter_ing;
	PREPARE stmt FROM @querycompinter_ing;
	EXECUTE stmt;

    SET @querycompinter_egr = CONCAT(
								'
                                CREATE TEMPORARY TABLE tmp_boletos_inter_egr
								SELECT
									fac.id_factura,
									fecha_factura,
									IFNULL(SUM(tarifa_moneda_base',lo_moneda_reporte,'), 0.00) total
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_gds_tr_vuelos vuelos ON
									det.id_factura_detalle = vuelos.id_factura_detalle
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND fac.id_sucursal = ',pr_id_sucursal,'
								AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
								AND serv.alcance = 2
								AND serv.id_producto = 1
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''E''
								AND vuelos.clave_linea_aerea IS NOT NULL
								GROUP BY fac.fecha_factura;');

	-- SELECT @querycompinter_egr;
	PREPARE stmt FROM @querycompinter_egr;
	EXECUTE stmt;

	CREATE TEMPORARY TABLE tmp_boletos_inter_1
    SELECT
		ingreso.id_factura,
        ingreso.fecha_factura,
        IFNULL((IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0) total
    FROM tmp_boletos_inter_ing ingreso
	LEFT JOIN tmp_boletos_inter_egr egreso ON
		ingreso.fecha_factura = egreso.fecha_factura;

	CREATE TEMPORARY TABLE tmp_boletos_inter_2
    SELECT
		ingreso.id_factura,
        ingreso.fecha_factura,
        IFNULL((IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0) total
    FROM tmp_boletos_inter_ing ingreso
	LEFT JOIN tmp_boletos_inter_egr egreso ON
		ingreso.fecha_factura = egreso.fecha_factura;

	SELECT
		COUNT(*)
	INTO
		@lo_contador_inter
	FROM tmp_boletos_inter_2;

    IF @lo_contador_inter = 0 THEN
		CREATE TEMPORARY TABLE tmp_boletos_inter
        SELECT
			id_factura,
            fecha_factura,
            total
		FROM tmp_boletos_inter_1;
	ELSE
		CREATE TEMPORARY TABLE tmp_boletos_inter
		SELECT
			id_factura,
            fecha_factura,
            total
		FROM tmp_boletos_inter_1
        UNION
		SELECT
			id_factura,
            fecha_factura,
            total
		FROM tmp_boletos_inter_2;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    CREATE TEMPORARY TABLE tmp_total_1
    SELECT
		nacionales.id_factura,
		nacionales.fecha_factura,
		IFNULL(nacionales.total, 0.00) total_nacinales,
		IFNULL(internacionales.total, 0.00) total_inter
    FROM tmp_boletos_nac nacionales
    LEFT JOIN tmp_boletos_inter internacionales ON
		nacionales.fecha_factura = internacionales.fecha_factura;

	CREATE TEMPORARY TABLE tmp_total_2
	SELECT
		IFNULL(nacionales.id_factura, internacionales.id_factura) id_factura,
		IFNULL(nacionales.fecha_factura, internacionales.fecha_factura) fecha_factura,
		IFNULL(nacionales.total, 0.00) total_nacinales,
		IFNULL(internacionales.total, 0.00) total_inter
	FROM tmp_boletos_nac nacionales
	RIGHT JOIN tmp_boletos_inter internacionales ON
		nacionales.fecha_factura = internacionales.fecha_factura
	WHERE nacionales.id_factura IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador_total
	FROM tmp_total_2;

    IF @lo_contador_total = 0 THEN
		SELECT *
		FROM tmp_total_1;
	ELSE
		SELECT *
		FROM tmp_total_1
        UNION
        SELECT *
		FROM tmp_total_2;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
