DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cxs_u`(
	IN  pr_id_gds_cxs			INT(11),
	IN  pr_id_grupo_empresa 	int(11),
	IN  pr_id_proveedor 		int(11),
	IN  pr_id_servicio 			int(11),
	IN  pr_id_serie 			int(11),
	IN  pr_id_forma_pago 		int(11),
    IN  pr_id_producto 			int(11),
	IN  pr_referencia 			varchar(10),
	IN  pr_importe 				decimal(16,2),
	IN  pr_incluye_impuesto 	char(1),
	IN  pr_en_otra_serie 		char(1),
	IN  pr_imprime 				char(1),
    IN  pr_automatico 			char(1),
    IN  pr_forma_pago_gds 		char(2),
    IN  pr_alcance				ENUM('NACIONAL','INTERNACIONAL', 'TODOS'),
    IN  pr_id_usuario			INT(11),
    OUT pr_affect_rows      	INT,
	OUT pr_message 	         	VARCHAR(500))
update_cxs:BEGIN
/*
	@nombre: 		sp_gds_cxs_u
	@fecha: 		07/08/2018
	@descripcion: 	SP para actualizar en ic_gds_tr_cxs
	@autor: 		Jonathan
	@cambios:
*/
	DECLARE  lo_id_proveedor 		VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_servicio 		VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_serie 			VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_forma_pago 		VARCHAR(200) DEFAULT '';
    DECLARE  lo_id_producto 		VARCHAR(200) DEFAULT '';
    DECLARE  lo_referencia 			VARCHAR(200) DEFAULT '';
	DECLARE  lo_importe 			VARCHAR(200) DEFAULT '';
    DECLARE  lo_imprime				VARCHAR(200) DEFAULT '';
	DECLARE  lo_automatico			VARCHAR(200) DEFAULT '';
    DECLARE  lo_incluye_impuesto	VARCHAR(200) DEFAULT '';
    DECLARE  lo_en_otra_serie		VARCHAR(200) DEFAULT '';
    DECLARE  lo_forma_pago_gds		VARCHAR(200) DEFAULT '';
    DECLARE  lo_alcance				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_cxs_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_proveedor > 0 THEN
		SET lo_id_proveedor = CONCAT('id_proveedor = ', pr_id_proveedor, ',');
    END IF;

    IF pr_id_servicio > 0 THEN
		SET lo_id_servicio = CONCAT('id_servicio = ', pr_id_servicio, ',');
    END IF;

    IF pr_id_serie > 0 THEN
		SET lo_id_serie = CONCAT('id_serie = ', pr_id_serie, ',');
    END IF;

    IF pr_id_serie = 0 THEN
		SET lo_id_serie = CONCAT('id_serie = NULL,');
    END IF;

    IF pr_id_forma_pago > 0 THEN
		SET lo_id_forma_pago = CONCAT('id_forma_pago = ', pr_id_forma_pago, ',');
    END IF;

    IF pr_id_producto > 0 THEN
		SET lo_id_producto = CONCAT('id_producto = ', pr_id_producto, ',');
    END IF;

    IF pr_id_producto = 0 THEN
		SET lo_id_producto = CONCAT('id_producto = NULL,');
    END IF;

	IF pr_referencia != '' THEN
		SET lo_referencia = CONCAT('referencia = "', pr_referencia, '",');
    END IF;

    IF pr_importe > 0 THEN
		SET lo_importe = CONCAT('importe = ', pr_importe, ',');
	END IF;

	IF pr_incluye_impuesto != '' THEN
		SET lo_incluye_impuesto = CONCAT('incluye_impuesto = "',pr_incluye_impuesto,'",');
	END IF;

    IF pr_en_otra_serie != '' THEN
		SET lo_en_otra_serie = CONCAT('en_otra_serie = "',pr_en_otra_serie,'",');
    END IF;

    IF pr_imprime != '' THEN
		SET lo_imprime = CONCAT('imprime = "', pr_imprime, '",');
    END IF;

    IF pr_automatico != '' THEN
		SET lo_automatico = CONCAT('automatico = "',pr_automatico,'",');
    END IF;

    IF pr_forma_pago_gds != '' THEN
		SET lo_forma_pago_gds = CONCAT('forma_pago_gds = "',pr_forma_pago_gds,'",');
    END IF;

    IF pr_alcance != '' THEN
		SET lo_alcance = CONCAT('alcance = "',pr_alcance,'",');
    END IF;

    IF pr_automatico = 'N' THEN
		SET lo_alcance = CONCAT('alcance = NULL,');
		SET lo_forma_pago_gds = CONCAT('forma_pago_gds = NULL,');
		SET lo_id_producto = CONCAT('id_producto = NULL,');
    END IF;

    SET @has_duplicated = 0;

		CALL sp_help_get_row_count_params(
				'ic_gds_tr_cxs',
				pr_id_grupo_empresa,
				CONCAT('
					referencia =  "', pr_referencia, '"
				'),
				@has_duplicated,
				pr_message);

    IF @has_duplicated > 0 THEN

		SET @pr_id_duplicated = '';
		SET @queryDuplicated = CONCAT('
						SELECT
							id_gds_cxs
						INTO
							@pr_id_duplicated
						FROM ic_gds_tr_cxs
						WHERE id_grupo_empresa = ', pr_id_grupo_empresa, '
						AND referencia =  "', pr_referencia, '" LIMIT 1');

		PREPARE stmt
		FROM @queryDuplicated;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

        IF @pr_id_duplicated != pr_id_gds_cxs THEN
			SET @error_code = 'CVE_DUPLICATE';
			SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
											(@has_duplicated),
										'}');
			SET pr_affect_rows = 0;
			ROLLBACK;

            LEAVE update_cxs;

		END IF;
	END IF;

	SET @query = CONCAT('UPDATE ic_gds_tr_cxs
							SET ',
                                lo_id_proveedor,
                                lo_id_servicio,
                                lo_id_serie,
                                lo_id_forma_pago,
                                lo_id_producto,
                                lo_referencia,
                                lo_importe,
								lo_incluye_impuesto,
                                lo_en_otra_serie,
                                lo_imprime,
                                lo_automatico,
                                lo_forma_pago_gds,
                                lo_alcance,
                                ' id_usuario=',pr_id_usuario,
							' , fecha_mod  = sysdate()
                            WHERE id_gds_cxs = ?
                            AND
                            id_grupo_empresa=',pr_id_grupo_empresa);
-- Select @query;
	PREPARE stmt FROM @query;

	SET @id_gds_cxs = pr_id_gds_cxs;
	EXECUTE stmt USING @id_gds_cxs;
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
