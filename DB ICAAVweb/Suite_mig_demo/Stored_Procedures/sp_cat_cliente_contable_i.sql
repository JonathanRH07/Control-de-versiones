DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_contable_i`(
	IN	pr_id_cliente			INT,
	IN 	pr_id_cuenta_contable 	INT,
    IN 	pr_dias_credito 		INT,
    IN 	pr_limite_credito 		INT,
    IN 	pr_porcentaje_descuento INT,
    IN 	pr_id_usuario			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_contable_i
	@fecha:			04/01/2017
	@descripcion:	SP para agregar registros en Cliente_contable.
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_contable_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_cat_tr_cliente_contable (
		id_cliente,
        id_cuenta_contable,
        dias_credito,
        limite_credito,
        porcentaje_descuento,
        id_usuario
		)
	VALUES
		(
		pr_id_cliente,
        pr_id_cuenta_contable,
        pr_dias_credito,
        pr_limite_credito,
        pr_porcentaje_descuento,
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
	COMMIT;

END$$
DELIMITER ;
