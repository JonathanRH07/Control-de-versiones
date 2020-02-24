DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_comisiones_prod_serv_c`(
	IN	pr_id_grupo_empresa		INT,
    IN	pr_id_sucursal			INT,
    IN	pr_id_vendedor			INT,
    IN	pr_tipo_fecha			INT, /* 1-Fecha de emision | 2-Fecha de vencimiento | 3-Fecha de pago */
    IN	pr_fecha_ini			DATE,
    IN	pr_fecha_fin			DATE,
    IN	pr_fecha_pago_ini		DATE, /* SOLO EN CASO DE PAGO (3) */
    IN	pr_fecha_pago_fin		DATE, /* SOLO EN CASO DE PAGO (3) */
    IN	pr_estatus				INT, /* 1-Todas | 2-Pagadas | 3-Pagadas con descuento */
    -- IN	pr_incluir_desc			INT,
    -- IN	pr_saldo				DECIMAL(16,4),
    OUT pr_message 	  			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_comisiones_prod_serv_c
	@fecha:			10/12/2018
	@descripcion:	Sp para consultar las ventas por vendedor y sus comisiones
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_estatus			VARCHAR(200) DEFAULT '';
    DECLARE lo_id_sucursal		VARCHAR(200) DEFAULT '';
    DECLARE lo_vendedor			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_comisiones_prod_serv_c';
	END;

    /* VALIDAR ESTATUS */
	IF pr_estatus > 0 THEN
		IF pr_estatus = 2 THEN
			SET lo_estatus = ' AND cxc.saldo_facturado = 0';
		END IF;
	END IF;

	/* VALIDAR VENDEDOR */
	IF pr_id_vendedor > 0 THEN
		SET lo_vendedor	= CONCAT(' AND fac.id_vendedor_tit = ',pr_id_vendedor);
	ELSEIF pr_id_vendedor > 0 AND pr_estatus = 2 THEN
		SET lo_vendedor = CONCAT(' AND cxc.id_vendedor = ',pr_id_vendedor);
    END IF;

	/* INICIO DESARRO0LLO */
    IF pr_tipo_fecha > 0 THEN
		/* TIPO DE FECHA 'EMISION' */
		IF pr_tipo_fecha = 1 THEN

            IF pr_id_sucursal != 0 THEN
				SET lo_id_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
			END IF;

            SET @query = CONCAT('SELECT
									serv.descripcion,
									SUM(fac.total_moneda_base) total
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_cat_tr_vendedor ven ON
									fac.id_vendedor_tit = ven.id_vendedor
								JOIN ic_cat_tr_plan_comision plan ON
									ven.id_comision = plan.id_plan_comision
								JOIN ic_glob_tr_cxc cxc ON
									fac.id_factura = cxc.id_factura
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                                ',lo_id_sucursal,'
								',lo_vendedor,'
								AND fac.fecha_factura >= ''',pr_fecha_ini,'''
								AND fac.fecha_factura <= ''',pr_fecha_fin,'''
                                AND (plan.fecha_ini >= ''',pr_fecha_ini,''' OR plan.fecha_fin <= ''',pr_fecha_fin,''')
                                ',lo_estatus,'
                                GROUP BY det.id_servicio
								ORDER BY SUM(fac.total_moneda_base) DESC');

			-- SELECT @query;
			PREPARE stmt FROM @query;
			EXECUTE stmt;

        /* TIPO DE FECHA 'VENCIMIENTO' */
		ELSEIF pr_tipo_fecha = 2 THEN

			IF pr_id_sucursal != 0 THEN
				SET lo_id_sucursal = CONCAT('AND cxc.id_sucursal = ',pr_id_sucursal);
			END IF;

			SET @query = CONCAT('SELECT
									serv.descripcion,
									SUM(fac.total_moneda_base) total
								FROM ic_glob_tr_cxc cxc
								JOIN ic_glob_tr_cxc_detalle cxc_det ON
									cxc.id_cxc = cxc_det.id_cxc
								JOIN ic_cat_tr_vendedor ven ON
									cxc.id_vendedor = ven.id_vendedor
								JOIN ic_cat_tr_plan_comision plan ON
									ven.id_comision = plan.id_plan_comision
								JOIN ic_fac_tr_factura fac ON
									cxc.id_factura = fac.id_factura
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
                                 WHERE cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
                                 ',lo_id_sucursal,'
                                 ',lo_vendedor,'
								 AND cxc.fecha_vencimiento >= ''',pr_fecha_ini,'''
								 AND cxc.fecha_vencimiento <= ''',pr_fecha_fin,'''
                                 AND (plan.fecha_ini >= ''',pr_fecha_ini,''' OR plan.fecha_fin <= ''',pr_fecha_fin,''')
                                 ',lo_estatus,'
                                 GROUP BY det.id_servicio
								 ORDER BY SUM(fac.total_moneda_base) DESC');

			-- SELECT @query;
			PREPARE stmt FROM @query;
			EXECUTE stmt;

        /* TIPO DE FECHA 'PAGO' */
		ELSEIF  pr_tipo_fecha = 3 THEN

			IF pr_id_sucursal != 0 THEN
				SET lo_id_sucursal = CONCAT('AND cxc.id_sucursal = ',pr_id_sucursal);
			END IF;

			SET @query = CONCAT('SELECT
									serv.descripcion,
									SUM(fac.total_moneda_base) total
								FROM ic_fac_tr_pagos pag
								JOIN ic_fac_tr_pagos_detalle det ON
									pag.id_pago = det.id_pago
								JOIN ic_glob_tr_cxc cxc ON
									det.id_cxc = cxc.id_cxc
								JOIN ic_glob_tr_cxc_detalle cxc_det ON
									cxc.id_cxc = cxc.id_cxc
								JOIN ic_cat_tr_vendedor ven ON
									cxc.id_vendedor = ven.id_vendedor
								JOIN ic_cat_tr_plan_comision plan ON
									ven.id_comision = plan.id_plan_comision
								JOIN ic_fac_tr_factura fac ON
									cxc.id_factura = fac.id_factura
								JOIN ic_fac_tr_factura_detalle fac_det ON
									fac.id_factura = fac_det.id_factura
								JOIN ic_cat_tc_servicio serv ON
									fac_det.id_servicio = serv.id_servicio
								WHERE cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_id_sucursal,'
								',lo_vendedor,'
								AND pag.fecha >= ''',pr_fecha_pago_ini,'''
								AND pag.fecha <= ''',pr_fecha_pago_fin,'''
                                AND fac.fecha_factura >= ''',pr_fecha_ini,'''
                                AND fac.fecha_factura <= ''',pr_fecha_fin,'''
								AND (plan.fecha_ini >= ''',pr_fecha_ini,''' OR plan.fecha_fin <= ''',pr_fecha_fin,''')
								',lo_estatus,'
								GROUP BY fac_det.id_servicio
								ORDER BY SUM(fac.total_moneda_base) DESC');

			-- SELECT @query;
			PREPARE stmt FROM @query;
			EXECUTE stmt;
        END IF;
    END IF;

    /* FIN DESARROLLO */

    /* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
