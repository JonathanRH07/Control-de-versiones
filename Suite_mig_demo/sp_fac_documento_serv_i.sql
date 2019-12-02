DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_documento_serv_i`(
	IN  pr_id_factura 					INT(11),
	IN  pr_pdf_documento				BLOB,
	OUT pr_inserted_id					INT,
	OUT pr_affect_rows	    			INT,
	OUT pr_message		    			VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_documento_serv_i
		@fecha 		: 11/06/2018
		@descripcion: SP para agregar registros en la tabla de ic_fac_documento_servicio.
		@autor 		: Carol Lizeth Mejía Soto
		@cambios 	:
	*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_documento_serv_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_fac_documento_servicio(
		id_factura,
		pdf_documento_servicio
	) VALUES (
		pr_id_factura,
		pr_pdf_documento
	);
	SET pr_inserted_id 	= @@identity;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
