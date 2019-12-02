DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_addenda_i`(
	IN  pr_id_cliente 		INT(11),
	IN  pr_addenda 			TEXT,
	IN  pr_id_addenda_def	INT(11),
	IN  pr_id_usuario 		INT(11),
	OUT pr_inserted_id 		INT(11),
	OUT pr_affect_rows 		INT(11),
	OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_addenda_i
		@fecha:			14/03/2017
		@descripcion: 	SP para inseratr registro en addenda
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_addenda_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;


	INSERT INTO ic_fac_tr_addenda (
		id_cliente,
        addenda,
		id_addenda_default,
		id_usuario
	) VALUES (
		pr_id_cliente,
        pr_addenda,
        pr_id_addenda_def,
		pr_id_usuario
	);

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	SET pr_inserted_id 	= @@identity;
	SET pr_message 		= 'SUCCESS';

END$$
DELIMITER ;
