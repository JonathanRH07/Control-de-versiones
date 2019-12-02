DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_u`(
	IN  pr_id_pago 					INT(11),
	-- IN  pr_id_grupo_empresa 			INT(11),
	-- IN  pr_id_sucursal 					INT(11),
	-- IN  pr_id_serie 					INT(11),
	-- IN  pr_id_cliente 					INT(11),
	-- IN  pr_id_moneda 					INT(11),
	-- IN  pr_id_direccion 				INT(11),
    IN  pr_id_usuario	 				INT(11),
	IN  pr_id_forma_pago 				INT(11),
	IN  pr_id_pago_sustituye_a 			INT(11),
	-- IN  pr_id_pago_sustituido_por 		INT(11),
	-- IN  pr_numero 						INT(13),
	-- IN  pr_razon_social 				VARCHAR(255),
	-- IN  pr_rfc 							VARCHAR(20),
	IN  pr_fecha 						DATE,
    IN  pr_fecha_captura_recibo  		DATE,
	-- IN  pr_tpo_cambio 					DECIMAL(10,4),
	-- IN  pr_total_pago 					DECIMAL(13,2),
	-- IN  pr_total_pago_moneda_base		DECIMAL(13,2),
	IN  pr_mtvo_cancelacion 			VARCHAR(255),
	-- IN  pr_aplica_contab 				INT(11),
	IN  pr_fecha_cancelacion 			DATE,
	IN  pr_mail_cliente 				VARCHAR(255),
	-- IN  pr_envio_electronico 			CHAR(1),
	-- IN  pr_c_UsoCFDI_sat 				CHAR(4),
	IN  pr_c_Formapago 					CHAR(4),
	IN  pr_c_UsoCFDI_descripcion_sat 	VARCHAR(50),
	IN  pr_no_operacion 				VARCHAR(50),
	IN  pr_confirmacion_pac 			CHAR(5),
	IN  pr_rfcemisorctaord 				CHAR(12),
	IN  pr_nombancoordext 				VARCHAR(300),
	IN  pr_ctaordenante 				VARCHAR(50),
    IN  pr_nombancoemisor               VARCHAR(300),
	IN  pr_rfcemisorctaben 				CHAR(12),
	IN  pr_ctabeneficiario 				VARCHAR(50),
	IN  pr_tipocadpago 					CHAR(2),
	IN  pr_certpago 					VARCHAR(300),
	IN  pr_cadpago 						TEXT,
	IN  pr_estatus 						ENUM('ACTIVO','CANCELADO'),
    IN  pr_concepto_p                   VARCHAR(200),
	IN  pr_concepto_c                   VARCHAR(200),
    IN  pr_recibimos_de                 VARCHAR(200),
    IN  pr_sello_spei					TEXT,
	OUT pr_affect_rows	        		INT,
	OUT pr_message		        		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_hoteles_u
		@fecha:			14/09/2017
		@descripcion:	SP para actualizar registro gds_hoteles
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	#Declaracion de variables.
	-- DECLARE lo_id_sucursal 					VARCHAR(200) DEFAULT '';
	-- DECLARE lo_id_serie  					VARCHAR(200) DEFAULT '';
	-- DECLARE lo_id_cliente 					VARCHAR(200) DEFAULT '';
	-- DECLARE lo_id_moneda 					VARCHAR(200) DEFAULT '';
	-- DECLARE lo_id_direccion 				VARCHAR(200) DEFAULT '';
	DECLARE lo_id_forma_pago 				VARCHAR(200) DEFAULT '';
	DECLARE lo_id_pago_sustituye_a 			VARCHAR(200) DEFAULT '';
	-- DECLARE lo_id_pago_sustituido_por 		VARCHAR(200) DEFAULT '';
	-- DECLARE lo_numero 						VARCHAR(200) DEFAULT '';
	-- DECLARE lo_razon_social 				VARCHAR(200) DEFAULT '';
	-- DECLARE lo_rfc 							VARCHAR(200) DEFAULT '';
	DECLARE lo_fecha 						VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_captura_recibo			VARCHAR(200) DEFAULT '';
	-- DECLARE lo_tpo_cambio 					VARCHAR(200) DEFAULT '';
	-- DECLARE lo_total_pago 					VARCHAR(200) DEFAULT '';
	-- DECLARE lo_total_pago_moneda_base 		VARCHAR(200) DEFAULT '';
	DECLARE lo_mtvo_cancelacion 			VARCHAR(200) DEFAULT '';
	-- DECLARE lo_aplica_contab 				VARCHAR(200) DEFAULT '';
	DECLARE lo_fecha_cancelacion 			VARCHAR(200) DEFAULT '';
	DECLARE lo_mail_cliente 				VARCHAR(200) DEFAULT '';
	-- DECLARE lo_envio_electronico 			VARCHAR(200) DEFAULT '';
	-- DECLARE lo_c_UsoCFDI_sat 				VARCHAR(200) DEFAULT '';
	DECLARE lo_c_Formapago 					VARCHAR(200) DEFAULT '';
	DECLARE lo_c_UsoCFDI_descripcion_sat 	VARCHAR(200) DEFAULT '';
	DECLARE lo_no_operacion 				VARCHAR(200) DEFAULT '';
	DECLARE lo_confirmacion_pac 			VARCHAR(200) DEFAULT '';
	DECLARE lo_rfcemisorctaord 				VARCHAR(200) DEFAULT ''; -- ererr
	DECLARE lo_nombancoordext 				VARCHAR(200) DEFAULT ''; -- dfsdf
	DECLARE lo_ctaordenante 				VARCHAR(200) DEFAULT ''; -- dsfsdf
    DECLARE lo_nombancoemisor 				VARCHAR(200) DEFAULT '';
	DECLARE lo_rfcemisorctaben 				VARCHAR(200) DEFAULT '';
	DECLARE lo_ctabeneficiario 				VARCHAR(200) DEFAULT '';
	DECLARE lo_tipocadpago 					VARCHAR(200) DEFAULT '';
	DECLARE lo_certpago 					VARCHAR(200) DEFAULT '';
	DECLARE lo_cadpago 						TEXT DEFAULT '';
	DECLARE lo_estatus 						VARCHAR(200) DEFAULT '';
	DECLARE lo_concepto_p 					VARCHAR(200) DEFAULT '';
    DECLARE lo_concepto_c 					VARCHAR(200) DEFAULT '';
	DECLARE lo_recibimos_de 				VARCHAR(200) DEFAULT '';
    DECLARE lo_sello_spei                   TEXT DEFAULT '';
    DECLARE lo_act_id_pago_sustituye_a		INT;

    /*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'PAYMENT.MESSAGE_ERROR_CREATE_PAYMENT';
		ROLLBACK;
	END;*/

	/* OBTNER EL ID_PAGO_SUSUTITUYE A  */
	SELECT
		id_pago_sustituye_a
	INTO
		lo_act_id_pago_sustituye_a
	FROM ic_fac_tr_pagos
	WHERE id_pago = pr_id_pago;

	START TRANSACTION;

    /*
    IF pr_id_sucursal != '' THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = "', pr_id_sucursal, '", ');
	END IF;
    */

	/*IF pr_id_serie != '' THEN
		SET lo_id_serie = CONCAT('id_serie = "', pr_id_serie, '", ');
	END IF;*/

	/*IF pr_id_cliente != '' THEN
		SET lo_id_cliente = CONCAT('id_cliente = "', pr_id_cliente, '", ');
	END IF;*/

	/*IF pr_id_moneda != '' THEN
		SET lo_id_moneda = CONCAT('id_moneda = "', pr_id_moneda, '", ');
	END IF;*/

	/*IF pr_id_direccion != '' THEN
		SET lo_id_direccion = CONCAT('id_direccion = "', pr_id_direccion, '", ');
	END IF;*/

	IF pr_id_forma_pago != '' THEN
		SET lo_id_forma_pago = CONCAT('id_forma_pago = "', pr_id_forma_pago, '", ');
	END IF;

	IF pr_id_pago_sustituye_a != '' THEN
		SET lo_id_pago_sustituye_a = CONCAT('id_pago_sustituye_a = "', pr_id_pago_sustituye_a, '", ');

        /* LIMPIAR ID_PAGO_SUSUTITUIDO_POR DEL ANTERIOR ID */
		UPDATE ic_fac_tr_pagos
		SET id_pago_sustituido_por = 0
		WHERE id_pago = lo_act_id_pago_sustituye_a;

        /* ACTUALIZAR EL ID_PAGO_SUSUTITUIDO_POR DEL NUEVO ID */
		UPDATE ic_fac_tr_pagos
		SET id_pago_sustituido_por = pr_id_pago
		WHERE id_pago = pr_id_pago_sustituye_a;

	END IF;

	/*IF pr_id_pago_sustituido_por != '' THEN
		SET lo_id_pago_sustituido_por = CONCAT('id_pago_sustituido_por = "', pr_id_pago_sustituido_por, '", ');
	END IF;*/

	/*IF pr_numero != '' THEN
		SET lo_numero = CONCAT('numero = "', pr_numero, '", ');
	END IF;*/

	/*IF pr_razon_social != '' THEN
		SET lo_razon_social = CONCAT('razon_social = "', pr_razon_social, '", ');
	END IF;*/

	/*IF pr_rfc != '' THEN
		SET lo_rfc = CONCAT('rfc = "', pr_rfc, '", ');
	END IF;*/

	IF pr_fecha != '' THEN
		SET lo_fecha = CONCAT('fecha = "', pr_fecha, '", ');
	END IF;


    IF pr_fecha_captura_recibo != '' THEN
		SET lo_fecha_captura_recibo = CONCAT('fecha_captura_recibo = "', pr_fecha_captura_recibo, '", ');
	END IF;

	/*IF pr_tpo_cambio != '' THEN
		SET lo_tpo_cambio = CONCAT('tpo_cambio = "', pr_tpo_cambio, '", ');
	END IF;*/

	/*IF pr_total_pago != '' THEN
		SET lo_total_pago = CONCAT('total_pago = "', pr_total_pago, '", ');
	END IF;*/

	/*IF pr_total_pago_moneda_base != '' THEN
		SET lo_total_pago_moneda_base = CONCAT('total_pago_moneda_base = "', pr_total_pago_moneda_base, '", ');
	END IF;*/

	IF pr_mtvo_cancelacion != '' THEN
		SET lo_mtvo_cancelacion = CONCAT('mtvo_cancelacion = "', pr_mtvo_cancelacion, '", ');
	END IF;

	/*IF pr_aplica_contab != '' THEN
		SET lo_aplica_contab = CONCAT('aplica_contab = "', pr_aplica_contab, '", ');
	END IF;*/

	IF pr_fecha_cancelacion != '' THEN
		SET lo_fecha_cancelacion = CONCAT('fecha_cancelacion = "', pr_fecha_cancelacion, '", ');
	END IF;

	IF pr_mail_cliente != '' THEN
		SET lo_mail_cliente = CONCAT('mail_cliente = "', pr_mail_cliente, '", ');
	END IF;

	/*IF pr_envio_electronico != '' THEN
		SET lo_envio_electronico = CONCAT('envio_electronico = "', pr_envio_electronico, '", ');
	END IF;*/

	/*IF pr_c_UsoCFDI_sat != '' THEN
		SET lo_c_UsoCFDI_sat = CONCAT('c_UsoCFDI_sat = "', pr_c_UsoCFDI_sat, '", ');
	END IF;*/

	IF pr_c_Formapago != '' THEN
		SET lo_c_Formapago = CONCAT('c_Formapago = "', pr_c_Formapago, '", ');
	END IF;

    IF pr_c_UsoCFDI_descripcion_sat != '' THEN
		SET lo_c_UsoCFDI_descripcion_sat = CONCAT('c_UsoCFDI_descripcion_sat = "', pr_c_UsoCFDI_descripcion_sat, '", ');
	END IF;

    IF pr_no_operacion != '' THEN
		SET lo_no_operacion = CONCAT('no_operacion = "', pr_no_operacion, '", ');
	END IF;

    IF pr_confirmacion_pac != '' THEN
		SET lo_confirmacion_pac = CONCAT('confirmacion_pac = "', pr_confirmacion_pac, '", ');
	END IF;

	IF pr_rfcemisorctaord != '' OR pr_rfcemisorctaord != 'null' THEN
		SET lo_rfcemisorctaord = CONCAT('rfcemisorctaord = "', pr_rfcemisorctaord, '", ');
	ELSEIF pr_rfcemisorctaord = '' OR pr_rfcemisorctaord = 'null' THEN
		SET lo_rfcemisorctaord = CONCAT('rfcemisorctaord = NULL, ');
	END IF;

	IF pr_nombancoordext != '' OR pr_nombancoordext != 'null' THEN
		SET lo_nombancoordext = CONCAT('nombancoordext = "', pr_nombancoordext, '", ');
	ELSEIF pr_nombancoordext = '' OR pr_nombancoordext = 'null' THEN
		SET lo_nombancoordext = CONCAT('nombancoordext = NULL, ');
	END IF;

    IF pr_ctaordenante != '' OR pr_ctaordenante != 'null' THEN
		SET lo_ctaordenante = CONCAT('ctaordenante = "', pr_ctaordenante, '", ');
	ELSEIF pr_ctaordenante = '' OR pr_ctaordenante = 'null' THEN
		SET lo_ctaordenante = CONCAT('ctaordenante = NULL, ');
	END IF;

    IF pr_nombancoemisor != '' OR pr_nombancoemisor != 'null' THEN
		SET lo_nombancoemisor = CONCAT('nombancoemisor = "', pr_nombancoemisor, '", ');
	ELSEIF pr_nombancoemisor = '' OR pr_nombancoemisor = 'null' THEN
		SET lo_nombancoemisor = CONCAT('nombancoemisor = NULL, ');
	END IF;

    IF pr_rfcemisorctaben != '' OR pr_rfcemisorctaben != 'null' THEN
		SET lo_rfcemisorctaben = CONCAT('rfcemisorctaben = "', pr_rfcemisorctaben, '", ');
	ELSEIF pr_rfcemisorctaben = '' OR pr_rfcemisorctaben = 'null' THEN
		SET lo_rfcemisorctaben = CONCAT('rfcemisorctaben = NULL, ');
	END IF;

    IF pr_ctabeneficiario != '' OR pr_ctabeneficiario != 'null' THEN
		SET lo_ctabeneficiario = CONCAT('ctabeneficiario = "', pr_ctabeneficiario, '", ');
	ELSEIF pr_ctabeneficiario = '' OR pr_ctabeneficiario = 'null' THEN
		SET lo_ctabeneficiario = CONCAT('ctabeneficiario = NULL, ');
	END IF;

    IF pr_tipocadpago != '' THEN
		SET lo_tipocadpago = CONCAT('tipocadpago = "', pr_tipocadpago, '", ');
	END IF;

    IF pr_certpago != '' THEN
		SET lo_certpago = CONCAT('certpago = "', pr_certpago, '", ');
	END IF;

    IF pr_cadpago != '' THEN
		SET lo_cadpago = CONCAT('cadpago = "', pr_cadpago, '", ');
	END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '", ');
	END IF;

	IF pr_concepto_p != '' THEN
		SET lo_concepto_p = CONCAT('concepto_p = "', pr_concepto_p, '", ');
	END IF;

	IF pr_concepto_c != '' THEN
		SET lo_concepto_c = CONCAT('concepto_c = "', pr_concepto_c, '", ');
	END IF;

	IF pr_recibimos_de != '' THEN
		SET lo_recibimos_de = CONCAT('recibimos_de = "', pr_recibimos_de, '", ');
	END IF;

	IF pr_sello_spei != '' THEN
		SET lo_sello_spei = CONCAT('sello_spei = "', pr_sello_spei, '", ');
	END IF;

	SET @query = CONCAT('
			UPDATE ic_fac_tr_pagos
			SET ',
				-- lo_id_sucursal,
				-- lo_id_serie,
				-- lo_id_cliente,
				-- lo_id_moneda,
				-- lo_id_direccion,
				lo_id_forma_pago,
				lo_id_pago_sustituye_a,
				-- lo_id_pago_sustituido_por,
				-- lo_numero,
				-- lo_razon_social,
				-- lo_rfc,
				lo_fecha,
                lo_fecha_captura_recibo,
				-- lo_tpo_cambio,
				-- lo_total_pago,
				-- lo_total_pago_moneda_base,
				lo_mtvo_cancelacion,
				-- lo_aplica_contab,
				lo_fecha_cancelacion,
				lo_mail_cliente,
				-- lo_envio_electronico,
				-- lo_c_UsoCFDI_sat,
				lo_c_Formapago,
				lo_c_UsoCFDI_descripcion_sat,
				lo_no_operacion,
				lo_confirmacion_pac,
				lo_rfcemisorctaord,
				lo_nombancoordext,
				lo_ctaordenante,
                lo_nombancoemisor,
				lo_rfcemisorctaben,
				lo_ctabeneficiario,
				lo_tipocadpago,
				lo_certpago,
				lo_cadpago,
				lo_estatus,
				lo_concepto_p,
				lo_concepto_c,
				lo_recibimos_de,
                lo_sello_spei,
                ' id_usuario = ',pr_id_usuario,'
                , fecha_mod = sysdate()
			WHERE id_pago = ?');

	-- AND id_grupo_empresa=',pr_id_grupo_empresa,'

	/*select @query;*/
	PREPARE stmt FROM @query;
	SET @id_pago= pr_id_pago;
	EXECUTE stmt USING @id_pago;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
