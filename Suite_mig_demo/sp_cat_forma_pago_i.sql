DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_i`(
	IN  pr_id_grupo_empresa         INT,
    IN	pr_id_usuario				INT,
    IN  pr_id_forma_pago_sat 		CHAR(3),
    IN  pr_cve_forma_pago      		VARCHAR(45),
    IN  pr_desc_forma_pago   		VARCHAR(255),
    IN  pr_id_tipo_forma_pago       INT,
	OUT pr_id_inserted_forma_pago  	INT,
    OUT pr_affected_rows	        INT,
   	OUT pr_message		            VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_cat_forma_pago_i
		@fecha 		: 13/07/2016
		@descripcion: SP para insertar registro en el catalogo formas de pago.
		@autor 		: Odeth Negrete
		@cambios 	:
	*/

	DECLARE lo_id_inserted_forma_pago INT;

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		 SET pr_message = 'WAY_TO_PAY.MESSAGE_ERROR_CREATE_FORMAPAGO';
		 SET pr_id_inserted_forma_pago = 0;
		 SET pr_affected_rows = 0;
	END;*/

	CALL sp_help_get_row_count_params(
		'ic_glob_tr_forma_pago',
		pr_id_grupo_empresa,
		CONCAT(' cve_forma_pago =  "', pr_cve_forma_pago,'" '),
		@existe_relacion,
		pr_message
	);

	IF @existe_relacion > 0 THEN
		-- SET @error_code = 'CVE_DUPLICATE';
		SET pr_message = 'ERROR.CVE_DUPLICATE'; -- CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@existe_relacion),'}');
		SET pr_affected_rows = 0;
	ELSE
		INSERT INTO ic_glob_tr_forma_pago (
			id_grupo_empresa ,
			id_usuario,
			id_forma_pago_sat,
			cve_forma_pago ,
			desc_forma_pago,
			id_tipo_forma_pago
		) VALUES (
			pr_id_grupo_empresa ,
			pr_id_usuario,
			pr_id_forma_pago_sat,
			pr_cve_forma_pago,
			pr_desc_forma_pago,
			pr_id_tipo_forma_pago
		);

		#Devuelve el numero de registros insertados
		SELECT ROW_COUNT() INTO pr_affected_rows FROM dual;

		SET pr_id_inserted_forma_pago = @@identity;

		# Mensaje de ejecución.
		SET pr_message = 'SUCCESS';
	END IF;
END$$
DELIMITER ;
