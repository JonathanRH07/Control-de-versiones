DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_origen_venta_i`(
	IN  pr_id_grupo_empresa    INT,
    IN	pr_id_usuario		   INT(11),
    IN  pr_cve				   VARCHAR(45),
    IN  pr_descripcion		   VARCHAR(100),
    OUT pr_inserted_id 		   INT,
    OUT pr_affect_rows 		   INT,
    OUT pr_message 	   		   VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_origen_venta_i
	@fecha:			04/08/2016
	@descripcion:	SP para insertar registro de catalogo Origen venta.
	@autor:			Odeth Negrete
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ORIGIN_SALE.MESSAGE_ERROR_CREATE_ORIGENVENTA';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    # Checa si ya existe la clave del corporativo
    CALL sp_help_get_row_count_params(
			'ic_cat_tr_origen_venta',
			pr_id_grupo_empresa,
			CONCAT(' cve =  "', pr_cve,'" '),
			@has_relations_with_origin_sale,
			pr_message);

	 IF @has_relations_with_origin_sale > 0 THEN

		SET @error_code = 'CVE_DUPLICATE';
			SET pr_message =  'ERROR.CVE_DUPLICATE';/*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
										(@has_relations_with_origin_sale),
									'}');*/
			SET pr_affect_rows = 0;
			ROLLBACK;

	 ELSE

		INSERT INTO ic_cat_tr_origen_venta(
			id_grupo_empresa,
            id_usuario,
			cve,
			descripcion
			)
		VALUE
			(
			pr_id_grupo_empresa,
            pr_id_usuario,
			pr_cve,
			pr_descripcion
			);


		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		SET pr_inserted_id 	= @@identity;
		# Mensaje de ejecución.
		SET pr_message = 'SUCCESS';
		COMMIT;

	END IF;
END$$
DELIMITER ;
