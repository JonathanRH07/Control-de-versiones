DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_ctrl_cambios_u`(
	IN  pr_id_catalogo			INT(11),
    IN  pr_id_registro			INT(11),
    IN  pr_id_usuario			INT(11),
    IN  pr_tipo_accion			ENUM('ALTA', 'ACTIVO', 'INACTIVO', 'CAMBIO', 'CANCELACION'),
    IN  pr_campo				CHAR(50),
    IN  pr_valor_original		CHAR(200),
    IN  pr_valor_nuevo			CHAR(200),
	OUT pr_affect_rows			INT(11),
	OUT pr_message				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_glob_ctrl_cambios_u
	@fecha: 		28/10/2016
	@descripción: 	SP para insertar generar el registro de actualizaciones de registro de cada catalogo.
	@autor: 		Odeth Negrete
	@cambios:

*/
	# Declaración de Variables
	#DECLARE lo_id_direccion		INT;
    #DECLARE lo_existe_doc       INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_ctrl_cambios_u';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

			# Se inserta el campo actualizado en el catalogo a utilizar
			INSERT INTO ic_glob_tr_ctrl_cambios (
				id_catalogo,
				id_registro,
				id_usuario,
				tipo_accion,
				campo,
				valor_original,
				valor_nuevo
				)
			VALUES (
				pr_id_catalogo,
				pr_id_registro,
				pr_id_usuario,
				pr_tipo_accion,
				pr_campo,
				pr_valor_original,
				pr_valor_nuevo
				);

			#Devuelve el numero de registros insertados
			SELECT
				ROW_COUNT()
			INTO
				pr_affect_rows
			FROM dual;
			IF pr_affect_rows = 1 THEN
			#Devuelve mensaje de ejecucion
					SET pr_message = 'SUCCESS';
				ELSE
						ROLLBACK;
				COMMIT;
			END IF;

	END$$
DELIMITER ;
