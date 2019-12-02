DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_detalle_imp_i`(
	IN  pr_id_factura_detalle 		INT(11),
	IN  pr_id_impuesto 				INT(11),
	IN  pr_base_valor 				VARCHAR(10),
	IN  pr_base_valor_cantidad 		DECIMAL(15,2),
	IN  pr_valor_impuesto 			VARCHAR(10),
	IN  pr_cantidad 				DECIMAL(15,2),
	IN  pr_id_usuario 				INT(11),
	OUT pr_inserted_id			 	INT,
	OUT pr_affect_rows				INT,
	OUT pr_message					VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_factura_detalle_imp_i
		@fecha 		: 13/03/2017
		@descripcion: SP para insertar registro en factura_detalle_imp
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_detalle_imp_i';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;
	/*
    # Checa si ya existe la clave.
    CALL sp_help_get_row_count_params(
			'ic_cat_tr_impuesto',
			pr_id_grupo_empresa,
			CONCAT(' cve_impuesto =  "', pr_cve_impuesto,'" '),
			@has_relations_with_tax,
			pr_message
	);

	IF @has_relations_with_tax> 0 THEN
		SET @error_code = 'CVE_DUPLICATE';
		SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_tax),'}');
		SET pr_affect_rows = 0;
		ROLLBACK;
	ELSE
	*/

    # Se insertan los valores ingresados.
	INSERT INTO ic_fac_tr_factura_detalle_imp (
		id_factura_detalle,
		id_impuesto,
		base_valor,
		base_valor_cantidad,
		valor_impuesto,
		cantidad,
		id_usuario
	) VALUES (
		pr_id_factura_detalle,
		pr_id_impuesto,
		pr_base_valor,
		pr_base_valor_cantidad,
		pr_valor_impuesto,
		pr_cantidad,
		pr_id_usuario
	);

	SET pr_inserted_id 	= @@identity;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS'; 	#Devuelve mensaje de ejecución
	-- COMMIT;

# END IF;
END$$
DELIMITER ;
