DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_cxs_comparativa_comisiones_c`(
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
    @nombre:		sp_rep_cxs_comparativa_comisiones_c
	@fecha:			2019/08/25
	@descripción : 	Stored procedure para consultar los cargos por servicio desglosados en tipo.
	@autor : 		Jonathan Ramirez Hernandez
    @cambios :
*/

	DECLARE lo_sucursal					VARCHAR(500) DEFAULT '';
    DECLARE lo_moneda					VARCHAR(100);
    DECLARE lo_total_agencia			DECIMAL(16,2) DEFAULT 0;
    DECLARE lo_total_vendedor			DECIMAL(16,2) DEFAULT 0;

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

	/* TOTAL INGRESOS */
    SET @lo_total_agencia_ing = 0;
    SET @queryagencia_ing = CONCAT(
				'
				SELECT
					IFNULL(SUM(det.comision_agencia',lo_moneda,'), 0)
				INTO
					@lo_total_agencia_ing
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                ',lo_sucursal,'
				AND serv.id_producto = 5
				AND serv.estatus = 1
                AND fac.estatus != 2
				AND fac.tipo_cfdi = ''I''
				AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
				AND fac.fecha_factura <= ''',pr_fecha_fin,''''
					  );

	-- SELECT @queryagencia_ing;
	PREPARE stmt FROM @queryagencia_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @lo_total_agencia_egr = 0;
    SET @queryagencia_egr = CONCAT(
				'
				SELECT
					IFNULL(SUM(det.comision_agencia',lo_moneda,'), 0)
				INTO
					@lo_total_agencia_egr
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                ',lo_sucursal,'
				AND serv.id_producto = 5
				AND serv.estatus = 1
                AND fac.estatus != 2
				AND fac.tipo_cfdi = ''E''
				AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
				AND fac.fecha_factura <= ''',pr_fecha_fin,''''
					  );

	-- SELECT @queryagencia_egr;
	PREPARE stmt FROM @queryagencia_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_total_agencia = (@lo_total_agencia_ing - @lo_total_agencia_egr);

    /* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    /* TOTAL DE CXS */
    SET @lo_total_vendedor_ing = 0;
    SET @queryvendedor_ing = CONCAT(
				'
				SELECT
					IFNULL(SUM(IFNULL(det.comision_titular',lo_moneda,', 0) + IFNULL(det.comision_auxiliar',lo_moneda,',0)), 0)
				INTO
					@lo_total_vendedor_ing
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                ',lo_sucursal,'
				AND serv.id_producto = 5
				AND serv.estatus = 1
                AND fac.estatus != 2
				AND fac.tipo_cfdi = ''I''
				AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
				AND fac.fecha_factura <= ''',pr_fecha_fin,''''
                );

	-- SELECT @queryvendedor_ing;
	PREPARE stmt FROM @queryvendedor_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @lo_total_vendedor_egr = 0;
    SET @queryvendedor_egr = CONCAT(
				'
				SELECT
					IFNULL(SUM(IFNULL(det.comision_titular',lo_moneda,', 0) + IFNULL(det.comision_auxiliar',lo_moneda,',0)), 0)
				INTO
					@lo_total_vendedor_egr
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tc_servicio serv ON
					det.id_servicio = serv.id_servicio
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                ',lo_sucursal,'
				AND serv.id_producto = 5
				AND serv.estatus = 1
                AND fac.estatus != 2
				AND fac.tipo_cfdi = ''E''
				AND fac.fecha_factura >=  ''',pr_fecha_ini,'''
				AND fac.fecha_factura <= ''',pr_fecha_fin,''''
                );

	-- SELECT @queryvendedor_egr;
	PREPARE stmt FROM @queryvendedor_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_total_vendedor = (@lo_total_vendedor_ing - @lo_total_vendedor_egr);

	/* -~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~ */

    SELECT
		lo_total_agencia,
        lo_total_vendedor;

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
