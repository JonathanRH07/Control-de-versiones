DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_sucursal_d`(
	IN  pr_id_sucursal				INT,
	IN  pr_cadena_unid_neg			VARCHAR(200),
	OUT pr_affect_rows				INT,
	OUT pr_message					VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_unidad_sucursal_d
	@fecha: 		22/08/2016
	@descripcion:	Este SP actualiza el estatus de la unidad de negocio a 'INACTIVO'
	@autor: 		Alan Olivares
	@cambios:
	@TODO: 			Hacer una validación para verificar si se puede eliminar
*/
	#Declaración de variables.
	DECLARE lo_num_unidades INT;
	DECLARE lo_id_unidad_negocio INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_unidad_sucursal_d';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	SET pr_affect_rows = 0;
	SET pr_message = 'SUCCESS';
	SELECT f_cuenta_palabras(pr_cadena_unid_neg,'|') INTO lo_num_unidades;

	loop_inserts_unidades: LOOP

		SELECT
			f_get_position_val_separator(pr_cadena_unid_neg, '|', lo_num_unidades)
		INTO
			lo_id_unidad_negocio;

		UPDATE ic_cat_tr_unidad_sucursal
			SET
			estatus_unidad_sucursal = 2
		WHERE
			id_sucursal			= pr_id_sucursal AND
			id_unidad_negocio	= lo_id_unidad_negocio;

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
