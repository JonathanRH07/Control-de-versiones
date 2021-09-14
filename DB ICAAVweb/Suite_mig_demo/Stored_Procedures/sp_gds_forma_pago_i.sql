DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_forma_pago_i`(
	IN  pr_id_grupo_empresa 	int(11),
	IN  pr_id_forma_pago 		int(11),
	IN  pr_id_gds_forma_pago 	int(11),
    IN  pr_id_usuario			INT(11),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_forma_pago_i
	@fecha: 		03/04/2018
	@descripcion: 	SP para inseratr en ic_gds_tr_forma_pago
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_forma_pago_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_gds_tr_forma_pago_emp (
		id_grupo_empresa,
		id_forma_pago,
		id_gds_forma_pago,
        id_usuario
		)
	VALUES
		(
		pr_id_grupo_empresa,
		pr_id_forma_pago,
		pr_id_gds_forma_pago,
        pr_id_usuario
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
