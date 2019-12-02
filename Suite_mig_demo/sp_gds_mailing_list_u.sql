DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_mailing_list_u`(
	IN  pr_id_gds_mailing_list	INT,
	IN  pr_id_grupo_empresa 	INT,
	IN  pr_nombre		 		VARCHAR(100),
    IN  pr_email 				VARCHAR(50),
    IN  pr_errores	 			CHAR(1),
    IN  pr_transacciones		CHAR(1),
    IN  pr_id_usuario			INT,
    OUT pr_affect_rows      	INT,
	OUT pr_message 	        	VARCHAR(500)
)
update_email:BEGIN
/*
	@nombre: 		sp_gds_mailing_list_u
	@fecha: 		30/08/2018
	@descripcion: 	SP para actualizar en ic_gds_tr_mailing_list
	@autor: 		David Roldan
	@cambios:
*/
	DECLARE  lo_nombre			VARCHAR(200) DEFAULT '';
    DECLARE  lo_email 			VARCHAR(200) DEFAULT '';
    DECLARE  lo_errores 		VARCHAR(200) DEFAULT '';
    DECLARE  lo_transacciones 	VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_mailing_list_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT('nombre =  "', pr_nombre, '", ');
	END IF;

    IF pr_email != '' THEN
		SET lo_email = CONCAT('email =  "', pr_email, '", ');
	END IF;

    IF pr_errores != '' THEN
		SET lo_errores = CONCAT('errores =  "', pr_errores, '", ');
	END IF;

    IF pr_transacciones != '' THEN
		SET lo_transacciones = CONCAT('transacciones =  "', pr_transacciones, '", ');
	END IF;

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

		SET @pr_id_duplicated = '';
		SET @queryDuplicated = CONCAT('
						SELECT
							id_gds_mailing_list
						INTO
							@pr_id_duplicated
						FROM ic_gds_tr_mailing_list
						WHERE id_grupo_empresa = ', pr_id_grupo_empresa, '
						AND email =  "', pr_email, '" LIMIT 1');

		PREPARE stmt
		FROM @queryDuplicated;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

        IF @pr_id_duplicated != pr_id_gds_mailing_list THEN
			SET @error_code = 'CVE_DUPLICATE';
			SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
											(@has_duplicated),
										'}');
			SET pr_affect_rows = 0;
			ROLLBACK;

            LEAVE update_email;

		END IF;
	END IF;

    SET @query = CONCAT('UPDATE ic_gds_tr_mailing_list
							SET ',
                            lo_nombre,
                            lo_email,
                            lo_errores,
                            lo_transacciones,
                            ' id_usuario = ',pr_id_usuario,
							', fecha_mod = sysdate()
                            WHERE id_gds_mailing_list = ',pr_id_gds_mailing_list,
                            ' AND id_grupo_empresa = ',pr_id_grupo_empresa
						);

    PREPARE stmt
	FROM @query;

	EXECUTE stmt;

	#Devuelve el numero de registros afectados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

    COMMIT;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
