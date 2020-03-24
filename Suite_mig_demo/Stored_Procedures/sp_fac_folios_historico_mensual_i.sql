DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_folios_historico_mensual_i`(
	IN	pr_id_grupo_empresa				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_folios_historico_mensual_c		PENDIENTE
	@fecha:			19/03/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_fecha_act				DATE;
    DECLARE lo_fecha					DATE;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_fac_folios_compra_i';
        ROLLBACK;
	END;

    START TRANSACTION;

	INSERT INTO ic_fac_tr_folios_historico_uso_mensual
	(
		id_grupo_empresa,
		no_folios_facturas,
		no_folios_nc,
		no_folios_documentos,
		no_folios_documentos_credito,
		no_folios_comprobantes_cc,
		no_folios_comprobantes_sc,
		fecha
	)
	SELECT
		id_grupo_empresa,
		no_folios_facturas,
		no_folios_nc,
		no_folios_documentos,
		no_folios_documentos_credito,
		no_folios_comprobantes_cc,
		no_folios_comprobantes_sc,
		fecha
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa
    AND estatus = 'ACTIVO';

	INSERT INTO ic_fac_tr_folios_historico
	(
		id_grupo_empresa,
		no_folios_comprados,
		no_folios_disponibles,
		no_folios_usados,
		no_folios_acumulados,
		metodo_pago,
		no_folios_facturas,
		no_folios_nc,
		no_folios_documentos,
		no_folios_documentos_credito,
		no_folios_comprobantes_cc,
		no_folios_comprobantes_sc,
		fecha
	)
	SELECT
		id_grupo_empresa,
		no_folios_comprados,
		no_folios_disponibles,
		no_folios_usados,
		no_folios_acumulados,
		metodo_pago,
		no_folios_facturas,
		no_folios_nc,
		no_folios_documentos,
		no_folios_documentos_credito,
		no_folios_comprobantes_cc,
		no_folios_comprobantes_sc,
		fecha
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa
    AND estatus = 'ACTIVO';

	COMMIT;

	# Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';
END$$
DELIMITER ;
