DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_cxs_cargos_x_tipo_c`(
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
    @nombre:		sp_rep_cxs_cargos_x_tipo_c
	@fecha:			2019/08/15
	@descripción : 	Stored procedure para consultar los cargos por servicio desglosados en tipo.
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

    DECLARE lo_sucursal					VARCHAR(500) DEFAULT '';
    DECLARE lo_moneda					VARCHAR(100);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_calcula_comision';
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

    /* -------------------------------------------------------------------- */

    DROP TABLE IF EXISTS tmp_ventas_x_tipo_ingreso;
    DROP TABLE IF EXISTS tmp_ventas_x_tipo_egreso;

    /* -------------------------------------------------------------------- */

    /* DESARROLLO */
    SET @query1 = CONCAT(
						'
                        CREATE TEMPORARY TABLE tmp_ventas_x_tipo_ingreso
                        SELECT
							serv.cve_servicio,
							serv.descripcion,
							COUNT(*) no_cargos,
							IFNULL(SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,') - SUM(descuento',lo_moneda,'), 0) total
						FROM ic_cat_tc_servicio serv
						JOIN ic_fac_tr_factura_detalle det ON
							serv.id_servicio = det.id_servicio
						JOIN ic_fac_tr_factura fac ON
							det.id_factura = fac.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND serv.id_producto = 5
						AND serv.estatus = 1','
                        ',lo_sucursal,'
                        AND fac.estatus != 2
                        AND fac.tipo_cfdi = ''I''
                        AND fac.fecha_factura >= ''',pr_fecha_ini,'''
						AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						GROUP BY serv.descripcion'
						);

    -- SELECT @query1;
	PREPARE stmt FROM @query1;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @query2 = CONCAT(
						'
                        CREATE TEMPORARY TABLE tmp_ventas_x_tipo_egreso
                        SELECT
							serv.cve_servicio,
							COUNT(*) no_cargos,
							IFNULL(SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,') - SUM(descuento',lo_moneda,'), 0) total
						FROM ic_cat_tc_servicio serv
						JOIN ic_fac_tr_factura_detalle det ON
							serv.id_servicio = det.id_servicio
						JOIN ic_fac_tr_factura fac ON
							det.id_factura = fac.id_factura
						WHERE serv.id_producto = 5
						AND serv.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND serv.estatus = 1','
                        ',lo_sucursal,'
                        AND fac.estatus != 2
                        AND fac.tipo_cfdi = ''E''
                        AND fac.fecha_factura >= ''',pr_fecha_ini,'''
						AND fac.fecha_factura <= ''',pr_fecha_fin,'''
						GROUP BY serv.descripcion'
						);

    -- SELECT @query2;
	PREPARE stmt FROM @query2;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* -------------------------------------------------------------------- */

    SELECT
		ingreso.cve_servicio,
		ingreso.descripcion,
		(IFNULL(ingreso.no_cargos, 0) - IFNULL(egreso.no_cargos, 0)) no_cargos,
		(IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)) total
	FROM tmp_ventas_x_tipo_ingreso ingreso
	LEFT JOIN tmp_ventas_x_tipo_egreso egreso ON
		ingreso.cve_servicio = egreso.cve_servicio;

    /* -------------------------------------------------------------------- */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
