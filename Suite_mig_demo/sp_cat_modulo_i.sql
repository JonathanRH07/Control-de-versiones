DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_modulo_i`(
	IN  pr_id_sistema    		INT,
    IN	pr_nombre_modulo		VARCHAR(60),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_modulo_i
	@fecha:			15/12/2016
	@descripcion:	SP para insertar registro de catalogo de modulos.
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_modulo_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO suite_mig_conf.st_adm_tc_modulo(
		id_sistema,
		nombre_modulo
		)
	VALUES
		(
		pr_id_sistema,
		pr_nombre_modulo
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
