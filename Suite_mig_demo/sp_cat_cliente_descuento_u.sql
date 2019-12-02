DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_descuento_u`(
	IN  pr_id_cliente_descuento INT(11),
	IN  pr_id_proveedor 		INT(11),
	IN  pr_id_cliente 			INT(11),
	IN  pr_id_servicio 			INT(11),
	IN  pr_descuento 			DECIMAL(16,2),
    IN 	pr_id_usuario			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_cliente_descuento_u
		@fecha:			11/01/2018
		@descripcion:	SP para actualizar registro en Cliente_descuento
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	#Declaracion de variables.
	DECLARE	lo_id_proveedor		VARCHAR(200) DEFAULT '';
	DECLARE	lo_id_cliente		VARCHAR(200) DEFAULT '';
	DECLARE	lo_id_servicio		VARCHAR(200) DEFAULT '';
	DECLARE	lo_descuento		VARCHAR(200) DEFAULT '';
    DECLARE lo_duplicado		INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_descuento_u';
		ROLLBACK;
	END;

	SELECT
		COUNT(*)
	INTO
		lo_duplicado
	FROM ic_cat_tr_cliente_descuento
	WHERE id_cliente = pr_id_cliente
	AND id_proveedor = pr_id_proveedor
	AND id_servicio = pr_id_servicio
    AND id_cliente_descuento != pr_id_cliente_descuento;

	IF pr_id_proveedor > 0 THEN
		SET lo_id_proveedor = CONCAT('id_proveedor = ', pr_id_proveedor, ',');
	END IF;

	IF pr_id_cliente > 0 THEN
		SET lo_id_cliente = CONCAT('id_cliente = "', pr_id_cliente, '",');
	END IF;

    IF pr_id_servicio  > 0 THEN
		SET lo_id_servicio = CONCAT('id_servicio = "', pr_id_servicio, '",');
	END IF;

	IF pr_descuento > 0 THEN
		SET lo_descuento = CONCAT('descuento = "', pr_descuento, '",');
	END IF;

	IF lo_duplicado = 0 THEN
		SET @query = CONCAT('
						UPDATE ic_cat_tr_cliente_descuento
						SET ',
							lo_id_proveedor,
							lo_id_cliente,
							lo_id_servicio,
							lo_descuento,
							' id_usuario =',pr_id_usuario ,
							' , fecha_mod = sysdate()
						WHERE id_cliente_descuento = ?
		');

        PREPARE stmt FROM @query;
		SET @id_cliente_descuento = pr_id_cliente_descuento;
		EXECUTE stmt USING @id_cliente_descuento;
	ELSE
		SET pr_message = 'ERROR CVE_DUPLICATE';
	END IF;

    SELECT
		ROW_COUNT()
    INTO
		pr_affect_rows
	FROM DUAL; #Devuelve el numero de registros insertados

    SET pr_message = 'SUCCESS'; # Mensaje de ejecucion.

END$$
DELIMITER ;
