DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_addenda_default_i`(
	IN  pr_id_addenda			INT(11),
	IN  pr_id_cliente 			INT(11),
	IN  pr_addenda_default 		TEXT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_fac_addenda_default_i
	@fecha: 		30/11/2017
	@descripcion: 	SP para inseratr registros en la tabla ic_fac_tr_addenda_default
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_fac_addenda_default_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;


	INSERT INTO  ic_fac_tr_addenda_default(
		id_addenda,
		id_cliente,
		addenda_default
		)
	VALUE
		(
        pr_id_addenda,
		pr_id_cliente,
		pr_addenda_default
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
