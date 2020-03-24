DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_detalle_u`(
	IN  pr_id_pago_detalle 	INT(11),
	IN  pr_id_pago 				INT(11),
	IN  pr_id_factura 			INT(11),
	IN  pr_id_detalle_cxc 		INT(11),
	IN  pr_importe_mn 			DECIMAL(13,2),
	IN  pr_importe 				DECIMAL(13,2),
	IN  pr_no_parcialidad 		INT(11),
    OUT pr_affect_rows	        INT,
	OUT pr_message		       	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_pagos_detalle_u
	@fecha:			19/02/2018
	@descripcion:	SP para actualizar registros en ic_fac_tr_pagos_detalle
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_pago 			VARCHAR(200) DEFAULT '';
    DECLARE lo_id_factura 		VARCHAR(200) DEFAULT '';
    DECLARE lo_id_detalle_cxc 	VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_mn 		VARCHAR(200) DEFAULT '';
    DECLARE lo_importe 			VARCHAR(200) DEFAULT '';
    DECLARE lo_no_parcialidad 	VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_pagos_detalle_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_pago > 0 THEN
		SET lo_id_pago = CONCAT('id_pago = ', pr_id_pago, ',');
	END IF;

	IF pr_id_factura > 0 THEN
		SET lo_id_factura = CONCAT('id_factura = ', pr_id_factura, ',');
	END IF;

	IF pr_id_detalle_cxc > 0 THEN
		SET lo_id_detalle_cxc = CONCAT('id_detalle_cxc = ', pr_id_detalle_cxc, ',');
	END IF;

	IF pr_importe_mn > 0 THEN
		SET lo_importe_mn = CONCAT('importe_mn = ', pr_importe_mn, ',');
	END IF;

	IF pr_importe > 0 THEN
		SET lo_importe = CONCAT('importe = ', pr_importe, ',');
	END IF;

	IF pr_no_parcialidad > 0 THEN
		SET lo_no_parcialidad = CONCAT('no_parcialidad = ', pr_no_parcialidad, ',');
	END IF;

	SET @query = CONCAT('UPDATE ic_fac_tr_pagos_detalle
							SET ',
								lo_id_pago,
								lo_id_factura,
                                lo_id_detalle_cxc,
								lo_importe_mn,
                                lo_importe,
								lo_no_parcialidad,
                                ' id_pago_detalle=',pr_id_pago_detalle ,
							' WHERE id_pago_detalle = ? ');

	PREPARE stmt FROM @query;

	SET @id_pago_detalle= pr_id_pago_detalle;
	EXECUTE stmt USING @id_pago_detalle;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
