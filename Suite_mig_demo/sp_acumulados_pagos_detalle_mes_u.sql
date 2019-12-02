DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_acumulados_pagos_detalle_mes_u`(
	IN  pr_fecha					VARCHAR(7),
    OUT pr_message					VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_acumulados_pagos_detalle_mes_u
	@fecha:			2019/02/22
	@descripcion:	SP para actualizar registros en la tabla de acumulados
	@autor:			Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_count				INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_acumulados_pagos_mes_u';
        ROLLBACK;
	END ;

    SELECT
		COUNT(*)
	INTO
		lo_count
	FROM ic_rep_tr_acumulado_pagos_detalle
	WHERE DATE_FORMAT(fecha,'%Y-%m') = pr_fecha;

	/* ---------------------------------------------------------- */

	START TRANSACTION;

    IF lo_count > 0 THEN

		DELETE FROM ic_rep_tr_acumulado_pagos_detalle
		WHERE DATE_FORMAT(fecha,'%Y-%m') = pr_fecha;

    END IF;

    /* ---------------------------------------------------------- */

	INSERT INTO ic_rep_tr_acumulado_pagos_detalle (id_grupo_empresa, id_sucursal, id_cliente, id_pago, id_cxc, importe, importe_usd, importe_eur, fecha)
	SELECT
		pag.id_grupo_empresa,
		pag.id_sucursal,
		pag.id_cliente,
		det.id_pago,
		det.id_cxc,
		SUM(det.importe_moneda_base) importe_moneda_base,
		CASE
			WHEN id_moneda = 149 THEN
				(importe_moneda_base / tpo_cambio)
			ELSE
				(importe_moneda_base / tipo_cambio_usd)
		END,
		CASE
			WHEN id_moneda = 49 THEN
				(importe_moneda_base / tpo_cambio)
			ELSE
				(importe_moneda_base / tipo_cambio_eur)
		END,
		pag.fecha_captura_recibo
	FROM ic_fac_tr_pagos_detalle det
	JOIN ic_fac_tr_pagos pag ON
		det.id_pago = pag.id_pago
	WHERE DATE_FORMAT(pag.fecha_captura_recibo,'%Y-%m') = pr_fecha
	AND pag.estatus = 'ACTIVO'
	GROUP BY det.id_pago_detalle;

    /* ---------------------------------------------------------- */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
    COMMIT;

END$$
DELIMITER ;
