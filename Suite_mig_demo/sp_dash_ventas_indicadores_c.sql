DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_ventas_indicadores_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_ventas_indicadores_c
	@fecha:			18/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda					VARCHAR(100);
    DECLARE lo_moneda2					VARCHAR(100) DEFAULT '';
    DECLARE lo_moneda3					VARCHAR(100) DEFAULT '';
    DECLARE lo_monto_total_ventas		DECIMAL(18,2) DEFAULT 0;
    DECLARE lo_meta_ventas_totales		DECIMAL(18,2) DEFAULT 0;
    DECLARE lo_comision_neta_ing		DECIMAL(18,2) DEFAULT 0;
    DECLARE lo_comision_neta_egr		DECIMAL(18,2) DEFAULT 0;
    DECLARE lo_comision_neta			DECIMAL(18,2) DEFAULT 0;
    DECLARE lo_importe_cobrado			DECIMAL(18,2) DEFAULT 0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_ventas_indicadores_c';
	END;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda = 'SUM(venta_neta_usd)';
        SET lo_moneda2 = '/fac.tipo_cambio_usd';
        SET lo_moneda3 = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda = 'SUM(venta_neta_eur)';
        SET lo_moneda2 = '/fac.tipo_cambio_eur';
        SET lo_moneda3 = '/tipo_cambio_usd';
	ELSE
		SET lo_moneda = 'SUM(venta_neta_moneda_base)';
    END IF;

    SET @query_moneda = CONCAT(
				'
				SELECT
					IFNULL(tipo_cambio, 0)
				INTO
					@lo_tipo_cambio
				FROM suite_mig_conf.st_adm_tr_config_moneda
				WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND id_moneda = ',pr_moneda_reporte);

	-- SELECT @query_moneda;
	PREPARE stmt FROM @query_moneda;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


	/* ~~~~~~~~~~~~~~~~~~~~ MONTO TOTAL DE VENTAS ~~~~~~~~~~~~~~~~~~~~ */

    /* INGRESO */
    SET @lo_monto_total_ventas_ing = 0;
    SET @query_ing = CONCAT(
						'
                        SELECT
							IFNULL(SUM((IFNULL(tarifa_moneda_base',lo_moneda3,', 0.00) + IFNULL(importe_markup',lo_moneda3,', 0.00)) - IFNULL(descuento',lo_moneda3,', 0.00)),0.00) venta_neta_mes
						INTO
							@lo_monto_total_ventas_ing
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE id_grupo_empresa =  ',pr_id_grupo_empresa,'
						AND id_sucursal = ',pr_id_sucursal,'
                        AND fac.estatus != 2
                        AND tipo_cfdi = ''I''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')'
						);

    -- SELECT @query_ing;
	PREPARE stmt FROM @query_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* EGRESO */
    SET @lo_monto_total_ventas_egr = 0;
    SET @query_egr = CONCAT(
						'
                        SELECT
							IFNULL(SUM((IFNULL(tarifa_moneda_base',lo_moneda3,', 0.00) + IFNULL(importe_markup',lo_moneda3,', 0.00)) - IFNULL(descuento',lo_moneda3,', 0.00)),0.00) venta_neta_mes
						INTO
							@lo_monto_total_ventas_egr
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE id_grupo_empresa =  ',pr_id_grupo_empresa,'
						AND id_sucursal = ',pr_id_sucursal,'
                        AND fac.estatus != 2
                        AND tipo_cfdi = ''E''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')'
						);

    -- SELECT @query_egr;
	PREPARE stmt FROM @query_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_monto_total_ventas = (@lo_monto_total_ventas_ing - @lo_monto_total_ventas_egr);

    /* ~~~~~~~~~~~~~~~~~~~~ META DE VENTAS TOTALES (PENDIENTE) ~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		IFNULL(SUM(meta_mes.meta/@lo_tipo_cambio), 0)
	INTO
		lo_meta_ventas_totales
	FROM ic_cat_tr_meta_venta meta
	JOIN ic_cat_tr_meta_venta_tipo meta_tipo ON
		meta.id_meta_venta = meta_tipo.id_meta_venta
	JOIN ic_cat_tr_meta_venta_meses meta_mes ON
		meta_tipo.id_meta_venta_tipo = meta_mes.id_meta_venta_tipo
	WHERE meta.id_grupo_empresa = pr_id_grupo_empresa
	AND meta_mes.mes = DATE_FORMAT(NOW(), '%m')
	AND meta_mes.anio = DATE_FORMAT(NOW(), '%Y');

	/* ~~~~~~~~~~~~~~~~~~~~ MONTO TOTAL DE VENTAS ~~~~~~~~~~~~~~~~~~~~ */

    /* COMISION INGRESOS */
    SET @lo_comision_neta_ing = 0;
    SET @querycomising = CONCAT(
						'
						SELECT
							IFNULL(SUM(comision_agencia',lo_moneda2,'), 0.00) comision_neta
						INTO
							@lo_comision_neta_ing
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle fac_det ON
							fac.id_factura = fac_det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                        AND fac.id_sucursal = ',pr_id_sucursal,'
                        AND fac.estatus != 2
						AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') >= DATE_FORMAT(NOW(), ''%Y-%m'')
						AND fac.tipo_cfdi =  ''I'''
						);

	-- SELECT @querycomising;
	PREPARE stmt FROM @querycomising;
	EXECUTE stmt;

    SET lo_comision_neta_ing = @lo_comision_neta_ing;


    /* COMISION EGRESOS */
    SET @lo_comision_neta_egr = 0;
	SET @querycomisegr = CONCAT(
						'
						SELECT
							IFNULL(SUM(comision_agencia',lo_moneda2,'), 0.00) comision_neta
						INTO
							@lo_comision_neta_egr
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle fac_det ON
							fac.id_factura = fac_det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                        AND fac.id_sucursal = ',pr_id_sucursal,'
                        AND fac.estatus != 2
						AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') >= DATE_FORMAT(NOW(), ''%Y-%m'')
						AND fac.tipo_cfdi =  ''E''');

	-- SELECT @querycomisegr;
	PREPARE stmt FROM @querycomisegr;
	EXECUTE stmt;

    SET lo_comision_neta_egr = @lo_comision_neta_egr;

    SET lo_comision_neta = (IFNULL(lo_comision_neta_ing,0) - IFNULL(lo_comision_neta_egr,0));

    /* ~~~~~~~~~~~~~~~~~~~~ IMPORTE COBRADO ~~~~~~~~~~~~~~~~~~~~ */

    SET @lo_importe_cobrado = 0;
    SET @querycxc = CONCAT(
					'
					SELECT
						IFNULL(SUM((detalle.importe_moneda_base * - 1)',lo_moneda3,'), 0) importe_cobrado
					INTO
						@lo_importe_cobrado
					FROM ic_glob_tr_cxc cxc
					JOIN ic_glob_tr_cxc_detalle detalle ON
						cxc.id_cxc = detalle.id_cxc
					WHERE cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
					AND DATE_FORMAT(detalle.fecha, ''%Y-%m'') = DATE_FORMAT(NOW(),''%Y-%m'')
					AND detalle.estatus = ''ACTIVO''
					AND cxc.estatus = ''ACTIVO''
					AND detalle.id_factura IS NULL
					AND cxc.id_sucursal = ',pr_id_sucursal
						);

    -- SELECT @querycxc;
	PREPARE stmt FROM @querycxc;
	EXECUTE stmt;

    SET lo_importe_cobrado = @lo_importe_cobrado;

    /* ~~~~~~~~~~~~~~~~~~~~ CONSULTAR INDICADORES ~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		lo_monto_total_ventas,
        lo_meta_ventas_totales,
        lo_comision_neta,
        lo_importe_cobrado;


	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
