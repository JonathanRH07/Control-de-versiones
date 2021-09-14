DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_reportes_graf_x_mes_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_reportes_graf_x_mes_c
	@fecha:			01/09/2019
	@descripcion:	SP para llenar el primer recuadro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_moneda					VARCHAR(100);
    DECLARE lo_sucursal					VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_reportes_indicadores_c';
	END;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
        SET lo_moneda = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
        SET lo_moneda = '/tipo_cambio_usd';
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

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_reporte_x_mes_ing;
    DROP TABLE IF EXISTS tmp_reporte_x_mes_egr;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @querying = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_reporte_x_mes_ing
					SELECT
						fac.fecha_factura,
						IFNULL(SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')), 0) total
					FROM ic_fac_tr_factura fac
                    JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND fac.estatus != 2
					AND fac.tipo_cfdi = ''I''
					AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					GROUP BY fac.fecha_factura');


	-- SELECT @querying;
	PREPARE stmt FROM @querying;
	EXECUTE stmt;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @queryegr = CONCAT(
					'
                    CREATE TEMPORARY TABLE tmp_reporte_x_mes_egr
					SELECT
						fac.fecha_factura,
						IFNULL(SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')), 0) total
					FROM ic_fac_tr_factura fac
                    JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND fac.estatus != 2
					AND fac.tipo_cfdi = ''E''
					AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					GROUP BY fac.fecha_factura');


    -- SELECT @queryegr;
	PREPARE stmt FROM @queryegr;
	EXECUTE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		ing.fecha_factura,
		(IFNULL(ing.total, 0) - IFNULL(egr.total, 0)) neto
	FROM tmp_reporte_x_mes_ing ing
	LEFT JOIN tmp_reporte_x_mes_egr egr ON
		ing.fecha_factura = egr.fecha_factura;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
