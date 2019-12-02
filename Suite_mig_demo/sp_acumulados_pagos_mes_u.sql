DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_acumulados_pagos_mes_u`(
	IN  pr_fecha					VARCHAR(7),
    OUT pr_message					VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_acumulados_pagos_mes_u
	@fecha:			2019/02/22
	@descripcion:	SP para actualizar registros en la tabla de acumulados
	@autor:			Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_acumulados_pagos_mes_u';
        ROLLBACK;
	END ;

    START TRANSACTION;

	/* ---------------------------------------------------------- */

	INSERT INTO ic_rep_tr_acumulado_pagos (id_grupo_empresa, id_sucursal, id_cliente, id_pago, id_serie, id_moneda, id_forma_pago, numero, tpo_cambio, total_pago, monto_moneda_base, monto_usd, monto_eur, fecha)
	SELECT
		id_grupo_empresa,
		id_sucursal,
		id_cliente,
		id_pago,
		id_serie,
		id_moneda,
		id_forma_pago,
		numero,
		tpo_cambio,
		total_pago,
		total_pago_moneda_base,
		CASE
			WHEN id_moneda = 149 THEN
				(total_pago_moneda_base / tpo_cambio)
			ELSE
				(total_pago_moneda_base / tipo_cambio_usd)
		END,
		CASE
			WHEN id_moneda = 49 THEN
				(total_pago_moneda_base / tpo_cambio)
			ELSE
				(total_pago_moneda_base / tipo_cambio_eur)
		END,
		fecha_captura_recibo
	FROM ic_fac_tr_pagos
	WHERE DATE_FORMAT(fecha_captura_recibo,'%Y-%m') = pr_fecha
	AND estatus != 'CANCELADO';

    /* ---------------------------------------------------------- */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
    COMMIT;
END$$
DELIMITER ;
