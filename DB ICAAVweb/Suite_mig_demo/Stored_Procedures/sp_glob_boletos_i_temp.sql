DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_boletos_i_temp`(
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_id_proveedor 		INT(11),
	IN  pr_id_inventario 		INT(11),
	IN  pr_id_gds 				INT(11),
	IN  pr_id_sucursal 			INT(11),
	IN  pr_id_factura_detalle 	INT(11),
	IN  pr_origen 				CHAR(3),
	IN  pr_numero_bol 			VARCHAR(15),
	IN  pr_conjunto 			VARCHAR(15),
	IN  pr_ruta 				VARCHAR(100),
    IN	pr_estatus				ENUM('ACTIVO','INACTIVO','FACTURADO','CANCELADO'),
	IN  pr_id_usuario 			INT,
    IN  pr_fecha_emision 		DATE,
    IN  pr_lowcost 				CHAR(1),
	OUT pr_inserted_id			INT,
	OUT pr_numero_boleto		VARCHAR(15),
    OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_boletos_i
		@fecha:			06/09/2017
		@descripcion:	SP para insertar registro en la tabla de boletos
		@autor:			Griselda Medina Medina
		@cambios:
	*/

    DECLARE lo_longitud 		INT;
    DECLARE lo_valida_ceros 	VARCHAR(1);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_boletos_i';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

    IF pr_id_inventario = '' THEN
		SET pr_id_inventario = NULL;
	END IF;

    SET pr_numero_boleto = '';

    IF pr_lowcost = 'S' THEN
		SELECT numero_bol INTO @num_boleto FROM ic_glob_tr_boleto
			LEFT JOIN ic_cat_tr_proveedor_aero ON
				ic_cat_tr_proveedor_aero.id_proveedor = ic_glob_tr_boleto.id_proveedor
			WHERE id_gds = pr_id_gds
            AND id_grupo_empresa = pr_id_grupo_empresa AND bajo_costo = "SI"
            ORDER BY id_boletos DESC LIMIT 0, 1;

		IF @num_boleto IS NULL THEN
			SELECT ic_gds_tr_configuracion.boleto_lowcost_inicial INTO @num_boleto FROM ic_gds_tr_configuracion
				JOIN ic_cat_tc_gds ON
					ic_cat_tc_gds.cve_gds = ic_gds_tr_configuracion.cve_gds
				WHERE ic_gds_tr_configuracion.id_grupo_empresa = pr_id_grupo_empresa
                AND ic_cat_tc_gds.id_gds =  pr_id_gds;
		ELSE
			SET @num_boleto = @num_boleto + 1;
        END IF;

        SELECT
				LENGTH(@num_boleto)
			INTO
				lo_longitud
			FROM DUAL;

			SELECT
				SUBSTRING(@num_boleto,(lo_longitud - 1),'1')
			INTO
				lo_valida_ceros
			FROM DUAL;

            IF lo_valida_ceros = '0' THEN
				SET pr_numero_boleto = LPAD(@num_boleto,lo_longitud,'0');
			ELSE
				SET pr_numero_boleto = LPAD(@num_boleto,10,' ');
            END IF;

    END IF;

    INSERT INTO ic_glob_tr_boleto
	(
		id_grupo_empresa,
		id_proveedor,
		id_inventario,
		id_gds,
		id_sucursal,
		id_factura_detalle,
		origen,
		numero_bol,
		conjunto,
		ruta,
		estatus,
		id_usuario,
		fecha_emision
	)
	VALUES
	(
		pr_id_grupo_empresa,
		pr_id_proveedor,
		pr_id_inventario,
		pr_id_gds,
		pr_id_sucursal,
		pr_id_factura_detalle,
		pr_origen,
		pr_numero_boleto,
		pr_conjunto,
		pr_ruta,
		pr_estatus,
		pr_id_usuario,
		pr_fecha_emision
	);

	SET pr_inserted_id 	= @@identity;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	#Devuelve mensaje de ejecución
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
