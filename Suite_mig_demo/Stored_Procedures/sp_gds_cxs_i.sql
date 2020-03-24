DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cxs_i`(
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
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_cxs_i
	@fecha: 		03/04/2018
	@descripcion: 	SP para inseratr en ic_gds_tr_cxs
	@autor: 		Griselda Medina Medina
	@cambios:
*/

    DECLARE lo_id_serie			VARCHAR(300) DEFAULT '';
    DECLARE lo_alcance			VARCHAR(300) DEFAULT '';
    DECLARE lo_forma_pago_gds	VARCHAR(300) DEFAULT '';
    DECLARE lo_id_producto		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_cxs_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    SET lo_id_serie = pr_id_serie;
    SET lo_alcance = pr_alcance;
    SET lo_forma_pago_gds = pr_forma_pago_gds;
    SET lo_id_producto = pr_id_producto;

    IF pr_id_producto = 0 THEN
		SET lo_id_producto = NULL;
    END IF;

    IF pr_id_serie = 0 THEN
		SET lo_id_serie = NULL;
    END IF;

    IF pr_automatico = 'N' THEN
		SET lo_alcance = NULL;
		SET lo_forma_pago_gds = NULL;
		SET lo_id_producto = NULL;
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

		SET @error_code = 'CVE_DUPLICATE';
			SET pr_message = 'ERROR.CVE_DUPLICATE';/*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
										(@has_duplicated),
									'}');*/
			SET pr_affect_rows = 0;
			ROLLBACK;

	 ELSE

		INSERT INTO ic_gds_tr_cxs (
			id_grupo_empresa,
			id_proveedor,
			id_servicio,
			id_serie,
			id_forma_pago,
			id_producto,
			referencia,
			importe,
			incluye_impuesto,
			en_otra_serie,
			imprime,
			automatico,
			forma_pago_gds,
			alcance,
			id_usuario
			)
		VALUE
			(
			pr_id_grupo_empresa,
			pr_id_proveedor,
			pr_id_servicio,
			lo_id_serie,
			pr_id_forma_pago,
			lo_id_producto,
			pr_referencia,
			pr_importe,
			pr_incluye_impuesto,
			pr_en_otra_serie,
			pr_imprime,
			pr_automatico,
			lo_forma_pago_gds,
			lo_alcance,
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
