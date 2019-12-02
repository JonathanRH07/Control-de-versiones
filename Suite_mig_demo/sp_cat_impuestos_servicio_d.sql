DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_impuestos_servicio_d`(
	IN  pr_id_servicio					INT,
	# Requiere una cadena de ID's separados por '|': '3|545|2|4|23|4'
	IN  pr_cadena_impuestos				VARCHAR(200),
	OUT pr_affect_rows					INT,
	OUT pr_message						VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_impuestos_servicio_d
	@fecha: 		29/08/2016
	@descripcion: 	SP para actualizar a 'INACTIVO' los impuestos de un servicio.
	@autor: 		Alan Olivares
	cambios:
*/
	DECLARE lo_num_impuestos		INT;
	DECLARE lo_id_impuesto			INT;
	DECLARE lo_filas_existentes		INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_servicio_impuesto_d';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	SET pr_affect_rows = 0;
	SET pr_message = 'SUCCESS';
	SELECT f_cuenta_palabras(pr_cadena_impuestos,'|') INTO lo_num_impuestos;

	loop_inserts_servicios: LOOP

		# Aqui se obtiene el id_impuesto actual
		SELECT
			f_get_position_val_separator(pr_cadena_impuestos, '|', lo_num_impuestos)
		INTO
			lo_id_impuesto;

		# Actualiza el impuesto servicio a un estatus 'INACTIVO'
		UPDATE
			ic_fac_tr_impuesto_servicio
			SET
			estatus_impuesto_servicio = 2
		WHERE
			id_servicio = pr_id_servicio		AND
			id_impuesto = lo_id_impuesto;

		SELECT
			ROW_COUNT()
		INTO
			@temp_affected_rows
		FROM dual;

		SET pr_affect_rows = pr_affect_rows + @temp_affected_rows;
		SET lo_num_impuestos = lo_num_impuestos - 1;

		IF lo_num_impuestos = 0 THEN
			LEAVE loop_inserts_servicios;
		END IF;
	END LOOP loop_inserts_servicios;
END$$
DELIMITER ;
