DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_serie_i_old`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_id_usuario_solicita 		INT(11),
    IN  pr_id_sucursal				INT(11),
    IN  pr_id_formato				INT(11),
    IN  pr_id_formato_concentrado	INT(11),
    IN  pr_id_moneda 				INT(11),
    IN  pr_id_autorizado_por 		INT(11),
    IN  pr_id_revisado_por			INT(11),
    IN  pr_cve_serie 				CHAR(5),
    IN  pr_cve_tipo_serie  			CHAR(4),
    IN  pr_cve_tipo_doc 			CHAR(4),
    IN  pr_folio_serie				INT(11),
    IN  pr_descripcion_serie		VARCHAR(50),
    IN  pr_electronica_serie		CHAR(1),
	IN  pr_automatico_serie		    INT(11),
    IN  pr_tipo_requisicion			CHAR(1),
	IN  pr_factura_xcta_terceros	TINYINT,
	IN  pr_copias_serie				INT(11),
	IN  pr_no_max_ren_serie			INT(11),
    IN 	pr_id_usuario 				INT(11),
    IN  pr_tipo_formato				CHAR(2),
    OUT pr_affect_rows    			INT,
    OUT pr_message 	        		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_serie_folio_i
	@fecha:			22/08/2016
	@descripcion:	SP para insertar registros de catalogo Series.
	@autor:			Odeth Negrete
	@cambios:
*/

# Declaracion de variables
	DECLARE lo_inserted_id 	            INT;
	DECLARE lo_catalogo 	            INT DEFAULT 13;
	DECLARE lo_tipo_accion	            INT DEFAULT 1;

# Exception

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR STORE sp_cat_serie_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

# Valida si ya existe la clave del cliente
    CALL sp_help_get_row_count_params(
			'ic_cat_tr_serie',
			pr_id_grupo_empresa,
			CONCAT(' cve_serie =  "', pr_cve_serie,'" and id_grupo_empresa = ', pr_id_grupo_empresa),
			@has_relations_with_series,
			pr_message);


	IF @has_relations_with_series > 0 THEN

		SET @error_code = 'CVE_DUPLICATE';
		SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
										(@has_relations_with_series),
									'}');
		SET pr_affect_rows = 0;
		ROLLBACK;

	ELSE
		INSERT INTO  ic_cat_tr_serie (
			id_grupo_empresa,
			id_usuario_solicita,
			id_sucursal,
			id_formato,
			id_formato_concentrado,
			id_moneda,
			id_autorizado_por,
			id_revisado_por,
			cve_serie,
			cve_tipo_serie,
			cve_tipo_doc,
			folio_serie,
			descripcion_serie,
			electronica_serie,
			automatico_serie,
			tipo_requisicion,
			factura_xcta_terceros,
			copias_serie,
			no_max_ren_serie,
			id_usuario,
			tipo_formato
		) VALUES (
			pr_id_grupo_empresa,
			pr_id_usuario_solicita,
			pr_id_sucursal,
			pr_id_formato,
			pr_id_formato_concentrado,
			pr_id_moneda,
			pr_id_autorizado_por,
			pr_id_revisado_por,
			pr_cve_serie,
			pr_cve_tipo_serie,
			pr_cve_tipo_doc,
			pr_folio_serie,
			pr_descripcion_serie,
			pr_electronica_serie,
			pr_automatico_serie,
			pr_tipo_requisicion,
			pr_factura_xcta_terceros,
			pr_copias_serie,
			pr_no_max_ren_serie,
			pr_id_usuario,
			pr_tipo_formato
		);
		SET lo_inserted_id 	= @@identity;

		CALL  sp_glob_ctrl_cambios_i (
			lo_catalogo,
			lo_inserted_id,
			pr_id_usuario_solicita,
			lo_tipo_accion,
		pr_affect_rows,@pr_message_dir);

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

        # Mensaje de ejecución.
		SET pr_message = 'SUCCESS';
		COMMIT;
	END IF;
END$$
DELIMITER ;
