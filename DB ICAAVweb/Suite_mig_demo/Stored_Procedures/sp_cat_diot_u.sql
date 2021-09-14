DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_diot_u`(
	IN 	pr_id_proveedor				INT,
    IN 	pr_id_sat_tipo_tercero 		INT,
    IN 	pr_id_sat_tipo_operacion 	INT,
    IN 	pr_id_usuario				INT,
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_diot_u
	@fecha:			02/02/2017
	@descripcion:	SP para actualizar registros el DOIT
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_sat_tipo_tercero 			VARCHAR(200) DEFAULT '';
	DECLARE lo_id_sat_tipo_operacion		VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_diot_u';
		ROLLBACK;
	END;


	IF pr_id_sat_tipo_tercero > 0 THEN
		SET lo_id_sat_tipo_tercero = CONCAT('id_sat_tipo_tercero = ', pr_id_sat_tipo_tercero, ',');
	END IF;

    IF pr_id_sat_tipo_operacion > 0 THEN
		SET lo_id_sat_tipo_operacion = CONCAT('id_sat_tipo_operacion = ', pr_id_sat_tipo_operacion, ',');
	END IF;

	SET @query = CONCAT('UPDATE ic_cat_tr_proveedor
							SET ',
								lo_id_sat_tipo_tercero,
								lo_id_sat_tipo_operacion,
                                ' id_usuario=',pr_id_usuario ,
								' , fecha_mod = sysdate()
							WHERE id_proveedor = ? ');

	PREPARE stmt FROM @query;

	SET @id_proveedor= pr_id_proveedor;
	EXECUTE stmt USING @id_proveedor;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
