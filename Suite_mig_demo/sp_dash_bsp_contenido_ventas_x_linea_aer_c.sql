DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_bsp_contenido_ventas_x_linea_aer_c`(
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
	@nombre:		sp_dash_bsp_contenido_ventas_x_linea_aer_c
	@fecha:			29/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por dia
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(255);
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

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

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_bsp_ing;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_airline_ing;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_consolidador_ing;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_ingreso;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_bsp_egr;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_airline_egr;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_consolidador_egr;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_egreso;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_1;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_2;
    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
    /* TOTAL BSP */
    SET @queryla_bsp_ing = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_ventas_bsp_ing
					SELECT
						airline.id_aerolinea,
						airline.nombre_aerolinea,
						SUM(tarifa_moneda_base',lo_moneda_reporte,') total,
						id_tipo_proveedor
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					LEFT JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					LEFT JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					LEFT JOIN ic_cat_tr_proveedor prov ON
						det.id_proveedor = prov.id_proveedor
					LEFT JOIN ct_glob_tc_aerolinea airline ON
						vuelos.clave_linea_aerea = airline.clave_aerolinea
					WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                    ',lo_sucursal,'
					-- AND serv.id_producto = 1
					AND prov.id_tipo_proveedor = 2
					AND fac.estatus != 2
					AND fac.tipo_cfdi = ''I''
					GROUP BY vuelos.clave_linea_aerea');

	-- SELECT @queryla_bsp_ing;
	PREPARE stmt FROM @queryla_bsp_ing;
	EXECUTE stmt;

    /* TOTAL AEROLINEA */
    SET @queryla_air_ing = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_ventas_airline_ing
					SELECT
						airline.id_aerolinea,
						airline.nombre_aerolinea,
						SUM(tarifa_moneda_base',lo_moneda_reporte,') total,
						id_tipo_proveedor
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					LEFT JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					LEFT JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					LEFT JOIN ic_cat_tr_proveedor prov ON
						det.id_proveedor = prov.id_proveedor
					LEFT JOIN ct_glob_tc_aerolinea airline ON
						vuelos.clave_linea_aerea = airline.clave_aerolinea
					WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                    ',lo_sucursal,'
					-- AND serv.id_producto = 1
					AND prov.id_tipo_proveedor = 1
					AND fac.estatus != 2
					AND fac.tipo_cfdi = ''I''
					GROUP BY vuelos.clave_linea_aerea');

	-- SELECT @queryla_air_ing;
	PREPARE stmt FROM @queryla_air_ing;
	EXECUTE stmt;

    /* TOTAL CONSOLIDADOR */
    SET @queryla_cons_ing = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_ventas_consolidador_ing
					SELECT
						airline.id_aerolinea,
						airline.nombre_aerolinea,
						SUM(tarifa_moneda_base',lo_moneda_reporte,') total,
						id_tipo_proveedor
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					LEFT JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					LEFT JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					LEFT JOIN ic_cat_tr_proveedor prov ON
						det.id_proveedor = prov.id_proveedor
					LEFT JOIN ct_glob_tc_aerolinea airline ON
						vuelos.clave_linea_aerea = airline.clave_aerolinea
					WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                    ',lo_sucursal,'
					-- AND serv.id_producto = 1
					AND prov.id_tipo_proveedor = 3
					AND fac.estatus != 2
					AND fac.tipo_cfdi = ''I''
					GROUP BY vuelos.clave_linea_aerea');

	-- SELECT @queryla_cons_ing;
	PREPARE stmt FROM @queryla_cons_ing;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_ventas_ingreso
	SELECT *
	FROM tmp_ventas_bsp_ing
	UNION
	SELECT *
	FROM tmp_ventas_airline_ing
	UNION
	SELECT *
	FROM tmp_ventas_consolidador_ing;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* TOTAL BSP */
    SET @queryla_bsp_egr = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_ventas_bsp_egr
					SELECT
						airline.id_aerolinea,
						airline.nombre_aerolinea,
						SUM(tarifa_moneda_base',lo_moneda_reporte,') total,
						id_tipo_proveedor
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					LEFT JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					LEFT JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					LEFT JOIN ic_cat_tr_proveedor prov ON
						det.id_proveedor = prov.id_proveedor
					LEFT JOIN ct_glob_tc_aerolinea airline ON
						vuelos.clave_linea_aerea = airline.clave_aerolinea
					WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                    ',lo_sucursal,'
					-- AND serv.id_producto = 1
					AND prov.id_tipo_proveedor = 2
					AND fac.estatus != 2
					AND fac.tipo_cfdi = ''E''
					GROUP BY vuelos.clave_linea_aerea');

	-- SELECT @queryla_bsp_egr;
	PREPARE stmt FROM @queryla_bsp_egr;
	EXECUTE stmt;

    /* TOTAL AEROLINEA */
    SET @queryla_air_egr = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_ventas_airline_egr
					SELECT
						airline.id_aerolinea,
						airline.nombre_aerolinea,
						SUM(tarifa_moneda_base',lo_moneda_reporte,') total,
						id_tipo_proveedor
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					LEFT JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					LEFT JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					LEFT JOIN ic_cat_tr_proveedor prov ON
						det.id_proveedor = prov.id_proveedor
					LEFT JOIN ct_glob_tc_aerolinea airline ON
						vuelos.clave_linea_aerea = airline.clave_aerolinea
					WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                    ',lo_sucursal,'
					-- AND serv.id_producto = 1
					AND prov.id_tipo_proveedor = 1
					AND fac.estatus != 2
					AND fac.tipo_cfdi = ''E''
					GROUP BY vuelos.clave_linea_aerea');

	-- SELECT @queryla_air_egr;
	PREPARE stmt FROM @queryla_air_egr;
	EXECUTE stmt;

    /* TOTAL CONSOLIDADOR */
    SET @queryla_cons_egr = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_ventas_consolidador_egr
					SELECT
						airline.id_aerolinea,
						airline.nombre_aerolinea,
						SUM(tarifa_moneda_base',lo_moneda_reporte,') total,
						id_tipo_proveedor
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					LEFT JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					LEFT JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					LEFT JOIN ic_cat_tr_proveedor prov ON
						det.id_proveedor = prov.id_proveedor
					LEFT JOIN ct_glob_tc_aerolinea airline ON
						vuelos.clave_linea_aerea = airline.clave_aerolinea
					WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                    ',lo_sucursal,'
					-- AND serv.id_producto = 1
					AND prov.id_tipo_proveedor = 3
					AND fac.estatus != 2
					AND fac.tipo_cfdi = ''E''
					GROUP BY vuelos.clave_linea_aerea');

	-- SELECT @queryla_cons_egr;
	PREPARE stmt FROM @queryla_cons_egr;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_ventas_egreso
	SELECT *
	FROM tmp_ventas_bsp_egr
	UNION
	SELECT *
	FROM tmp_ventas_airline_egr
	UNION
	SELECT *
	FROM tmp_ventas_consolidador_egr;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    CREATE TEMPORARY TABLE tmp_ventas_1
    SELECT
		IFNULL(ingreso.id_aerolinea, egreso.id_aerolinea) id_aerolinea,
		IFNULL(ingreso.nombre_aerolinea, ingreso.nombre_aerolinea) nombre_aerolinea,
		CASE
			WHEN ingreso.id_tipo_proveedor = 2 THEN
				IFNULL(SUM(IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0)
			ELSE
				0
		END total_bsp,
		CASE
			WHEN ingreso.id_tipo_proveedor = 1 THEN
				IFNULL(SUM(IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)) , 0)
			ELSE
				0
		END total_airline,
		CASE
			WHEN ingreso.id_tipo_proveedor = 3 THEN
				IFNULL(SUM(IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0)
			ELSE
				0
		END total_consolidador
	FROM tmp_ventas_ingreso ingreso
	LEFT JOIN tmp_ventas_egreso egreso ON
		ingreso.id_aerolinea = egreso.id_aerolinea
	GROUP BY ingreso.id_aerolinea;

    CREATE TEMPORARY TABLE tmp_ventas_2
    SELECT
		IFNULL(ingreso.id_aerolinea, egreso.id_aerolinea) id_aerolinea,
		IFNULL(ingreso.nombre_aerolinea, ingreso.nombre_aerolinea) nombre_aerolinea,
		CASE
			WHEN ingreso.id_tipo_proveedor = 2 THEN
				IFNULL(SUM(IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0)
			ELSE
				0
		END total_bsp,
		CASE
			WHEN ingreso.id_tipo_proveedor = 1 THEN
				IFNULL(SUM(IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)) , 0)
			ELSE
				0
		END total_airline,
		CASE
			WHEN ingreso.id_tipo_proveedor = 3 THEN
				IFNULL(SUM(IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0)
			ELSE
				0
		END total_consolidador
	FROM tmp_ventas_ingreso ingreso
	RIGHT JOIN tmp_ventas_egreso egreso ON
		ingreso.id_aerolinea = egreso.id_aerolinea
	WHERE ingreso.id_aerolinea IS NULL
	GROUP BY ingreso.id_aerolinea;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_ventas_2;

    IF @lo_contador = 0 THEN
		SELECT
			id_aerolinea,
			nombre_aerolinea,
			total_bsp,
			total_airline,
			total_consolidador,
			(total_bsp + total_airline + total_consolidador) total_perido
        FROM tmp_ventas_1
        LIMIT pr_ini_pag, pr_fin_pag;
	ELSE
		SELECT
			id_aerolinea,
			nombre_aerolinea,
			total_bsp,
			total_airline,
			total_consolidador,
			(total_bsp + total_airline + total_consolidador) total_perido
		FROM(SELECT *
			FROM tmp_ventas_1
			UNION
			SELECT *
			FROM tmp_ventas_2) a
            ;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    IF @lo_contador = 0 THEN
		SELECT
			COUNT(*)
		INTO
			pr_rows_tot_table
        FROM tmp_ventas_1;
	ELSE
		SELECT
			COUNT(*)
		INTO
			pr_rows_tot_table
		FROM(
			SELECT *
			FROM tmp_ventas_1
			UNION
			SELECT *
			FROM tmp_ventas_2) a
		LIMIT pr_ini_pag, pr_fin_pag;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
