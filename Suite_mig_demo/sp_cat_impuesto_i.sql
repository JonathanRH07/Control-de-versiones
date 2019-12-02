DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_impuesto_i`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_c_ClaveProdServ		CHAR(30),
	IN  pr_id_unidad			INT(11),
    IN  pr_cve_impuesto			CHAR(10),
	IN  pr_desc_impuesto		CHAR(30),
	IN  pr_tipo_valor_impuesto	ENUM('T','C','E'),
	IN  pr_valor_impuesto		DECIMAL(16,4),
	IN  pr_cve_impuesto_cat		CHAR(10),
	IN  pr_por_pagar_impuesto  	ENUM('SI', 'NO'),
	IN  pr_tipo 				ENUM('F', 'L'),
	IN  pr_clase 				ENUM('T', 'R'),
	IN  pr_estatus_impuesto    	ENUM('ACTIVO', 'INACTIVO'),
	IN	pr_id_usuario			INT(11),
	OUT pr_inserted_id			INT,
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_impuesto_i
		@fecha:			26/08/2016
		@descripcion:	SP para insertar registro de catalogo Impuestos.
		@autor:			Odeth Negrete
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_impuestos_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

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
	# Se insertan los valores ingresados.
		INSERT INTO ic_cat_tr_impuesto (
			id_grupo_empresa,
            #c_ClaveProdServ,
            #id_unidad,
			cve_impuesto,
			desc_impuesto,
			tipo_valor_impuesto,
			valor_impuesto,
            cve_impuesto_cat,
            por_pagar_impuesto,
			tipo,
			clase,
			estatus_impuesto,
            id_usuario
		)VALUES (
			pr_id_grupo_empresa,
            #pr_c_ClaveProdServ,
            #pr_id_unidad,
			pr_cve_impuesto,
			pr_desc_impuesto,
			pr_tipo_valor_impuesto,
			pr_valor_impuesto,
            pr_cve_impuesto_cat,
            pr_por_pagar_impuesto,
            pr_tipo,
            pr_clase,
            pr_estatus_impuesto,
            pr_id_usuario
		);

		SET pr_inserted_id 	= @@identity;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		#Devuelve mensaje de ejecución
		SET pr_message = 'SUCCESS';
		COMMIT;

	END IF;
END$$
DELIMITER ;
