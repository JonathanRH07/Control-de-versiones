DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `ic_gds_tr_remarks_grupo_emp`(
	IN  pr_id_grupo_empresa 	INT,
    IN 	pr_id_usuario			INT,
    IN  pr_cve_gds				CHAR(2),
	IN  pr_remark				VARCHAR(10),
	IN  pr_valor_remark			VARCHAR(30),
	IN  pr_obligatorio			CHAR(1),
	IN  pr_item					INT(1),
	IN  pr_separador 			VARCHAR(45),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	        	VARCHAR(500)
)
BEGIN
/*
	@nombre: 		ic_gds_tr_remarks_grupo_emp
	@fecha: 		12/04/2018
	@descripcion: 	SP para inseratar registro de tr_remarks_grupo_emp.
	@autor: 		David Roldan Solares
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_cat_corporativo_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;
 /*
    # Checa si ya existe la clave del corporativo
    CALL sp_help_get_row_count_params(
			'ic_gds_tr_remarks_grupo_emp',
			pr_id_grupo_empresa,
			CONCAT(' id_remarks_grupo_emp =  "', pr_cve_corporativo,'" '),
			@has_relations_with_corporate,
			pr_message
	);
*/
/*	IF @has_relations_with_corporate > 0 THEN

		SET @error_code = 'DUPLICATED_CODE';
		SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_corporate),'}');
		SET pr_affect_rows = 0;
		ROLLBACK;
	ELSE*/
		INSERT INTO ic_gds_tr_remarks_grupo_emp (
			id_grupo_empresa,
            id_usuario,
			cve_gds,
			remark,
			valor_remark,
			obligatorio,
			item,
			separador
			)
		VALUE
			(
			pr_id_grupo_empresa,
            pr_id_usuario,
			pr_cve_gds,
			pr_remark,
			pr_valor_remark,
			pr_obligatorio,
			pr_item,
			pr_separador
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
-- 	END IF;
END$$
DELIMITER ;
