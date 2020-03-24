DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_documento_serv_u`(
	IN  pr_id_documento_servicio 	INT(11),
    IN  pr_pdf_documento			BLOB,
	OUT pr_affect_rows 				INT,
    OUT pr_message 	   				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_documento_serv_u
		@fecha:			12/08/2018
		@descripcion:	SP para actualizar registros en la tabla ic_fac_documento_servicio.
		@autor:			Carol Mejia
		@cambios:
	*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR store sp_fac_documento_serv_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	UPDATE ic_fac_documento_servicio
	SET pdf_documento_servicio = pr_pdf_documento
	WHERE id_documento_servicio = pr_id_documento_servicio;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
