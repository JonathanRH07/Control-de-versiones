DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_glob_direccion_u`(
	IN 	pr_id_direccion 				INT(11),
	IN 	pr_cve_pais 					CHAR(2),
	IN 	pr_calle 						VARCHAR(255),
	IN 	pr_num_exterior 				VARCHAR(45),
	IN 	pr_num_interior 				VARCHAR(45),
	IN 	pr_colonia 						VARCHAR(100),
	IN 	pr_municipio 					VARCHAR(100),
	IN 	pr_ciudad 						VARCHAR(100),
	IN 	pr_estado 						VARCHAR(100),
	IN 	pr_codigo_postal 				CHAR(10),
    IN 	pr_modulo 						CHAR(10),
    IN 	pr_id_modulo 					INT(11),
    OUT pr_inserted_id					INT(11),
    OUT pr_affect_rows	    			INT,
	OUT pr_message		    			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_direccion2_u
		@fecha:			26/01/2017
		@descripcion:
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	#Declaracion de variables.
	DECLARE	lo_cve_pais					VARCHAR(200) DEFAULT '';
	DECLARE	lo_calle 					VARCHAR(200) DEFAULT '';
	DECLARE	lo_num_exterior				VARCHAR(200) DEFAULT '';
	DECLARE	lo_num_interior				VARCHAR(200) DEFAULT '';
	DECLARE	lo_colonia					VARCHAR(200) DEFAULT '';
	DECLARE	lo_municipio 				VARCHAR(200) DEFAULT '';
	DECLARE	lo_ciudad					VARCHAR(200) DEFAULT '';
    DECLARE lo_estado					VARCHAR(200) DEFAULT '';
    DECLARE lo_codigo_postal 			VARCHAR(200) DEFAULT '';
	DECLARE lo_status 					VARCHAR(50) DEFAULT 'ACTIVO';
    DECLARE lo_valida_fac				INT;
    DECLARE lo_estatus_dir				VARCHAR(15);
    DECLARE lo_contador					INT DEFAULT 0;

    /* DIRECCION ACTUAL */
    DECLARE lo_act_cve_pais     		CHAR(2);
    DECLARE lo_act_calle 				VARCHAR(255);
	DECLARE lo_act_num_exterior 		VARCHAR(45);
	DECLARE	lo_act_num_interior 		VARCHAR(45);
	DECLARE	lo_act_colonia 				VARCHAR(100);
	DECLARE	lo_act_municipio 			VARCHAR(100);
	DECLARE	lo_act_ciudad 				VARCHAR(100);
	DECLARE	lo_act_estado 				VARCHAR(100);
	DECLARE lo_act_codigo_postal 		VARCHAR(10);

	-- validar si existe en una factura
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_direccion_u';
		ROLLBACK;
	END;

    /* VALIDAMOS QUE EXISTAN FACTURAS CON EL ID DIRECCION */
    SELECT
		COUNT(id_factura)
    INTO
		lo_valida_fac
    FROM ic_fac_tr_factura
    WHERE id_direccion = pr_id_direccion;

	/* OBTENEMOS LOS DATOS DE LA DIRECCION */
	SELECT
		estatus,
        cve_pais,
        calle,
        num_exterior,
        num_interior,
        colonia,
        municipio,
        ciudad,
        estado,
        codigo_postal
	INTO
		lo_estatus_dir,
		lo_act_cve_pais,
        lo_act_calle,
        lo_act_num_exterior,
        lo_act_num_interior,
        lo_act_colonia,
        lo_act_municipio,
        lo_act_ciudad,
        lo_act_estado,
        lo_act_codigo_postal
	FROM ct_glob_tc_direccion
	WHERE id_direccion = pr_id_direccion;


	IF pr_cve_pais != '' THEN
		IF pr_cve_pais != lo_act_cve_pais THEN
			SET lo_cve_pais = CONCAT('cve_pais = "', pr_cve_pais, '",');
            SET lo_contador = lo_contador + 1;
        END IF;
	END IF;

	IF pr_calle != '' THEN
		IF pr_calle != lo_act_calle THEN
			SET lo_calle = CONCAT('calle = "', pr_calle, '",');
            SET lo_contador = lo_contador + 1;
        END IF;
	END IF;

	IF pr_num_exterior != '' THEN
		IF pr_num_exterior != lo_act_num_exterior THEN
			SET lo_num_exterior = CONCAT('num_exterior = "', pr_num_exterior, '",');
            SET lo_contador = lo_contador + 1;
        END IF;
	END IF;

	IF pr_num_interior != '' THEN
		IF pr_num_interior != lo_act_num_interior THEN
			SET lo_num_interior = CONCAT('num_interior = "', pr_num_interior, '",');
            SET lo_contador = lo_contador + 1;
        END IF;
	END IF;

	IF pr_colonia  != '' THEN
		IF pr_colonia != lo_act_colonia THEN
			SET lo_colonia = CONCAT('colonia = "', pr_colonia, '",');
            SET lo_contador = lo_contador + 1;
        END IF;
	END IF;

	IF pr_municipio != '' THEN
		IF pr_municipio != lo_act_municipio THEN
			SET lo_municipio = CONCAT('municipio = "', pr_municipio, '",');
            SET lo_contador = lo_contador + 1;
		END IF;
	END IF;

	IF pr_ciudad != '' THEN
		IF pr_ciudad != lo_act_ciudad THEN
			SET lo_ciudad = CONCAT('ciudad = "', pr_ciudad, '",');
            SET lo_contador = lo_contador + 1;
		END IF;
	END IF;

	IF pr_estado != '' THEN
		IF pr_estado != lo_act_estado THEN
			SET lo_estado = CONCAT('estado = "', pr_estado, '",');
            SET lo_contador = lo_contador + 1;
        END IF;
	END IF;

	IF pr_codigo_postal != '' THEN
		IF pr_codigo_postal != lo_act_codigo_postal THEN
			SET lo_codigo_postal = CONCAT('codigo_postal = "', pr_codigo_postal, '",');
            SET lo_contador = lo_contador + 1;
		END IF;
	END IF;

    /* SI NO EXISTEN FACTURAS CON EL ID DIRECCION */
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
								WHERE  id_direccion = ?');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		SET @id_direccion = pr_id_direccion;
		EXECUTE stmt USING @id_direccion;

		#Devuelve el numero de registros insertados
		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

        #ID insertado
        SET pr_inserted_id = 0;

        # Mensaje de ejecucion.
		SET pr_message = 'SUCCESS';
		COMMIT;
    ELSE
		IF pr_modulo = 'CL' THEN

            IF lo_contador > 0 THEN
				INSERT INTO ct_glob_tc_direccion (
					cve_pais,
					calle,
					num_exterior,
					num_interior,
					colonia,
					municipio,
					ciudad,
					estado,
					codigo_postal
				)
				VALUES
				(
					pr_cve_pais,
					pr_calle,
					pr_num_exterior,
					pr_num_interior,
					pr_colonia,
					pr_municipio,
					pr_ciudad,
					pr_estado,
					pr_codigo_postal
				);

				SET pr_inserted_id 	= @@identity;


				UPDATE ct_glob_tc_direccion
				SET estatus = 'INACTIVO'
				WHERE id_direccion = pr_id_direccion;

				UPDATE ic_cat_tr_cliente
				SET id_direccion = pr_inserted_id
				WHERE id_cliente = pr_id_modulo;

                SET pr_inserted_id = 0;
                SET pr_affect_rows = 0;
				SET pr_message = 'SUCCESS';
				COMMIT;
			ELSE
				SET pr_inserted_id = 0;
                SET pr_affect_rows = 0;
				SET pr_message = 'SUCCESS';
			END IF;
        ELSE
			IF lo_contador > 0 THEN
				IF pr_num_interior IS NULL THEN
					SET pr_num_interior = '';
				ELSE
					SET pr_num_interior = pr_num_interior;
				END IF;

				INSERT INTO ct_glob_tc_direccion (
					cve_pais,
					calle,
					num_exterior,
					num_interior,
					colonia,
					municipio,
					ciudad,
					estado,
					codigo_postal
				)
				VALUES
				(
					pr_cve_pais,
					pr_calle,
					pr_num_exterior,
					pr_num_interior,
					pr_colonia,
					pr_municipio,
					pr_ciudad,
					pr_estado,
					pr_codigo_postal
				);

				SET pr_inserted_id 	= @@identity;

				IF lo_estatus_dir = 'ACTIVO' THEN

					UPDATE ct_glob_tc_direccion
					SET estatus = 'INACTIVO'
					WHERE id_direccion = pr_id_direccion;


				END IF;

				SET pr_inserted_id = 0;
                SET pr_affect_rows = 0;
				SET pr_message = 'SUCCESS';
				COMMIT;
			ELSE
				SET pr_inserted_id = 0;
                SET pr_affect_rows = 0;
				SET pr_message = 'SUCCESS';
			END IF;
		END IF;
    END IF;
END$$
DELIMITER ;
