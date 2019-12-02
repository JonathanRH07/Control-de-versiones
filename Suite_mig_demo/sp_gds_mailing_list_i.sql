DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_mailing_list_i`(
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_nombre				VARCHAR(100),
    IN	pr_email				VARCHAR(50),
    IN	pr_errores				CHAR(1),
    IN	pr_transacciones		CHAR(1),
    IN	pr_id_usuario			INT(11),
    IN	pr_estatus				ENUM('ACTIVO','INACTIVO'),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	        	VARCHAR(500)
)
BEGIN
    /*
		@nombre:		sp_gds_mailing_list_i
		@fecha:			26/09/2017
		@descripcion:	SP para inseratr en ic_gds_tr_mailing_list
		@autor: 		Jonathan Ramirez Hernandez
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_mailing_list_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    SET @has_duplicated = 0;

		CALL sp_help_get_row_count_params(
				'ic_gds_tr_mailing_list',
				pr_id_grupo_empresa,
				CONCAT('
					email =  "', pr_email, '"
				'),
				@has_duplicated,
				pr_message);


	IF @has_duplicated > 0 THEN

		SET @error_code = 'CVE_DUPLICATE';
			SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
										(@has_duplicated),
									'}');
			SET pr_affect_rows = 0;
			ROLLBACK;

	 ELSE

	INSERT INTO ic_gds_tr_mailing_list
	(
		id_grupo_empresa,
		nombre,
		email,
		errores,
		transacciones,
		id_usuario,
		estatus,
		fecha_mod
	)
	VALUES
	(
		pr_id_grupo_empresa,
		pr_nombre,
        pr_email,
        pr_errores,
        pr_transacciones,
        pr_id_usuario,
        pr_estatus,
        SYSDATE()
	);


	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_inserted_id 	= @@identity;

	SET pr_message 		= 'SUCCESS';
	COMMIT;

    END IF;
END$$
DELIMITER ;
