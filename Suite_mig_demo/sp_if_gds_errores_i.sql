DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_errores_i`(
	IN	pr_id_gds_general		INT,
	IN  pr_problema			    VARCHAR(500),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_gds_errores_i
	@fecha:			08/08/2016
	@descripcion:	SP para insertar registro de catalogo de errores
	@autor:			Odeth Negrete
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_if_gds_errores_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_gds_tr_errores (
		id_gds_general,
		problema
		)
	VALUES
		(
		pr_id_gds_general,
		pr_problema
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
	COMMIT;

END$$
DELIMITER ;
