DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_sucursal_i`(
	IN  pr_id_sucursal				INT,
	# Requiere una cadena de ID's separados por '|': '3|545|2|4|23|4'
	IN  pr_cadena_unid_neg			VARCHAR(200),
	OUT pr_affect_rows				INT,
	OUT pr_message					VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_unidad_sucursal_i
	@fecha: 		22/08/2016
	@descripcion: 	SP para insertar la relación entre una sucursal y las unidades de negocio asignadas
	@autor: 		Alan Olivares
	@cambios:
*/
	# Declaracion de variables.
	DECLARE lo_num_unidades				INT;
	DECLARE lo_id_unidad_negocio		INT;
	DECLARE lo_filas_existentes			INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_unidad_sucursal_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	SET pr_affect_rows = 0;
    SET pr_message = 'SUCCESS';
	SELECT f_cuenta_palabras(pr_cadena_unid_neg,'|') INTO lo_num_unidades;

	loop_inserts_unidades: LOOP
		# Aqui se obtiene el id_unidad_negocio actual
		SELECT
			f_get_position_val_separator(pr_cadena_unid_neg, '|', lo_num_unidades)
		INTO
			lo_id_unidad_negocio;

		CALL sp_help_get_row_count_params(
			'ic_cat_tr_unidad_sucursal',
			0,
			CONCAT(' id_sucursal =  ', pr_id_sucursal, ' AND id_unidad_negocio=',lo_id_unidad_negocio),
			lo_filas_existentes,
			pr_message);
		# Aquí se verifica si ya hay una relación entre la sucursal y la unidad de negocio por insertar
		IF lo_filas_existentes > 0 THEN
			# Si ya existe una relación entonces solo se activa el estatus de la relación
			UPDATE
				ic_cat_tr_unidad_sucursal
				SET
				estatus_unidad_sucursal = 1
			WHERE
				id_unidad_negocio 	= lo_id_unidad_negocio		AND
                id_sucursal			= pr_id_sucursal;
		ELSE
			# Sino existe una relación entonces se crea
			INSERT INTO ic_cat_tr_unidad_sucursal(id_sucursal, id_unidad_negocio)
			VALUES(pr_id_sucursal, lo_id_unidad_negocio);
		END IF;

		SELECT
			ROW_COUNT()
		INTO
			@temp_affected_rows
		FROM dual;

		SET pr_affect_rows = pr_affect_rows + @temp_affected_rows;
		SET lo_num_unidades = lo_num_unidades - 1;

		IF lo_num_unidades = 0 THEN
			LEAVE loop_inserts_unidades;
		END IF;
	END LOOP loop_inserts_unidades;

END$$
DELIMITER ;
