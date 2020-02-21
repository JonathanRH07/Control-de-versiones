DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_bsp_grafica_top_aerolineas_c`(
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
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_bsp_grafica_top_aerolineas_c';
	END ;

    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/fac.tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/fac.tipo_cambio_eur';
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

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    DROP TABLE IF EXISTS tmp_top_airlines_ing;
    DROP TABLE IF EXISTS tmp_top_airlines_egr;

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	SET @query_ing = CONCAT(
						'
                        CREATE TEMPORARY TABLE tmp_top_airlines_ing
						SELECT
							airline.clave_aerolinea clave,
							airline.nombre_aerolinea nombre,
							IFNULL(SUM((tarifa_moneda_base',lo_moneda_reporte,')),0) total_neto
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_gds_tr_vuelos vuelos ON
							det.id_factura_detalle = vuelos.id_factura_detalle
						JOIN ct_glob_tc_aerolinea airline ON
							vuelos.clave_linea_aerea = airline.clave_aerolinea
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						AND tipo_cfdi = ''I''
						AND fac.estatus != 2
						AND vuelos.clave_linea_aerea IS NOT NULL
						GROUP BY vuelos.clave_linea_aerea, fac.id_grupo_empresa');

	-- SELECT @query_ing;
	PREPARE stmt FROM @query_ing;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	/* -------------------------------------------------------- */

	SET @query_egr = CONCAT(
						'
						CREATE TEMPORARY TABLE tmp_top_airlines_egr
						SELECT
							airline.clave_aerolinea clave,
							airline.nombre_aerolinea nombre,
							IFNULL(SUM((tarifa_moneda_base',lo_moneda_reporte,')),0) total_neto
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						JOIN ic_gds_tr_vuelos vuelos ON
							det.id_factura_detalle = vuelos.id_factura_detalle
						JOIN ct_glob_tc_aerolinea airline ON
							vuelos.clave_linea_aerea = airline.clave_aerolinea
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						AND tipo_cfdi = ''E''
						AND fac.estatus != 2
						AND vuelos.clave_linea_aerea IS NOT NULL
						GROUP BY vuelos.clave_linea_aerea, fac.id_grupo_empresa');

	-- SELECT @query_egr;
	PREPARE stmt FROM @query_egr;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		ingreso.clave,
		ingreso.nombre,
		IFNULL((IFNULL(ingreso.total_neto, 0) - IFNULL(egreso.total_neto, 0)), 0) total_neto
	FROM tmp_top_airlines_ing ingreso
	LEFT JOIN tmp_top_airlines_egr egreso ON ingreso.clave = egreso.clave
	GROUP BY ingreso.clave
    HAVING total_neto > 0
	ORDER BY total_neto DESC
	LIMIT 10;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
