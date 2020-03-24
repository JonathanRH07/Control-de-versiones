DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_analisis_u`(
	IN  pr_id_factura_analisis 	INT(11),
	IN  pr_id_factura 			INT(11),
	IN  pr_no_analisis 			VARCHAR(4),
	IN  pr_descripcion 			VARCHAR(50),
	OUT pr_affect_rows 			INT,
	OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre 		: sp_fac_factura_analisis_u
		@fecha 			: 03/03/2017
		@descripcion 	: SP para actualizar registros en el modulo de facturacion_analisis.
		@autor 			: Griselda Medina Medina
		@cambios 		:
	*/

	# Declaración de variables.
	DECLARE  lo_no_analisis 		VARCHAR(100) DEFAULT '';
    DECLARE  lo_descripcion 		VARCHAR(100) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_analisis_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	IF pr_no_analisis != '' THEN
		SET lo_no_analisis = CONCAT(' no_analisis=  "', pr_no_analisis, '",');
	END IF;

    IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT(' descripcion=  "', pr_descripcion, '"');
	END IF;

	SET @query = CONCAT('
			UPDATE ic_fac_tr_factura_analisis
			SET ',
				lo_no_analisis,
				lo_descripcion,
			' WHERE id_factura_analisis = ?'
	);
	PREPARE stmt FROM @query;
	SET @id_factura_analisis = pr_id_factura_analisis;
	EXECUTE stmt USING @id_factura_analisis;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
