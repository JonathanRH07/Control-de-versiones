DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cancelacion`(
	IN	pr_id_factura							INT,
    IN	pr_cve_tipo_serie						CHAR(5),
    IN	pr_id_razon_cancelacion					INT,
	IN	pr_motivo_cancelacion					VARCHAR(256),
    IN	pr_id_status_cancelacion				INT,
    IN	pr_fecha_cancelacion					DATETIME,
    IN  pr_id_usuario_cancelacion				INT,
    OUT pr_affect_rows 							INT,
    OUT pr_message 	   							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_factura_cancelacion
	@fecha:			30/10/2018
	@descripcion:	SP para actualizar el estatus de la factura a cancelada.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE	lo_tipo_cfdi			CHAR(2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_cancelacion';
        SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

    IF pr_fecha_cancelacion IS NULL THEN
		SET pr_fecha_cancelacion = NOW();
    END IF;

    SELECT
		tipo_cfdi
	INTO
		lo_tipo_cfdi
	FROM ic_fac_tr_factura
	WHERE id_factura = pr_id_factura;


   /* CANCELAR FACTURA */
	UPDATE ic_fac_tr_factura
	SET estatus = 'CANCELADA',
		id_razon_cancelacion = pr_id_razon_cancelacion,
		motivo_cancelacion = pr_motivo_cancelacion,
        id_status_cancelacion = pr_id_status_cancelacion,
        fecha_cancelacion = pr_fecha_cancelacion,
        fecha_solicitud_cancelacion = DATE_FORMAT(pr_fecha_cancelacion,  '%Y-%m-%d'),
        hora_solicitud_cancelacion = DATE_FORMAT(pr_fecha_cancelacion,  '%H:%i:%s'),
        id_usuario_cancelacion = pr_id_usuario_cancelacion
	WHERE id_factura = pr_id_factura;


	/* SE VALIDA SI ES FACTURA O DOCUMENTO DE SERVICIO, SE CANCELA EN FACTURA Y CXC */
    IF lo_tipo_cfdi = 'I' OR pr_cve_tipo_serie = 'FACT' OR pr_cve_tipo_serie = 'DOCS'THEN

		/* CANCELAR CXC */
        UPDATE ic_glob_tr_cxc
		SET estatus = 'INACTIVO'
		WHERE id_factura = pr_id_factura;

    END IF;


    /* SE VALIDA SI ES NOTA DE CREDITO, SE CANCELA EN FACTURA Y CXC_DETALLE */
    IF lo_tipo_cfdi = 'E' OR pr_cve_tipo_serie = 'NC' OR pr_cve_tipo_serie = 'FNCA' OR pr_cve_tipo_serie = 'DC' THEN

        /* CANCELAR CXC_DETALLE */
        UPDATE ic_glob_tr_cxc_detalle
		SET estatus = 'INACTIVO'
		WHERE id_factura = pr_id_factura;

	END IF;


    #Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
