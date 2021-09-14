DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_i`(
	IN  pr_id_grupo_empresa 		INT(11),
	IN  pr_id_sucursal 				INT(11),
	IN  pr_id_serie 				INT(11),
	IN  pr_id_cliente 				INT(11),
	IN  pr_id_centro_costo_n1 		VARCHAR(2000),
	IN  pr_id_centro_costo_n2 		VARCHAR(2000),
	IN  pr_id_centro_costo_n3 		VARCHAR(2000),
	IN  pr_id_vendedor_tit 			INT(11),
	IN  pr_id_vendedor_aux 			INT(11),
	IN  pr_id_moneda 				INT(11),
	IN  pr_razon_social				VARCHAR(255),
	IN  pr_nombre_comercial			VARCHAR(255),
	IN  pr_id_direccion 			INT(11),
	IN  pr_rfc						CHAR(20),
	IN  pr_tel						CHAR(30),
	IN  pr_id_usuario 				INT(11),
	IN  pr_id_origen 				INT(11),
	IN  pr_id_unidad_negocio 		INT(11),
	IN  pr_id_cuenta_contable 		INT(11),
	IN  pr_fecha_factura			DATE,
    IN  pr_hora_factura				TIME,
	IN  pr_tipo_cambio 				DECIMAL(15,4),
	IN  pr_solicito_cliente 		VARCHAR(100),
	IN  pr_total_moneda_facturada 	DECIMAL(13,2),
	IN  pr_total_moneda_base 		DECIMAL(13,2),
	IN  pr_nota 					VARCHAR(100),
	IN  pr_total_descuento 			DECIMAL(13,2),
	IN  pr_globalizador 			CHAR(6),
	IN  pr_descripcion_exten 		VARCHAR(255),
	IN  pr_motivo_cancelacion 		VARCHAR(255),
	IN  pr_aplica_contabilidad 		INT(1),
	IN  pr_fecha_cancelacion 		VARCHAR(20),
	IN  pr_envio_electronico 		CHAR(1),
	IN  pr_tipo_formato 			CHAR(2),
	IN  pr_id_pnr_consecutivo		INT(11),
	IN  pr_pnr						CHAR(6),
	IN  pr_confirmacion_pac 		CHAR(5),
	IN  pr_email_envio 				VARCHAR(255),
	IN  pr_c_MetodoPago 			CHAR(3),
	IN  pr_c_UsoCFDI 				CHAR(3),
	IN  pr_config_tipo_descu 		CHAR(1),
    IN  pr_cve_tipo_cfdi_ingreso	CHAR(2),
    IN  pr_tipo_cfdi				CHAR(1),
    IN  pr_cve_tipo_serie			CHAR(4),
    IN  pr_id_virtuoso				INT(11),
    IN  pr_NumRegldTrib				VARCHAR(20),
    OUT pr_num_fac					INT(13),
	OUT pr_inserted_id				INT,
	OUT pr_affect_rows	    		INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_i
		@fecha:			02/03/2017
		@descripcion:	SP para agregar registros en la tabla de facturas.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_corporativo		VARCHAR(10) DEFAULT NULL;
    DECLARE	lo_vendedor			VARCHAR(10) DEFAULT NULL;
    DECLARE lo_folio			VARCHAR(100) DEFAULT NULL;
    DECLARE lo_num_fac			INT DEFAULT NULL;
    DECLARE ld_tipo_cambio_usd		DECIMAL(13,4);
    DECLARE ld_tipo_cambio_eur		DECIMAL(13,4);

    /*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;*/

	-- START TRANSACTION;

    UPDATE ic_cat_tr_serie
    SET	folio_serie = folio_serie + 1
	WHERE ic_cat_tr_serie.id_serie = pr_id_serie ;

	SET lo_num_fac = (SELECT folio_serie  FROM ic_cat_tr_serie WHERE id_serie = pr_id_serie);

	-- SET lo_num_fac= concat(pr_id_grupo_empresa,pr_id_sucursal,pr_id_serie,lo_folio);
 /* se cacela estecodigoya que el SPno funciona correctamente
    CALL sp_help_get_row_count_params_bill(
		'ic_fac_tr_factura', pr_id_grupo_empresa, pr_id_sucursal, CONCAT(' AND id_serie = ',pr_id_serie,' AND fac_numero =  ', lo_num_fac), @has_relations_with_bill, pr_message
	);

	IF @has_relations_with_bill > 0 THEN */

	IF EXISTS (SELECT id_factura FROM ic_fac_tr_factura WHERE id_sucursal = pr_id_sucursal AND  id_serie = pr_id_serie AND fac_numero = lo_num_fac)	THEN
  		SET pr_message = CONCAT('{"error": "4002", "code": "DUPLICATED", "folio": "', lo_num_fac,'"}');
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	ELSE

		/*Dolares*/
		IF pr_id_moneda = 149 THEN
			SET ld_tipo_cambio_usd = pr_tipo_cambio;
		ELSE
			SET ld_tipo_cambio_usd = (SELECT ifnull(tipo_cambio,0)
									 FROM suite_mig_conf.st_adm_tr_config_moneda
									 JOIN ct_glob_tc_moneda ON
										suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
									 WHERE clave_moneda = 'USD'
                                     AND st_adm_tr_config_moneda.id_grupo_empresa = pr_id_grupo_empresa);
		END IF;
		/*Euros*/
		IF pr_id_moneda = 49 THEN
			SET ld_tipo_cambio_eur = pr_tipo_cambio;
		ELSE
			SET ld_tipo_cambio_eur = (SELECT ifnull(tipo_cambio,0)
									  FROM suite_mig_conf.st_adm_tr_config_moneda
                                      JOIN ct_glob_tc_moneda ON
										 suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
									  WHERE clave_moneda = 'EUR'
                                      AND st_adm_tr_config_moneda.id_grupo_empresa = pr_id_grupo_empresa);
		END IF;

		INSERT INTO ic_fac_tr_factura
        (
			id_grupo_empresa,
			id_sucursal,
			id_serie,
			id_cliente,
			id_centro_costo_n1,
			id_centro_costo_n2,
			id_centro_costo_n3,
			id_vendedor_tit,
			id_vendedor_aux,
			id_moneda,
			razon_social,
			nombre_comercial,
			id_direccion,
			rfc,
			tel,
			id_usuario,
			id_origen,
			id_unidad_negocio,
			id_cuenta_contable,
			fac_numero,
			fecha_factura,
            hora_factura,
			tipo_cambio,
			solicito_cliente,
			total_moneda_facturada,
			total_moneda_base,
			nota,
			total_descuento,
			globalizador,
			descripcion_exten,
			aplica_contabilidad,
			envio_electronico,
			tipo_formato,
			id_pnr_consecutivo,
			pnr,
			confirmacion_pac,
			email_envio,
			c_MetodoPago,
			c_UsoCFDI,
			config_tipo_descu,
			cve_tipo_cfdi_ingreso,
            tipo_cfdi,
			cve_tipo_serie,
            tipo_cambio_usd,
            tipo_cambio_eur,
            id_virtuoso,
            NumRegldTrib
		)
		VALUES
		(
			pr_id_grupo_empresa,
			pr_id_sucursal,
			pr_id_serie,
			pr_id_cliente,
			pr_id_centro_costo_n1,
			pr_id_centro_costo_n2,
			pr_id_centro_costo_n3,
			pr_id_vendedor_tit,
			pr_id_vendedor_aux,
			pr_id_moneda,
			pr_razon_social,
			pr_nombre_comercial,
			pr_id_direccion,
			pr_rfc,
			pr_tel,
			pr_id_usuario,
			pr_id_origen,
			pr_id_unidad_negocio,
			pr_id_cuenta_contable,
			lo_num_fac,
			pr_fecha_factura,
			pr_hora_factura,
			pr_tipo_cambio,
			pr_solicito_cliente,
			pr_total_moneda_facturada,
			pr_total_moneda_base,
			pr_nota,
			pr_total_descuento,
			pr_globalizador,
			pr_descripcion_exten,
			pr_aplica_contabilidad,
			pr_envio_electronico,
			pr_tipo_formato,
			pr_id_pnr_consecutivo,
			pr_pnr,
			pr_confirmacion_pac,
			pr_email_envio,
			pr_c_MetodoPago,
			pr_c_UsoCFDI,
			pr_config_tipo_descu,
			pr_cve_tipo_cfdi_ingreso,
			pr_tipo_cfdi,
			pr_cve_tipo_serie,
			ld_tipo_cambio_usd,
			ld_tipo_cambio_eur,
			pr_id_virtuoso,
			pr_NumRegldTrib
		);

		SET pr_inserted_id 	= @@identity;
        SET pr_num_fac      = lo_num_fac;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		SET pr_message = 'SUCCESS'; # Mensaje de ejecución.
		-- COMMIT;
        -- Commit  fuera de lugar debe estar hasta el final del proceso de inserción de facturas
    END IF;

END$$
DELIMITER ;
