DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_plan_comision_i`(
	IN	pr_id_grupo_empresa		INT,
	IN	pr_cve_plan_comision 	CHAR(15),
	IN	pr_descripcion 			VARCHAR(255),
	IN	pr_cuota_minima			CHAR(1),
	IN	pr_cuota_minima_monto 	DECIMAL(13,2),
	IN	pr_comisiones_por 		CHAR(1),
	IN	pr_fecha_ini 			DATE,
    IN 	pr_fecha_fin			DATE,
    IN 	pr_id_usuario			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_plan_comision_i
	@fecha:			05/01/2017
	@descripcion:	SP para agregar registros en plan_comision.
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'COMMISSION_PLAN.MESSAGE_ERROR_CREATE_PLANCOMISIONES';
		SET pr_affect_rows = 0;
	END;

    CALL sp_help_get_row_count_params(
			'ic_cat_tr_plan_comision',
			pr_id_grupo_empresa,
			CONCAT(' cve_plan_comision =  "', pr_cve_plan_comision,'" '),
			@has_relations_with_tax,
			pr_message
	);

	IF @has_relations_with_tax> 0 THEN
		SET @error_code = 'CVE_DUPLICATE';
		SET pr_message = 'ERROR.CVE_DUPLICATE'; -- CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_tax),'}');
		SET pr_affect_rows = 0;
	ELSE

		INSERT INTO ic_cat_tr_plan_comision (
			 id_grupo_empresa,
			 cve_plan_comision,
			 descripcion,
			 cuota_minima,
			 cuota_minima_monto,
			 comisiones_por,
			 fecha_ini,
			 fecha_fin,
			 id_usuario
			)
		VALUES
			(
			 pr_id_grupo_empresa,
			 pr_cve_plan_comision,
			 pr_descripcion,
			 pr_cuota_minima,
			 pr_cuota_minima_monto,
			 pr_comisiones_por,
			 pr_fecha_ini,
			 pr_fecha_fin,
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
    END IF;
END$$
DELIMITER ;
