DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_vendedor_i`(
	IN  pr_id_grupo_empresa     INT(11),
    IN	pr_id_usuario			INT(11),
    IN  pr_clave				CHAR(10),
    IN  pr_nombre			    VARCHAR(90),
    IN  pr_id_sucursal			INT(11),
    IN  pr_email			  	VARCHAR (100),
    IN  pr_id_comision          INT(11),
    IN  pr_id_comision_aux		INT(11),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_vendedor_i
	@fecha: 		17/02/2017
	@descripcion: 	SP para inseratr registro de catalogo vendedores.
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'VENDEDORES.MESSAGE_ERROR_CREATE_VENDEDORES';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    # Checa si ya existe la clave del corporativo
    CALL sp_help_get_row_count_params(
			'ic_cat_tr_vendedor',
			pr_id_grupo_empresa,
			CONCAT(' clave  =  "', pr_clave,'" '),
			@has_relations_with_seller,
			pr_message);

	 IF @has_relations_with_seller > 0 THEN

		SET @error_code = 'CVE_DUPLICATE';
			SET pr_message = 'ERROR.CVE_DUPLICATE'; /*CONCAT('{"error": "4002", "code": "', @error_code, '", "count": ',(@has_relations_with_seller),'}');*/
			SET pr_affect_rows = 0;
			ROLLBACK;

	 ELSE

		INSERT INTO ic_cat_tr_vendedor (
				id_grupo_empresa,
				id_usuario,
				id_sucursal,
				clave,
				nombre,
				email,
                id_comision,
                id_comision_aux
				)
		VALUE
				(
				pr_id_grupo_empresa,
				pr_id_usuario,
				pr_id_sucursal,
				pr_clave,
				pr_nombre,
				pr_email,
                pr_id_comision,
                pr_id_comision_aux
				);

		#Devuelve el numero de registros insertados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM DUAL;

		SET pr_inserted_id 	= @@identity;
		 # Mensaje de ejecución.
		SET pr_message 		= 'SUCCESS';

		COMMIT;
	END IF;
END$$
DELIMITER ;
