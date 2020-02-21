DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_bsp_indicadores_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_ventas_indicadores_c
	@fecha:			29/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda					VARCHAR(100);
    DECLARE lo_suma_total_airlines		DECIMAL(16,2);
    DECLARE lo_suma_bolnal				DECIMAL(16,2);
    DECLARE lo_suma_bolint				DECIMAL(16,2);
    DECLARE lo_boletos_facturados		INT;
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_ventas_indicadores_c';
	END;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda = '/fac.tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda = '/fac.tipo_cambio_eur';
	ELSE
		SET lo_moneda = '';
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

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	DROP TABLE IF EXISTS tmp_aerolinea_acumulado_ingreso;
    DROP TABLE IF EXISTS tmp_aerolinea_acumulado_egreso;

	/* ~~~~~~~~~~~~~~~~~~~~ MONTO TOTAL DE AEROLINEAS ~~~~~~~~~~~~~~~~~~~~ */

	SET @query1_ing = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_aerolinea_acumulado_ingreso
				SELECT
					fac.id_grupo_empresa,
					IFNULL(SUM((tarifa_moneda_base',lo_moneda,')),0) monto_moneda_base
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_gds_tr_vuelos vuelos ON
					det.id_factura_detalle = vuelos.id_factura_detalle
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
				AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND tipo_cfdi = ''I''
				AND fac.estatus != 2
				AND vuelos.clave_linea_aerea IS NOT NULL');

	-- SELECT @query1_ing;
	PREPARE stmt FROM @query1_ing;
	EXECUTE stmt;

	/* *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* */

	SET @query1_egr = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_aerolinea_acumulado_egreso
				SELECT
					IFNULL(fac.id_grupo_empresa, ',pr_id_grupo_empresa,') id_grupo_empresa,
					IFNULL(SUM((tarifa_moneda_base',lo_moneda,')),0) monto_moneda_base
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_gds_tr_vuelos vuelos ON
					det.id_factura_detalle = vuelos.id_factura_detalle
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
				AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND tipo_cfdi = ''E''
				AND fac.estatus != 2
				AND vuelos.clave_linea_aerea IS NOT NULL');

	-- SELECT @query1_egr;
	PREPARE stmt FROM @query1_egr;
	EXECUTE stmt;


	SET @lo_suma_total_airlines = 0;
	SET @query1 = CONCAT(
				'
				SELECT
					IFNULL((IFNULL(ingreso.monto_moneda_base, 0) - IFNULL(egreso.monto_moneda_base,0 )), 0.00) monto_moneda_base
				INTO
					@lo_suma_total_airlines
				FROM tmp_aerolinea_acumulado_ingreso ingreso
				LEFT JOIN tmp_aerolinea_acumulado_egreso egreso ON
					ingreso.id_grupo_empresa = egreso.id_grupo_empresa');

	-- SELECT @query1;
	PREPARE stmt FROM @query1;
	EXECUTE stmt;

    SET lo_suma_total_airlines = @lo_suma_total_airlines;


    /* ~~~~~~~~~~~~~~~~~~~~ MONTO TOTAL DE BOLETOS NACIONALES ~~~~~~~~~~~~~~~~~~~~ */

    SET @lo_suma_bolnal_ing = 0;
    SET @query2ing = CONCAT(
					'
					SELECT
						IFNULL(SUM((tarifa_moneda_base',lo_moneda,')),0)
					INTO
						@lo_suma_bolnal_ing
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                    ',lo_sucursal,'
					AND serv.alcance = 1
					-- AND serv.id_producto = 1
                    AND fac.estatus != 2
                    AND fac.tipo_cfdi = ''I''
					AND vuelos.clave_linea_aerea IS NOT NULL');

	-- SELECT @query2ing;
	PREPARE stmt FROM @query2ing;
	EXECUTE stmt;

	SET @lo_suma_bolnal_egr = 0;
    SET @query2_egr = CONCAT(
					'
					SELECT
						IFNULL(SUM((tarifa_moneda_base',lo_moneda,')),0)
					INTO
						@lo_suma_bolnal_egr
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_gds_tr_vuelos vuelos ON
						det.id_factura_detalle = vuelos.id_factura_detalle
					JOIN ic_cat_tc_servicio serv ON
						det.id_servicio = serv.id_servicio
					WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                    ',lo_sucursal,'
					AND serv.alcance = 1
					-- AND serv.id_producto = 1
                    AND fac.estatus != 2
                    AND fac.tipo_cfdi = ''E''
					AND vuelos.clave_linea_aerea IS NOT NULL');

	-- SELECT @query2_egr;
	PREPARE stmt FROM @query2_egr;
	EXECUTE stmt;

    SET lo_suma_bolnal = (IFNULL(@lo_suma_bolnal_ing, 0) - IFNULL(@lo_suma_bolnal_egr, 0));

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* ~~~~~~~~~~~~~~~~~~~~ MONTO TOTAL DE BOLETOS INTERNACIONALES ~~~~~~~~~~~~~~~~~~~~ */

	SET @lo_suma_bolint_ing = 0;
    SET @query3_ing = CONCAT(
				'
				SELECT
					IFNULL(SUM((tarifa_moneda_base',lo_moneda,')),0)
				INTO
					@lo_suma_bolint_ing
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_gds_tr_vuelos vuelos ON
					det.id_factura_detalle = vuelos.id_factura_detalle
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                ',lo_sucursal,'
				AND serv.alcance = 2
				-- AND serv.id_producto = 1
                AND fac.estatus != 2
                AND fac.tipo_cfdi = ''I''
				AND vuelos.clave_linea_aerea IS NOT NULL');

	-- SELECT @query3_ing;
	PREPARE stmt FROM @query3_ing;
	EXECUTE stmt;

	SET @lo_suma_bolint_egr = 0;
    SET @query3_egr = CONCAT(
				'
				SELECT
					IFNULL(SUM((tarifa_moneda_base',lo_moneda,')),0)
				INTO
					@lo_suma_bolint_egr
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_gds_tr_vuelos vuelos ON
					det.id_factura_detalle = vuelos.id_factura_detalle
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                ',lo_sucursal,'
				AND serv.alcance = 2
				-- AND serv.id_producto = 1
                AND fac.estatus != 2
                AND fac.tipo_cfdi = ''E''
				AND vuelos.clave_linea_aerea IS NOT NULL');

	-- SELECT @query3_egr;
	PREPARE stmt FROM @query3_egr;
	EXECUTE stmt;

    SET lo_suma_bolint = (IFNULL(@lo_suma_bolint_ing, 0) - IFNULL(@lo_suma_bolint_egr, 0));

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* ~~~~~~~~~~~~~~~~~~~~ MONTO TOTAL DE BOLETOS INTERNACIONALES ~~~~~~~~~~~~~~~~~~~~ */

    SET lo_boletos_facturados = 0;
    SET @query4 = CONCAT(
				'
				SELECT
					IFNULL(COUNT(*), 0)
				INTO
					@lo_boletos_facturados
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				LEFT JOIN ic_gds_tr_vuelos vuelos ON
					det.id_factura_detalle = vuelos.id_factura_detalle
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                ',lo_sucursal,'
				AND serv.id_producto = 1
                AND fac.estatus != 2');

	-- SELECT @query4;
	PREPARE stmt FROM @query4;
	EXECUTE stmt;

    SET lo_boletos_facturados = @lo_boletos_facturados;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		lo_suma_total_airlines,
        lo_suma_bolnal,
        lo_suma_bolint,
        lo_boletos_facturados;


    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
