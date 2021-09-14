DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_boleto_factura_c`(
	IN  pr_id_grupo_empresa 		INT(11),
    IN  pr_id_proveedor		 		INT(11),
	IN  pr_numero_bol				VARCHAR(15),
	IN  pr_tipo_suc 				VARCHAR(100),
	IN  pr_id_sucursal 				INT(11),
    IN	pr_cve_serie 				VARCHAR(500),
	IN	pr_fac_numero 				INT,
    IN  pr_cve_cliente				VARCHAR(45),
    IN  pr_clave_moneda				VARCHAR(10),
    IN  pr_total_moneda_base		DECIMAL(16,2),
    IN  pr_total_moneda_facturada	DECIMAL(13,2),
    IN  pr_clave_vendedor_tit		CHAR(10),
	IN  pr_fecha_factura_I 			DATE,
	IN  pr_fecha_factura_F 			DATE,
    IN	pr_tipo_serie				CHAR(4),
    IN	pr_uuid						CHAR(40),
    IN  pr_pnr						CHAR(6),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
	OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
	/*
		@nombre 		: sp_fac_boleto_factura_b
		@fecha 			: 10/08/2018
		@descripcion 	: SP para buscar la factura de un boleto en específico
		@autor 			: Carol Mejia
		@cambios 		:
	*/

    DECLARE lo_proveedor	 			VARCHAR(200) DEFAULT '';
	DECLARE lo_numero_bol	 			VARCHAR(200) DEFAULT '';
    DECLARE	lo_cve_serie				VARCHAR(200) DEFAULT '';
    DECLARE	lo_fac_numero 				VARCHAR(200) DEFAULT '';
    DECLARE lo_cve_cliente				VARCHAR(200) DEFAULT '';
    DECLARE lo_clave_moneda				VARCHAR(200) DEFAULT '';
    DECLARE lo_total_moneda_base		VARCHAR(200) DEFAULT '';
    DECLARE lo_total_moneda_facturada	VARCHAR(200) DEFAULT '';
    DECLARE lo_clave_vendedor_tit		VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_factura_I			VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_factura_F			VARCHAR(200) DEFAULT '';
    DECLARE lo_tipo_serie				VARCHAR(200) DEFAULT '';
    DECLARE lo_n_uuid					VARCHAR(200) DEFAULT '';
    DECLARE lo_uuid						VARCHAR(200) DEFAULT '';
    DECLARE lo_pnr						VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';
    DECLARE var_sucursal 				VARCHAR(200) DEFAULT '';
	DECLARE lo_valida_corp 				INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR sp_fac_boleto_factura_c';
	END ;

	SET lo_first_select = ' AND boleto.id_factura_detalle <> 0 AND fac.estatus = "ACTIVO" ';

    IF pr_id_proveedor != '' THEN
		SET lo_proveedor = CONCAT(' AND boleto.id_proveedor = ', pr_id_proveedor);
	END IF;

	IF pr_numero_bol != '' THEN
		SET lo_numero_bol = CONCAT(' AND boleto.numero_bol = "', pr_numero_bol, '" ');
	END IF;

	IF pr_cve_serie !='' THEN
		SET lo_cve_serie = CONCAT(' AND serie.cve_serie LIKE "%', pr_cve_serie,'%" ');
    END IF;

    IF pr_fac_numero > 0 THEN
		SET lo_fac_numero = CONCAT(' AND fac.fac_numero LIKE "%', pr_fac_numero,'%"');
    END IF;

    IF pr_cve_cliente != '' THEN
		SET lo_cve_cliente	= CONCAT(' AND cli.cve_cliente = "', pr_cve_cliente,'"');
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

    IF pr_fecha_factura_I	!= '0000-00-00' THEN
		SET lo_fecha_factura_I	 = CONCAT(' AND fac.fecha_factura >= "', pr_fecha_factura_I,'"');
    END IF;

	IF pr_fecha_factura_F	!= '0000-00-00' THEN
		SET lo_fecha_factura_F	 = CONCAT(' AND fac.fecha_factura <= "', pr_fecha_factura_F,'"');
    END IF;

    IF (pr_tipo_serie !='') THEN
			SET lo_tipo_serie = CONCAT(' AND serie.cve_tipo_serie = "', pr_tipo_serie, '" ');
	END IF;

    IF (pr_tipo_serie = 'FACT') THEN
			SET lo_n_uuid = CONCAT(' AND cfdi.uuid is not null ');
	END IF;

    IF (pr_uuid != '') THEN
			SET lo_uuid = CONCAT(' AND cfdi.uuid LIKE "%', pr_uuid,'%"');
	END IF;

	IF pr_pnr != '' THEN
		SET lo_pnr = CONCAT(' AND fac.pnr LIKE ''%', pr_pnr,'%''');
    END IF;

    # Busqueda por ORDER BY
	IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

    IF pr_tipo_suc = 'SUCURSAL' THEN
		SET var_sucursal = CONCAT(' AND fac.id_sucursal = ',pr_id_sucursal,' ');
	END IF;



	SET @query = CONCAT('
				SELECT
					fac.id_cliente,
					cli.cve_cliente,
					cli.tipo_cliente,
					cli.id_direccion,
					cli.tipo_persona,
					cli.email,
					fac.id_serie,
					serie.cve_serie,
                    serie.cve_tipo_serie,
                    serie.descripcion_serie,
					serie.cve_tipo_doc,
                    serie.tipo_formato,
					doc.descripcion_tipo_doc,
					fac.id_sucursal,
					suc.nombre,
					fac.id_vendedor_tit,
					ven_titular.id_comision,
					ven_titular.clave AS clave_vendedor_tit,
					ven_titular.nombre AS desc_vendedor_tit,
					ven_titular.email AS email_vendedor_tit,
                    ven_titular.id_comision AS vendedor_tit_comision,
					fac.id_vendedor_aux,
					ven_auxiliar.clave AS clave_vendedor_aux,
					ven_auxiliar.nombre AS desc_vendedor_aux,
					ven_auxiliar.email AS email_vendedor_aux,
                    ven_auxiliar.id_comision_aux AS vendedor_aux_comision,
					fac.id_origen,
					origen.cve AS clave_origen,
					origen.descripcion AS desc_origen,
					fac.id_unidad_negocio,
					uni.cve_unidad_negocio AS txt_unidad_negocio,
					uni.desc_unidad_negocio,
					fac.id_factura,
					fac.id_moneda,
                    mon.clave_moneda,
					fac.id_usuario,
                    CONCAT(usuario.nombre_usuario," ",usuario.paterno_usuario) AS usuario_mod,
					fac.id_centro_costo_n1,
					fac.id_centro_costo_n2,
					fac.id_centro_costo_n3,
					fac.id_cuenta_contable,
					fac.razon_social,
					fac.rfc,
					fac.nombre_comercial,
					fac.fac_numero,
					fac.fecha_factura,
					fac.tel,
					fac.tipo_cambio,
					fac.solicito_cliente,
					fac.total_moneda_facturada,
					fac.total_moneda_base,
					fac.nota,
					fac.total_descuento,
					fac.globalizador,
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
                    cfdi.id_cfdi,
                    cfdi.genera_xml,
                    cfdi.factura_xml,
					mon.decripcion,
                    docserv.id_documento_servicio
                    -- fac.cve_tipo_serie
				FROM ic_glob_tr_boleto boleto
				LEFT JOIN ic_fac_tr_factura_detalle fact_det
					ON boleto.id_factura_detalle = fact_det.id_factura_detalle
				INNER JOIN ic_fac_tr_factura fac
					ON fact_det.id_factura = fac.id_factura
				INNER JOIN ic_cat_tr_cliente cli
					ON cli.id_cliente = fac.id_cliente
				INNER JOIN ic_cat_tr_serie serie
					ON serie.id_serie = fac.id_serie
				INNER JOIN ic_cat_tr_tipo_doc doc
					ON doc.cve_tipo_doc = serie.cve_tipo_doc
				INNER JOIN ic_cat_tr_sucursal suc
					ON suc.id_sucursal = fac.id_sucursal
				LEFT JOIN ic_cat_tc_unidad_negocio uni
					ON uni.id_unidad_negocio = fac.id_unidad_negocio
				INNER JOIN ic_cat_tr_vendedor ven_titular
					ON ven_titular.id_vendedor= fac.id_vendedor_tit
				LEFT JOIN ic_cat_tr_vendedor ven_auxiliar
					ON ven_auxiliar.id_vendedor = fac.id_vendedor_aux
				LEFT JOIN ic_cat_tr_origen_venta origen
					ON origen.id_origen_venta = fac.id_origen
				LEFT JOIN ic_fac_tr_factura_cfdi cfdi
					ON cfdi.id_factura = fac.id_factura
				LEFT JOIN ic_fac_documento_servicio docserv
					ON docserv.id_factura = fac.id_factura
				INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
					ON usuario.id_usuario = fac.id_usuario
				JOIN ct_glob_tc_moneda mon ON
				 fac.id_moneda = mon.id_moneda
				WHERE fac.id_grupo_empresa = ? ',
					 lo_first_select,
                     lo_n_uuid,
                     lo_uuid,
                     lo_proveedor,
                     lo_numero_bol,
                     lo_cve_serie,
                     lo_fac_numero,
                     lo_cve_cliente,
                     lo_clave_moneda,
                     lo_total_moneda_base,
                     lo_total_moneda_facturada,
                     lo_clave_vendedor_tit,
                     lo_fecha_factura_I,
                     lo_fecha_factura_F,
                     lo_pnr,
                     lo_tipo_serie,
					 var_sucursal,
					 lo_order_by,
				 'LIMIT ?,?'
	);

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
				FROM ic_glob_tr_boleto boleto
					LEFT JOIN ic_fac_tr_factura_detalle fact_det
						ON boleto.id_factura_detalle = fact_det.id_factura_detalle
					INNER JOIN ic_fac_tr_factura fac
						ON fact_det.id_factura = fac.id_factura
					INNER JOIN ic_cat_tr_cliente cli
						ON cli.id_cliente= fac.id_cliente
					INNER JOIN ic_cat_tr_serie serie
						ON serie.id_serie= fac.id_serie
					INNER JOIN ic_cat_tr_tipo_doc doc
						ON doc.cve_tipo_doc = serie.cve_tipo_doc
					INNER JOIN ic_cat_tr_sucursal suc
						ON suc.id_sucursal = fac.id_sucursal
					LEFT JOIN ic_cat_tc_unidad_negocio uni
						ON uni.id_unidad_negocio = fac.id_unidad_negocio
					INNER JOIN ic_cat_tr_vendedor ven_titular
						ON ven_titular.id_vendedor= fac.id_vendedor_tit
					LEFT JOIN ic_cat_tr_vendedor ven_auxiliar
						ON ven_auxiliar.id_vendedor= fac.id_vendedor_aux
					LEFT JOIN ic_cat_tr_origen_venta origen
						ON origen.id_origen_venta = fac.id_origen
					LEFT JOIN ic_fac_tr_factura_cfdi cfdi
						ON cfdi.id_factura = fac.id_factura
					LEFT JOIN ic_fac_documento_servicio docserv
						ON docserv.id_factura = fac.id_factura
					INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario = fac.id_usuario
					JOIN ct_glob_tc_moneda mon ON
						fac.id_moneda = mon.id_moneda
				WHERE fac.id_grupo_empresa = ? ',
					lo_first_select,
                    lo_n_uuid,
					lo_uuid,
                    lo_proveedor,
                    lo_numero_bol,
                    lo_cve_serie,
                    lo_fac_numero,
                    lo_cve_cliente,
                    lo_clave_moneda,
                    lo_total_moneda_base,
                    lo_total_moneda_facturada,
                    lo_clave_vendedor_tit,
                    lo_fecha_factura_I,
                    lo_fecha_factura_F,
                    lo_pnr,
                    lo_tipo_serie,
					var_sucursal
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table	= @pr_rows_tot_table;
	SET pr_message			= 'SUCCESS';
END$$
DELIMITER ;
