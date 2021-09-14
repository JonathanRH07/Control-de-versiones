DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_centro_costo_v2_d`(
	IN  pr_id_centro_costo 	INT,
    IN  pr_usuario		   	INT,
    OUT pr_affect_rows	   	INT,
	OUT pr_message		   	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_centro_costo_v2_u
	@fecha:			19/10/2017
	@descripcion:	SP para actualizar registro en centro_costo
	@autor:			David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_centro_costo_v2_d';
		ROLLBACK;
	END;



    DELETE
		FROM ic_cat_tr_centro_costo
    WHERE  id_centro_costo = pr_id_centro_costo;

    #Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';



END$$
DELIMITER ;
