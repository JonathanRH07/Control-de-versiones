DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cfdi_us`(
	IN  pr_id_factura 			INT(11),
	IN  pr_uuid 				VARCHAR(100),
    IN  pr_factura_xml 			BLOB,
    IN	pr_archivo_addenda 		TEXT,
    OUT pr_affect_rows 			INT,
    OUT pr_message 	   			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_factura_cfdi_u
	@fecha:			04/08/2016
	@descripcion:	SP para actualizar registro de  ic_fac_tr_factura_cfdi
	@autor:			Griselda Medina Medina
	@cambios:
*/

	# Declaración de variables.
    DECLARE lo_factura_xml			VARCHAR(10000) DEFAULT '';
    DECLARE lo_archivo_addenda		VARCHAR(10000) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_cfdi_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	IF pr_factura_xml != '' THEN
		SET lo_factura_xml = CONCAT('factura_xml =  "', pr_factura_xml, '",');
	END IF;

	IF pr_archivo_addenda != '' THEN
		SET lo_archivo_addenda = CONCAT(' archivo_addenda = "', pr_archivo_addenda, '" ,');
	END IF;


	SET @query = CONCAT('UPDATE ic_fac_tr_factura_cfdi
						SET ',
							lo_factura_xml,
							lo_archivo_addenda,
						' WHERE id_factura = ?
						AND
						uuid=',uuid,'');


	PREPARE stmt FROM @query;

	SET @id_factura = pr_id_factura;
	EXECUTE stmt USING @id_factura;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
