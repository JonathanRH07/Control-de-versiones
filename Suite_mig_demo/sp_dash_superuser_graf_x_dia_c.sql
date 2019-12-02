DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_superuser_graf_x_dia_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_superuser_graf_x_dia_c
	@fecha:			31/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por dia
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_moneda_reporte				VARCHAR(255);
    DECLARE lo_total_dia					DECIMAL(13,2) DEFAULT 0;
	DECLARE lo_meta_total					DECIMAL(13,2) DEFAULT 0;

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

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_total_actual;
    DROP TABLE IF EXISTS tmp_total_actual_ing;
    DROP TABLE IF EXISTS tmp_total_actual_egr;
    DROP TABLE IF EXISTS tmp_total_anterior;
    DROP TABLE IF EXISTS tmp_total_anterior_ing;
    DROP TABLE IF EXISTS tmp_total_anterior_egr;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* AÑO ACTUAL */
    SET @queryactual_ing = CONCAT(
						'
                        CREATE TEMPORARY TABLE tmp_total_actual_ing
						SELECT
							fecha_factura,
							IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))), 0) total_venta
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND fac.estatus != 2
						AND fac.tipo_cfdi = ''I''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						GROUP BY fac.fecha_factura');

	-- SELECT @queryactual_ing;
	PREPARE stmt FROM @queryactual_ing;
	EXECUTE stmt;

	SET @queryactual_egr = CONCAT(
						'
						CREATE TEMPORARY TABLE tmp_total_actual_egr
						SELECT
							fecha_factura,
							IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))), 0) total_venta
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND fac.estatus != 2
						AND fac.tipo_cfdi = ''E''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						GROUP BY fac.fecha_factura');

	-- SELECT @queryactual_egr;
	PREPARE stmt FROM @queryactual_egr;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_total_actual
	SELECT
		ingreso.fecha_factura,
		(IFNULL(ingreso.total_venta, 0) - IFNULL(egreso.total_venta, 0)) total_venta
	FROM tmp_total_actual_ing ingreso
	LEFT JOIN tmp_total_actual_egr egreso ON
		ingreso.fecha_factura = egreso.fecha_factura;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* AÑO ANTERIOR */
	SET @queryanterior_ing = CONCAT(
						'
						CREATE TEMPORARY TABLE tmp_total_anterior_ing
						SELECT
							fecha_factura,
							IFNULL(SUM(((tarifa_moneda_base + importe_markup) - descuento)',lo_moneda_reporte,'), 0) total_venta
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND fac.estatus != 2
                        AND fac.tipo_cfdi = ''I''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), ''%Y-%m'')
						GROUP BY fac.fecha_factura');

    -- SELECT @queryanterior_ing;
	PREPARE stmt FROM @queryanterior_ing;
	EXECUTE stmt;

    SET @queryanterior_egr = CONCAT(
						'
						CREATE TEMPORARY TABLE tmp_total_anterior_egr
						SELECT
							fecha_factura,
							IFNULL(SUM(((tarifa_moneda_base + importe_markup) - descuento)',lo_moneda_reporte,'), 0) total_venta
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND fac.estatus != 2
                        AND fac.tipo_cfdi = ''E''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), ''%Y-%m'')
						GROUP BY fac.fecha_factura');

    -- SELECT @queryanterior_egr;
	PREPARE stmt FROM @queryanterior_egr;
	EXECUTE stmt;

    CREATE TEMPORARY TABLE tmp_total_anterior
	SELECT
		ingreso.fecha_factura,
		(IFNULL(ingreso.total_venta, 0) - IFNULL(egreso.total_venta, 0)) total_venta
	FROM tmp_total_anterior_ing ingreso
	LEFT JOIN tmp_total_anterior_egr egreso ON
		ingreso.fecha_factura = egreso.fecha_factura;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		CASE
			WHEN actual.fecha_factura  IS NULL THEN
				DATE_ADD(anterior.fecha_factura, INTERVAL 1 YEAR)
			ELSE
				actual.fecha_factura
		END fecha_actual,
		IFNULL(actual.total_venta, 0.00) total_venta_anio_actual,
		CASE
			WHEN anterior.fecha_factura IS NULL THEN
				DATE_SUB(actual.fecha_factura, INTERVAL 1 YEAR)
			ELSE
				anterior.fecha_factura
		END fecha_anio_anterio,
		IFNULL(anterior.total_venta, 0.00) total_venta_anio_anterior
	FROM tmp_total_actual actual
	LEFT JOIN tmp_total_anterior anterior ON
		DATE_FORMAT(actual.fecha_factura, '%m-%d') = DATE_FORMAT(anterior.fecha_factura, '%m-%d')
	ORDER BY 1;

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
