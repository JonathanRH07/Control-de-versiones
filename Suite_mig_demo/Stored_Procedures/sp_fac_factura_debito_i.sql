DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_debito_i`(
	IN	pr_id_grupo_empresa			INT,
    IN	pr_id_pago					INT,
    IN	pr_id_factura				INT,
    IN  pr_importe 					DECIMAL(13,2),
    IN	pr_concepto					VARCHAR(150),
    OUT pr_inserted_id				INT,
	OUT pr_affect_rows	    		INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_debito_i
		@fecha:			25/07/2018
		@descripcion:	Sp para insertar registros a la tabla de ic_fac_tr_debito para aplicar notas
		@autor: 		Carol Mejía
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_debito_i';
	END ;

   -- START TRANSACTION;

	INSERT INTO ic_fac_tr_debito(
		id_grupo_empresa,
        id_pago,
		id_factura,
        importe,
		concepto
	) VALUES (
		pr_id_grupo_empresa,
        pr_id_pago,
		pr_id_factura,
        pr_importe,
		pr_concepto
	);
	SET pr_inserted_id 	= @@identity;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
