DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_cxc_detalle`(
	IN  pr_id_grupo_empresa			INT,
	IN  pr_fecha_ini				DATE,
	IN  pr_fecha_fin				DATE,
    IN  pr_pagos_hasta				DATE,
    IN  pr_moneda	    			CHAR(5),
	IN  pr_id_sucursal				INT,
	IN  pr_tipo_reporte				VARCHAR(100),
	IN  pr_id_corporativo			INT,
	IN  pr_id_cliente				INT,
    IN  pr_id_vendedor				INT,
    IN  pr_tipo_informa				VARCHAR(25),
    IN  pr_agrupado					VARCHAR(100),
    IN  pr_estatus					VARCHAR(500),
    OUT pr_message 					TEXT)
BEGIN
/*
	@nombre:		sp_rep_cxc_totales
	@fecha: 		22/05/2018
	@descripción: 	Sp para obtenber en detalle los reportes de CxC
	@autor : 		Rafael Quezada
	@cambios:
*/

    DECLARE lo_rango_fechas 		CHAR(100) DEFAULT '';
    DECLARE lo_gro_empre 			CHAR(45)  DEFAULT '';
    DECLARE lo_moneda 				CHAR(45)  DEFAULT '';
    DECLARE lo_sucursal 			CHAR(45)  DEFAULT '';
    DECLARE lo_corporativo 			CHAR(45)  DEFAULT '';
	DECLARE lo_cliente 				CHAR(45)  DEFAULT '';
    DECLARE lo_vendedor 			CHAR(45)  DEFAULT '';
    DECLARE lo_select_fin 			CHAR(200) DEFAULT '';
	DECLARE lo_select  				CHAR(70)  DEFAULT '';
	DECLARE li_cxcdven1				INTEGER;
    DECLARE li_cxcdven2 			INTEGER;
    DECLARE li_cxcdven3 			INTEGER;
    DECLARE li_cxcdven4 			INTEGER;
    DECLARE li_cxcdven5 			INTEGER;
    DECLARE li_cxcdven6 			INTEGER;
	DECLARE li_cxcdven7 			INTEGER;
	DECLARE lo_ven1 				CHAR(200) DEFAULT '';
    DECLARE lo_ven2 				CHAR(200) DEFAULT '';
    DECLARE lo_ven3					CHAR(200) DEFAULT '';
    DECLARE lo_ven4 				CHAR(200) DEFAULT '';
    DECLARE lo_ven5 				CHAR(200) DEFAULT '';
	DECLARE lo_ven6 				CHAR(255) DEFAULT '';
    DECLARE lo_ven7 				CHAR(255) DEFAULT '';
    DECLARE lo_suma     			CHAR(10)  DEFAULT '';
    DECLARE lo_cierra   			CHAR(3)   DEFAULT '';
    DECLARE lo_tabla    			CHAR(20)  DEFAULT '';

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
	FROM suite_mig_conf.st_adm_tr_config_admin 	conf_adm
	JOIN suite_mig_conf.st_adm_tr_grupo_empresa grup_emp ON
		conf_adm.id_empresa = grup_emp.id_empresa
	WHERE grup_emp.id_grupo_empresa = pr_id_grupo_empresa;

    IF current_date() != pr_pagos_hasta THEN
		SET  lo_tabla = 'tmp_pagos_hasta.';
	END IF ;

	-- Si es analitico o concentrado
	IF pr_tipo_informa = 'concentrado' THEN
		SET lo_suma = 'SUM(';
		SET lo_cierra = ') ';
	END IF ;

	IF pr_moneda = 'USD'  THEN
		SET lo_moneda = Concat(' / ', lo_tabla, 'tipo_cambio_usd ' );
	ELSEIF pr_moneda = 'EUR'  THEN
		SET lo_moneda = Concat(' / ', lo_tabla, 'tipo_cambio_eur ' );
	ELSE
        SET lo_moneda = ' ';
	END IF;

	IF li_cxcdven1 >  0 THEN
		SET lo_ven1 = CONCAT(lo_suma ,lo_tabla,'vencimiento_uno ',lo_moneda ,lo_cierra,' vencimiento_uno, ');
	ELSE
		SET lo_ven1 = CONCAT(lo_suma ,lo_tabla,'vencimiento_uno ',lo_moneda ,lo_cierra,' vencimiento_excedido, ');
    END IF;

    IF li_cxcdven2 > 0 THEN
		SET lo_ven2 = CONCAT( lo_suma ,lo_tabla,'vencimiento_dos ',lo_moneda ,lo_cierra,' vencimiento_dos, ');
    ELSE
		SET lo_ven2 = CONCAT( lo_suma ,lo_tabla,'vencimiento_dos ',lo_moneda ,lo_cierra,' vencimiento_excedido, ') ;
    END IF;

	IF li_cxcdven3 > 0 THEN
		SET lo_ven3 = CONCAT( lo_suma ,lo_tabla,'vencimiento_tres ',lo_moneda ,lo_cierra,' vencimiento_tres, ');
    ELSE
		SET lo_ven3 = CONCAT( lo_suma ,lo_tabla,'vencimiento_tres ',lo_moneda ,lo_cierra,' vencimiento_tres, ');
    END IF;

	IF li_cxcdven4 > 0 THEN
		SET lo_ven4 = CONCAT( lo_suma ,lo_tabla,'vencimiento_cuatro ',lo_moneda ,lo_cierra,' vencimiento_cuatro, ');
    ELSE
		SET lo_ven4 = CONCAT( lo_suma ,lo_tabla,'vencimiento_cuatro ',lo_moneda ,lo_cierra,' vencimiento_excedido, ');
    END IF;

	IF li_cxcdven5 > 0 THEN
		SET lo_ven5 = CONCAT( lo_suma ,lo_tabla,'vencimiento_cinco ',lo_moneda ,lo_cierra,' vencimiento_cinco, ');
    ELSE
		SET lo_ven5 = CONCAT( lo_suma ,lo_tabla,'vencimiento_cinco ',lo_moneda , lo_cierra,' vencimiento_excedido, ');
    END IF;

	IF li_cxcdven6 > 0 THEN
		  SET lo_ven6 = CONCAT( lo_suma ,lo_tabla,'vencimiento_seis ',lo_moneda ,lo_cierra,' vencimiento_seis, ');
		  SET lo_ven7 = CONCAT( lo_suma ,lo_tabla,'vencimiento_siete ',lo_moneda ,lo_cierra,' vencimiento_excedido, ');
	ELSE
		SET lo_ven6 = CONCAT( lo_suma ,lo_tabla,'vencimiento_seis ',lo_moneda ,lo_cierra,' vencimiento_excedido, ');
	END IF;

    SET lo_rango_fechas =  CONCAT('AND fecha_emision >= ''',pr_fecha_ini , ''' AND fecha_emision <= ''', pr_fecha_fin,''' ');

    IF  pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND id_sucursal = ', pr_id_sucursal, ' ');
	END IF;
	IF  pr_id_cliente > 0 THEN
		SET lo_cliente = CONCAT('AND id_cliente = ', pr_id_cliente, ' ');
	END IF;
	IF  pr_id_corporativo > 0 THEN
		SET lo_corporativo = CONCAT('AND id_corporativo = ', pr_id_corporativo, ' ');
	END IF;
	IF  pr_id_vendedor > 0 THEN
		SET lo_vendedor = CONCAT('AND id_vendedor = ', pr_id_vendedor, ' ');
	END IF;

    IF pr_tipo_reporte = 'Cliente' THEN
		SET lo_select = CONCAT('cve_cliente cve,','
									','nombre_cliente nombre,');
        IF pr_tipo_informa = 'concentrado' THEN
			SET lo_select_fin = CONCAT('GROUP BY cve','
							    ','ORDER BY cve');
		ELSE
             SET lo_select_fin = CONCAT('GROUP BY cve, razon_social, cve_serie, fac_numero','
								','ORDER BY cve, razon_social, cve_serie, fac_numero');
        END IF;
	ELSEIF pr_tipo_reporte = 'Vendedor' THEN
		SET lo_select = CONCAT('clave cve,','
							        ','nombre_vendedor nombre,');
        IF pr_tipo_informa = 'concentrado' THEN
			 SET lo_select_fin = CONCAT('GROUP BY clave','
								','ORDER BY clave');
		ELSE
			SET lo_select_fin = CONCAT('GROUP BY clave, cve_serie, fac_numero','
								','ORDER BY clave, cve_serie, fac_numero');
		END IF;
	ELSEIF pr_tipo_reporte = 'Vendedor-Cliente' THEN
		SET lo_select = CONCAT('clave cve,','
									','nombre_vendedor nombre,');
        IF pr_tipo_informa = 'concentrado' THEN
			SET lo_select_fin = CONCAT('GROUP BY cve','
							   ','ORDER BY cve');
		ELSE
			SET lo_select_fin = CONCAT('GROUP BY cve, cve_cliente, cve_serie, fac_numero','
								','ORDER BY cve, cve_cliente, cve_serie, fac_numero');
        END IF;
	ELSEIF pr_tipo_reporte = 'Corporativo' THEN
		SET lo_select = CONCAT('cve_corporativo cve,','
									','nom_corporativo nombre,');
		IF pr_tipo_informa = 'concentrado' THEN
			SET lo_select_fin = CONCAT('GROUP BY cve','
							   ','ORDER BY cve');
		ELSE
			SET lo_select_fin = CONCAT('GROUP BY cve , cve_cliente, cve_serie, fac_numero','
								','ORDER BY cve , cve_cliente, cve_serie, fac_numero');
		END IF;
    ELSE
	   SET lo_select   = ''' '','' '',';
       SET  lo_select_fin = 'ORDER BY cve_serie, fac_numero';
    END IF;

	-- Reporte con saldos al día
    -- Configuración o armado de la sección del where
   	IF  current_date() = pr_pagos_hasta THEN
		IF pr_tipo_informa = 'concentrado' THEN
				SET @query = CONCAT('
								SELECT ','
									',lo_select,'
									','SUM(importe_facturado ', lo_moneda ,') importe_facturado,
									SUM(por_vencer ', lo_moneda ,') por_vencer,','
									',lo_ven1,'
									',lo_ven2,'
									',lo_ven3,'
									',lo_ven4,'
									',lo_ven5,'
									',lo_ven6,'
									',lo_ven7,'
									SUM(saldo_facturado ', lo_moneda ,' )saldo_facturado
								FROM antiguedad_saldos
								WHERE estatus =  ''activo''
								AND saldo_facturado > 0
								AND id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_rango_fechas,'
								',lo_moneda,'
								',lo_sucursal,'
								',lo_corporativo,'
								',lo_cliente,'
								',lo_vendedor,'
								',lo_select_fin
								);
		ELSE
			SET @query = CONCAT('
								SELECT ','
									',lo_select,'
									','cve_serie,
									fac_numero,
									razon_social,
									fecha_emision,
									importe_facturado ', lo_moneda ,' importe_facturado ,
									fecha_vencimiento,
									dias_vencidos,
									por_vencer ', lo_moneda ,' por_vencer,','
									',lo_ven1,'
                                    ',lo_ven2,'
                                    ',lo_ven3,'
                                    ',lo_ven4,'
                                    ',lo_ven5,'
                                    ',lo_ven6,'
                                    ',lo_ven7,'
									saldo_facturado ', lo_moneda ,' saldo_facturado ,
                                    antiguedad_saldos.id_cxc
								FROM antiguedad_saldos
                                WHERE estatus = ''activo''
                                AND saldo_facturado != 0
                                AND id_grupo_empresa = ',pr_id_grupo_empresa,'
                                ',lo_rango_fechas,'
                                ',lo_sucursal,'
                                ',lo_corporativo,'
                                ',lo_cliente,'
                                ',lo_vendedor,'
                                ',lo_select_fin);
		 END IF;
	ELSE
     -- Reporte con pagos hasta
		IF pr_tipo_informa = 'concentrado' THEN
			SET @query = CONCAT('
								SELECT ','
									',lo_select,'
									','SUM(importe_facturado ', lo_moneda ,') importe_facturado,
									SUM(tmp_pagos_hasta.por_vencer ', lo_moneda ,' ) por_vencer,','
									',lo_ven1,'
                                    ',lo_ven2,'
                                    ',lo_ven3,'
                                    ',lo_ven4,'
                                    ',lo_ven5,'
                                    ',lo_ven6,'
                                    ',lo_ven7,'
									SUM(tmp_pagos_hasta.saldo_facturado ', lo_moneda ,' ) saldo_facturado
								FROM antiguedad_saldos
								JOIN tmp_pagos_hasta on
									antiguedad_saldos.id_cxc = tmp_pagos_hasta.id_cxc ' ,'
								WHERE estatus = ''activo''
                                AND tmp_pagos_hasta.saldo_facturado > 0
                                AND id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_rango_fechas,'
                                ',lo_moneda,'
                                ',lo_sucursal,'
                                ',lo_corporativo,'
                                ',lo_cliente,'
                                ',lo_vendedor,'
                                ',lo_select_fin);
                -- SELECT @query;
		ELSE
			SET @query = CONCAT('
								SELECT ','
									',lo_select,'
									','cve_serie,
									fac_numero,
									razon_social,
									fecha_emision,
									importe_facturado ', lo_moneda ,'importe_facturado ,
									fecha_vencimiento,
									tmp_pagos_hasta.dias_vencidos,
									tmp_pagos_hasta.por_vencer ', lo_moneda ,'por_vencer,','
									',lo_ven1,'
									',lo_ven2,'
									',lo_ven3,'
									',lo_ven4,'
									',lo_ven5,'
									',lo_ven6,'
									',lo_ven7,'
									tmp_pagos_hasta.saldo_facturado ', lo_moneda ,'saldo_facturado,
									antiguedad_saldos.id_cxc
								FROM antiguedad_saldos
                                JOIN tmp_pagos_hasta on
									antiguedad_saldos.id_cxc = tmp_pagos_hasta.id_cxc ' ,'
								',lo_select_fin);
		END IF;
	END IF;

	PREPARE stmt FROM @query;
	EXECUTE stmt;

    DROP TEMPORARY TABLE IF EXISTS tmp_pagos_hasta;

    # Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
