DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_folios_credito_desglose_c`(
	IN	pr_id_grupo_empresa				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_folios_credito_desglose_c
	@fecha:			22/05/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_rep_folios_credito_desglose_c';
	END;

	/* ------------------------------------------------------- */

	SELECT
		SUM(hist.no_folios_facturas) no_facturas,
		SUM(hist.no_folios_nc) no_egresos,
		SUM(hist.no_folios_documentos) no_documentos_servicio,
		SUM(hist.no_folios_documentos_credito) no_documentos_credito,
		SUM(hist.no_folios_comprobantes_cc) no_comprobantes_cc,
		SUM(hist.no_folios_comprobantes_sc) no_comprobantes_sc
	FROM ic_fac_tr_folios fol
	JOIN ic_fac_tr_folios_historico hist ON
		fol.id_grupo_empresa = hist.id_grupo_empresa
	WHERE fol.id_grupo_empresa = pr_id_grupo_empresa
	AND fol.metodo_pago = 'C';

    /* ------------------------------------------------------- */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
