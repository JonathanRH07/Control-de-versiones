DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_addEjemplocrea_i`(
	IN  pr_id_grupo_empresa     INT(11),
    IN 	pr_id_usuario			INT(11),
    IN  pr_cve_corporativo 		VARCHAR(45),
    IN  pr_nom_corporativo 	    VARCHAR(100),
    IN  pr_limite_credito       DECIMAL(15,2),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_corporativo_i
	@fecha: 		04/08/2016
	@descripcion: 	SP para inseratr registro de catalogo Corporativo.
	@autor: 		Odeth Negrete
	@cambios: 		16/09/2016 - Alan Olivares
					07/12/2016 - Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_cat_corporativo_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    # Checa si ya existe la clave del corporativo
    CALL sp_help_get_row_count_params(
			'ic_cat_tr_corporativo',
			pr_id_grupo_empresa,
			CONCAT(' cve_corporativo =  "', pr_cve_corporativo,'" '),
			@has_relations_with_corporate,
			pr_message
	);

	IF @has_relations_with_corporate > 0 THEN

		SET @error_code = 'DUPLICATED_CODE';
		SET pr_message = CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_corporate),'}');
		SET pr_affect_rows = 0;
		ROLLBACK;

	ELSE
		INSERT INTO  ic_cat_tr_corporativo(
			id_grupo_empresa,
            id_usuario,
			cve_corporativo ,
			nom_corporativo,
			limite_credito_corporativo
			)
		VALUE
			(
			pr_id_grupo_empresa,
            pr_id_usuario,
			pr_cve_corporativo ,
			pr_nom_corporativo,
			pr_limite_credito
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
