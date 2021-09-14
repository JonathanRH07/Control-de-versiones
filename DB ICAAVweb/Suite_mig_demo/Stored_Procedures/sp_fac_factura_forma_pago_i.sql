DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_forma_pago_i`(
	IN  pr_id_factura 				INT(11),
	IN  pr_id_forma_pago 			INT(11),
	IN  pr_id_antcte 				INT(11),
	IN  pr_id_forma_pago_sat 		CHAR(5),
	IN  pr_importe 					DECIMAL(15,2),
	IN  pr_referencia_anticipo 		VARCHAR(20),
	IN  pr_concepto 				VARCHAR(50),
	IN  pr_id_usuario 				INT(11),
	OUT pr_inserted_id			 	INT,
	OUT pr_affect_rows				INT,
	OUT pr_message					VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_forma_pago_i
		@fecha:			13/03/2017
		@descripcion:	SP para insertar registro en factura_forma_pago
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_forma_pago_i';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

	# Se insertan los valores ingresados.
		INSERT INTO ic_fac_tr_factura_forma_pago (
			id_factura,
			id_forma_pago,
			id_antcte,
			id_forma_pago_sat,
			importe,
			referencia_anticipo,
			concepto,
			id_usuario
		) VALUES (
			pr_id_factura,
			pr_id_forma_pago,
			pr_id_antcte,
			pr_id_forma_pago_sat,
			pr_importe,
			pr_referencia_anticipo,
			pr_concepto,
			pr_id_usuario
		);
		SET pr_inserted_id 	= @@identity;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		#Devuelve mensaje de ejecución
		SET pr_message = 'SUCCESS';
		-- COMMIT;
END$$
DELIMITER ;
