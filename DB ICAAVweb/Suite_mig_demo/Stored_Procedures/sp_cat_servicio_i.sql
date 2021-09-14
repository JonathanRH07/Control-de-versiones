DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_servicio_i`(
	IN  pr_id_grupo_empresa		INT(11),
	IN	pr_id_usuario			INT(11),
	IN  pr_id_producto			INT(11),
    IN  pr_id_unidad_medida		INT,
	IN  pr_c_ClaveProdServ		CHAR(10),
	IN  pr_cve_servicio			CHAR(10),
	IN  pr_alcance				ENUM('NACIONAL','INTERNACIONAL'),
	IN  pr_descripcion			VARCHAR(100),
	IN  pr_valida_adicis		ENUM('SI','NO'),
	OUT pr_inserted_id	   		INT,
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_servicio_i
		@fecha:			28/11/2016
		@descripcion: 	SP para insertar registros de catalogo Servicios.
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'SERVICIOS.MESSAGE_ERROR_CREATE_SERVICIOS';
		SET pr_affect_rows = 0;
	END;

	CALL sp_help_get_row_count_params('ic_cat_tc_servicio',pr_id_grupo_empresa, CONCAT(' cve_servicio =  "', pr_cve_servicio,'" '), @existe_relacion, pr_message);

	IF @existe_relacion > 0 THEN

		SET @error_code = 'CVE_DUPLICATE';
		SET pr_message = 'ERROR.CVE_DUPLICATE'; /*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@existe_relacion),'}');*/
		SET pr_affect_rows = 0;

	 ELSE
		INSERT INTO  ic_cat_tc_servicio (
			id_grupo_empresa,
			id_usuario,
			id_producto,
            id_unidad_medida,
			c_ClaveProdServ,
			cve_servicio,
			alcance,
			descripcion,
			valida_adicis
		) VALUES (
			pr_id_grupo_empresa,
			pr_id_usuario,
			pr_id_producto,
            pr_id_unidad_medida,
			pr_c_ClaveProdServ,
			pr_cve_servicio,
			pr_alcance,
			pr_descripcion,
			pr_valida_adicis
		);

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		SET pr_inserted_id 	= @@identity;
		SET pr_message = 'SUCCESS';
	END IF;
END$$
DELIMITER ;
