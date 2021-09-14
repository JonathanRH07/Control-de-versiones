DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_folios_desgloce_c`(
	IN	pr_id_grupo_empresa						INT,
    OUT pr_message								VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_folios_desgloce_c
	@fecha:			22/05/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_rep_folios_detalle_c';
	END;

	/* -------------------------------------------------------------- */

	SELECT
		IFNULL(no_folios_facturas, 0) no_facturas,
		IFNULL(no_folios_nc, 0) no_egresos,
		IFNULL(no_folios_documentos, 0) no_documentos_servicio,
		IFNULL(no_folios_documentos_credito, 0) no_documentos_credito,
		IFNULL(no_folios_comprobantes_cc, 0) no_comprobantes_cc,
		IFNULL(no_folios_comprobantes_sc, 0) no_comprobantes_sc
	FROM ic_fac_tr_folios_historico_uso_mensual
	WHERE id_grupo_empresa = pr_id_grupo_empresa
    ORDER BY fecha DESC;

	/* -------------------------------------------------------------- */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
