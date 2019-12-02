DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_comisiones_ventas_x_vendedor_c`(
	IN	pr_id_grupo_empresa		INT,
    IN  pr_id_sucursal			INT,
    IN	pr_id_vendedor			INT,
    IN	pr_tipo_fecha			INT, /* 1-Fecha de emision | 2-Fecha de vencimiento | 3-Fecha de pago */
    IN	pr_fecha_ini			DATE,
    IN	pr_fecha_fin			DATE,
    IN	pr_fecha_pago_ini		DATE, /* SOLO EN CASO DE PAGO (3) */
    IN	pr_fecha_pago_fin		DATE, /* SOLO EN CASO DE PAGO (3) */
    IN	pr_estatus				INT, /* 1-Todas | 2-Pagadas */
    OUT pr_message 	  			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_comisiones_ventas_x_vendedor_c
	@fecha:			10/12/2018
	@descripcion:	Sp para consultar las ventas por vendedor y sus comisiones
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_estatus			VARCHAR(200) DEFAULT '';
    DECLARE lo_vendedor			VARCHAR(200) DEFAULT '';
    DECLARE lo_cxc				VARCHAR(200) DEFAULT '';


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_comisiones_ventas_x_vendedor_c';
	END;

    DROP TABLE IF EXISTS tmp_report_comisiones_egreso;
    DROP TABLE IF EXISTS tmp_report_comisiones_ingreso;

    /* VALIDAR ESTATUS */
	IF pr_estatus = 2 THEN
		SET lo_estatus = ' AND cxc.saldo_facturado = 0';
        SET lo_cxc	   = ' JOIN ic_glob_tr_cxc cxc ON fac.id_factura = cxc.id_factura ';
	END IF;

	/* VALIDAR VENDEDOR */
	IF pr_id_vendedor > 0 AND pr_estatus <> 2 THEN
		SET lo_vendedor	= CONCAT(' AND fac.id_vendedor_tit = ',pr_id_vendedor);
	ELSEIF pr_id_vendedor > 0 AND pr_estatus = 2 THEN
		SET lo_vendedor = CONCAT(' AND cxc.id_vendedor = ',pr_id_vendedor);
    END IF;

	/* INICIO DESARRO0LLO */

	/* TIPO DE FECHA 'EMISION' */
	IF pr_tipo_fecha = 1 THEN

		/* FECHA FACTURA */
		SET @query = CONCAT('CREATE TEMPORARY TABLE tmp_report_comisiones_ingreso
							SELECT
								vend.id_vendedor id_vendedor_tit,
								vend.nombre,
								SUM(total_moneda_base) ventas,
								SUM((comision_agencia) + ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2)) importe_comision,

								SUM(ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2) * ROUND((porc_comision_titular/100),2)) +
								SUM(comision_agencia * ROUND((porc_comision_titular/100),2)) +
								SUM(ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2) * ROUND((porc_comision_auxiliar/100),2)) +
								SUM(comision_agencia * ROUND((porc_comision_auxiliar/100),2)) porcentaje,

								SUM(comision_titular) + SUM(comision_auxiliar) cuota_fija,
								0 meta_venta,

								(SUM((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_titular))/100) +
								SUM(comision_agencia * (porc_comision_titular/100)) +
								SUM((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_auxiliar))/100) +
								SUM(comision_agencia * (porc_comision_auxiliar/100))) + (SUM(comision_titular) + SUM(comision_auxiliar)) comision_neta,

								cuota_minima_monto,
								cve_plan_comision
							FROM ic_fac_tr_factura fac
							JOIN ic_fac_tr_factura_detalle fac_det ON
								fac.id_factura = fac_det.id_factura
							JOIN ic_cat_tr_vendedor vend ON
								fac.id_vendedor_tit = vend.id_vendedor
							JOIN ic_cat_tr_plan_comision plan_comis ON
								vend.id_comision = plan_comis.id_plan_comision ',
							lo_cxc,
							' WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,
							lo_vendedor,
                            lo_estatus,
							' AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                            AND fac.fecha_factura <= ''',pr_fecha_fin,'''
							AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
							AND fac.tipo_cfdi = ''I''
							GROUP BY fac.id_vendedor_tit');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET @query2 = CONCAT('CREATE TEMPORARY TABLE tmp_report_comisiones_egreso
							SELECT
								fac.id_vendedor_tit,
								IFNULL(SUM(total_moneda_base),0) devoluciones
							FROM ic_fac_tr_factura fac
							JOIN ic_fac_tr_factura_detalle fac_det ON
								fac.id_factura = fac_det.id_factura
							JOIN ic_cat_tr_vendedor vend ON
								fac.id_vendedor_tit = vend.id_vendedor
							JOIN ic_cat_tr_plan_comision plan_comis ON
								vend.id_comision = plan_comis.id_plan_comision ',
							lo_cxc,
							' WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,
							lo_vendedor,
                            lo_estatus,
							' AND fac.fecha_factura >= ''',pr_fecha_ini,'''
							AND fac.fecha_factura <= ''',pr_fecha_fin,'''
							AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
							AND fac.tipo_cfdi = ''E''
							GROUP BY fac.id_vendedor_tit');

		-- SELECT @query2;
		PREPARE stmt FROM @query2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SELECT
			ing.id_vendedor_tit id_vendedor,
            ing.nombre vendedor,
			IFNULL(ing.ventas,0) ventas,
			IFNULL(egre.devoluciones,0) devoluciones,
			IFNULL(ing.ventas,0) - IFNULL(egre.devoluciones,0) neto,
            IFNULL(ing.importe_comision,0) importe_comision,
			IFNULL(ing.porcentaje,0) porcentaje,
			IFNULL(ing.cuota_fija,0) cuota_fija,
			IFNULL(ing.meta_venta,0) meta_venta,
			IFNULL(ing.comision_neta,0) comision_neta,
			ing.cve_plan_comision plan_comis,
            IFNULL(ing.cuota_minima_monto,0) couta_minima
		FROM tmp_report_comisiones_ingreso ing
		LEFT JOIN tmp_report_comisiones_egreso egre ON
			ing.id_vendedor_tit = egre.id_vendedor_tit
		ORDER BY 1 ASC;

	/* TIPO DE FECHA 'VENCIMIENTO' */
	ELSEIF pr_tipo_fecha = 2 THEN

		/* TIPO DE FECHA 'VENCIMIENTO' */
		SET @query = CONCAT('CREATE TEMPORARY TABLE tmp_report_comisiones_ingreso
							SELECT
								vend.id_vendedor id_vendedor_tit,
								vend.nombre,
								SUM(total_moneda_base) ventas,
								SUM((comision_agencia) + ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2)) importe_comision,

								SUM(ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2) * ROUND((porc_comision_titular/100),2)) +
								SUM(comision_agencia * ROUND((porc_comision_titular/100),2)) +
								SUM(ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2) * ROUND((porc_comision_auxiliar/100),2)) +
								SUM(comision_agencia * ROUND((porc_comision_auxiliar/100),2)) porcentaje,

								SUM(comision_titular) + SUM(comision_auxiliar) cuota_fija,
								0 meta_venta,

								(SUM((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_titular))/100) +
								SUM(comision_agencia * (porc_comision_titular/100)) +
								SUM((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_auxiliar))/100) +
								SUM(comision_agencia * (porc_comision_auxiliar/100))) + (SUM(comision_titular) + SUM(comision_auxiliar)) comision_neta,

								cuota_minima_monto,
								cve_plan_comision
							FROM ic_fac_tr_factura fac
							JOIN ic_fac_tr_factura_detalle fac_det ON
								fac.id_factura = fac_det.id_factura
							JOIN ic_cat_tr_vendedor vend ON
								fac.id_vendedor_tit = vend.id_vendedor
							JOIN ic_cat_tr_plan_comision plan_comis ON
								vend.id_comision = plan_comis.id_plan_comision
							JOIN ic_glob_tr_cxc cxc ON
								fac.id_factura = cxc.id_factura
							WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_vendedor,'
                            ',lo_estatus,'
							AND cxc.fecha_vencimiento >= ''',pr_fecha_ini,'''
							AND cxc.fecha_vencimiento <= ''',pr_fecha_fin,'''
							AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
							AND fac.tipo_cfdi = ''I''
                            AND DATEDIFF(SYSDATE(),cxc.fecha_vencimiento) > 0
							GROUP BY fac.id_vendedor_tit');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET @query2 = CONCAT('CREATE TEMPORARY TABLE tmp_report_comisiones_egreso
							SELECT
								fac.id_vendedor_tit,
								IFNULL(SUM(total_moneda_base),0) devoluciones
							FROM ic_fac_tr_factura fac
							JOIN ic_fac_tr_factura_detalle fac_det ON
								fac.id_factura = fac_det.id_factura
							JOIN ic_cat_tr_vendedor vend ON
								fac.id_vendedor_tit = vend.id_vendedor
							JOIN ic_cat_tr_plan_comision plan_comis ON
								vend.id_comision = plan_comis.id_plan_comision
							JOIN ic_glob_tr_cxc cxc ON
								fac.id_factura = cxc.id_factura
							WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_vendedor,'
							',lo_estatus,'
							AND cxc.fecha_vencimiento >= ''',pr_fecha_ini,'''
							AND cxc.fecha_vencimiento <= ''',pr_fecha_fin,'''
							AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
							AND fac.tipo_cfdi = ''E''
                            AND DATEDIFF(SYSDATE(),cxc.fecha_vencimiento) > 0
							GROUP BY fac.id_vendedor_tit');

		-- SELECT @query2;
		PREPARE stmt FROM @query2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SELECT
			ing.id_vendedor_tit id_vendedor,
            ing.nombre vendedor,
			IFNULL(ing.ventas,0) ventas,
			IFNULL(egre.devoluciones,0) devoluciones,
			IFNULL(ing.ventas,0) - IFNULL(egre.devoluciones,0) neto,
            IFNULL(ing.importe_comision,0) importe_comision,
			IFNULL(ing.porcentaje,0) porcentaje,
			IFNULL(ing.cuota_fija,0) cuota_fija,
			IFNULL(ing.meta_venta,0) meta_venta,
			IFNULL(ing.comision_neta,0) comision_neta,
			ing.cve_plan_comision plan_comis,
            IFNULL(ing.cuota_minima_monto,0) couta_minima
		FROM tmp_report_comisiones_ingreso ing
		LEFT JOIN tmp_report_comisiones_egreso egre ON
			ing.id_vendedor_tit = egre.id_vendedor_tit
		ORDER BY 1 ASC;


	/* TIPO DE FECHA 'PAGO' */
	ELSEIF  pr_tipo_fecha = 3 THEN

		/* TIPO DE FECHA 'PAGO' */
		SET @query = CONCAT('CREATE TEMPORARY TABLE tmp_report_comisiones_ingreso
							 SELECT
								vend.id_vendedor id_vendedor_tit,
								vend.nombre,
								SUM(total_moneda_base) ventas,
								SUM((comision_agencia) + ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2)) importe_comision,

								SUM(ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2) * ROUND((porc_comision_titular/100),2)) +
								SUM(comision_agencia * ROUND((porc_comision_titular/100),2)) +
								SUM(ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2) * ROUND((porc_comision_auxiliar/100),2)) +
								SUM(comision_agencia * ROUND((porc_comision_auxiliar/100),2)) porcentaje,

								SUM(comision_titular) + SUM(comision_auxiliar) cuota_fija,
								0 meta_venta,

								(SUM((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_titular))/100) +
								SUM(comision_agencia * (porc_comision_titular/100)) +
								SUM((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_auxiliar))/100) +
								SUM(comision_agencia * (porc_comision_auxiliar/100))) + (SUM(comision_titular) + SUM(comision_auxiliar)) comision_neta,

								cuota_minima_monto,
								cve_plan_comision
							FROM ic_fac_tr_factura fac
							JOIN ic_fac_tr_factura_detalle fac_det ON
								fac.id_factura = fac_det.id_factura
							JOIN ic_cat_tr_vendedor vend ON
								fac.id_vendedor_tit = vend.id_vendedor
							JOIN ic_cat_tr_plan_comision plan_comis ON
								vend.id_comision = plan_comis.id_plan_comision
							JOIN ic_glob_tr_cxc cxc ON
								fac.id_factura = cxc.id_factura
							JOIN ic_glob_tr_cxc_detalle cxc_det ON
								cxc.id_cxc = cxc_det.id_cxc
							JOIN ic_fac_tr_pagos pag ON
								cxc_det.id_pago = pag.id_pago
							WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_vendedor,'
                            ',lo_estatus,'
							AND pag.fecha >= ''',pr_fecha_pago_ini,'''
							AND pag.fecha <= ''',pr_fecha_pago_fin,'''
							AND fac.fecha_factura >= ''',pr_fecha_ini,'''
							AND fac.fecha_factura <= ''',pr_fecha_fin,'''
							AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
							AND fac.tipo_cfdi = ''I''
                            AND cxc.saldo_facturado = 0
							GROUP BY fac.id_vendedor_tit');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET @query2 = CONCAT('CREATE TEMPORARY TABLE tmp_report_comisiones_egreso
								SELECT
									fac.id_vendedor_tit,
									IFNULL(SUM(total_moneda_base),0) devoluciones
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle fac_det ON
									fac.id_factura = fac_det.id_factura
								JOIN ic_cat_tr_vendedor vend ON
									fac.id_vendedor_tit = vend.id_vendedor
								JOIN ic_cat_tr_plan_comision plan_comis ON
									vend.id_comision = plan_comis.id_plan_comision
								JOIN ic_glob_tr_cxc cxc ON
									fac.id_factura = cxc.id_factura
								JOIN ic_glob_tr_cxc_detalle cxc_det ON
									cxc.id_cxc = cxc_det.id_cxc
								JOIN ic_fac_tr_pagos pag ON
									cxc_det.id_pago = pag.id_pago
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_vendedor,'
								',lo_estatus,'
								AND pag.fecha >= ''',pr_fecha_pago_ini,'''
								AND pag.fecha <= ''',pr_fecha_pago_fin,'''
								AND fac.fecha_factura >= ''',pr_fecha_ini,'''
								AND fac.fecha_factura <= ''',pr_fecha_fin,'''
								AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
								AND fac.tipo_cfdi = ''E''
                                AND cxc.saldo_facturado = 0
								GROUP BY fac.id_vendedor_tit');

		-- SELECT @query2;
		PREPARE stmt FROM @query2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SELECT
			ing.id_vendedor_tit id_vendedor,
            ing.nombre vendedor,
			IFNULL(ing.ventas,0) ventas,
			IFNULL(egre.devoluciones,0) devoluciones,
			IFNULL(ing.ventas,0) - IFNULL(egre.devoluciones,0) neto,
            IFNULL(ing.importe_comision,0) importe_comision,
			IFNULL(ing.porcentaje,0) porcentaje,
			IFNULL(ing.cuota_fija,0) cuota_fija,
			IFNULL(ing.meta_venta,0) meta_venta,
			IFNULL(ing.comision_neta,0) comision_neta,
			ing.cve_plan_comision plan_comis,
            IFNULL(ing.cuota_minima_monto,0) couta_minima
		FROM tmp_report_comisiones_ingreso ing
		LEFT JOIN tmp_report_comisiones_egreso egre ON
			ing.id_vendedor_tit = egre.id_vendedor_tit
		ORDER BY 1 ASC;

	END IF;

    /* FIN DESARROLLO */

    /* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
