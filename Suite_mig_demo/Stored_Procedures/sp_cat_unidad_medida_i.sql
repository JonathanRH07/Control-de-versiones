DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_medida_i`(
	IN  pr_id_grupo_empresa         INT,
    IN	pr_cve_unidad_medida		CHAR(10),
    IN  pr_descripcion 				VARCHAR(90),
    IN  pr_c_ClaveUnidad      		CHAR(3),
    IN  pr_id_usuario				INT,
    OUT pr_inserted_id			 	INT,
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_unidad_medida_i
	@fecha:			08/08/2016
	@descripcion:	SP para insertar registros en la tabla unidad_medida
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'UNIDADES.MESSAGE_ERROR_CREATE_UNIDADES';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    # Checa si ya existe la clave del GRUPO FIT
    CALL sp_help_get_row_count_params(
			'ic_cat_tc_unidad_medida',
			pr_id_grupo_empresa,
			CONCAT(' cve_unidad_medida =  "', pr_cve_unidad_medida,'" '),
			@existe_relacion,
			pr_message);

	IF @existe_relacion > 0 THEN

        SET @error_code = 'CVE_DUPLICATE';
		SET pr_message = 'ERROR.CVE_DUPLICATE';/*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
									(@existe_relacion),
								'}');*/
		SET pr_affect_rows = 0;
		ROLLBACK;

    ELSE

		INSERT INTO ic_cat_tc_unidad_medida(
			id_grupo_empresa,
            cve_unidad_medida,
            descripcion,
            c_ClaveUnidad,
            id_usuario
			)
		VALUES
			(
			pr_id_grupo_empresa,
            pr_cve_unidad_medida,
            pr_descripcion,
            pr_c_ClaveUnidad,
            pr_id_usuario
			);

		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

        SET pr_inserted_id 	= @@identity;
		#Devuelve mensaje de ejecucion
		SET pr_message = 'SUCCESS';
		COMMIT;
	END IF;

END$$
DELIMITER ;
