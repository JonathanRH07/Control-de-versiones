DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_cancelacion`(
	IN	pr_id_pago					INT,
    IN	pr_id_razon_cancelacion		INT,
    IN	pr_concepto_c				VARCHAR(200),
    OUT pr_affect_rows 				INT,
    OUT pr_message 	   				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_pagos_cancelacion
	@fecha:			11/10/2018
	@descripcion:	SP para actualizar el estatus del pago a inactivo.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR store sp_fac_facturacion_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    UPDATE ic_fac_tr_pagos
	SET estatus = 'CANCELADO',
		id_razon_cancelacion = pr_id_razon_cancelacion,
        concepto_c = pr_concepto_c,
        fecha_cancelacion = SYSDATE(),
        hora_cancelacion = SYSDATE()
	WHERE id_pago = pr_id_pago;

	UPDATE ic_glob_tr_cxc_detalle
	SET estatus = 'INACTIVO'
	WHERE id_pago = pr_id_pago;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
