DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cfdi_i`(
	IN  pr_id_factura 					INT(11),
	IN  pr_numero_certificado 			VARCHAR(20),
	IN  pr_cadena_original 				TEXT,
	IN  pr_sello_digital 				TEXT,
	IN  pr_certificado 					TEXT,
	IN  pr_genera_xml 					CHAR(1),
	IN  pr_factura_xml 					BLOB,
	IN  pr_genera_pdf 					CHAR(1),
	IN  pr_factura_pdf 					BLOB,
	IN  pr_fecha_envio_email 			DATETIME,
	IN  pr_timbre_cfdi 					TEXT,
	IN  pr_version_timbrado 			VARCHAR(4),
	IN  pr_uuid 						VARCHAR(100),
	IN  pr_fecha_timbrado 				DATETIME,
	IN  pr_numero_certificado_sat 		VARCHAR(20),
	IN  pr_sello_sat 					TEXT,
	IN  pr_cadena_timbre 				TEXT,
	IN  pr_cfdi_timbrado 				CHAR(1),
	IN  pr_confirma_cancelacion_cfdi 	TEXT,
	IN  pr_archivo_addenda 				TEXT,
	OUT pr_inserted_id					INT,
	OUT pr_affect_rows	    			INT,
	OUT pr_message		    			VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_factura_cfdi_i
		@fecha 		: 02/03/2017
		@descripcion: SP para agregar registros en la tabla de facturas cfdi.
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_cfdi_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_fac_tr_factura_cfdi(
		id_factura,
		numero_certificado,
		cadena_original,
		sello_digital,
		certificado,
		genera_xml,
		factura_xml,
		genera_pdf,
		factura_pdf,
		fecha_envio_email,
		timbre_cfdi,
		version_timbrado,
		uuid,
		fecha_timbrado,
		numero_certificado_sat,
		sello_sat,
		cadena_timbre,
		cfdi_timbrado,
		confirma_cancelacion_cfdi,
		archivo_addenda
	) VALUES (
		pr_id_factura,
		pr_numero_certificado,
		pr_cadena_original,
		pr_sello_digital,
		pr_certificado,
		pr_genera_xml,
		pr_factura_xml,
		pr_genera_pdf,
		pr_factura_pdf,
		pr_fecha_envio_email,
		pr_timbre_cfdi,
		pr_version_timbrado,
		pr_uuid,
		pr_fecha_timbrado,
		pr_numero_certificado_sat,
		pr_sello_sat,
		pr_cadena_timbre,
		pr_cfdi_timbrado,
		pr_confirma_cancelacion_cfdi,
		pr_archivo_addenda
	);
	SET pr_inserted_id 	= @@identity;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
