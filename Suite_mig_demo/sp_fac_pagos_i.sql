DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_i`(
	IN  pr_id_grupo_empresa 			INT(11),
	IN  pr_id_serie 					INT(11),
	IN  pr_id_cliente 					INT(11),
	IN  pr_id_moneda 					INT(11),
	IN  pr_id_direccion 				INT(11),
	IN  pr_id_usuario 					INT(11),
	IN  pr_id_forma_pago 				INT(11),
	IN  pr_id_pago_sustituye_a 			INT(11),
	IN  pr_id_pago_sustituido_por 		INT(11),
	IN  pr_numero 						INT(13),
	IN  pr_razon_social 				VARCHAR(255),
	IN  pr_rfc 							VARCHAR(20),
	IN  pr_fecha 						DATE,
    IN	pr_fecha_captura_recibo			DATE,
	IN  pr_tpo_cambio 					DECIMAL(10,4),
	IN  pr_total_pago 					DECIMAL(13,2),
	IN  pr_total_pago_moneda_base		DECIMAL(13,2),
	IN  pr_mtvo_cancelacion 			VARCHAR(255),
	IN  pr_aplica_contab 				INT(11),
	IN  pr_fecha_cancelacion 			DATE,
	IN  pr_mail_cliente 				VARCHAR(255),
	IN  pr_envio_electronico 			CHAR(1),
	IN  pr_c_UsoCFDI_sat 				CHAR(4),
	IN  pr_c_Formapago 					CHAR(4),
	IN  pr_c_UsoCFDI_descripcion_sat 	VARCHAR(50),
	IN  pr_no_operacion 				VARCHAR(50),
	IN  pr_confirmacion_pac 			CHAR(5),
	IN  pr_rfcemisorctaord 				CHAR(12),
	IN  pr_nombancoordext 				VARCHAR(300),
	IN  pr_ctaordenante 				VARCHAR(50),
    IN  pr_nombancoemisor 				VARCHAR(300),
	IN  pr_rfcemisorctaben 				CHAR(12),
	IN  pr_ctabeneficiario 				VARCHAR(50),
	IN  pr_tipocadpago 					CHAR(2),
	IN  pr_certpago 					VARCHAR(300),
	IN  pr_cadpago 						TEXT,
    IN  pr_concepto_p                   VARCHAR(200),
    IN  pr_concepto_c					VARCHAR(200),
    IN  pr_recibimos_de					VARCHAR(200),
    IN  pr_sello_spei                   TEXT,
    IN  pr_factura_pdf          	    BLOB,
    OUT pr_inserted_id					INT,
    OUT pr_affect_rows      			INT,
    OUT pr_message 	         			VARCHAR(500),
    OUT pr_num_fact                     INT)
BEGIN
/*
	@nombre: 		ic_gds_vuelos_i
	@fecha: 		14/09/2017
	@descripcion: 	SP para inseratr en ic_gds_vuelos
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_num_fac				INT DEFAULT NULL;
    DECLARE ld_tipo_cambio_usd		DECIMAL(13,4);
    DECLARE ld_tipo_cambio_eur		DECIMAL(13,4);
    DECLARE lo_id_sucursal			INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'PAYMENT.MESSAGE_ERROR_CREATE_PAYMENT';
        SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

	UPDATE ic_cat_tr_serie
    SET		folio_serie = folio_serie + 1
	WHERE ic_cat_tr_serie.id_serie = pr_id_serie ;

	SELECT
		id_sucursal
	INTO
		lo_id_sucursal
	FROM ic_cat_tr_serie
	WHERE id_serie = pr_id_serie;

	SET lo_num_fac = (SELECT folio_serie  FROM ic_cat_tr_serie WHERE id_serie=pr_id_serie);
    /*
        CALL sp_help_get_row_count_params_bill(
		'ic_fac_tr_pagos', pr_id_grupo_empresa, pr_id_sucursal, CONCAT(' numero =  "', lo_num_fac,'" '), @has_relations_with_bill, pr_message
	);

	IF @has_relations_with_bill > 0 THEN

        SET @error_code = 'DUPLICATED_No_Recibo';
		SET pr_message = CONCAT('{"error": "4002", "code": "FACTURA.', @error_code, '", "count": ',(@has_relations_with_bill),'}');
		SET pr_affect_rows = 0;
		ROLLBACK; */

   IF EXISTS (Select * from ic_fac_tr_pagos WHERE id_sucursal = lo_id_sucursal and  id_serie = pr_id_serie and numero = lo_num_fac )	THEN
  		SET pr_message = CONCAT('{"error": "4002", "code": "DUPLICATED;', lo_num_fac);
		SET pr_affect_rows = 0;
        SET pr_message 		= 'ERROR';
		-- ROLLBACK;
	ELSE

    		/*Dolares*/
		IF pr_id_moneda = 149 THEN
			SET ld_tipo_cambio_usd = pr_tpo_cambio;
		ELSE
			SET ld_tipo_cambio_usd = (SELECT ifnull(tipo_cambio,0) FROM suite_mig_conf.st_adm_tr_config_moneda join ct_glob_tc_moneda on
			 suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
			WHERE clave_moneda = 'USD' and st_adm_tr_config_moneda.id_grupo_empresa = pr_id_grupo_empresa);
		END IF;
		/*Euros*/
		IF pr_id_moneda = 49 THEN
			SET ld_tipo_cambio_eur = pr_tpo_cambio;
		ELSE
			SET ld_tipo_cambio_eur = (SELECT ifnull(tipo_cambio,0) FROM suite_mig_conf.st_adm_tr_config_moneda join ct_glob_tc_moneda on
				suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
			WHERE clave_moneda = 'EUR' and st_adm_tr_config_moneda.id_grupo_empresa = pr_id_grupo_empresa);
		END IF;

	INSERT INTO ic_fac_tr_pagos (
		id_grupo_empresa,
		id_sucursal,
		id_serie,
		id_cliente,
		id_moneda,
		id_direccion,
		id_usuario,
		id_forma_pago,
		id_pago_sustituye_a,
		id_pago_sustituido_por,
		numero,
		razon_social,
		rfc,
		fecha,
        fecha_captura_recibo,
		tpo_cambio,
		total_pago,
		total_pago_moneda_base,
		mtvo_cancelacion,
		aplica_contab,
		fecha_cancelacion,
		mail_cliente,
		envio_electronico,
		c_UsoCFDI_sat,
		c_Formapago,
		c_UsoCFDI_descripcion_sat,
		no_operacion,
		confirmacion_pac,
		rfcemisorctaord,
		nombancoordext,
		ctaordenante,
		nombancoemisor,
		rfcemisorctaben,
		ctabeneficiario,
		tipocadpago,
		certpago,
		cadpago,
		concepto_p,
		concepto_c,
		recibimos_de,
        sello_spei,
        tipo_cambio_usd,
        tipo_cambio_eur,
        factura_pdf
		)
	VALUE
		(
		pr_id_grupo_empresa,
		lo_id_sucursal,
		pr_id_serie,
		pr_id_cliente,
		pr_id_moneda,
		pr_id_direccion,
		pr_id_usuario,
		pr_id_forma_pago,
		pr_id_pago_sustituye_a,
		pr_id_pago_sustituido_por,
		lo_num_fac,
		pr_razon_social,
		REPLACE(pr_rfc,'-',''),
		pr_fecha,
        pr_fecha_captura_recibo,
		pr_tpo_cambio,
		pr_total_pago,
		pr_total_pago_moneda_base,
		pr_mtvo_cancelacion,
		pr_aplica_contab,
		pr_fecha_cancelacion,
		pr_mail_cliente,
		pr_envio_electronico,
		UPPER(pr_c_UsoCFDI_sat),
		pr_c_Formapago,
		pr_c_UsoCFDI_descripcion_sat,
		pr_no_operacion,
		pr_confirmacion_pac,
		pr_rfcemisorctaord,
		pr_nombancoordext,
		pr_ctaordenante,
        pr_nombancoemisor,
		pr_rfcemisorctaben,
		pr_ctabeneficiario,
		pr_tipocadpago,
		pr_certpago,
		pr_cadpago,
		pr_concepto_p,
		pr_concepto_c,
		pr_recibimos_de,
        pr_sello_spei,
        ld_tipo_cambio_usd,
        ld_tipo_cambio_eur,
        pr_factura_pdf
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;

    -- En caso de sustitución  actualiza el recibo susutituido
    IF pr_id_pago_sustituye_a > 0 THEN
		UPDATE ic_fac_tr_pagos
		SET id_pago_sustituido_por = pr_inserted_id
		WHERE id_pago = pr_id_pago_sustituye_a;
	END IF;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

    # Devuelve el numero de factura asignado

    SET pr_num_fact = lo_num_fac;

	-- COMMIT;
	END IF;
END$$
DELIMITER ;
