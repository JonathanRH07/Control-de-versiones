DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cxs_xcliente_i`(
	IN  pr_id_gds_cxs 		INT(11),
	IN  pr_id_cliente 		INT(11),
	IN  pr_importe 			DECIMAL(16,2),
	IN  pr_id_usuario		INT(11),
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows      INT,
    OUT pr_message 	        VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_cxs_xcliente_i
	@fecha: 		05/04/2018
	@descripcion: 	SP para inseratr en ic_gds_tr_cxs_xcliente
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_cxs_xcliente_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_gds_tr_cxs_xcliente (
		id_gds_cxs,
		id_cliente,
		importe,
        id_usuario
		)
	VALUE
		(
		pr_id_gds_cxs,
		pr_id_cliente,
		pr_importe,
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
