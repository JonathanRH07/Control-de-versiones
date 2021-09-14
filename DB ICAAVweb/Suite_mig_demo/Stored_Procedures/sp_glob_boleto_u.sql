DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_boleto_u`(
	IN  pr_id_boleto 				INT(11),
    IN	pr_id_proveedor				INT(11),
    IN	pr_id_sucursal				INT(11),
    IN  pr_id_factura_detalle 		INT(11),
    IN  pr_conjunto					VARCHAR(15),
    IN	pr_ruta						VARCHAR(100),
    IN	pr_estatus 					ENUM('ACTIVO','INACTIVO','FACTURADO','CANCELADO'),
	IN  pr_id_usuario				INT,
    IN  pr_fecha_emision 			DATE,
	OUT pr_affect_rows				INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
	/*
	@nombre:		sp_glob_boleto_u
	@fecha:			19/11/2017
	@descripcion:	SP para actualizar los la tabla global de boletos
	@autor:			Griselda Medina Medina
	@cambios:
	*/

	#Declaracion de variables.
	DECLARE lo_id_factura_detalle 	VARCHAR(500) DEFAULT '';
    DECLARE lo_id_proveedor		  	VARCHAR(500) DEFAULT '';
    DECLARE lo_id_sucursal		  	VARCHAR(500) DEFAULT '';
    DECLARE lo_conjunto				VARCHAR(500) DEFAULT '';
    DECLARE	lo_ruta 			  	VARCHAR(500) DEFAULT '';
    DECLARE	lo_estatus 			  	VARCHAR(500) DEFAULT '';
    DECLARE	lo_fecha_emision	  	VARCHAR(500) DEFAULT '';

    DECLARE lo_bol_factura_detalle	VARCHAR(500) DEFAULT '';
    DECLARE lo_bol_estatus			VARCHAR(500) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_boleto_u';
	-- ROLLBACK;
	END;

	-- START TRANSACTION;

	SELECT
		id_factura_detalle,
		estatus
	INTO
		lo_bol_factura_detalle,
        lo_bol_estatus
	FROM ic_glob_tr_boleto
    WHERE id_boletos = pr_id_boleto;

	IF pr_id_factura_detalle  > 0 THEN
		SET lo_id_factura_detalle = CONCAT('id_factura_detalle = ', pr_id_factura_detalle, ',');
	END IF;

    IF pr_id_proveedor  > 0 THEN
		SET lo_id_proveedor = CONCAT('id_proveedor = ', pr_id_proveedor, ',');
	END IF;

    IF pr_id_sucursal  > 0 THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = ', pr_id_sucursal, ',');
	END IF;

    IF pr_conjunto != '' THEN
		SET lo_conjunto = CONCAT('conjunto = ''',pr_conjunto, ''',');
    END IF;

    IF pr_ruta != '' THEN
		SET lo_ruta = CONCAT('ruta = "', pr_ruta, '",');
	END IF;

    IF pr_estatus != '' THEN
		IF pr_estatus = 'INACTIVO' THEN
			IF (lo_bol_factura_detalle > 0 AND lo_bol_estatus = 'ACTIVO') OR lo_bol_estatus = 'INACTIVO' THEN
				SET pr_message = 'TICKET.MESSAGE_ERROR_UPDATE_STATUS';
			ELSE
				SET lo_estatus = CONCAT(' estatus = "', pr_estatus, '",');
			END IF;
		ELSE
			SET lo_estatus = CONCAT(' estatus = "', pr_estatus, '",');
        END IF;
    END IF;

    IF pr_fecha_emision != '0000-00-00' THEN
		SET lo_fecha_emision = CONCAT('fecha_emision = "', pr_fecha_emision, '",');
	END IF;

	SET @query = CONCAT('UPDATE ic_glob_tr_boleto
							SET ',
								lo_id_factura_detalle,
                                lo_id_proveedor,
                                lo_id_sucursal,
                                lo_conjunto,
                                lo_ruta,
                                lo_estatus,
                                lo_fecha_emision,
								 ' id_usuario=',pr_id_usuario,
								', fecha_mod  = sysdate()
							WHERE id_boletos = ?');

    -- SELECT @query;
	PREPARE stmt FROM @query;
	SET @id_boletos= pr_id_boleto;
	EXECUTE stmt USING @id_boletos;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
