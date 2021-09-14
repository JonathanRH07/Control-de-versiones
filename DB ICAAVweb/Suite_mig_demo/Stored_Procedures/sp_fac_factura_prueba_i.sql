DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_prueba_i`(
	IN  pr_id_grupo_empresa 		INT(11),
	IN  pr_id_sucursal 				INT(11),
	IN  pr_id_serie 				INT(11),
	IN  pr_id_cliente 				INT(11),
	IN  pr_id_centro_costo_n1 		INT(11),
	IN  pr_id_centro_costo_n2 		INT(11),
	IN  pr_id_centro_costo_n3 		INT(11),
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
	-- IN  pr_fac_numero 				INT(13),
    IN  pr_fecha_factura			TIMESTAMP,
	IN  pr_tipo_cambio 				DECIMAL(15,4),
	IN  pr_solicito_cliente 		VARCHAR(100),
	IN  pr_total_moneda_ext 		DECIMAL(13,2),
	IN  pr_total_moneda_base 		DECIMAL(13,2),
	IN  pr_nota 					VARCHAR(100),
	IN  pr_total_descuento 			DECIMAL(13,2),
	IN  pr_globalizador 			CHAR(6),
	IN  pr_descripcion_exten 		VARCHAR(255),
	IN  pr_motivo_cancelacion 		VARCHAR(255),
	IN  pr_aplica_contabilidad 		INT(1),
	IN  pr_fecha_cancelacion 		TIMESTAMP,
	IN  pr_envio_electronico 		CHAR(1),
	IN  pr_tipo_formato 			CHAR(1),
    IN  pr_id_pnr_consecutivo		INT(11),
    IN  pr_pnr						CHAR(6),
	IN  pr_confirmacion_pac 		CHAR(5),
    IN  pr_email_envio 				VARCHAR(255),#
	IN  pr_c_MetodoPago 			CHAR(3),#
	IN  pr_c_UsoCFDI 				CHAR(3),#
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

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	SET lo_folio= (SELECT folio_serie  FROM ic_cat_tr_serie WHERE id_serie=pr_id_serie);

	SET lo_num_fac= concat(pr_id_grupo_empresa,pr_id_sucursal,pr_id_serie,lo_folio);


    CALL sp_help_get_row_count_params_bill('ic_fac_tr_factura',pr_id_grupo_empresa,pr_id_sucursal,CONCAT(' fac_numero =  "', lo_num_fac,'" '),@has_relations_with_bill, pr_message);

	IF @has_relations_with_bill > 0 THEN
		SET @error_code = 'DUPLICATED_No_FACTURA';
		SET pr_message = CONCAT('{"error": "4002", "code": "FACTURA.', @error_code, '", "count": ',(@has_relations_with_bill),'}');
		SET pr_affect_rows = 0;
		ROLLBACK;
	ELSE
		INSERT INTO ic_fac_tr_factura (
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
			tipo_cambio,
			solicito_cliente,
			total_moneda_ext,
			total_moneda_base,
			nota,
			total_descuento,
			globalizador,
			descripcion_exten,
			motivo_cancelacion,
			aplica_contabilidad,
			fecha_cancelacion,
			envio_electronico,
			tipo_formato,
			id_pnr_consecutivo,
			pnr,
			confirmacion_pac,
			email_envio,
			c_MetodoPago,
			c_UsoCFDI
		) VALUES (
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
			pr_tipo_cambio,
			pr_solicito_cliente,
			pr_total_moneda_ext,
			pr_total_moneda_base,
			pr_nota,
			pr_total_descuento,
			pr_globalizador,
			pr_descripcion_exten,
			pr_motivo_cancelacion,
			pr_aplica_contabilidad,
			pr_fecha_cancelacion,
			pr_envio_electronico,
			pr_tipo_formato,
			pr_id_pnr_consecutivo,
			pr_pnr,
			pr_confirmacion_pac,
			pr_email_envio,
			pr_c_MetodoPago,
			pr_c_UsoCFDI
		);
		SET pr_inserted_id 	= @@identity;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		# Mensaje de ejecución.
		SET pr_message = 'SUCCESS';
		COMMIT;
	END IF;
END$$
DELIMITER ;
