DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_impuesto_u`(
	IN  pr_id_impuesto			INT(11),
	IN  pr_c_ClaveProdServ		CHAR(30),
	IN  pr_id_unidad			INT(11),
	IN  pr_por_pagar_impuesto  	ENUM('SI', 'NO'),
	IN	pr_id_usuario			INT(11),
		#IN  pr_desc_impuesto		CHAR(30),
        #IN  pr_valor_impuesto		DECIMAL(16,4),
		#IN  pr_tipo_valor_impuesto	ENUM('T','C','E'),
		#IN  pr_clase 				ENUM('T', 'R'),
		#IN  pr_estatus_impuesto    	ENUM('ACTIVO', 'INACTIVO'),
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_impuesto_u
		@fecha:			26/08/2016
		@descripcion:	SP para actualizar los impuestos.
		@autor:			Odeth Negrete
		@cambios:
	*/

    # Declaración de variables.
	DECLARE lo_por_pagar_impuesto 		VARCHAR(200) DEFAULT '';
    #DECLARE lo_c_ClaveProdServ  		VARCHAR(200) DEFAULT '';
    #DECLARE lo_id_unidad 				VARCHAR(200) DEFAULT '';
	#DECLARE lo_desc_impuesto  			VARCHAR(200) DEFAULT '';
	#DECLARE lo_valor_impuesto 			VARCHAR(200) DEFAULT '';
	#DECLARE lo_tipo_valor_impuesto 	VARCHAR(200) DEFAULT '';
	#DECLARE lo_clase  					VARCHAR(200) DEFAULT '';
	#DECLARE lo_estatus_impuesto		VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'MESSAGE_ERROR_UPDATE_IMPUESTOS';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	IF pr_por_pagar_impuesto  != '' THEN
		SET lo_por_pagar_impuesto = CONCAT('por_pagar_impuesto = "', pr_por_pagar_impuesto,'",');
	END IF;

/*

    IF pr_c_ClaveProdServ  != '' THEN
		SET lo_c_ClaveProdServ = CONCAT('c_ClaveProdServ = "', pr_c_ClaveProdServ,'",');
	END IF;

	IF pr_id_unidad  != '' THEN
		SET lo_id_unidad = CONCAT('id_unidad = "', pr_id_unidad,'",');
	END IF;

		IF pr_desc_impuesto  != '' THEN
			SET lo_desc_impuesto = CONCAT('desc_impuesto = "', pr_desc_impuesto,'",');
		END IF;

		IF pr_valor_impuesto > 0 THEN
			SET lo_valor_impuesto = CONCAT('valor_impuesto = ', pr_valor_impuesto,',' );
		END IF;

		IF pr_tipo_valor_impuesto > 0 THEN
			SET lo_tipo_valor_impuesto = CONCAT('tipo_valor_impuesto = "', pr_tipo_valor_impuesto,'",');
		END IF;

		IF pr_clase  != '' THEN
			SET lo_clase = CONCAT('clase = "', pr_clase,'",');
		END IF;

		IF pr_estatus_impuesto !='' THEN
			SET lo_estatus_impuesto = CONCAT('estatus_impuesto = "', pr_estatus_impuesto,'",');
		END IF;
    */

    SET @query = CONCAT('
    				UPDATE ic_cat_tr_impuesto
					SET ',
						#lo_c_ClaveProdServ,
						#lo_id_unidad,
						lo_por_pagar_impuesto,
						#lo_desc_impuesto,
						#lo_valor_impuesto,
						#lo_tipo_valor_impuesto,
						#lo_clase,
						#lo_estatus_impuesto,
						' id_usuario=',pr_id_usuario
						,' , fecha_mod_impuesto  = sysdate()
					WHERE
						id_impuesto = ?'
	);

    #SELECT @query;

	PREPARE stmt FROM @query;
	SET @id_impuesto = pr_id_impuesto;
	EXECUTE stmt USING @id_impuesto;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS'; # Mensaje de ejecución.

    IF pr_affect_rows = 0 THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END$$
DELIMITER ;
