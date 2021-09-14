DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_negocio_i`(
	IN  pr_id_grupo_empresa      	INT(11),
    IN	pr_id_usuario				INT(11),
    IN  pr_cve_unidad_negocio  		VARCHAR(45),
	IN  pr_desc_unidad_negocio   	VARCHAR(100),
    OUT pr_inserted_id      		INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_unidad_negocio_i
	@fecha:			04/08/2016
	@descripcion: 	SP para inseratr registro de catalogo Unidad de negocio.
	@autor: 		Odeth Negrete
	@cambios:		19/09/2016	- Alan Olivares
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'BUSINESS_UNIT.MESSAGE_ERROR_CREATE_UNIDADNEGOCIO';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;
    # Checa si ya existe la clave  de la unidad de negocio
    CALL sp_help_get_row_count_params(
			'ic_cat_tc_unidad_negocio',
			pr_id_grupo_empresa,
			CONCAT(' cve_unidad_negocio =  "', pr_cve_unidad_negocio,'" '),
			@has_relations_with_business_unit,
			pr_message);

	 IF @has_relations_with_business_unit > 0 THEN

		SET @error_code = 'CVE_DUPLICATE';
			SET pr_message = 'ERROR.CVE_DUPLICATE';/*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',
										(@has_relations_with_business_unit),
									'}');*/
			SET pr_affect_rows = 0;
			ROLLBACK;

	 ELSE

			INSERT INTO  ic_cat_tc_unidad_negocio (
				id_grupo_empresa,
                id_usuario,
				cve_unidad_negocio,
				desc_unidad_negocio
				)
			VALUES
				(
				pr_id_grupo_empresa,
                pr_id_usuario,
				pr_cve_unidad_negocio,
				pr_desc_unidad_negocio
				);

			#Devuelve el numero de registros insertados
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
