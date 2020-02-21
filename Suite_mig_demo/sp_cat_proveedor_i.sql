DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_i`(
	IN	pr_id_grupo_empresa			INT,
	IN	pr_id_tipo_proveedor 		INT,
    IN	pr_id_direccion 			INT,
    IN	pr_id_sucursal 				INT,
    IN	pr_cve_proveedor 			VARCHAR(45),
    IN 	pr_tipo_proveedor_operacion	ENUM('INGRESO','EGRESO','AMBOS'),
    IN	pr_tipo_persona 			CHAR(1),
    IN	pr_rfc 						VARCHAR(30),
    IN	pr_razon_social 			VARCHAR(255),
    IN	pr_nombre_comercial			VARCHAR(255),
    IN	pr_telefono 				VARCHAR(20),
    IN 	pr_email					VARCHAR(255),
    IN	pr_id_usuario				INT,
    IN 	pr_inventario 				CHAR(1),
    IN 	pr_num_dias_credito 		INT,
    IN 	pr_ctrl_comisiones 			CHAR(1),
    IN 	pr_no_contab_comision 		CHAR(1),
    OUT pr_inserted_id				INT,
    OUT pr_affect_rows	    		INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_proveedor_i
		@fecha:			20/12/2016
		@descripcion:	SP para agregar registros al catalogo Proveedores.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_inserted_id INT;
    DECLARE lo_valida_dir 	INT;
    DECLARE lo_id_proveedor INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'PROVEEDORES.MESSAGE_ERROR_CREATE_PROVEEDORES';
		SET pr_affect_rows = 0;
        CALL sp_glob_direccion2_d(pr_id_direccion);
	END;



    CALL sp_help_get_row_count_params(
			'ic_cat_tr_proveedor',
			pr_id_grupo_empresa,
			CONCAT(' cve_proveedor =  "', pr_cve_proveedor,'" '),
			@has_relations_with_tax,
			pr_message
	);

	IF @has_relations_with_tax> 0 THEN
		SET @error_code = 'CVE_DUPLICATE';
		SET pr_message = 'ERROR.CVE_DUPLICATE';/*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_tax),'}');*/
		SET pr_affect_rows = 0;
        CALL sp_glob_direccion2_d(pr_id_direccion);
		ROLLBACK;
	ELSE

		INSERT INTO ic_cat_tr_proveedor(
			id_grupo_empresa,
			id_tipo_proveedor,
			id_direccion,
			id_sucursal,
			cve_proveedor,
			tipo_proveedor_operacion,
			tipo_persona,
			rfc,
			razon_social,
			nombre_comercial,
			telefono,
			email,
			id_usuario
			)
		VALUES (
			pr_id_grupo_empresa,
			pr_id_tipo_proveedor,
			pr_id_direccion,
			pr_id_sucursal,
			pr_cve_proveedor,
			pr_tipo_proveedor_operacion,
			pr_tipo_persona,
			pr_rfc,
			pr_razon_social,
			pr_nombre_comercial,
			pr_telefono,
			pr_email,
			pr_id_usuario
		);


        SET lo_inserted_id 	= @@identity;

        CALL sp_cat_proveedor_conf_i(
			lo_inserted_id,
			pr_id_grupo_empresa,
			pr_inventario,
			pr_num_dias_credito,
			pr_ctrl_comisiones,
			pr_no_contab_comision,
			pr_id_usuario,
            pr_inserted_id,
			pr_affect_rows,
			pr_message
		);

		SET pr_inserted_id 	= lo_inserted_id;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		#Devuelve mensaje de ejecución
		SET pr_message = 'SUCCESS';


	END IF;
END$$
DELIMITER ;
