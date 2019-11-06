DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_accion_permiso_u`(
	IN 	pr_id_accion_permiso 		INT(11),
	IN 	pr_id_tipo_permiso 			INT(11),
	IN 	pr_id_controlador 			INT(11),
	IN 	pr_id_submodulo 			INT(11),
	IN 	pr_nom_accion 				VARCHAR(50),
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_accion_permiso_u
	@fecha:			17/01/2017
	@descripcion:	SP para actualizar registros en la tabla st_adm_tc_accion_permiso
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_tipo_permiso 		VARCHAR(200) DEFAULT '';
	DECLARE lo_id_controlador 		VARCHAR(200) DEFAULT '';
	DECLARE lo_id_submodulo 		VARCHAR(200) DEFAULT '';
	DECLARE lo_nom_accion 			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_accion_permiso_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_tipo_permiso > 0 THEN
		SET lo_id_tipo_permiso = CONCAT('id_tipo_permiso = ', pr_id_tipo_permiso, ',');
	END IF;

    IF pr_id_controlador > 0 THEN
		SET lo_id_controlador = CONCAT('id_controlador = ', pr_id_controlador, ',');
	END IF;

    IF pr_id_submodulo > 0 THEN
		SET lo_id_submodulo = CONCAT('id_submodulo = ', pr_id_submodulo, ',');
	END IF;

    IF pr_nom_accion != '' THEN
		SET lo_nom_accion = CONCAT('nom_accion = "', pr_nom_accion, '"');
	END IF;

   SET @query = CONCAT('UPDATE st_adm_tc_accion_permiso
							SET ',
								lo_id_tipo_permiso,
								lo_id_controlador,
								lo_id_submodulo,
								lo_nom_accion,
						' WHERE id_accion_permiso = ?'
	);

	PREPARE stmt FROM @query;
	SET @id_accion_permiso= pr_id_accion_permiso;
	EXECUTE stmt USING @id_accion_permiso;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
