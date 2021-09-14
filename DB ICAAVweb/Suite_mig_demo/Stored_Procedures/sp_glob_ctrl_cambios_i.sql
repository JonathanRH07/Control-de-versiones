DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_ctrl_cambios_i`(
	IN  pr_id_catalogo		INT (11),
    IN  pr_id_registro		INT (11),
    IN  pr_id_usuario		INT (11),
    IN  pr_tipo_accion		ENUM('ALTA', 'ACTIVO', 'INACTIVO', 'CAMBIO', 'CANCELACION'),
    OUT pr_affect_rows		INT(11),
	OUT pr_message			VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_glob_ctrl_cambios_i
		@fecha: 		25/10/2016
		@descripción: 	SP para insertar registro de cambios en cada Catalogo.
		@autor: 		Odeth Negrete
		@Cambios:
	*/

	# Declaración de variables
	DECLARE lo_id_cambio   INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_ctrl_cambios_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	# Se inserta la direccion del catalogo a utilizar.
	INSERT INTO  ic_glob_tr_ctrl_cambios (
			id_catalogo,
			id_registro,
			id_usuario,
			tipo_accion
		) VALUES (
			pr_id_catalogo,
			pr_id_registro,
			pr_id_usuario,
			pr_tipo_accion
	);

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

    #SET pr_inserted_id 	= @@identity;
    IF pr_affect_rows = 1 THEN SET pr_message = 'SUCCESS'; ELSE ROLLBACK;
	COMMIT;
	END IF;
END$$
DELIMITER ;
