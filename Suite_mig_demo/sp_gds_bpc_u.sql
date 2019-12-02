DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_bpc_u`(
	IN  pr_id_bpc				INT,
	IN  pr_id_serie 			INT,
	IN  pr_id_grupo_empresa 	INT,
	IN  pr_imprime 				CHAR(1),
	IN  pr_cve_gds 				CHAR(2),
	IN  pr_tipo_bpc 			CHAR(1),
	IN  pr_bpc_consolid 		INT,
	IN  pr_bpc 					VARCHAR(10),
    IN  pr_estatus				ENUM('ACTIVO','INACTIVO'),
    IN	pr_id_usuario			INT,
    OUT pr_affect_rows      	INT,
	OUT pr_message 	         	VARCHAR(500))
update_bpc:BEGIN
/*
	@nombre: 		sp_gds_bpc_u
	@fecha: 		03/04/2018
	@descripcion: 	SP para actualizar en ic_gds_tr_bpc
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE  lo_id_serie 			VARCHAR(200) DEFAULT '';
	DECLARE  lo_id_grupo_empresa 	VARCHAR(200) DEFAULT '';
	DECLARE  lo_imprime 			VARCHAR(200) DEFAULT '';
	DECLARE  lo_cve_gds 			VARCHAR(200) DEFAULT '';
	DECLARE  lo_tipo_bpc 			VARCHAR(200) DEFAULT '';
	DECLARE  lo_bpc_consolid 		VARCHAR(200) DEFAULT '';
	DECLARE  lo_bpc 				VARCHAR(200) DEFAULT '';
    DECLARE  lo_estatus				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_bpc_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_serie >0 THEN
		SET lo_id_serie = CONCAT('id_serie = ', pr_id_serie, ',');
	END IF;

    IF pr_imprime != '' THEN
		SET lo_imprime = CONCAT('imprime =  "', pr_imprime, '",');
	END IF;

    IF pr_cve_gds != '' THEN
		SET lo_cve_gds = CONCAT('cve_gds =  "', pr_cve_gds, '",');
	END IF;

    IF pr_tipo_bpc != '' THEN
		SET lo_tipo_bpc = CONCAT('tipo_bpc =  "', pr_tipo_bpc, '",');
	END IF;

	IF pr_bpc_consolid != '' THEN
		SET lo_bpc_consolid = CONCAT('bpc_consolid =  "', pr_bpc_consolid, '",');
	END IF;

    IF pr_bpc != '' THEN
		SET lo_bpc = CONCAT('bpc =  "', pr_bpc, '",');
	END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus =  "', pr_estatus, '",');
	END IF;



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

		SET @pr_id_duplicated = '';
		SET @queryDuplicated = CONCAT('
						SELECT
							id_bpc
						INTO
							@pr_id_duplicated
						FROM ic_gds_tr_bpc
						WHERE id_grupo_empresa = ', pr_id_grupo_empresa, '
						AND id_serie =  "', pr_id_serie, '"
						AND cve_gds = "', pr_cve_gds, '"
						AND bpc = "', pr_bpc, '"
						AND tipo_bpc = "', pr_tipo_bpc, '"');

		PREPARE stmt
		FROM @queryDuplicated;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

        IF @pr_id_duplicated != pr_id_bpc THEN
			SET @error_code = 'CVE_DUPLICATE';
			SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
											(@has_duplicated),
										'}');
			SET pr_affect_rows = 0;
			ROLLBACK;

            LEAVE update_bpc;

		END IF;
	END IF;


		SET @query = CONCAT('UPDATE ic_gds_tr_bpc
							SET ',
								lo_id_serie,
								lo_imprime,
								lo_cve_gds,
                                lo_tipo_bpc,
                                lo_bpc_consolid,
                                lo_bpc,
                                lo_estatus,
							' id_bpc = ',pr_id_bpc,'
                            , id_usuario = ',pr_id_usuario,
                            ' WHERE id_bpc = ?
                            AND id_grupo_empresa=',pr_id_grupo_empresa,'');
	-- Select @query;
		PREPARE stmt
		FROM @query;

		SET @id_bpc = pr_id_bpc;
		EXECUTE stmt USING @id_bpc;
		#Devuelve el numero de registros afectados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		# Mensaje de ejecución.
		SET pr_message = 'SUCCESS';


		COMMIT;
END$$
DELIMITER ;
