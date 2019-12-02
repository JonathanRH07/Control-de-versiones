DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_direccion_u`(
	IN pr_id_direccion 		INT(11),
	IN pr_cve_pais 			CHAR(2),
	IN pr_calle 			VARCHAR(255),
	IN pr_num_exterior 		VARCHAR(45),
	IN pr_num_interior 		VARCHAR(45),
	IN pr_colonia 			VARCHAR(100),
	IN pr_municipio 		VARCHAR(100),
	IN pr_ciudad 			VARCHAR(100),
	IN pr_estado 			VARCHAR(100),
	IN pr_codigo_postal 	CHAR(10),
    IN pr_modulo 			CHAR(10),
    IN pr_id_modulo 		INT(11),
    OUT pr_inserted_id		INT(11),
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_direccion2_u
		@fecha:			26/01/2017
		@descripcion:
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	#Declaracion de variables.
	DECLARE	lo_cve_pais			VARCHAR(200) DEFAULT '';
	DECLARE	lo_calle 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_num_exterior		VARCHAR(200) DEFAULT '';
	DECLARE	lo_num_interior		VARCHAR(200) DEFAULT '';
	DECLARE	lo_colonia			VARCHAR(200) DEFAULT '';
	DECLARE	lo_municipio 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_ciudad			VARCHAR(200) DEFAULT '';
    DECLARE lo_estado			VARCHAR(200) DEFAULT '';
    DECLARE lo_codigo_postal 	VARCHAR(200) DEFAULT '';
	DECLARE lo_status 			VARCHAR(50) DEFAULT 'ACTIVO';
    DECLARE lo_valida_fac		INT;
    DECLARE lo_estatus_dir		VARCHAR(15);

	-- validar si existe en una factura
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_direccion_u';
		ROLLBACK;
	END;

    SELECT
		COUNT(id_factura)
    INTO
		lo_valida_fac
    FROM ic_fac_tr_factura
    WHERE id_direccion = pr_id_direccion;

	SELECT
		estatus
	INTO
		lo_estatus_dir
	FROM ct_glob_tc_direccion
	WHERE id_direccion = pr_id_direccion;

	IF pr_cve_pais != '' THEN
		SET lo_cve_pais = CONCAT('cve_pais = "', pr_cve_pais, '",');
	END IF;

	IF pr_calle != '' THEN
		SET lo_calle = CONCAT('calle = "', pr_calle, '",');
	END IF;

	IF pr_num_exterior != '' THEN
		SET lo_num_exterior = CONCAT('num_exterior = "', pr_num_exterior, '",');
	END IF;

	IF pr_num_interior != '' THEN
		SET lo_num_interior = CONCAT('num_interior = "', pr_num_interior, '",');
	END IF;

	IF pr_colonia  != '' THEN
		SET lo_colonia = CONCAT('colonia = "', pr_colonia, '",');
	END IF;

	IF pr_municipio != '' THEN
		SET lo_municipio = CONCAT('municipio = "', pr_municipio, '",');
	END IF;

	IF pr_ciudad != '' THEN
		SET lo_ciudad = CONCAT('ciudad = "', pr_ciudad, '",');
	END IF;

	IF pr_estado != '' THEN
		SET lo_estado = CONCAT('estado = "', pr_estado, '",');
	END IF;

	IF pr_codigo_postal != '' THEN
		SET lo_codigo_postal = CONCAT('codigo_postal = "', pr_codigo_postal, '",');
	END IF;

    IF lo_valida_fac = 0 THEN

		START TRANSACTION;

		SET @query = CONCAT('UPDATE ct_glob_tc_direccion
								SET ','
									',lo_cve_pais,'
									',lo_calle,'
									',lo_num_exterior,'
									',lo_num_interior,'
									',lo_colonia,'
									',lo_municipio,'
									',lo_ciudad,'
									',lo_estado,'
									',lo_codigo_postal,'
									',' estatus = "ACTIVO",','
									',' fecha_mod = sysdate()
								WHERE  id_direccion= ?');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		SET @id_direccion= pr_id_direccion;
		EXECUTE stmt USING @id_direccion;

		#Devuelve el numero de registros insertados
		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		SET pr_inserted_id = 0; # Mensaje de ejecucion.
		SET pr_message = 'SUCCESS';
		COMMIT;

    ELSE
		IF pr_modulo = 'CL' THEN

			UPDATE ic_cat_tr_cliente
			SET id_direccion = @pr_inserted_id
			WHERE id_cliente = pr_id_modulo;

            CALL sp_glob_direccion_i(pr_cve_pais, pr_calle, pr_num_exterior, pr_num_interior, pr_colonia, pr_municipio, pr_ciudad, pr_estado, pr_codigo_postal, pr_inserted_id, pr_affect_rows, pr_message);

			UPDATE ct_glob_tc_direccion
			SET estatus = 'INACTIVO'
			WHERE id_direccion = pr_id_direccion;

			SET pr_inserted_id = @@identity;

			SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
			SET pr_message = 'SUCCESS';
			COMMIT;

        ELSE
			CALL sp_glob_direccion_i(pr_cve_pais, pr_calle, pr_num_exterior, pr_num_interior, pr_colonia, pr_municipio, pr_ciudad, pr_estado, pr_codigo_postal, pr_inserted_id, pr_affect_rows, pr_message);

            IF lo_estatus_dir = 'ACTIVO' THEN

				UPDATE ct_glob_tc_direccion
				SET estatus = 'INACTIVO'
				WHERE id_direccion = pr_id_direccion;

				SET pr_inserted_id = @@identity;

            END IF;

			SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
			SET pr_message = 'SUCCESS';
			COMMIT;

		END IF;
    END IF;
END$$
DELIMITER ;
