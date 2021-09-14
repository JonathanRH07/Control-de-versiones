DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_cxs_ingresos_netos_costo_promedio_c`(
	IN 	pr_id_grupo_empresa 			INT,
    -- IN  pr_periodo						ENUM('DIARIO', 'SEMANAL', 'MENSUAL', 'BIMESTRAL', 'TRIMESTRAL', 'SEMESTRAL', 'ANUAL'),
    IN 	pr_id_sucursal					INT,
    IN  pr_id_moneda					INT,
    IN	pr_fecha_ini					DATE,
	IN	pr_fecha_fin					DATE,
    OUT	pr_message						VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_rep_cxs_ingresos_netos_costo_promedio_c
	@fecha:			2019/09/01
	@descripción : 	Stored procedure para consultar los cargos por servicio desglosados en tipo.
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

    DECLARE lo_sucursal					VARCHAR(500) DEFAULT '';
    DECLARE lo_moneda					VARCHAR(100);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_cxs_comparativa_comisiones_c';
	END ;

    /* VALIDAMOS SI SE CONSULTA UNA SUCURSAL EN ESPECIFICO */
    IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

    /* VALIDAMOS EL TIPO DE MONEDA QUE SE OBTIENE EL REPORTE */
    IF pr_id_moneda = 149 THEN -- DOLARES
		SET lo_moneda = '/tipo_cambio_usd';
	ELSEIF pr_id_moneda = 49 THEN -- EUROS
		SET lo_moneda = '/tipo_cambio_eur';
	ELSE -- MONEDA NACIONAL
		SET lo_moneda = '';
    END IF;

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    DROP TABLE IF EXISTS tmp_netos_ingreso;
    DROP TABLE IF EXISTS tmp_netos_egreso;
    DROP TABLE IF EXISTS tmp_neto_total;

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

	SET @querytabla = CONCAT(
						'
                        CREATE TEMPORARY TABLE tmp_netos_ingreso
                        SELECT
							serv.id_servicio,
							IFNULL(((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento',lo_moneda,')), 0) total_importe,
							IFNULL(COUNT(*), 0) no_cargos,
							IFNULL(((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento',lo_moneda,')), 0) total_ingresos,
							IFNULL(SUM((comision_titular',lo_moneda,') + (comision_auxiliar',lo_moneda,')), 0) comision_neta
						FROM ic_cat_tc_servicio serv
						JOIN ic_fac_tr_factura_detalle det ON
							serv.id_servicio = det.id_servicio
						JOIN ic_fac_tr_factura fac ON
							det.id_factura = fac.id_factura
						WHERE serv.id_producto = 5
						AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND serv.estatus = 1
                        AND fac.estatus != 2
						AND fac.tipo_cfdi = ''I''
						AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
						AND fac.fecha_factura <= ''',pr_fecha_fin,'''');

	-- SELECT @querytabla;
	PREPARE stmt FROM @querytabla;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @querytabla2 = CONCAT(
						'
                        CREATE TEMPORARY TABLE tmp_netos_egreso
                        SELECT
							serv.id_servicio,
							IFNULL(((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento',lo_moneda,')), 0) total_importe,
							IFNULL(COUNT(*), 0) no_cargos,
							IFNULL(((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento',lo_moneda,')), 0) total_ingresos,
							IFNULL(SUM((comision_titular',lo_moneda,') + (comision_auxiliar',lo_moneda,')), 0) comision_neta
						FROM ic_cat_tc_servicio serv
						JOIN ic_fac_tr_factura_detalle det ON
							serv.id_servicio = det.id_servicio
						JOIN ic_fac_tr_factura fac ON
							det.id_factura = fac.id_factura
						WHERE serv.id_producto = 5
						AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND serv.estatus = 1
                        AND fac.estatus != 2
						AND fac.tipo_cfdi = ''E''
						AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
						AND fac.fecha_factura <= ''',pr_fecha_fin,'''');

	-- SELECT @querytabla2;
	PREPARE stmt FROM @querytabla2;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	CREATE TEMPORARY TABLE tmp_neto_total
	SELECT
		IFNULL(IFNULL(ingreso.total_importe, 0) - IFNULL(egreso.total_importe, 0), 0.00) total_importe,
		IFNULL(IFNULL(ingreso.no_cargos, 0) - IFNULL(egreso.no_cargos, 0), 0) no_cargos,
		IFNULL(IFNULL(ingreso.total_ingresos, 0) - IFNULL(egreso.total_ingresos, 0), 0.00) total_ingresos,
		IFNULL(IFNULL(ingreso.comision_neta, 0) - IFNULL(egreso.comision_neta, 0) , 0.00) comision_neta
	FROM tmp_netos_ingreso ingreso
	LEFT JOIN tmp_netos_egreso egreso ON
		ingreso.id_servicio = egreso.id_servicio;

	SELECT
		IFNULL(total_importe, 0.00) total_importe,
		IFNULL(no_cargos, 0) no_cargos,
		IFNULL(IFNULL(total_importe, 0.00) / IFNULL(no_cargos, 0), 0.00) costo_promedio,
		IFNULL(total_ingresos, 0.00) total_ingresos,
		IFNULL(comision_neta, 0.00) comision_neta,
		IFNULL((IFNULL(total_ingresos, 0.00) - IFNULL(comision_neta, 0.00)), 0.00) ingresos_netos_x_cargos
	FROM tmp_neto_total;

	/* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
