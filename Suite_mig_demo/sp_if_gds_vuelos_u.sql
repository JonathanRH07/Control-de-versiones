DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_vuelos_u`(
	IN  pr_id_gds_vuelos 			INT(11),
	IN  pr_id_factura_detalle 		INT(11),
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_gds_vuelos_u
		@fecha: 		22/01/2018
		@descripcion: 	SP para actualizar registros en la tabla ic_gds_tr_vuelos
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	# Declaración de variables.
	DECLARE lo_id_factura_detalle 		VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_vuelos_u';
	END ;

    START TRANSACTION;

	IF pr_id_factura_detalle != '' THEN
		SET lo_id_factura_detalle = CONCAT(' id_factura_detalle = "', pr_id_factura_detalle , '"');
    END IF;

    SET @query = CONCAT('
			UPDATE ic_gds_tr_vuelos
			SET ',
				lo_id_factura_detalle,
			' WHERE id_gds_vuelos= ?'
	);
	PREPARE stmt FROM @query;
	SET @id_gds_vuelos = pr_id_gds_vuelos;
	EXECUTE stmt USING @id_gds_vuelos;

    #Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
    COMMIT;
END$$
DELIMITER ;
