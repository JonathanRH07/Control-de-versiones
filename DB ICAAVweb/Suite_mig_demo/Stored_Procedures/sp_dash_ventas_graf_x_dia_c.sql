DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_ventas_graf_x_dia_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_ventas_graf_x_dia_c
	@fecha:			20/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por dia
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_moneda_reporte				VARCHAR(255);
	DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_ventas_graf_x_semestre_c';
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

	DROP TABLE IF EXISTS tmp_objetivo_ing;
    DROP TABLE IF EXISTS tmp_objetivo_egr;
    DROP TABLE IF EXISTS tmp_objetivo_1;
    DROP TABLE IF EXISTS tmp_objetivo_2;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		IFNULL(SUM(meta_mes.meta), 0)
	INTO
		@lo_meta_total
	FROM ic_cat_tr_meta_venta meta
	JOIN ic_cat_tr_meta_venta_tipo meta_tipo ON
		meta.id_meta_venta = meta_tipo.id_meta_venta
	JOIN ic_cat_tr_meta_venta_meses meta_mes ON
		meta_tipo.id_meta_venta_tipo = meta_mes.id_meta_venta_tipo
	WHERE meta.id_grupo_empresa = pr_id_grupo_empresa
	AND meta_mes.mes = DATE_FORMAT(NOW(), '%m')
	AND meta_mes.anio = DATE_FORMAT(NOW(), '%Y');

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_act_ing = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_objetivo_ing
                    SELECT
						fecha_factura,
						IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))), 0) lo_total_dia,
                        (',@lo_meta_total,'',lo_moneda_reporte,') lo_meta_total
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND estatus != 2
					AND tipo_cfdi = ''I''
					GROUP BY fecha_factura');

	-- SELECT @query_act_ing;
	PREPARE stmt FROM @query_act_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @query_act_egr = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_objetivo_egr
                    SELECT
						fecha_factura,
						IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))), 0) lo_total_dia,
                        (',@lo_meta_total,'',lo_moneda_reporte,') lo_meta_total
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND estatus != 2
					AND tipo_cfdi = ''E''
					GROUP BY fecha_factura');

	-- SELECT @query_act_egr;
	PREPARE stmt FROM @query_act_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


    CREATE TEMPORARY TABLE tmp_objetivo_1
    SELECT
		ingreso.fecha_factura,
		IFNULL(IFNULL(ingreso.lo_total_dia, 0) - IFNULL(egreso.lo_total_dia, 0), 0) lo_total_dia,
        ingreso.lo_meta_total
	FROM tmp_objetivo_ing ingreso
	LEFT JOIN tmp_objetivo_egr egreso ON
		ingreso.fecha_factura = egreso.fecha_factura;

	CREATE TEMPORARY TABLE tmp_objetivo_2
	SELECT
		IFNULL(ingreso.fecha_factura, egreso.fecha_factura) fecha_factura,
		IFNULL(IFNULL(ingreso.lo_total_dia, 0) - IFNULL(egreso.lo_total_dia, 0), 0) lo_total_dia,
        ingreso.lo_meta_total
	FROM tmp_objetivo_ing ingreso
	RIGHT JOIN tmp_objetivo_egr egreso ON
		ingreso.fecha_factura = egreso.fecha_factura
	WHERE ingreso.fecha_factura IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_objetivo_2;

    IF @lo_contador = 0 THEN
		SELECT *
        FROM tmp_objetivo_1;
	ELSE
		SELECT *
        FROM tmp_objetivo_1
        UNION
        SELECT *
        FROM tmp_objetivo_2;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
