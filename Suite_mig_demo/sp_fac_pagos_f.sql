DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_f`(
	IN  pr_id_grupo_empresa				INT(11),
    IN  pr_id_sucursal					INT(11),
    IN  pr_id_idioma					INT,
    IN  pr_id_pago						INT,
    IN  pr_estatus						ENUM('ACTIVO', 'CANCELADO','TODOS'),
	IN 	pr_clave_moneda            		VARCHAR(100),
	IN 	pr_cve_forma_pago          		VARCHAR(100),
	IN 	pr_cve_serie               		VARCHAR(100),
	IN 	pr_cve_sucursal            		VARCHAR(100),
	IN 	pr_fecha_captura_recibo_I    	TIMESTAMP,
    IN 	pr_fecha_captura_recibo_F    	TIMESTAMP,
    IN 	pr_fecha_uuid_I    				TIMESTAMP,
    IN 	pr_fecha_uuid_F    				TIMESTAMP,
	IN 	pr_numero                  		VARCHAR(100),
	IN 	pr_razon_social            		VARCHAR(100),
	IN 	pr_total_pago_f            		VARCHAR(100),
	IN 	pr_total_pago_moneda_base_f  	VARCHAR(100),
	IN 	pr_tpo_cambio              		VARCHAR(100),
    IN 	pr_sealing_uuid                 VARCHAR(100),
    IN  pr_timbrado						CHAR(1),
    IN  pr_sustituido					CHAR(1),
    IN 	pr_sust_cve_serie               VARCHAR(100),
    IN 	pr_sust_numero                  VARCHAR(100),
    IN 	pr_sust_sealing_uuid            VARCHAR(100),
    IN  pr_pago_con_cfdi				CHAR(1),
    IN  pr_consulta_gral				CHAR(30),
    IN  pr_ini_pag						INT(11),
	IN  pr_fin_pag						INT(11),
	IN  pr_order_by						VARCHAR(100),
    OUT pr_rows_tot_table				INT,
	OUT pr_message						VARCHAR(5000))
BEGIN
--
/*
	@nombre:		sp_fac_pagos_f
	@fecha: 		2018/04/19
	@descripción: 	Sp para obtenber registros de las tablas ic_fac_tr_pagos
	@autor : 		Griselda Medina Medina
	@cambios: 	    se agrego el uuid relacionado @mario , se agregaron filtrado estandar, filtrado especifico(2/15/2019) 2/06/2019
*/
	DECLARE lo_matriz					INT;
    DECLARE lo_matriz_campo				VARCHAR(200)  DEFAULT '';
    DECLARE lo_consulta_gral			VARCHAR(1000) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200)  DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200)  DEFAULT '';
	DECLARE lo_estatus					VARCHAR(200)  DEFAULT '';
    DECLARE lo_id_pago					VARCHAR(200)  DEFAULT '';
	DECLARE lo_clave_moneda 	        VARCHAR(2000) DEFAULT '';
	DECLARE lo_cve_forma_pago 	        VARCHAR(2000) DEFAULT '';
	DECLARE lo_cve_serie 	            VARCHAR(2000) DEFAULT '';
	DECLARE lo_cve_sucursal 	        VARCHAR(2000) DEFAULT '';
	DECLARE lo_fecha_captura_recibo_I 	VARCHAR(2000) DEFAULT '';
    DECLARE lo_fecha_captura_recibo_F 	VARCHAR(2000) DEFAULT '';
    DECLARE lo_fecha_uuid_I 			VARCHAR(2000) DEFAULT '';
    DECLARE lo_fecha_uuid_F 			VARCHAR(2000) DEFAULT '';
	DECLARE lo_numero 	                VARCHAR(2000) DEFAULT '';
	DECLARE lo_razon_social 	        VARCHAR(2000) DEFAULT '';
	DECLARE lo_total_pago_f 	        VARCHAR(2000) DEFAULT '';
	DECLARE lo_total_pago_moneda_base_f VARCHAR(2000) DEFAULT '';
	DECLARE lo_tpo_cambio 	            VARCHAR(2000) DEFAULT '';
    DECLARE lo_sealing_uuid 	        VARCHAR(2000) DEFAULT '';
    DECLARE lo_timbrado 	            VARCHAR(2000) DEFAULT '';
    DECLARE lo_sustituido 	            VARCHAR(2000) DEFAULT '';
    DECLARE lo_sust_cve_serie 	        VARCHAR(2000) DEFAULT '';
    DECLARE lo_sust_numero 	            VARCHAR(2000) DEFAULT '';
    DECLARE lo_sust_sealing_uuid 	    VARCHAR(2000) DEFAULT '';
    DECLARE lo_pago_con_cfdi 	        VARCHAR(2000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = RETURNED_SQLSTATE;
	END ;

    IF (pr_estatus != '' AND pr_estatus != 'TODOS') THEN
		SET lo_estatus = CONCAT(' AND pagos.estatus = ''', pr_estatus, ''' ');
	END IF;

	SELECT
		matriz
	INTO
		lo_matriz
    FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF lo_matriz = 0 THEN
		SET lo_matriz_campo = CONCAT(' AND pagos.id_sucursal = ',pr_id_sucursal);
    END IF;

    IF (pr_consulta_gral !='')THEN
     SET lo_consulta_gral = CONCAT('
     AND (serie.cve_serie LIKE "%', pr_consulta_gral,'%"
     OR pagos.numero LIKE "%', pr_consulta_gral,'%"
     OR sucursal.cve_sucursal LIKE "%', pr_consulta_gral,'%"
     OR cliente.razon_social LIKE "%', pr_consulta_gral,'%"
     OR pagos.fecha LIKE "%', pr_consulta_gral,'%"
     OR pagos.total_pago LIKE "%', REPLACE(pr_consulta_gral,',',''),'%"
     OR pagos.total_pago_moneda_base LIKE "%', REPLACE(pr_consulta_gral,',',''),'%"
     OR moneda.clave_moneda LIKE "%', pr_consulta_gral,'%"
     OR pagos.tpo_cambio LIKE ''%',pr_consulta_gral,'%''
     OR concat(fpago.id_forma_pago_sat,"-",fpago.cve_forma_pago)  LIKE "%', pr_consulta_gral,'%"
     OR pagos.tpo_cambio LIKE "%', pr_consulta_gral,'%")');

	END IF;

   # BUSQUEDA ESPECIFICA

    IF pr_id_pago > 0 THEN
		SET lo_id_pago = CONCAT(' AND pagos.id_pago = ', pr_id_pago);
    END IF;

	IF pr_clave_moneda !='' THEN
		SET lo_clave_moneda =CONCAT('AND moneda.clave_moneda LIKE ''%',pr_clave_moneda,'%'' ');
	END IF;

	IF pr_cve_forma_pago !='' THEN
		SET lo_cve_forma_pago =CONCAT('AND concat(fpago.id_forma_pago_sat,"-",fpago.cve_forma_pago) LIKE ''%',pr_cve_forma_pago,'%'' ');
	END IF;
	IF pr_cve_serie !='' THEN
		SET lo_cve_serie =CONCAT('AND serie.cve_serie LIKE ''%',pr_cve_serie,'%'' ');
	END IF;
	IF pr_cve_sucursal !='' THEN
		SET lo_cve_sucursal =CONCAT('AND sucursal.cve_sucursal LIKE ''%',pr_cve_sucursal,'%'' ');
	END IF;

    IF pr_fecha_captura_recibo_I != '0000-00-00' THEN
		SET lo_fecha_captura_recibo_I	= CONCAT(' AND pagos.fecha_captura_recibo >= ''', pr_fecha_captura_recibo_I,'''');
    END IF;

	IF pr_fecha_captura_recibo_F != '0000-00-00' THEN
		SET lo_fecha_captura_recibo_F = CONCAT(' AND pagos.fecha_captura_recibo <= ''',pr_fecha_captura_recibo_F,'''');
    END IF;

    IF pr_fecha_uuid_I != '0000-00-00' THEN
		SET lo_fecha_uuid_I	= CONCAT(' AND pagos.fecha >= ''', pr_fecha_uuid_I,'''');
    END IF;

	IF pr_fecha_uuid_F != '0000-00-00' THEN
		SET lo_fecha_uuid_F = CONCAT(' AND pagos.fecha <= ''',pr_fecha_uuid_F,'''');
    END IF;

	IF pr_numero !='' THEN
		SET lo_numero =CONCAT('AND pagos.numero LIKE ''%',pr_numero,'%'' ');
	END IF;
	IF pr_razon_social !='' THEN
		SET lo_razon_social =CONCAT('AND cliente.razon_social LIKE ''%',pr_razon_social,'%'' ');
	END IF;
	IF pr_total_pago_f !='' THEN
		SET lo_total_pago_f =CONCAT('AND pagos.total_pago LIKE ''%',pr_total_pago_f,'%'' ');
	END IF;
	IF pr_total_pago_moneda_base_f !='' THEN
		SET lo_total_pago_moneda_base_f =CONCAT('AND pagos.total_pago_moneda_base LIKE ''%',pr_total_pago_moneda_base_f,'%'' ');
	END IF;
	IF pr_tpo_cambio !='' THEN
		SET lo_tpo_cambio =CONCAT('AND pagos.tpo_cambio LIKE ''%',pr_tpo_cambio,'%'' ');
	END IF;

	IF pr_timbrado ='S' THEN
		SET lo_timbrado =CONCAT(' AND !isnull(cfdi.uuid) ');
	END IF;

    IF pr_timbrado ='N' THEN
		SET lo_timbrado =CONCAT(' AND isnull(cfdi.uuid) ');
	END IF;

    IF pr_pago_con_cfdi = 'S' THEN
		SET lo_pago_con_cfdi = ' AND pagos.c_UsoCFDI_descripcion_sat <> "N" AND pagos.c_UsoCFDI_sat <> "N" ';
    END IF;

    IF pr_sealing_uuid !='' THEN
		SET lo_sealing_uuid =CONCAT(' AND cfdi.uuid LIKE ''%',pr_sealing_uuid,'%'' ');
	END IF;

    IF pr_sustituido ='S' THEN
		SET lo_sustituido =' AND !isnull(cfdi_sust.uuid) ';
	END IF;

    IF pr_sustituido ='N' THEN
		SET lo_sustituido = ' AND isnull(cfdi_sust.uuid) ';
	END IF;

    IF pr_sust_cve_serie !='' THEN
		SET lo_sust_cve_serie =CONCAT(' AND ser_sust.cve_serie LIKE ''%',pr_sust_cve_serie,'%'' ');
	END IF;

    IF pr_sust_numero !='' THEN
		SET lo_sust_numero =CONCAT(' AND pagos_sust.numero LIKE ''%',pr_sust_numero,'%'' ');
	END IF;

    IF pr_sust_sealing_uuid !='' THEN
		SET lo_sust_sealing_uuid =CONCAT(' AND cfdi_sust.uuid LIKE ''%',pr_sust_sealing_uuid,'%'' ');
	END IF;


   # Busqueda por ORDER BY
	IF pr_order_by <> '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	 SET @query = CONCAT('SELECT
							pagos.id_pago,
							pagos.id_grupo_empresa,
							pagos.id_serie,
							concat(serie.cve_serie," - ",serie.descripcion_serie) as cve_serie_d,
							serie.cve_serie,
							pagos.numero,
							pagos.id_pago_sustituye_a,
							concat(moneda.clave_moneda," - ",mon_transl.descripcion_moneda) as clave_moneda_d,
							moneda.clave_moneda,
							descripcion_moneda,
							mon_transl.plural,
							pagos.id_cliente,
							cliente.cve_cliente,
							pagos.mail_cliente,
							cliente.razon_social,
							cliente.id_sucursal,
							cliente.rfc,
							sucursal.cve_sucursal,
							pagos.fecha as fecha_uuid,
							pagos.fecha_captura_recibo,
							pagos.total_pago,
							pagos.total_pago_moneda_base,
							pagos.no_operacion,
							pagos.confirmacion_pac,
							pagos.tpo_cambio,
							cfdi.uuid as sealing_uuid,
                            cfdi.genera_xml,
							cfdi.factura_xml,
							pagos.id_usuario,
							usuario.usuario,
							concat(usuario.nombre_usuario," ",paterno_usuario) as usuario_mod,
							pagos.id_forma_pago,
							fpago.cve_forma_pago,
							fpago.id_forma_pago_sat,
							concat(usuario.usuario) AS user_alias,
							pagos.id_pago_sustituido_por,
							pagos.estatus,
							pagos.nombancoemisor,
							pagos.rfcemisorctaord,
							pagos.nombancoordext,
							pagos.nombancoemisor,
							pagos.ctaordenante,
							pagos.rfcemisorctaben,
							pagos.ctabeneficiario,
							pagos.tipocadpago,
							pagos.certpago,
							pagos.cadpago,
							pagos.concepto_p,
							pagos.concepto_c,
							pagos.recibimos_de,
							pagos.c_UsoCFDI_sat,
							pagos.id_razon_cancelacion,
							cancel.descripcion,
							pagos.fecha_mod,
							pagos.c_UsoCFDI_descripcion_sat,
							pagos.sello_spei as xmlspei,
							IF(pagos.c_UsoCFDI_sat <>"N" AND cfdi.uuid IS NOT NULL, "S", IF (pagos.c_UsoCFDI_sat <>"N" AND cfdi.uuid IS NULL, "N", "")) timbrado,
                            IF(pagos.c_UsoCFDI_sat <>"N" AND cfdi.uuid IS NOT NULL, "SI", IF (pagos.c_UsoCFDI_sat <>"N" AND cfdi.uuid IS NULL, "NO", "")) nombre_timbrado,
							suc_sust.cve_sucursal AS sust_cve_sucursal,
                            suc_sust.nombre AS sust_nombre_sucursal,
							ser_sust.cve_serie AS sust_cve_serie,
							pagos_sust.numero AS sust_numero,
							cfdi_sust.uuid AS sust_sealing_uuid,
                            IF(cfdi_sust.uuid IS NOT NULL, "S", "N") sustituido,
                            IF(cfdi_sust.uuid IS NOT NULL, "SI", "NO") nombre_sustituido
							FROM ic_fac_tr_pagos AS pagos
							LEFT JOIN ct_glob_tc_moneda AS moneda
							ON moneda.id_moneda = pagos.id_moneda
							LEFT JOIN ct_glob_tc_moneda_trans as mon_transl
							ON moneda.id_moneda = mon_transl.id_moneda
							LEFT JOIN ic_cat_tr_serie AS serie
							ON serie.id_serie=pagos.id_serie
							LEFT JOIN ic_cat_tr_cliente AS cliente
							ON cliente.id_cliente=pagos.id_cliente
							LEFT JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
							ON usuario.id_usuario=pagos.id_usuario
							LEFT JOIN ic_cat_tr_sucursal AS sucursal
							ON sucursal.id_sucursal=pagos.id_sucursal
							LEFT JOIN ic_glob_tr_forma_pago AS fpago
							ON fpago.id_forma_pago=pagos.id_forma_pago
							LEFT JOIN ic_fac_tr_pagos_cfdi AS cfdi
							ON cfdi.id_pago=pagos.id_pago
							LEFT JOIN ic_fac_tc_razon_cancelacion cancel
							ON pagos.id_razon_cancelacion = cancel.id_razon_cancelacion
                            LEFT JOIN ic_fac_tr_pagos pagos_sust
                            ON pagos.id_pago_sustituye_a = pagos_sust.id_pago
                            LEFT JOIN ic_cat_tr_sucursal suc_sust
							ON pagos_sust.id_sucursal = suc_sust.id_sucursal
							LEFT JOIN ic_cat_tr_serie ser_sust
							ON pagos_sust.id_serie = ser_sust.id_serie
							LEFT JOIN ic_fac_tr_pagos_cfdi cfdi_sust
							ON cfdi_sust.id_pago = pagos_sust.id_pago
							WHERE pagos.id_grupo_empresa=?
							AND   mon_transl.id_idioma = ', pr_id_idioma
							,lo_matriz_campo
							,lo_first_select
							,lo_consulta_gral
							,lo_estatus
                            ,lo_id_pago
                            ,lo_timbrado
                            ,lo_pago_con_cfdi
                            ,lo_sustituido
                            ,lo_sust_cve_serie
                            ,lo_sust_numero
                            ,lo_sust_sealing_uuid
							,'',lo_clave_moneda,''
							,'',lo_cve_forma_pago,''
							,'',lo_cve_serie,''
							,'',lo_cve_sucursal,''
							,'',lo_fecha_captura_recibo_I,''
                            ,'',lo_fecha_captura_recibo_F,''
                            ,'',lo_fecha_uuid_I,''
                            ,'',lo_fecha_uuid_F,''
							,'',lo_numero,''
							,'',lo_razon_social,''
							,'',REPLACE(lo_total_pago_f,',',''),''
							,'',REPLACE(lo_total_pago_moneda_base_f,',',''),''
							,'',lo_tpo_cambio,''
                            ,'',lo_sealing_uuid,''
							,lo_order_by
							,' LIMIT ?,?'
				);

    -- SELECT @query;
    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;


    /**/
    SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('SELECT
									 COUNT(*)
								  INTO
									 @pr_rows_tot_table
								  FROM ic_fac_tr_pagos AS pagos
								LEFT JOIN ct_glob_tc_moneda AS moneda
									ON moneda.id_moneda = pagos.id_moneda
								LEFT JOIN ct_glob_tc_moneda_trans as mon_transl
									ON moneda.id_moneda = mon_transl.id_moneda
								LEFT JOIN ic_cat_tr_serie AS serie
									ON serie.id_serie=pagos.id_serie
								LEFT JOIN ic_cat_tr_cliente AS cliente
									ON cliente.id_cliente=pagos.id_cliente
								LEFT JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
									ON usuario.id_usuario=pagos.id_usuario
								LEFT JOIN ic_cat_tr_sucursal AS sucursal
									ON sucursal.id_sucursal=pagos.id_sucursal
								LEFT JOIN ic_glob_tr_forma_pago AS fpago
									ON fpago.id_forma_pago=pagos.id_forma_pago
								LEFT JOIN ic_fac_tr_pagos_cfdi AS cfdi
									ON cfdi.id_pago=pagos.id_pago
								LEFT JOIN ic_fac_tc_razon_cancelacion cancel
									ON pagos.id_razon_cancelacion = cancel.id_razon_cancelacion
								LEFT JOIN ic_fac_tr_pagos pagos_sust
									ON pagos.id_pago_sustituye_a = pagos_sust.id_pago
								LEFT JOIN ic_cat_tr_sucursal suc_sust
									ON pagos_sust.id_sucursal = suc_sust.id_sucursal
								LEFT JOIN ic_cat_tr_serie ser_sust
									ON pagos_sust.id_serie = ser_sust.id_serie
								LEFT JOIN ic_fac_tr_pagos_cfdi cfdi_sust
									ON cfdi_sust.id_pago = pagos_sust.id_pago
								WHERE pagos.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND   mon_transl.id_idioma = ', pr_id_idioma
								,lo_matriz_campo
								,lo_first_select
								,lo_consulta_gral
								,lo_estatus
                                ,lo_id_pago
                                ,lo_timbrado
                                ,lo_pago_con_cfdi
                                ,lo_sustituido
                                ,lo_sust_cve_serie
								,lo_sust_numero
								,lo_sust_sealing_uuid
								,'',lo_clave_moneda,''
								,'',lo_cve_forma_pago,''
								,'',lo_cve_serie,''
								,'',lo_cve_sucursal,''
								,'',lo_fecha_captura_recibo_I,''
								,'',lo_fecha_captura_recibo_F,''
                                ,'',lo_fecha_uuid_I,''
								,'',lo_fecha_uuid_F,''
								,'',lo_numero,''
								,'',lo_razon_social,''
								,'',REPLACE(lo_total_pago_f,',',''),''
								,'',REPLACE(lo_total_pago_moneda_base_f,',',''),''
								,'',lo_tpo_cambio
								,'',lo_sealing_uuid
                                );

    -- SELECT @queryTotalRows;
    PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    SET pr_rows_tot_table	= @pr_rows_tot_table;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
