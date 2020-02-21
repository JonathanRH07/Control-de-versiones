DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_imp_serv_u`(
	IN  pr_id_prov_imp_serv 		INT(11),
	-- IN  pr_id_prove_servicio 		INT(11),
	-- IN  pr_id_impuesto 				INT(11),
    IN  pr_base_valor				DECIMAL(16,2),
	IN  pr_id_usuario 				INT(11),
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_prove_imp_serv_u
		@fecha: 		10/03/2017
		@descripcion: 	SP para actualizar registros en prove_imp_serv
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	# Declaración de variables.
	DECLARE lo_id_prove_servicio 		VARCHAR(100) DEFAULT '';
	DECLARE lo_id_impuesto 				VARCHAR(100) DEFAULT '';
    DECLARE lo_base_valor 				VARCHAR(100) DEFAULT '';
	DECLARE lo_desc_tipo_proveedor  	VARCHAR(100) DEFAULT '';

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_prove_imp_serv_u';
	END ;*/


	/*
	IF pr_id_prove_servicio != '' THEN
		SET lo_id_prove_servicio = CONCAT(' id_prove_servicio = "', pr_id_prove_servicio , '",');
    END IF;

    IF pr_id_impuesto != '' THEN
		SET lo_id_impuesto = CONCAT(' id_impuesto = "', pr_id_impuesto  , '",');
    END IF;
	*/

	IF pr_base_valor != '' THEN
		SET lo_base_valor = CONCAT(' base_valor = "', pr_base_valor , '",');
    END IF;

    SET @query = CONCAT('
			UPDATE ic_fac_tr_prove_imp_serv
			SET ',
				/*
				lo_id_prove_servicio,
				lo_id_impuesto,
				lo_tipo_valor_cantidad,
				lo_cantidad,
                */
                lo_base_valor,
				' id_usuario=',pr_id_usuario,
				' , fecha_mod = sysdate()
			WHERE id_prov_imp_serv= ?'
	);
	PREPARE stmt FROM @query;

	SET @id_prov_imp_serv = pr_id_prov_imp_serv;
	EXECUTE stmt USING @id_prov_imp_serv;

    #Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
