DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_descuento_i`(
	IN  pr_id_proveedor 	INT(11),
	IN  pr_id_cliente 		INT(11),
	IN  pr_id_servicio 		INT(11),
	IN  pr_descuento 		DECIMAL(16,2),
    IN 	pr_id_usuario		INT,
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_cliente_descuento_i
		@fecha:			11/01/2018
		@descripcion:	SP para agregar descuentos a Clientes.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

    DECLARE lo_duplicado	INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_descuento_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	SELECT
		COUNT(*)
	INTO
		lo_duplicado
	FROM ic_cat_tr_cliente_descuento
	WHERE id_cliente = pr_id_cliente
	AND id_proveedor = pr_id_proveedor
	AND id_servicio = pr_id_servicio;

    IF lo_duplicado = 0 THEN
		INSERT INTO ic_cat_tr_cliente_descuento (
			id_proveedor,
			id_cliente,
			id_servicio,
			descuento,
			id_usuario
		) VALUES (
			pr_id_proveedor,
			pr_id_cliente,
			pr_id_servicio,
			pr_descuento,
			pr_id_usuario
		);
	ELSE
		SET pr_message = 'ERROR CVE_DUPLICATE';
	END IF;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	SET pr_inserted_id 	= @@identity;

    #Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
