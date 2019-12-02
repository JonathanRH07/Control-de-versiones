DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_cfdi_u`(
	IN pr_id_cfdi          	     	INT(11),
	IN pr_id_pago          	     	INT(11),
	IN pr_numero_certificado     	VARCHAR(20),
	IN pr_cadena_original        	TEXT,
	IN pr_sello_digital          	TEXT,
	IN pr_certificado          	 	TEXT,
	IN pr_genera_xml          	 	CHAR(1),
	IN pr_factura_xml          	 	BLOB,
	IN pr_genera_pdf          	 	CHAR(1),
	IN pr_fecha_envio_email      	DATETIME,
	IN pr_timbre_cfdi          	 	TEXT,
	IN pr_version_timbrado       	VARCHAR(4),
	IN pr_uuid          	     	VARCHAR(100),
	IN pr_fecha_timbrado         	DATETIME,
	IN pr_numero_certificado_sat 	VARCHAR(20),
	IN pr_sello_sat          	 	TEXT,
	IN pr_cadena_timbre          	TEXT,
	IN pr_cfdi_timbrado              CHAR(1),
	IN pr_confirma_cancelacion_cfdi  TEXT,
    IN  rfc_prov_ser	             TEXT,
	OUT pr_affect_rows	    		 INT,
	OUT pr_message		    		 VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_pagos_cfdi_u
		@fecha 		: 24/04/2019
		@descripcion: SP para agregar registros en la tabla de facturas cfdi.
		@autor 		: Yazbek Kido
		@cambios 	:
	*/

    DECLARE  lo_numero_certificado 			VARCHAR(100) DEFAULT '';
	DECLARE  lo_cadena_original 			TEXT DEFAULT '';
	DECLARE  lo_sello_digital 				TEXT DEFAULT '';
	DECLARE  lo_certificado 				TEXT DEFAULT '';
	DECLARE  lo_genera_xml 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_factura_xml 				TEXT DEFAULT '';
    DECLARE  lo_genera_pdf 					VARCHAR(100) DEFAULT '';
	DECLARE  lo_factura_pdf 				TEXT DEFAULT '';
	DECLARE  lo_fecha_envio_email 			VARCHAR(100) DEFAULT '';
	DECLARE  lo_timbre_cfdi 				TEXT DEFAULT '';
    DECLARE  lo_version_timbrado 			VARCHAR(100) DEFAULT '';
	DECLARE  lo_uuid 						VARCHAR(100) DEFAULT '';
	DECLARE  lo_fecha_timbrado 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_numero_certificado_sat 		VARCHAR(100) DEFAULT '';
    DECLARE  lo_sello_sat 					TEXT DEFAULT '';
	DECLARE  lo_cadena_timbre 				TEXT DEFAULT '';
	DECLARE  lo_cfdi_timbrado 				VARCHAR(100) DEFAULT '';
	DECLARE  lo_confirma_cancelacion_cfdi 	TEXT DEFAULT '';
    DECLARE  lo_rfc_prov_ser				TEXT DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'PAYMENT.MESSAGE_ERROR_SAVE_CFDI';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    IF pr_numero_certificado != '' THEN
		SET lo_numero_certificado = CONCAT(' numero_certificado=  ''', pr_numero_certificado, ''',');
	END IF;

    IF pr_cadena_original != '' THEN
		SET lo_cadena_original = CONCAT(' cadena_original=  ''', pr_cadena_original, ''',');
	END IF;

    IF pr_sello_digital != '' THEN
		SET lo_sello_digital = CONCAT(' sello_digital=  ''', pr_sello_digital, ''',');
	END IF;

    IF pr_certificado != '' THEN
		SET lo_certificado = CONCAT(' certificado=  ''', pr_certificado, ''',');
	END IF;

    IF pr_genera_xml != '' THEN
		SET lo_genera_xml = CONCAT(' genera_xml=  ''', pr_genera_xml, ''',');
	END IF;

    IF pr_factura_xml != '' THEN
		SET lo_factura_xml = CONCAT(' factura_xml=''', pr_factura_xml, ''',');
	END IF;

    IF pr_genera_pdf != '' THEN
		SET lo_genera_pdf = CONCAT(' genera_pdf=  ''', pr_genera_pdf, ''',');
	END IF;

    IF pr_fecha_envio_email != '' THEN
		SET lo_fecha_envio_email = CONCAT(' fecha_envio_email=  ''', pr_fecha_envio_email, ''',');
	END IF;

    IF pr_timbre_cfdi != '' THEN
		SET lo_timbre_cfdi = CONCAT(' timbre_cfdi=  ''', pr_timbre_cfdi, ''',');
	END IF;

    IF pr_version_timbrado != '' THEN
		SET lo_version_timbrado = CONCAT(' version_timbrado=  ''', pr_version_timbrado, ''',');
	END IF;

    IF pr_uuid != '' THEN
		SET lo_uuid = CONCAT(' uuid=  ''', pr_uuid, ''',');
	END IF;

    IF pr_fecha_timbrado != '0000-00-00 00:00:00' THEN
		SET lo_fecha_timbrado = CONCAT(' fecha_timbrado =  ''', pr_fecha_timbrado, ''',');
	END IF;

    IF pr_numero_certificado_sat != '' THEN
		SET lo_numero_certificado_sat = CONCAT(' numero_certificado_sat=  ''', pr_numero_certificado_sat, ''',');
	END IF;

    IF pr_sello_sat != '' THEN
		SET lo_sello_sat = CONCAT(' sello_sat=  ''', pr_sello_sat, ''',');
	END IF;

    IF pr_cadena_timbre != '' THEN
		SET lo_cadena_timbre = CONCAT(' cadena_timbre=  ''', pr_cadena_timbre, ''',');
	END IF;

    IF pr_cfdi_timbrado != '' THEN
		SET lo_cfdi_timbrado = CONCAT(' cfdi_timbrado=  ''', pr_cfdi_timbrado, ''',');
	END IF;

    IF pr_confirma_cancelacion_cfdi != '' THEN
		SET lo_confirma_cancelacion_cfdi = CONCAT(' confirma_cancelacion_cfdi=  ''', pr_confirma_cancelacion_cfdi, ''',');
	END IF;

    IF rfc_prov_ser != '' THEN
		SET lo_rfc_prov_ser = CONCAT(' rfc_prov_ser=  ''', rfc_prov_ser, ''',');
	END IF;

    SET @query = CONCAT('UPDATE ic_fac_tr_pagos_cfdi
						SET ',
							  lo_numero_certificado,
							  lo_cadena_original,
							  lo_sello_digital,
							  lo_certificado,
							  lo_genera_xml,
							  lo_factura_xml,
							  lo_genera_pdf,
							  lo_fecha_envio_email,
							  lo_timbre_cfdi,
							  lo_version_timbrado,
							  lo_uuid,
							  lo_fecha_timbrado,
							  lo_numero_certificado_sat,
							  lo_sello_sat,
							  lo_cadena_timbre,
							  lo_cfdi_timbrado,
							  lo_confirma_cancelacion_cfdi,
							  lo_rfc_prov_ser,
							  'id_cfdi=',pr_id_cfdi,
						' WHERE id_cfdi = ?'
	);

 --  Select @query;
	PREPARE stmt FROM @query;
    SET @id_cfdi = pr_id_cfdi;
	EXECUTE stmt USING @id_cfdi;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	COMMIT;


END$$
DELIMITER ;
