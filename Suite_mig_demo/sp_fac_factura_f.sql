DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_f`(
	IN  pr_id_grupo_empresa 			INT,
    IN  pr_id_factura		 			INT,
    IN  pr_id_sucursal		 			INT,
	IN  pr_cve_serie					VARCHAR(500),
	IN  pr_fac_numero					INT,
    IN  pr_cve_cliente					VARCHAR(45),
	IN  pr_razon_social					VARCHAR(255),
	IN  pr_fecha_factura_I				TIMESTAMP,
	IN  pr_fecha_factura_F				TIMESTAMP,
	IN  pr_clave_moneda					VARCHAR(10),
	IN  pr_total_moneda_base			DECIMAL(16,2),
	IN  pr_total_moneda_facturada		DECIMAL(13,2),
	IN  pr_clave_vendedor_tit			CHAR(10),
	IN  pr_pnr							CHAR(6),
	IN	pr_tipo_serie					CHAR(4),
    IN	pr_uuid							CHAR(40),
	IN  pr_estatus						ENUM('ACTIVO', 'CANCELADA','TODOS'),
	IN  pr_id_estatus_cancelacion		INT(11),
    IN  pr_id_razon_cancelacion			INT(11),
    IN pr_idioma						CHAR(3),
    IN  pr_consulta_gral				CHAR(30),
	IN  pr_ini_pag						INT,
	IN  pr_fin_pag						INT,
	IN  pr_order_by						VARCHAR(300),
	OUT pr_rows_tot_table 				INT,
	OUT pr_message 						VARCHAR(500)
)
BEGIN
	/*
		@nombre:		sp_fac_factura_f
		@fecha:			21/04/2017
		@descripción : 	SP para consultar registros en facturacion.
		@autor : 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE  lo_sucursal					VARCHAR(200) DEFAULT '';
    DECLARE  lo_cve_serie					VARCHAR(200) DEFAULT '';
    DECLARE  lo_fac_numero					VARCHAR(200) DEFAULT '';
    DECLARE  lo_cve_cliente					VARCHAR(200) DEFAULT '';
    DECLARE  lo_razon_social				VARCHAR(200) DEFAULT '';
    DECLARE  lo_fecha_factura_I				VARCHAR(200) DEFAULT '';
    DECLARE  lo_fecha_factura_F				VARCHAR(200) DEFAULT '';
    DECLARE  lo_clave_moneda				VARCHAR(200) DEFAULT '';
    DECLARE  lo_total_moneda_base			VARCHAR(200) DEFAULT '';
    DECLARE  lo_total_moneda_facturada		VARCHAR(200) DEFAULT '';
    DECLARE  lo_clave_vendedor_tit			VARCHAR(200) DEFAULT '';
    DECLARE  lo_pnr							VARCHAR(200) DEFAULT '';
    DECLARE  lo_estatus						VARCHAR(200) DEFAULT '';
    DECLARE  lo_tipo_serie					VARCHAR(200) DEFAULT '';
    DECLARE  lo_n_uuid						VARCHAR(200) DEFAULT '';
    DECLARE	 lo_uuid						VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_estatus_cancelacion		VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_razon_cancelacion		VARCHAR(200) DEFAULT '';
    DECLARE  lo_consulta_gral				VARCHAR(200) DEFAULT '';
    DECLARE  lo_order_by					VARCHAR(200) DEFAULT '';
	DECLARE  lo_id_factura					VARCHAR(200) DEFAULT '';
    DECLARE  lo_idioma_camp					VARCHAR(200) DEFAULT '';
    DECLARE  lo_idioma						VARCHAR(200) DEFAULT '';
    DECLARE  lo_idioma_join					VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_f';
	END ;

    IF pr_id_factura > 0 THEN
		SET lo_id_factura = CONCAT(' AND fac.id_factura = ', pr_id_factura);
    END IF;

    IF pr_id_sucursal != '' THEN
		SET lo_sucursal = CONCAT(' AND fac.id_sucursal = ', pr_id_sucursal);
    END IF;

    IF pr_cve_serie	!= '' THEN
		SET lo_cve_serie = CONCAT(' AND serie.cve_serie LIKE ''%',pr_cve_serie,'%''');
    END IF;



    IF pr_fac_numero > 0 THEN
		SET lo_fac_numero = CONCAT(' AND fac.fac_numero LIKE ''%', pr_fac_numero,'%''');
    END IF;

    IF pr_cve_cliente != '' THEN
		SET lo_cve_cliente	= CONCAT(' AND cli.cve_cliente = "', pr_cve_cliente,'"');
    END IF;

    IF pr_razon_social != '' THEN
		SET lo_razon_social	= CONCAT(' AND fac.razon_social LIKE ''%', pr_razon_social,'%''');
    END IF;

	IF pr_fecha_factura_I != '0000-00-00' THEN
		SET lo_fecha_factura_I	= CONCAT(' AND fac.fecha_factura >= ''', pr_fecha_factura_I,'''');
    END IF;

	IF pr_fecha_factura_F != '0000-00-00' THEN
		SET lo_fecha_factura_F = CONCAT(' AND fac.fecha_factura <= ''',pr_fecha_factura_F,'''');
    END IF;

    IF pr_clave_moneda != '' THEN
		SET lo_clave_moneda = CONCAT(' AND mon.clave_moneda LIKE ''%', pr_clave_moneda,'%''');
    END IF;

	IF pr_total_moneda_base > 0 THEN
		SET lo_total_moneda_base = CONCAT(' AND fac.total_moneda_base = ', pr_total_moneda_base);
    END IF;

	IF pr_total_moneda_facturada > 0 THEN
		SET lo_total_moneda_facturada = CONCAT(' AND fac.total_moneda_facturada = ', pr_total_moneda_facturada);
    END IF;

    IF pr_clave_vendedor_tit != '' THEN
		SET lo_clave_vendedor_tit = CONCAT(' AND ven_titular.clave LIKE ''%', pr_clave_vendedor_tit,'%''');
    END IF;

	IF pr_pnr != '' THEN
		SET lo_pnr = CONCAT(' AND fac.pnr LIKE ''%', pr_pnr,'%''');
    END IF;

	IF (pr_tipo_serie !='') THEN
		IF  (pr_tipo_serie = 'FACT') THEN
			SET lo_n_uuid = CONCAT(' AND cfdi.uuid is not null ');
		END IF;
		SET lo_tipo_serie = CONCAT(' AND serie.cve_tipo_serie = "', pr_tipo_serie, '" ', lo_n_uuid);

	END IF;

    IF (pr_uuid != '') THEN
		IF (pr_uuid = 'is not null') THEN
			SET lo_uuid = CONCAT(' AND cfdi.uuid ', pr_uuid);
		ELSE
			SET lo_uuid = CONCAT(' AND cfdi.uuid LIKE "%', pr_uuid,'%"');
        END IF;
	END IF;

	IF (pr_estatus !='' AND pr_estatus !='TODOS' ) THEN
			SET lo_estatus = CONCAT(' AND fac.estatus = "', pr_estatus, '" ');
	END IF;

    IF pr_id_estatus_cancelacion > 0 THEN
		SET lo_id_estatus_cancelacion = CONCAT(' AND fac.id_status_cancelacion = ', pr_id_estatus_cancelacion);
    END IF;

    IF pr_id_razon_cancelacion > 0 THEN
		SET lo_id_razon_cancelacion = CONCAT(' AND fac.id_razon_cancelacion = ', pr_id_razon_cancelacion);
    END IF;

    IF pr_idioma != '' THEN
		SET lo_idioma_camp = 'razon_canc_t.descripcion razon_cancel_t,';
        SET lo_idioma	   = CONCAT(' AND idioma.cve_idioma = ''', pr_idioma, '''');
        SET lo_idioma_join = 'LEFT JOIN ic_fac_tr_razon_cancelacion_factura_trans razon_canc_t ON
							  razon_canc.id_razon_cancelacion = razon_canc_t.id_razon_cancelacion
							  LEFT JOIN ct_glob_tc_idioma idioma ON
							  razon_canc_t.id_idioma = idioma.id_idioma';
	ELSE
		SET lo_idioma_camp = ''''' razon_cancel_t,';
    END IF;

    IF (pr_consulta_gral != '' ) THEN
		SET lo_consulta_gral = CONCAT('
				AND (cli.razon_social	 	LIKE "%', pr_consulta_gral, '%"
				OR serie.cve_serie 			LIKE "%', pr_consulta_gral, '%"
				OR fac.fac_numero 			LIKE "%', pr_consulta_gral, '%"
				OR fac.fecha_factura 		LIKE "%', pr_consulta_gral, '%" )'
		);
	END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    SET @query = CONCAT('
			SELECT
				fac.id_cliente,
				cli.cve_cliente,
				cli.tipo_cliente,
                cli.complemento_ine,
				fac.id_direccion,
				cli.tipo_persona,
				cli.email,
				fac.id_serie,
				serie.cve_serie,
                serie.cve_tipo_serie,
                serie.descripcion_serie,
				serie.cve_tipo_doc,
                serie.tipo_formato,
                serie.factura_xcta_terceros,
				doc.descripcion_tipo_doc,
				fac.id_sucursal,
				suc.nombre,
				fac.id_vendedor_tit,
				ven_titular.id_comision,
				ven_titular.clave clave_vendedor_tit,
				ven_titular.nombre desc_vendedor_tit,
				ven_titular.email email_vendedor_tit,
				fac.id_vendedor_aux,
				ven_auxiliar.clave clave_vendedor_aux,
				ven_auxiliar.nombre desc_vendedor_aux,
				ven_auxiliar.email email_vendedor_aux,
				fac.id_origen,
				origen.cve clave_origen,
				origen.descripcion desc_origen,
				fac.id_unidad_negocio,
				uni.cve_unidad_negocio txt_unidad_negocio,
				uni.desc_unidad_negocio,
				fac.id_factura,
				fac.id_moneda,
                mon.clave_moneda,
				fac.id_usuario,
                concat(usuario.nombre_usuario," ",usuario.paterno_usuario) usuario_mod,
				fac.id_centro_costo_n1,
				fac.id_centro_costo_n2,
				fac.id_centro_costo_n3,
				fac.id_cuenta_contable,
				fac.razon_social,
				fac.rfc,
				fac.nombre_comercial,
				fac.fac_numero,
				fac.fecha_factura,
                fac.hora_factura,
				fac.tel,
				fac.tipo_cambio,
				fac.solicito_cliente,
				fac.total_moneda_facturada,
				fac.total_moneda_base,
				fac.nota,
				fac.total_descuento,
				fac.globalizador,
                CONCAT(fac.globalizador,"-",cat_gds.nombre) AS globalizador_concat,
				fac.descripcion_exten,
				fac.motivo_cancelacion,
				fac.aplica_contabilidad,
				fac.fecha_cancelacion,
				fac.envio_electronico,
				fac.tipo_formato,
				fac.id_pnr_consecutivo,
				fac.pnr,
				fac.confirmacion_pac,
				fac.email_envio,
				fac.c_MetodoPago,
				fac.c_UsoCFDI,
				fac.estatus,
                fac.config_tipo_descu,
				cfdi.uuid,
                fac.cve_tipo_cfdi_ingreso,
                fac.tipo_cfdi,
				cfdi.id_cfdi,
                cfdi.genera_xml,
                cfdi.factura_xml,
                mon.decripcion,
                docserv.id_documento_servicio,
                gds.texto_pnr,
				fac.id_status_cancelacion,
				est_can.descripcion AS status_can_desc,
                razon_canc.id_razon_cancelacion/*descripcion*/ razon_cancel,
				fac.fecha_solicitud_cancelacion,
				fac.hora_solicitud_cancelacion,
                fac.motivo_cancelacion observaciones,
                IFNULL(usuario_cancelacion.usuario,''DESCONOCIDO'') usuario_canc,',
                lo_idioma_camp,
                ' fac.fecha_mod
			FROM ic_fac_tr_factura fac
			INNER JOIN ic_cat_tr_cliente cli ON
				cli.id_cliente = fac.id_cliente
			INNER JOIN ic_cat_tr_serie serie ON
				serie.id_serie = fac.id_serie
			INNER JOIN ic_cat_tr_tipo_doc doc ON
				doc.cve_tipo_doc = serie.cve_tipo_doc
			INNER JOIN ic_cat_tr_sucursal suc ON
				suc.id_sucursal = fac.id_sucursal
			LEFT JOIN ic_cat_tc_unidad_negocio uni ON
				uni.id_unidad_negocio = fac.id_unidad_negocio
			LEFT JOIN ic_cat_tr_vendedor ven_titular ON
				ven_titular.id_vendedor = fac.id_vendedor_tit
			LEFT JOIN ic_cat_tr_vendedor ven_auxiliar ON
				ven_auxiliar.id_vendedor = fac.id_vendedor_aux
			LEFT JOIN ic_cat_tr_origen_venta origen ON
				origen.id_origen_venta = fac.id_origen
			LEFT JOIN ic_fac_tr_factura_cfdi cfdi ON
				cfdi.id_factura = fac.id_factura
			LEFT JOIN ic_fac_documento_servicio docserv ON
				docserv.id_factura = fac.id_factura
			INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario ON
				usuario.id_usuario = fac.id_usuario
			JOIN ct_glob_tc_moneda mon ON
				 fac.id_moneda = mon.id_moneda
			LEFT JOIN ic_gds_tr_general gds ON
				fac.id_pnr_consecutivo = gds.id_gds_generall
			LEFT JOIN ic_cat_tc_gds cat_gds ON
				fac.globalizador = cat_gds.cve_gds
			LEFT JOIN ic_fac_tc_factura_estatus_cancelacion est_can ON
				fac.id_status_cancelacion = est_can.id_estatus_cancelacion
			LEFT JOIN ic_fac_tr_razon_cancelacion_factura razon_canc ON
				fac.id_razon_cancelacion = razon_canc.id_razon_cancelacion
			LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario_cancelacion ON
				usuario_cancelacion.id_usuario = fac.id_usuario_cancelacion',
			lo_idioma_join,
			' WHERE fac.id_grupo_empresa = ? ',
                lo_id_factura,
				lo_sucursal,
				lo_cve_serie,
                lo_fac_numero,
                lo_cve_cliente,
                lo_razon_social,
                lo_fecha_factura_I,
                lo_fecha_factura_F,
                lo_clave_moneda,
                lo_total_moneda_base,
                lo_total_moneda_facturada,
                lo_clave_vendedor_tit,
                lo_pnr,
                lo_tipo_serie,
                lo_estatus,
                lo_uuid,
                lo_id_estatus_cancelacion,
                lo_id_razon_cancelacion,
                lo_idioma,
                lo_consulta_gral,
                lo_order_by,
			' LIMIT ?,?'
	);

	-- SELECT @query;
    PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;

    EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;



	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
			SELECT COUNT(*) INTO @pr_rows_tot_table
			FROM ic_fac_tr_factura fac
			INNER JOIN ic_cat_tr_cliente cli ON
				cli.id_cliente = fac.id_cliente
			INNER JOIN ic_cat_tr_serie serie ON
				serie.id_serie = fac.id_serie
			INNER JOIN ic_cat_tr_tipo_doc doc ON
				doc.cve_tipo_doc = serie.cve_tipo_doc
			INNER JOIN ic_cat_tr_sucursal suc ON
				suc.id_sucursal = fac.id_sucursal
			LEFT JOIN ic_cat_tc_unidad_negocio uni ON
				uni.id_unidad_negocio = fac.id_unidad_negocio
			LEFT JOIN ic_cat_tr_vendedor ven_titular ON
				ven_titular.id_vendedor = fac.id_vendedor_tit
			LEFT JOIN ic_cat_tr_vendedor ven_auxiliar ON
				ven_auxiliar.id_vendedor = fac.id_vendedor_aux
			LEFT JOIN ic_cat_tr_origen_venta origen ON
				origen.id_origen_venta = fac.id_origen
			LEFT JOIN ic_fac_tr_factura_cfdi cfdi ON
				cfdi.id_factura = fac.id_factura
			LEFT JOIN ic_fac_documento_servicio docserv ON
				docserv.id_factura = fac.id_factura
			INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario ON
				usuario.id_usuario = fac.id_usuario
			JOIN ct_glob_tc_moneda mon ON
				 fac.id_moneda = mon.id_moneda
			LEFT JOIN ic_gds_tr_general gds ON
				fac.id_pnr_consecutivo = gds.id_gds_generall
			LEFT JOIN ic_cat_tc_gds cat_gds ON
				fac.globalizador = cat_gds.cve_gds
			LEFT JOIN ic_fac_tc_factura_estatus_cancelacion est_can ON
				fac.id_status_cancelacion = est_can.id_estatus_cancelacion
			LEFT JOIN ic_fac_tr_razon_cancelacion_factura razon_canc ON
				fac.id_razon_cancelacion = razon_canc.id_razon_cancelacion ',
			lo_idioma_join,
			' WHERE fac.id_grupo_empresa = ? ',
                lo_id_factura,
				lo_sucursal,
				lo_cve_serie,
                lo_fac_numero,
                lo_cve_cliente,
                lo_razon_social,
                lo_fecha_factura_I,
                lo_fecha_factura_F,
                lo_clave_moneda,
                lo_total_moneda_base,
                lo_total_moneda_facturada,
                lo_clave_vendedor_tit,
                lo_pnr,
                lo_tipo_serie,
                lo_estatus,
                lo_uuid,
                lo_id_estatus_cancelacion,
                lo_id_razon_cancelacion,
                lo_idioma,
                lo_consulta_gral
	);

    PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table	= @pr_rows_tot_table;
	SET pr_message			= 'SUCCESS';
END$$
DELIMITER ;
