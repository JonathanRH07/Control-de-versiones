DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_boletos_i`(
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_id_proveedor 		INT(11),
	IN  pr_id_inventario 		INT(11),
	IN  pr_id_gds 				INT(11),
	IN  pr_id_sucursal 			INT(11),
	IN  pr_id_factura_detalle 	INT(11),
	IN  pr_origen 				CHAR(3),
	IN  pr_numero_bol 			VARCHAR(15),
	IN  pr_conjunto 			VARCHAR(15),
	IN  pr_ruta 				VARCHAR(100),
	IN  pr_id_usuario 			INT,
	OUT pr_inserted_id			INT,
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre 		: sp_fac_boletos_i
		@fecha 			: 06/09/2017
		@descripcion 	: SP para insertar registro en la tabla de boletos
		@autor 			: Griselda Medina Medina
		@cambios 		:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_boletos_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    /*
    # Checa si ya existe la clave.
    CALL sp_help_get_row_count_params(
			'ic_fac_tr_boletos',
			pr_id_grupo_empresa,
			CONCAT(' numero_bol =  "', pr_numero_bol,'" '),
			@has_relations,
			pr_message
	);

	IF @has_relations> 0 THEN
		SET @error_code = 'BOL_DUPLICATE';
		SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations),'}');
		SET pr_affect_rows = 0;
		ROLLBACK;
	ELSE
    */

	INSERT INTO ic_fac_tr_factura_boleto(
		id_grupo_empresa,
		id_proveedor,
		id_inventario,
		id_gds,
		id_sucursal,
		id_factura_detalle,
		origen,
		numero_bol,
		conjunto,
		ruta,
		id_usuario
	)
	VALUES(
		pr_id_grupo_empresa,
		pr_id_proveedor,
		pr_id_inventario,
		pr_id_gds,
		pr_id_sucursal,
		pr_id_factura_detalle,
		pr_origen,
		pr_numero_bol,
		pr_conjunto,
		pr_ruta,
		pr_id_usuario
	);
	SET pr_inserted_id 	= @@identity;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	#Devuelve mensaje de ejecución
	SET pr_message = 'SUCCESS';
	COMMIT;

	#END IF;
END$$
DELIMITER ;
