DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meta_venta_i`(
	IN  pr_id_grupo_empresa     INT(11),
    IN 	pr_id_usuario			INT(11),
    IN  pr_clave 				VARCHAR(15),
    IN  pr_descripcion 	    	VARCHAR(250),
	IN  pr_id_tipo_meta			INT(11),
    IN  pr_fecha_inicio			DATE,
    IN  pr_fecha_fin			DATE,
    IN  pr_total				DECIMAL(15,2),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_meta_venta_i
	@fecha: 		04/10/2019
	@descripcion: 	SP para inseratr registro de catalogo de Meta de Ventas.
	@autor: 		Yazbek Kido
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'SALES_TARGET.MESSAGE_ERROR_CREATE_SALESTARGET';
        SET pr_affect_rows = 0;
	END;


    # Checa si ya existe la clave del corporativo
    CALL sp_help_get_row_count_params(
			'ic_cat_tr_meta_venta',
			pr_id_grupo_empresa,
			CONCAT(' clave =  "', pr_clave,'" '),
			@has_relations_with_target,
			pr_message
	);

	IF @has_relations_with_target > 0 THEN

		SET @error_code = 'DUPLICATED_CODE';
		SET pr_message = 'ERROR.CVE_DUPLICATE';/*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_corporate),'}');*/
		SET pr_affect_rows = 0;
		SET pr_inserted_id = 0;
	ELSE

		SELECT count(*) into @period_exists FROM
			ic_cat_tr_meta_venta
            where id_grupo_empresa = pr_id_grupo_empresa AND pr_fecha_inicio < fecha_fin AND pr_fecha_fin > fecha_inicio;

        IF @period_exists > 0 THEN
			SET @error_code = 'PERIOD_DUPLICATED';
			SET pr_message = 'SALES_TARGET.PERIOD_DUPLICATED';/*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_corporate),'}');*/
			SET pr_affect_rows = 0;
			SET pr_inserted_id = 0;
        ELSE

			INSERT INTO  ic_cat_tr_meta_venta(
				id_grupo_empresa,
				clave,
				descripcion ,
				id_tipo_meta,
				fecha_inicio,
				fecha_fin,
				total,
				id_usuario
				)
			VALUE
				(
				pr_id_grupo_empresa,
				pr_clave,
				pr_descripcion,
				pr_id_tipo_meta,
				pr_fecha_inicio,
				pr_fecha_fin,
				pr_total,
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
		END IF;

	END IF;
END$$
DELIMITER ;
