DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_analisis_i`(
	IN  pr_id_factura 		INT(11),
	IN  pr_no_analisis 		VARCHAR(4),
	IN  pr_descripcion 		VARCHAR(50),
    IN  pr_id_usuario		INT,
	OUT pr_inserted_id 		INT,
	OUT pr_affect_rows 		INT,
	OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_analisis_i
		@fecha:			08/03/2017
		@descripcion: 	SP para insertar registros en la tabla factura_analisis
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_analisis_i';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;
		/*
			CALL sp_help_get_row_count_params(
				'ic_cat_tc_servicio',
				pr_id_grupo_empresa,
				CONCAT(' cve_servicio =  "', pr_cve_servicio,'" '),
				@existe_relacion,
				pr_message);

			IF @existe_relacion > 0 THEN

				SET @error_code = 'CVE_DUPLICATE';
					SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
												(@existe_relacion),
											'}');
					SET pr_affect_rows = 0;
					ROLLBACK;

			 ELSE
		*/

		INSERT INTO  ic_fac_tr_factura_analisis(
			id_factura,
			no_analisis,
			descripcion,
            id_usuario
		) VALUES (
			pr_id_factura,
			pr_no_analisis,
			pr_descripcion,
            pr_id_usuario
		);

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		SET pr_inserted_id 	= @@identity;
		SET pr_message 		= 'SUCCESS';
		-- COMMIT;

		#	END IF;
END$$
DELIMITER ;
