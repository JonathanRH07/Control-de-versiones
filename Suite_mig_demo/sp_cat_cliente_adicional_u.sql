DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_adicional_u`(
	IN	pr_id_cliente_adicional 	INT(11),
	IN 	pr_id_cliente 				INT(11),
	IN 	pr_politicas_viaje 			TEXT,
	IN 	pr_preferencias 			TEXT,
    IN  pr_id_usuario				INT,
    OUT pr_affect_rows	        	INT,
	OUT pr_message		       		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_adicional_u
	@fecha:			04/01/2017
	@descripcion:	SP para actualizar registros en Cliente_adicional
	@autor:			Griselda Medina Medina
	@cambios:
*/

	#Declaracion de variables.
	DECLARE lo_politicas_viaje 		VARCHAR(200) DEFAULT '';
	DECLARE lo_preferencias			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_adicional_u';
		ROLLBACK;
	END;



	IF pr_politicas_viaje = '' THEN
		SET lo_politicas_viaje = CONCAT('politicas_viaje  = NULL,');
	ELSE IF pr_politicas_viaje != '' THEN
		SET lo_politicas_viaje = CONCAT('politicas_viaje  = "', pr_politicas_viaje, '",');
	END IF;
    END IF;

    IF pr_politicas_viaje ='null' THEN
		SET lo_politicas_viaje = CONCAT('politicas_viaje  = NULL,');
	END IF;


	IF pr_preferencias = '' THEN
		SET lo_preferencias = CONCAT('preferencias  = NULL,');
	ELSE IF pr_preferencias != '' THEN
			SET lo_preferencias =CONCAT('preferencias  = "', pr_preferencias, '",');
    END IF;
    END IF;

    IF pr_preferencias='null' THEN
		SET lo_preferencias = CONCAT('preferencias  = NULL,');
	END IF;

	SET @query = CONCAT('UPDATE ic_cat_tr_cliente_adicional
							SET ',
								lo_politicas_viaje,
								lo_preferencias,
                                ' id_usuario=',pr_id_usuario ,
								', fecha_mod = sysdate()
							WHERE id_cliente = ?');

	PREPARE stmt FROM @query;

	SET @id_cliente= pr_id_cliente;
	EXECUTE stmt USING @id_cliente;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';


END$$
DELIMITER ;
