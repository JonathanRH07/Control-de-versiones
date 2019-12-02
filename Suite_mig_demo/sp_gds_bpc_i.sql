DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_bpc_i`(
	IN  pr_id_serie 			int(11),
	IN  pr_id_grupo_empresa 	int(11),
	IN  pr_imprime 				char(1),
	IN  pr_cve_gds 				char(2),
	IN  pr_tipo_bpc 			char(1),
	IN  pr_bpc_consolid 		int(11),
	IN  pr_bpc 					varchar(10),
    IN	pr_id_usuario			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_bpc_i
	@fecha: 		03/04/2018
	@descripcion: 	SP para inseratr en ic_gds_tr_bpc
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_bpc_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    # Checa si ya existe una serie para ese pcc
    CALL sp_help_get_row_count_params(
			'ic_gds_tr_bpc',
			pr_id_grupo_empresa,
			CONCAT('
				id_serie =  "', pr_id_serie, '"
				AND cve_gds = "', pr_cve_gds, '"
                AND bpc = "', pr_bpc, '"
                AND tipo_bpc = "', pr_tipo_bpc, '"
            '),
			@has_duplicated,
			pr_message);

	IF @has_duplicated > 0 THEN

		SET @error_code = 'CVE_DUPLICATE';
			SET pr_message = 'ERROR.CVE_DUPLICATE'; /* CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_duplicated),'}');*/
			SET pr_affect_rows = 0;
			ROLLBACK;

	 ELSE

		INSERT INTO ic_gds_tr_bpc (
			id_serie,
			id_grupo_empresa,
			imprime,
			cve_gds,
			tipo_bpc,
			bpc_consolid,
			bpc,
            id_usuario
			)
		VALUE
			(
			pr_id_serie,
			pr_id_grupo_empresa,
			pr_imprime,
			pr_cve_gds,
			pr_tipo_bpc,
			pr_bpc_consolid,
			pr_bpc,
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

		COMMIT;
	END IF;

END$$
DELIMITER ;
