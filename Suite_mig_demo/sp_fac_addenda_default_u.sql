DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_addenda_default_u`(
	IN  pr_id_addenda 				int(11),
	IN  pr_id_cliente 				int(11),
	IN  pr_addenda_default 			text,
	OUT pr_affect_rows      	 	INT,
	OUT pr_message 	         	 	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_fac_addenda_default_i
	@fecha: 		30/11/2017
	@descripcion: 	SP para actualizar registros en la tabla ic_fac_tr_addenda_default
	@autor: 		Griselda Medina Medina
	@cambios:
*/

	DECLARE lo_id_cliente				VARCHAR(200) DEFAULT '';
    DECLARE lo_addenda_default 			VARCHAR(2000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_addenda_default_i';
        SET pr_affect_rows = 0;
	ROLLBACK;
	END;

	START TRANSACTION;


	IF pr_addenda_default != '' THEN
		SET lo_addenda_default= CONCAT(' addenda_default =  ''', pr_addenda_default, '');
	END IF;


	# Actualización en la tabla.
	SET @query = CONCAT('UPDATE ic_fac_tr_addenda_default
							SET ',
								lo_addenda_default,
							''' WHERE id_addenda = ?
							AND
							id_cliente=',pr_id_cliente,'');

-- select @query;
	PREPARE stmt
		FROM @query;


	SET @id_addenda = pr_id_addenda;
	EXECUTE stmt USING @id_addenda;

	#Devuelve el numero de registros afectados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
