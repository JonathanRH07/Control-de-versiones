DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_superuser_graf_top_servicios_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_superuser_graf_top_servicios_c
	@fecha:			31/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por dia
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(100);
    DECLARE lo_valida						INT;
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_superuser_graf_x_dia_c';
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

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_top_servicios_ing;
    DROP TABLE IF EXISTS tmp_top_servicios_egr;
    DROP TABLE IF EXISTS tmp_top_servicios_1;
    DROP TABLE IF EXISTS tmp_top_servicios_2;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_top_ing = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_top_servicios_ing
				SELECT
					servicio.id_servicio,
					servicio.descripcion,
                    IFNULL(SUM(IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0) - IFNULL(descuento',lo_moneda_reporte,', 0)), 0) total_venta
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio servicio ON
					det.id_servicio = servicio.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
				AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND fac.estatus != 2
				AND fac.tipo_cfdi = ''I''
				GROUP BY servicio.id_servicio
				LIMIT 10');

	-- SELECT @query_top_ing;
	PREPARE stmt FROM @query_top_ing;
	EXECUTE stmt;

	SET @query_top_egr = CONCAT(
				'
				CREATE TEMPORARY TABLE tmp_top_servicios_egr
				SELECT
					servicio.id_servicio,
					servicio.descripcion,
					IFNULL(SUM(IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0) - IFNULL(descuento',lo_moneda_reporte,', 0)), 0) total_venta
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio servicio ON
					det.id_servicio = servicio.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
				AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND fac.estatus != 2
				AND fac.tipo_cfdi = ''E''
				GROUP BY servicio.id_servicio
				LIMIT 10');

	-- SELECT @query_top_egr;
	PREPARE stmt FROM @query_top_egr;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_top_servicios_1
	SELECT
		ingreso.id_servicio,
		ingreso.descripcion nombre,
		IFNULL(IFNULL(ingreso.total_venta, 0) - IFNULL(egreso.total_venta, 0), 0) neto_mes
	FROM tmp_top_servicios_ing ingreso
	LEFT JOIN tmp_top_servicios_egr egreso ON
		ingreso.id_servicio = egreso.id_servicio
	ORDER BY neto_mes DESC;

    CREATE TEMPORARY TABLE tmp_top_servicios_2
	SELECT
		egreso.id_servicio,
		egreso.descripcion nombre,
		IFNULL(IFNULL(ingreso.total_venta, 0) - IFNULL(egreso.total_venta, 0), 0) neto_mes
	FROM tmp_top_servicios_ing ingreso
	RIGHT JOIN tmp_top_servicios_egr egreso ON
		ingreso.id_servicio = egreso.id_servicio
	ORDER BY neto_mes DESC;

    SELECT
		COUNT(*)
	INTO
		lo_valida
    FROM tmp_top_servicios_2;

    IF lo_valida = 0 THEN
		SELECT *
		FROM tmp_top_servicios_1;
	ELSE
		SELECT *
		FROM tmp_top_servicios_1
		UNION
        SELECT *
		FROM tmp_top_servicios_2;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
