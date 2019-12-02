DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_centro_costo_nivel_i`(
	IN  pr_id_cliente 		INT(11),
	IN  pr_nivel 			SMALLINT(6),
	IN  pr_descripcion 		VARCHAR(30),
	IN  pr_id_usuario 		INT(11),
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_centro_costo_nivel_i
	@fecha:			17/03/2017
	@descripcion:	SP para agregar registros en la tabla centro_costo_nivel
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_centro_costo_nivel_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	INSERT INTO ic_cat_tr_centro_costo_nivel (
		id_cliente,
        nivel,
        descripcion,
        id_usuario
		)
	VALUES
		(
		pr_id_cliente,
        pr_nivel,
        pr_descripcion,
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
