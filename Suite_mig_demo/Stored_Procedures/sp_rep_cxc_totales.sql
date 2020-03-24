DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_cxc_totales`(
	IN  pr_id_grupo_empresa			INT,
	IN  pr_fecha_ini				DATE,
	IN  pr_fecha_fin				DATE,
    IN  pr_pagos_hasta				DATE,
    IN  pr_moneda	    			CHAR(5) ,
	IN  pr_id_sucursal				INT,
	IN  pr_tipo_reporte				VARCHAR(100),
	IN  pr_id_corporativo			INT,
	IN  pr_id_cliente				INT,
    IN  pr_id_vendedor				INT,
    IN  pr_tipo_informa				VARCHAR(25),
    IN  pr_agrupado					VARCHAR(100),
    IN  pr_estatus					VARCHAR(100),
    OUT pr_message 					TEXT)
BEGIN
/*
	@nombre:		sp_rep_cxc_totales
	@fecha: 		18/05/2018
	@descripción: 	Sp para obtenber los totales para los reportes de CxC
	@autor : 		Rafael Quezada
	@cambios:
*/
    DECLARE lo_rango_fechas 		CHAR(100) DEFAULT '';
    DECLARE lo_gro_empre 			CHAR(45) DEFAULT '';
    DECLARE lo_moneda 				CHAR(45) DEFAULT '';
    DECLARE lo_sucursal 			CHAR(45) DEFAULT '';
    DECLARE lo_corporativo 			CHAR(45) DEFAULT '';
	DECLARE lo_cliente 				CHAR(45) DEFAULT '';
    DECLARE lo_vendedor 			CHAR(45) DEFAULT '';
	DECLARE li_cxcdven1				INTEGER;
    DECLARE li_cxcdven2 			INTEGER;
    DECLARE li_cxcdven3 			INTEGER;
    DECLARE li_cxcdven4 			INTEGER;
    DECLARE li_cxcdven5 			INTEGER;
    DECLARE li_cxcdven6 			INTEGER;
	DECLARE li_cxcdven7 			INTEGER;
	DECLARE lo_ven1 				CHAR(250) DEFAULT '';
    DECLARE lo_ven2 				CHAR(250) DEFAULT '';
    DECLARE lo_ven3					CHAR(250) DEFAULT '';
    DECLARE lo_ven4 				CHAR(250) DEFAULT '';
    DECLARE lo_ven5 				CHAR(250) DEFAULT '';
	DECLARE lo_ven6 				CHAR(255) DEFAULT '';
    DECLARE lo_ven7 				CHAR(255) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_cxc_totales';
	END ;

	DROP TEMPORARY TABLE IF EXISTS tmp_pagos_hasta;

    -- Recuperación de dias de vencimeinto
	SELECT
		cxcdven1,
        cxcdven2,
        cxcdven3,
        cxcdven4,
        cxcdven5,
        cxcdven6
	INTO
		li_cxcdven1,
        li_cxcdven2,
        li_cxcdven3,
        li_cxcdven4,
        li_cxcdven5,
        li_cxcdven6
	FROM suite_mig_conf.st_adm_tr_config_admin conf_adm
    JOIN suite_mig_conf.st_adm_tr_grupo_empresa grup_empr ON
		conf_adm.id_empresa = grup_empr.id_empresa
	WHERE grup_empr.id_grupo_empresa = pr_id_grupo_empresa;

	IF pr_moneda = 'USD'  THEN
		SET lo_moneda = ' / tipo_cambio_usd ' ;
    ELSEIF     pr_moneda = 'EUR'  THEN
		SET lo_moneda = ' / tipo_cambio_eur ' ;
	ELSE
        SET lo_moneda = '' ;
	END IF;

	/* 1 */
    IF li_cxcdven1 >  0 THEN
		SET lo_ven1 = CONCAT('
							cxcdven1,','
							','IFNULL(SUM(vencimiento_uno ', lo_moneda ,'), 0) as suma_vencimiento_uno,','
							','IFNULL(SUM(IF(vencimiento_uno > 0 ,1,0)), 0) as facturas_vencimiento_uno, ');
	ELSE
		SET lo_ven1 = CONCAT('
							 1 as dias_excedido,','
							 ','IFNULL(SUM(vencimiento_uno)', lo_moneda ,', 0)  as suma_vencimiento_excedido,','
							 ','IFNULL(SUM(IF(vencimiento_uno <> 0 ,1,0)), 0) as facturas_vencimiento_excedido, ');
	END IF;

    /* 2 */
    IF li_cxcdven2 > 0 THEN
		SET lo_ven2 = CONCAT('
							cxcdven2,','
							','IFNULL(SUM(vencimiento_dos ', lo_moneda ,'), 0) as suma_vencimiento_dos,','
							','IFNULL(SUM(IF(vencimiento_dos <> 0 ,1,0)), 0) as facturas_vencimiento_dos,');
	ELSE
		SET lo_ven2 = CONCAT('
							cxcdven1 + 1 as dias_excedido,','
							','IFNULL(SUM(vencimiento_dos ', lo_moneda ,'), 0) as suma_vencimiento_excedido,','
							','IFNULL(SUM(IF(vencimiento_dos <> 0 ,1,0)), 0) as facturas_vencimiento_excedido,');
	END IF;

	/* 3 */
	IF li_cxcdven3 > 0 THEN
		SET lo_ven3 = CONCAT('
							cxcdven3,','
							','IFNULL(SUM(vencimiento_tres ', lo_moneda ,'), 0) as suma_vencimiento_tres,','
							','IFNULL(SUM(IF(vencimiento_tres <> 0 ,1,0)), 0) as facturas_vencimiento_tres, ');
    ELSE
		SET lo_ven3 = CONCAT('
							cxcdven2 + 1 as dias_excedido,','
							','IFNULL(SUM(vencimiento_tres ', lo_moneda ,'), 0) as suma_vencimiento_excedido,','
							','IFNULL(SUM(IF(vencimiento_tres <> 0 ,1,0)), 0) as facturas_vencimiento_exedido, ');
    END IF;

	/* 4 */
	IF li_cxcdven4 > 0 THEN
		SET lo_ven4 = CONCAT('
							cxcdven4,','
							','IFNULL(SUM(vencimiento_cuatro ', lo_moneda ,'), 0) as suma_vencimiento_cuatro,','
							','IFNULL(SUM(IF(vencimiento_cuatro <> 0 ,1,0)), 0) as facturas_vencimiento_cuatro,');
	ELSE
		SET lo_ven4 = CONCAT(
							'cxcdven3 + 1 as dias_excedido,','
							','IFNULL(SUM(vencimiento_cuatro ', lo_moneda ,'), 0) as suma_vencimiento_excedido,','
							','IFNULL(SUM(IF(vencimiento_cuatro <> 0 ,1,0)), 0) as facturas_vencimiento_exedido,');
	END IF;

    /* 5 */
    IF li_cxcdven5 > 0 THEN
		SET lo_ven5 = CONCAT(
							'cxcdven5,','
							','IFNULL(SUM(vencimiento_cinco ', lo_moneda ,'), 0) as suma_vencimiento_cinco,','
							','IFNULL(SUM(IF(vencimiento_cinco <> 0 ,1,0)), 0) as facturas_vencimiento_cinco,');
	ELSE
		SET lo_ven5 = CONCAT(
							'cxcdven4 + 1 as dias_excedido,','
							','IFNULL(SUM(vencimiento_cinco ', lo_moneda ,'), 0) as suma_vencimiento_excedido,','
							','IFNULL(SUM(IF(vencimiento_cinco <> 0 ,1,0)), 0) as facturas_vencimiento_excedido,');
    END IF;

    /* 6 */
	IF li_cxcdven6 > 0 THEN
		SET lo_ven6  = CONCAT(
							'cxcdven6,','
							','IFNULL(SUM(vencimiento_seis ', lo_moneda ,'), 0) as suma_vencimiento_seis,','
							','IFNULL(SUM(IF(vencimiento_seis <> 0 ,1,0)), 0) as facturas_vencimiento_seis,');

		SET lo_ven7 = CONCAT(
							'cxcdven6 + 1 as dias_excedido,','
							','IFNULL(SUM(vencimiento_siete ', lo_moneda ,'), 0) as suma_vencimiento_excedido,','
							','IFNULL(SUM(IF(vencimiento_siete <> 0 ,1,0)), 0) as facturas_vencimiento_excedido,');
	ELSE
		SET lo_ven6 = CONCAT('
							cxcdven5 + 1 as dias_excedido,','
							','IFNULL(SUM(vencimiento_seis ', lo_moneda,'), 0) as suma_vencimiento_excedido,','
							','IFNULL(SUM(IF(vencimiento_seis <> 0 ,1,0)), 0) as facturas_vencimiento_excedido,');

		SET lo_ven7 = CONCAT('
							cxcdven6 + 1 as dias_excedido,','
							','IFNULL(SUM(vencimiento_siete ', lo_moneda ,', 0) as suma_vencimiento_excedido,','
							','IFNULL(SUM(if(vencimiento_siete <> 0 ,1,0)), 0) as facturas_vencimiento_excedido,');
	END IF;


	IF current_date() = pr_pagos_hasta THEN

		IF (pr_id_grupo_empresa > 0 ) AND (pr_id_grupo_empresa IS NOT NULL) THEN
			SET lo_gro_empre = CONCAT('id_grupo_empresa = ', pr_id_grupo_empresa, ' ');
		END IF;

		SET lo_rango_fechas =  CONCAT('AND fecha_emision >= "',   pr_fecha_ini , '" AND fecha_emision <= "', pr_fecha_fin,'" ');

		IF  pr_id_sucursal > 0 AND pr_id_sucursal IS NOT NULL THEN
			SET lo_sucursal = CONCAT('AND id_sucursal = ', pr_id_sucursal, ' ');
		END IF;

		IF  pr_id_cliente > 0 AND pr_id_cliente IS NOT NULL THEN
			SET lo_cliente = CONCAT('AND id_cliente = ', pr_id_cliente, ' ');
		END IF;

		IF  pr_id_corporativo > 0 AND pr_id_corporativo IS NOT NULL THEN
			SET lo_corporativo = CONCAT('AND id_corporativo = ', pr_id_corporativo, ' ');
		END IF;

		IF  pr_id_vendedor > 0 AND pr_id_vendedor IS NOT NULL THEN
			SET lo_vendedor = CONCAT('AND id_vendedor = ', pr_id_vendedor, ' ');
		END IF;

		SET @query = CONCAT('
							SELECT
								IFNULL(SUM(por_vencer', lo_moneda ,'), 0) as suma_por_vencer,
								IFNULL(SUM(if (POR_VENCER > 0 ,1,0)), 0) as facturas_por_vencer, '
								,lo_ven1
								,lo_ven2
								,lo_ven3
								,lo_ven4
								,lo_ven5
								,lo_ven6
								,lo_ven7,'
								IFNULL(SUM( saldo_facturado ', lo_moneda ,'  ), 0) as total_importe,
								IFNULL(SUM(if (saldo_facturado <> 0 ,1,0)), 0) as total_facturas
							FROM antiguedad_saldos
							WHERE estatus = "ACTIVO"
							AND saldo_facturado != 0
							AND ',lo_gro_empre,'
							',lo_rango_fechas,'
							',lo_sucursal,'
							',lo_corporativo,'
							',lo_cliente,'
							',lo_vendedor
				);

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt ;

  ELSE

	IF (pr_id_grupo_empresa > 0 ) AND (pr_id_grupo_empresa IS NOT NULL ) THEN
		SET lo_gro_empre = CONCAT(' ic_glob_tr_cxc.id_grupo_empresa =', pr_id_grupo_empresa, ' ');
	END IF;

    SET lo_rango_fechas =  CONCAT('	AND fecha_emision between "',   pr_fecha_ini , '" and "', pr_fecha_fin,'" ');

	IF  pr_id_sucursal > 0 AND pr_id_sucursal IS NOT NULL THEN
		SET lo_sucursal = CONCAT(' AND ic_glob_tr_cxc.id_sucursal =', pr_id_sucursal, ' ');
	END IF;
	IF  pr_id_cliente > 0 AND pr_id_cliente IS NOT NULL THEN
		SET lo_cliente = CONCAT(' AND ic_glob_tr_cxcid_cliente =', pr_id_cliente, ' ');
	END IF;
	IF  pr_id_corporativo > 0 AND pr_id_corporativo IS NOT NULL THEN
		SET lo_corporativo = CONCAT(' AND id_corporativo =', pr_id_corporativo, ' ');
	END IF;
	IF  pr_id_vendedor > 0 AND pr_id_vendedor IS NOT NULL THEN
		SET lo_vendedor = CONCAT(' AND ic_glob_tr_cxc.id_vendedor =', pr_id_vendedor, ' ');
	END IF;

    SET @query = CONCAT('
						CREATE TEMPORARY TABLE tmp_pagos_hasta
						SELECT
							ic_glob_tr_cxc.id_cxc,
							tipo_cambio_usd,
							tipo_cambio_eur,
							`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven1` AS `cxcdven1`,
							`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven2` AS `cxcdven2`,
							`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven3` AS `cxcdven3`,
							`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven4` AS `cxcdven4`,
							`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven5` AS `cxcdven5`,
							`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven6` AS `cxcdven6`,
							ic_glob_tr_cxc.importe_facturado  + pago_hasta as saldo_facturado,
							(CASE
								WHEN
									( "',   pr_fecha_fin , '"  > CAST(`ic_glob_tr_cxc`.`fecha_vencimiento`
										AS DATE))
								THEN
									(TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`))
								ELSE 0
							END) AS `dias_vencidos`,
							(CASE
								WHEN ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) <= 0) THEN ic_glob_tr_cxc.importe_moneda_base  + pago_hasta
								ELSE 0
							END) AS `por_vencer`,
							(CASE
								WHEN
									((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven1` <> 0)
										AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven1` IS NOT NULL))
								THEN
									(CASE
										WHEN
											(((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > 0)
												AND ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) <= `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven1`))
										THEN
											ic_glob_tr_cxc.importe_moneda_base  + pago_hasta
										ELSE 0
									END)
								ELSE 0
							END) AS `vencimiento_uno`,
							(CASE
								WHEN
									((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven2` <> 0)
										AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven2` IS NOT NULL))
								THEN
									(CASE
										WHEN
											(((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven1`)
												AND ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) <= `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven2`))
										THEN
											ic_glob_tr_cxc.importe_moneda_base  + pago_hasta
										ELSE 0
									END)
								ELSE (CASE
									WHEN
										((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven1` <> 0)
											AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven1` IS NOT NULL))
									THEN
										(CASE
											WHEN ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven1`) THEN `ic_glob_tr_cxc`.`saldo_facturado`
											ELSE 0
										END)
									ELSE 0
								END)
							END) AS `vencimiento_dos`,
							(CASE
								WHEN
									((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven3` <> 0)
										AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven3` IS NOT NULL))
								THEN
									(CASE
										WHEN
											(((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven2`)
												AND ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) <= `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven3`))
										THEN
										ic_glob_tr_cxc.importe_moneda_base  + pago_hasta
										ELSE 0
									END)
								ELSE (CASE
									WHEN
										((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven2` <> 0)
											AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven2` IS NOT NULL))
									THEN
										(CASE
											WHEN ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven2`) THEN `ic_glob_tr_cxc`.`saldo_facturado`
											ELSE 0
										END)
									ELSE 0
								END)
							END) AS `vencimiento_tres`,
							(CASE
								WHEN
									((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven4` <> 0)
										AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven4` IS NOT NULL))
								THEN
									(CASE
										WHEN
											(((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven3`)
												AND ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) <= `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven4`))
										THEN
											ic_glob_tr_cxc.importe_moneda_base  + pago_hasta
										ELSE 0
									END)
								ELSE (CASE
									WHEN
										((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven3` <> 0)
											AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven3` IS NOT NULL))
									THEN
										(CASE
											WHEN ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven3`) THEN `ic_glob_tr_cxc`.`saldo_facturado`
											ELSE 0
										END)
									ELSE 0
								END)
							END) AS `vencimiento_cuatro`,
							(CASE
								WHEN
									((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven5` <> 0)
										AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven5` IS NOT NULL))
								THEN
									(CASE
										WHEN
											(((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven4`)
												AND ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) <= `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven5`))
										THEN
											ic_glob_tr_cxc.importe_moneda_base  + pago_hasta
										ELSE 0
									END)
								ELSE (CASE
									WHEN
										((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven4` <> 0)
											AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven4` IS NOT NULL))
									THEN
										(CASE
											WHEN ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven4`) THEN `ic_glob_tr_cxc`.`saldo_facturado`
											ELSE 0
										END)
									ELSE 0
								END)
							END) AS `vencimiento_cinco`,
							(CASE
								WHEN
									((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven6` <> 0)
										AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven6` IS NOT NULL))
								THEN
									(CASE
										WHEN
											(((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven5`)
												AND ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) <= `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven6`))
										THEN
											ic_glob_tr_cxc.importe_moneda_base  + pago_hasta
										ELSE 0
									END)
								ELSE (CASE
									WHEN
										((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven5` <> 0)
											AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven5` IS NOT NULL))
									THEN
										(CASE
											WHEN ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven5`) THEN ic_glob_tr_cxc.importe_facturado  + pago_hasta
											ELSE 0
										END)
									ELSE 0
								END)
							END) AS `vencimiento_seis`,
							(CASE
								WHEN
									((`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven6` <> 0)
										AND (`suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven6` IS NOT NULL))
								THEN
									(CASE
										WHEN ((TO_DAYS( "',   pr_fecha_fin , '"  ) - TO_DAYS(`ic_glob_tr_cxc`.`fecha_vencimiento`)) > `suite_mig_conf`.`st_adm_tr_config_admin`.`cxcdven6`) THEN ic_glob_tr_cxc.importe_moneda_base  + pago_hasta
										ELSE 0
									END)
								ELSE 0
							END) AS `vencimiento_siete`
						FROM ic_glob_tr_cxc
                        JOIN `ic_cat_tr_cliente` ON
							`ic_glob_tr_cxc`.`id_cliente` = `ic_cat_tr_cliente`.`id_cliente`
						JOIN `ic_cat_tr_vendedor` ON
							`ic_glob_tr_cxc`.`id_vendedor` = `ic_cat_tr_vendedor`.`id_vendedor`
						LEFT JOIN `ic_cat_tr_corporativo` ON
							`ic_cat_tr_cliente`.`id_corporativo` = `ic_cat_tr_corporativo`.`id_corporativo`
						JOIN `suite_mig_conf`.`st_adm_tr_grupo_empresa` ON
							`ic_glob_tr_cxc`.`id_grupo_empresa` = `suite_mig_conf`.`st_adm_tr_grupo_empresa`.`id_grupo_empresa`
						JOIN `suite_mig_conf`.`st_adm_tr_config_admin` ON
							`suite_mig_conf`.`st_adm_tr_grupo_empresa`.`id_empresa` = `suite_mig_conf`.`st_adm_tr_config_admin`.`id_empresa`
						JOIN (SELECT
								cxc_2.id_cxc,
								SUM(ifnull(detalle_2.importe_moneda_base,0)) as pago_hasta
							  FROM ic_glob_tr_cxc cxc_2
							  LEFT OUTER JOIN ic_glob_tr_cxc_detalle detalle_2 ON
								cxc_2.id_cxc = detalle_2.id_cxc AND
								detalle_2.fecha <=  "', pr_pagos_hasta , '" AND
								detalle_2.estatus = "ACTIVO"
							 GROUP BY cxc_2.id_cxc )as pagos_hasta ON
							ic_glob_tr_cxc.id_cxc =  pagos_hasta.id_cxc
						WHERE  ic_glob_tr_cxc.estatus = "ACTIVO"
                        AND ic_glob_tr_cxc.importe_moneda_base  + pago_hasta <> 0
                        AND ',lo_gro_empre,
							lo_rango_fechas,
							lo_sucursal,
                            lo_corporativo,
                            lo_cliente,
                            lo_vendedor
						);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	SET @query2 = CONCAT('
						SELECT
							IFNULL(SUM( por_vencer', lo_moneda ,' ), 0) as suma_por_vencer,
							IFNULL(SUM( if (por_vencer > 0 ,1,0)), 0) as facturas_por_vencer, ',
							lo_ven1,lo_ven2, lo_ven3, lo_ven4, lo_ven5,lo_ven6, lo_ven7,
							'IFNULL(SUM( saldo_facturado ', lo_moneda ,'  ), 0) as total_importe,
							IFNULL(SUM(if (saldo_facturado <> 0 ,1,0)), 0) as total_facturas
						FROM tmp_pagos_hasta ');

	-- SELECT @query2;
    PREPARE stmt FROM @query2;
  	EXECUTE stmt;

  END IF;

   # Mensaje de ejecucion.
   SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
