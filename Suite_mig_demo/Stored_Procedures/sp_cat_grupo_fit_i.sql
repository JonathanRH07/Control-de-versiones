DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_grupo_fit_i`(
	IN  pr_id_grupo_empresa     INT,
    IN	pr_id_usuario			INT,
	IN  pr_cve_codigo_grupo     VARCHAR(45),
    IN  pr_desc_grupo_fit       VARCHAR(50),
    IN  pr_fecha_inicio_grupo   DATE,
    IN  pr_fecha_fin_grupo      DATE,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_grupo_fit_c
	@fecha:			08/08/2016
	@descripcion:	SP para insertar registro de catalogo Grupos fit.
	@autor:			Odeth Negrete
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'PROJECTS.MESSAGE_ERROR_CREATE_GRUPOFIT';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    # Checa si ya existe la clave del GRUPO FIT
    CALL sp_help_get_row_count_params(
			'ic_fac_tc_grupo_fit',
			pr_id_grupo_empresa,
			CONCAT(' cve_codigo_grupo =  "', pr_cve_codigo_grupo,'" '),
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
		#Dependiendo del parametro del grupo fit inserta un valor

		INSERT INTO ic_fac_tc_grupo_fit (
			id_grupo_empresa,
			id_usuario,
			cve_codigo_grupo,
			desc_grupo_fit,
			fecha_ini_grupo_fit,
			fecha_fin_grupo_fit
			)
		VALUES
			(
			pr_id_grupo_empresa,
			pr_id_usuario,
			pr_cve_codigo_grupo,
			pr_desc_grupo_fit,
			pr_fecha_inicio_grupo,
			pr_fecha_fin_grupo
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
	END IF;

END$$
DELIMITER ;
