DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_impuestos_servicio_i`(
	IN  pr_id_servicio					INT,
	# Requiere una cadena de ID's separados por '|': '3|545|2|4|23|4'
	IN  pr_cadena_impuestos				VARCHAR(200),
	OUT pr_affect_rows					INT,
	OUT pr_message						VARCHAR(500))
BEGIN
/*
	Nombre: sp_cat_impuestos_servicio_i
	Fecha: 29/08/2016
	Descripcion: SP para insertar impuestos a un servicio
	Autor: Alan Olivares
	Cambios:
*/
	DECLARE lo_num_impuestos		INT;
	DECLARE lo_id_impuesto			INT;
	DECLARE lo_filas_existentes		INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_servicio_impuesto_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	SET pr_affect_rows = 0;
	SET pr_message = 'SUCCESS';
	SELECT f_cuenta_palabras(pr_cadena_impuestos,'|') INTO lo_num_impuestos;
	SELECT pr_cadena_impuestos, lo_num_impuestos;

	loop_inserts_servicios: LOOP

		# Aqui se obtiene el id_impuesto actual
		SELECT
			f_get_position_val_separator(pr_cadena_impuestos, '|', lo_num_impuestos)
		INTO
			lo_id_impuesto;

		CALL sp_help_get_row_count_params(
			'ic_fac_tr_impuesto_servicio',
			0,
			CONCAT(' id_servicio=', pr_id_servicio, ' AND id_impuesto=',lo_id_impuesto),
			lo_filas_existentes,
			pr_message);

		IF lo_filas_existentes > 0 THEN
			# Si ya existe una relación entonces solo se activa el estatus de la relación

			UPDATE
				ic_fac_tr_impuesto_servicio
				SET
				estatus_impuesto_servicio = 1
			WHERE
				id_servicio = pr_id_servicio	AND
				id_impuesto = lo_id_impuesto;
		ELSE
			INSERT INTO ic_fac_tr_impuesto_servicio(id_servicio, id_impuesto)
			VALUES(pr_id_servicio, lo_id_impuesto);
		END IF;


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
