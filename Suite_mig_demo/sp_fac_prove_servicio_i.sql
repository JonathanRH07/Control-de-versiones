DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_prove_servicio_i`(
	IN	pr_id_proveedor					INT(11),
    IN	pr_id_servicio					INT(11),
    IN  pr_id_impuesto          		INT,
    IN	pr_id_aerolinea					VARCHAR(10),
    IN  pr_comision 					DECIMAL(5,2),
    IN  pr_tipo_valor_comision 			CHAR(1),
	IN  pr_margen 						DECIMAL(5,2),
	IN  pr_tipo_valor_margen 			CHAR(1),
    IN  pr_id_usuario					INT,
    OUT pr_inserted_id					INT,
    OUT pr_affect_rows	    			INT,
	OUT pr_message		   	 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_prove_servicio_i
		@fecha:			27/12/2016
		@descripcion:	SP para insertar registro de Proveedor-Servicio
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_filas_existentes			INT;
    DECLARE lo_count					INT DEFAULT 0;
    DECLARE lo_aerolinea 				VARCHAR(150);
    DECLARE lo_tipo_proveedor			INT;
    DECLARE lo_producto					INT;
    DECLARE lo_id_aerolinea				INT DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_servicio_i';
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
			lo_id_aerolinea
		FROM ic_fac_tr_prove_servicio
		WHERE id_servicio = pr_id_servicio
		AND  id_proveedor = pr_id_proveedor
		ORDER BY id_prove_servicio DESC
        LIMIT 1;
    END IF;

    IF lo_tipo_proveedor != 2 OR lo_tipo_proveedor != 3 THEN
		IF lo_id_aerolinea = '' THEN
			SELECT
				COUNT(*)
			INTO
				lo_count
			FROM ic_fac_tr_prove_servicio
			WHERE id_servicio = pr_id_servicio
			AND  id_proveedor = pr_id_proveedor;
        ELSEIF lo_id_aerolinea != pr_id_aerolinea THEN
			SET lo_count = 0;
		ELSEIF lo_id_aerolinea = pr_id_aerolinea THEN
			SET lo_count = 1;
		ELSE
			SET lo_count = 0;
		END IF;
	ELSE
		SET lo_count = 0;
	END IF;

	IF pr_id_aerolinea != '' THEN
		SET lo_aerolinea = pr_id_aerolinea;
	ELSE
		SET lo_aerolinea = NULL;
    END IF;

    IF lo_count = 0 THEN
		INSERT INTO ic_fac_tr_prove_servicio
		(
			id_proveedor,
			id_servicio,
			id_impuesto,
			id_aerolinea,
			id_usuario,
			comision,
			tipo_valor_comision,
			margen,
			tipo_valor_margen
		)
		VALUES
        (
			pr_id_proveedor,
			pr_id_servicio,
			pr_id_impuesto,
			lo_aerolinea,
			pr_id_usuario,
			pr_comision,
			pr_tipo_valor_comision,
			pr_margen,
			pr_tipo_valor_margen
		);

		#Devuelve el numero de registros insertados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM DUAL;

		SET pr_inserted_id 	= @@identity;
		#Devuelve mensaje de ejecucion
		SET pr_message = 'SUCCESS';

	ELSEIF lo_count > 0 THEN
		SET pr_message = 'ERROR DUPLICATED_CODE';
		SET pr_affect_rows = 0;
	END IF;

END$$
DELIMITER ;
