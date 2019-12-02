DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_servicio_impuesto_u`(
	IN  pr_id_servicio_impuesto		INT(11),
    IN  pr_id_usuario				INT(11),
    IN  pr_id_servicio				INT(11),
    IN  pr_id_impuesto      		INT(11),
    IN  pr_estatus		 			ENUM('ACTIVO', 'INACTIVO'),
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_servicio_impuesto_u
		@fecha:			27/12/2016
		@descripcion: 	SP para actualizar los registros en servicios impuestos
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	# Variables
    DECLARE lo_id_servicio    	VARCHAR(100) DEFAULT '';
    DECLARE lo_id_impuesto    	VARCHAR(100) DEFAULT '';
    DECLARE lo_estatus			VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_servicio_impuesto_u';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	IF pr_id_servicio  > 0 THEN
		SET lo_id_servicio  = CONCAT('id_servicio  = ', pr_id_servicio, ',');
    END IF;

	IF pr_id_impuesto > 0 THEN
		SET lo_id_impuesto = CONCAT('id_impuesto = ', pr_id_impuesto, ',');
    END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus= CONCAT('estatus  = "', pr_estatus , '",');
    END IF;

    SET @query = CONCAT('
			UPDATE ic_fac_tr_servicio_impuesto SET ',
				lo_id_servicio,
				lo_id_impuesto,
				lo_estatus,
				' id_usuario=',pr_id_usuario,
				', fecha_mod  = sysdate()
			WHERE id_servicio_impuesto = ?'
	);
	PREPARE stmt FROM @query;
	SET @id_servicio_impuesto = pr_id_servicio_impuesto;
	EXECUTE stmt USING @id_servicio_impuesto;

	#Devuelve el numero de registros insertados
    SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

    # Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
