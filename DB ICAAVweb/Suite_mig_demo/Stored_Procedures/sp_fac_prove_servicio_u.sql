DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_prove_servicio_u`(
	IN  pr_id_prove_servicio				INT(11),
    IN  pr_id_proveedor						INT(11),
    IN  pr_id_servicio      				INT(11),
    IN  pr_id_impuesto          			INT,
    IN	pr_id_aerolinea						INT,
    IN	pr_comision 						DECIMAL(5,2),
	IN	pr_tipo_valor_comision 				CHAR(1),
	IN	pr_margen 							DECIMAL(5,2),
	IN	pr_tipo_valor_margen 				CHAR(1),
	IN  pr_id_usuario     					INT(11),
    OUT pr_affect_rows	        			INT(11),
	OUT pr_message		        			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_tr_prove_servicio_gu
		@fecha:			27/12/2016
		@descripcion: 	SP para actualizar los registros en ic_fac_tr_prove_servicio.
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	# Variables
    DECLARE lo_id_proveedor 				VARCHAR(100) DEFAULT '';
    DECLARE lo_id_servicio 					VARCHAR(100) DEFAULT '';
    DECLARE lo_id_impuesto					VARCHAR(100) DEFAULT '';
    DECLARE lo_id_aerolinea					VARCHAR(100) DEFAULT '';
    DECLARE lo_comision 					VARCHAR(100) DEFAULT '';
	DECLARE lo_tipo_valor_comision 			VARCHAR(100) DEFAULT '';
	DECLARE lo_margen 						VARCHAR(100) DEFAULT '';
	DECLARE lo_tipo_valor_margen 			VARCHAR(100) DEFAULT '';
    DECLARE lo_count						INT;

	DECLARE lo_tipo_proveedor				INT;
    DECLARE lo_producto						INT;
    DECLARE lo_id_act_aerolinea				INT DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_servicio_u';
		SET pr_affect_rows = 0;
	END;

	SELECT
		id_tipo_proveedor
	INTO
		lo_tipo_proveedor
	FROM ic_cat_tr_proveedor
	WHERE id_proveedor = pr_id_proveedor;

    SELECT
		id_producto
	INTO
		lo_producto
	FROM ic_cat_tc_servicio
    WHERE id_servicio = pr_id_servicio;

    IF lo_producto > 0 THEN
		SELECT
			id_aerolinea
		INTO
			lo_id_act_aerolinea
		FROM ic_fac_tr_prove_servicio
		WHERE id_servicio = pr_id_servicio
		AND  id_proveedor = pr_id_proveedor
        AND id_prove_servicio != pr_id_prove_servicio
		ORDER BY id_prove_servicio DESC
        LIMIT 1;
    END IF;

    IF lo_tipo_proveedor != 2 OR lo_tipo_proveedor != 3 THEN
		IF lo_id_act_aerolinea = '' THEN
			SELECT
				COUNT(*)
			INTO
				lo_count
			FROM ic_fac_tr_prove_servicio
			WHERE id_servicio = pr_id_servicio
			AND  id_proveedor = pr_id_proveedor
            AND id_prove_servicio != pr_id_prove_servicio;
        ELSEIF lo_id_act_aerolinea != pr_id_aerolinea THEN
			SET lo_count = 0;
		ELSEIF lo_id_act_aerolinea = pr_id_aerolinea THEN
			SET lo_count = 1;
		ELSE
			SET lo_count = 0;
		END IF;
	ELSE
		SET lo_count = 0;
	END IF;

    IF lo_count = 0 THEN
		IF pr_id_proveedor  > 0 THEN
			SET lo_id_proveedor = CONCAT('id_proveedor = ', pr_id_proveedor, ',');
		END IF;

		IF pr_id_servicio > 0 THEN
			SET lo_id_servicio = CONCAT('id_servicio = ', pr_id_servicio, ',');
		END IF;

        IF pr_id_impuesto > 0 THEN
			SET lo_id_impuesto = CONCAT('id_impuesto = ', pr_id_impuesto, ',');
		END IF;

		IF pr_id_aerolinea > 0 THEN
			SET lo_id_aerolinea = CONCAT('id_aerolinea = ', pr_id_aerolinea, ',');
		END IF;

		IF pr_comision !='' THEN
			SET lo_comision = CONCAT('comision = "', pr_comision, '",');
		END IF;

		IF pr_tipo_valor_comision !='' THEN
			SET lo_tipo_valor_comision = CONCAT('tipo_valor_comision = "', pr_tipo_valor_comision, '",');
		END IF;

		IF pr_margen !='' THEN
			SET lo_margen = CONCAT('margen = "', pr_margen, '",');
		END IF;

		IF pr_tipo_valor_margen !='' THEN
			SET lo_tipo_valor_margen = CONCAT('tipo_valor_margen = "', pr_tipo_valor_margen, '",');
		END IF;

		SET @query = CONCAT('
				UPDATE ic_fac_tr_prove_servicio SET ',
					lo_id_proveedor
					,lo_id_servicio
                    ,lo_id_impuesto
                    ,lo_id_aerolinea
					,lo_comision
					,lo_tipo_valor_comision
					,lo_margen
					,lo_tipo_valor_margen
					,' id_usuario=',pr_id_usuario
					,' , fecha_mod  = sysdate()
				WHERE id_prove_servicio = ?'
		);

        -- SELECT @query;
		PREPARE stmt FROM @query;
		SET @id_prove_servicio = pr_id_prove_servicio;
		EXECUTE stmt USING @id_prove_servicio;

		#Devuelve el numero de registros insertados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM DUAL;

        # Mensaje de ejecucion.
		SET pr_message = 'SUCCESS';
	ELSE
		SET pr_message = 'ERROR DUPLICATED_CODE';
		SET pr_affect_rows = 0;
    END IF;
END$$
DELIMITER ;
