DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_imp_serv_i`(
	IN  pr_id_prove_servicio 	INT(11),
	IN  pr_id_impuesto 			INT(11),
    IN  pr_tipo_valor_cantidad	CHAR(1),
	IN  pr_cantidad 			DECIMAL(8,2),
	IN  pr_por_pagar 			CHAR(2),
    IN  pr_base_valor			DECIMAL(16,2),
	IN  pr_id_usuario 			INT(11),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_prove_imp_serv_i
		@fecha 		: 15/12/2016
		@descripcion: SP para insertar registro en catalogo usuarios.
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/
	# DECLARE lo_por_pagar 		VARCHAR(100) DEFAULT '';
    DECLARE lo_count			INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_imp_serv_i';
        SET pr_affect_rows = 0;
	END;

	# Falta validar que el usuario no se este usando en otras tablas
    /*
    IF(pr_por_pagar !='') THEN
		SET lo_por_pagar=pr_por_pagar;
	ELSE
		SET lo_por_pagar='NO';
	END IF;
    */

    SELECT
		COUNT(*)
	INTO
		lo_count
	FROM ic_fac_tr_prove_imp_serv
	WHERE id_prove_servicio = pr_id_prove_servicio
    AND   id_impuesto = pr_id_impuesto;

	IF lo_count = 0 THEN
		INSERT INTO ic_fac_tr_prove_imp_serv
			(
				id_prove_servicio,
				id_impuesto,
				tipo_valor_cantidad,
				cantidad,
				por_pagar,
				base_valor,
				id_usuario
			)
		VALUE
			(
				pr_id_prove_servicio,
				pr_id_impuesto,
				pr_tipo_valor_cantidad,
				pr_cantidad,
				pr_por_pagar,
				pr_base_valor,
				pr_id_usuario
			);

		#Devuelve el numero de registros insertados
		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

		SET pr_inserted_id 	= @@identity;

		# Mensaje de ejecución.
		SET pr_message 		= 'SUCCESS';
	ELSE
		SET pr_message = 'ERROR DUPLICATED_CODE';
        SET pr_affect_rows = 0;
	END IF;
END$$
DELIMITER ;
