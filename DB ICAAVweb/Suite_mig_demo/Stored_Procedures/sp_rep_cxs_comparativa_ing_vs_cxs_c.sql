DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_cxs_comparativa_ing_vs_cxs_c`(
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
    @nombre:		sp_rep_cxs_comparativa_ing_vs_cxs_c
	@fecha:			2019/08/25
	@descripción : 	Stored procedure para consultar los cargos por servicio desglosados en tipo.
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

	DECLARE lo_sucursal					VARCHAR(500) DEFAULT '';
    DECLARE lo_moneda					VARCHAR(100);
    DECLARE lo_total_ingresos			DECIMAL(16,2) DEFAULT 0;
    DECLARE lo_total_cargos				DECIMAL(16,2) DEFAULT 0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_cxs_comparativa_ing_vs_cxs_c';
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

	/* TOTAL INGRESOS */
    SET @lo_total_ingresos1 = 0;
    SET @queryingresos1 = CONCAT(
				'
				SELECT
					IFNULL(SUM(det.comision_agencia',lo_moneda,'), 0)
				INTO
					@lo_total_ingresos1
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                ',lo_sucursal,'
                AND serv.id_producto != 5
                AND serv.estatus = 1
                AND fac.estatus != 2
				AND fac.tipo_cfdi = ''I''
				AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
				AND fac.fecha_factura <= ''',pr_fecha_fin,''''
					  );

    -- SELECT @queryingresos1;
	PREPARE stmt FROM @queryingresos1;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @lo_total_ingresos2 = 0;
    SET @queryingresos2 = CONCAT(
				'
				SELECT
					IFNULL(SUM(det.comision_agencia',lo_moneda,'), 0)
				INTO
					@lo_total_ingresos2
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                ',lo_sucursal,'
                AND serv.id_producto != 5
                AND serv.estatus = 1
                AND fac.estatus != 2
				AND fac.tipo_cfdi = ''E''
				AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
				AND fac.fecha_factura <= ''',pr_fecha_fin,''''
					  );

    -- SELECT @queryingresos2;
	PREPARE stmt FROM @queryingresos2;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_total_ingresos = (@lo_total_ingresos1 - @lo_total_ingresos2);

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    /* TOTAL DE CXS */
    SET @lo_total_cargos1 = 0;
    SET @querycxs1 = CONCAT(
				'
				SELECT
					IFNULL((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento),0)
				INTO
					@lo_total_cargos1
				FROM ic_cat_tc_servicio serv
				JOIN ic_fac_tr_factura_detalle det ON
					serv.id_servicio = det.id_servicio
				JOIN ic_fac_tr_factura fac ON
					det.id_factura = fac.id_factura
				WHERE serv.id_producto = 5
				AND serv.id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND serv.estatus = 1','
                ',lo_sucursal,'
                AND fac.tipo_cfdi = ''I''
				AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
				AND fac.fecha_factura <= ''',pr_fecha_fin,''''
                );

	-- SELECT @querycxs;
	PREPARE stmt FROM @querycxs1;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @lo_total_cargos2 = 0;
    SET @querycxs2 = CONCAT(
				'
				SELECT
					IFNULL((SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,'))- SUM(descuento),0)
				INTO
					@lo_total_cargos2
				FROM ic_cat_tc_servicio serv
				JOIN ic_fac_tr_factura_detalle det ON
					serv.id_servicio = det.id_servicio
				JOIN ic_fac_tr_factura fac ON
					det.id_factura = fac.id_factura
				WHERE serv.id_producto = 5
				AND serv.id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND serv.estatus = 1','
                ',lo_sucursal,'
                AND fac.tipo_cfdi = ''E''
				AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
				AND fac.fecha_factura <= ''',pr_fecha_fin,''''
                );

	-- SELECT @querycxs2;
	PREPARE stmt FROM @querycxs2;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_total_cargos = (@lo_total_cargos1 - @lo_total_cargos2);

	/* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    SELECT
		lo_total_ingresos,
        lo_total_cargos;

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
