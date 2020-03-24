DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_adicional_i`(
	IN 	pr_id_cliente 			INT(11),
	IN 	pr_politicas_viaje 		TEXT,
	IN 	pr_preferencias 		TEXT,
    IN  pr_id_usuario			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_adicional_i
	@fecha:			25/01/2017
	@descripcion:	SP para agregar registros en Cliente_adicional
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_politicas_viaje 	VARCHAR(10000) DEFAULT '';
    DECLARE lo_preferencias 	VARCHAR(10000) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_adicional_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;


    IF pr_politicas_viaje = 'null' THEN
		SET lo_politicas_viaje = NULL;
	ELSE
		SET lo_politicas_viaje = pr_politicas_viaje;
	END IF;

    IF pr_preferencias = 'null' THEN
		SET lo_preferencias = NULL;
	ELSE
		SET lo_preferencias = pr_preferencias;
	END IF;

	INSERT INTO ic_cat_tr_cliente_adicional(
		id_cliente,
        politicas_viaje,
        preferencias,
        id_usuario
		)
	VALUES
		(
		pr_id_cliente,
        lo_politicas_viaje,
        lo_preferencias,
        pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
