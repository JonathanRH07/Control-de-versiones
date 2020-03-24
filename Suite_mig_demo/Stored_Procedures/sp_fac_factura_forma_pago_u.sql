DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_forma_pago_u`(
	IN  pr_id_factura_forma_pago 	INT(11),
	IN  pr_id_factura 				INT(11),
	IN  pr_id_forma_pago 			INT(11),
	IN  pr_id_antcte 				INT(11),
	IN  pr_id_forma_pago_sat 		CHAR(5),
	IN  pr_importe 					DECIMAL(15,2),
	IN  pr_referencia_anticipo 		VARCHAR(20),
	IN  pr_concepto 				VARCHAR(50),
	IN  pr_id_usuario 				INT(11),
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_detalle_imp_u
		@fecha: 		13/03/2017
		@descripcion: 	SP para actualizar registros en factura_detalle_imp
		@autor: 		Griselda Medina Medina
		@cambios:
	*/
	# Declaración de variables.

	DECLARE lo_id_factura  				VARCHAR(100) DEFAULT '';
    DECLARE lo_id_forma_pago  			VARCHAR(100) DEFAULT '';
    DECLARE lo_id_antcte  				VARCHAR(100) DEFAULT '';
    DECLARE lo_id_forma_pago_sat  		VARCHAR(100) DEFAULT '';
    DECLARE lo_importe  				VARCHAR(100) DEFAULT '';
    DECLARE lo_referencia_anticipo  	VARCHAR(100) DEFAULT '';
    DECLARE lo_concepto  				VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_forma_pago_u';
	END ;

    -- START TRANSACTION;

	IF pr_id_factura   != '' THEN
		SET lo_id_factura = CONCAT(' id_factura = "', pr_id_factura  , '",');
    END IF;

	IF pr_id_forma_pago   != '' THEN
		SET lo_id_forma_pago = CONCAT(' id_forma_pago = "', pr_id_forma_pago  , '",');
    END IF;

	IF pr_id_antcte   != '' THEN
		SET lo_id_antcte = CONCAT('  id_antcte = "', pr_id_antcte  , '",');
    END IF;

	IF pr_id_forma_pago_sat   != '' THEN
		SET lo_id_forma_pago_sat = CONCAT(' id_forma_pago_sat = "', pr_id_forma_pago_sat  , '",');
    END IF;

	IF pr_importe   != '' THEN
		SET lo_importe = CONCAT(' importe = "', pr_importe , '",');
    END IF;

	IF pr_referencia_anticipo   != '' THEN
		SET lo_referencia_anticipo = CONCAT(' referencia_anticipo = "', pr_referencia_anticipo  , '",');
    END IF;

	IF pr_concepto   != '' THEN
		SET lo_concepto = CONCAT('  concepto = "', pr_concepto  , '",');
    END IF;


    SET @query = CONCAT('UPDATE ic_fac_tr_factura_forma_pago
							SET ',
								lo_id_factura,
								lo_id_forma_pago,
                                lo_id_antcte,
								lo_id_forma_pago_sat,
                                lo_importe,
								lo_referencia_anticipo,
                                lo_concepto,
								' id_usuario=',pr_id_usuario,
								' , fecha_mod = sysdate()
							WHERE id_factura_forma_pago = ?'
	);
	PREPARE stmt FROM @query;
	SET @id_factura_forma_pago = pr_id_factura_forma_pago;
	EXECUTE stmt USING @id_factura_forma_pago;

    #Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
    -- COMMIT;
END$$
DELIMITER ;
