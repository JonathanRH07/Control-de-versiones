DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_graf_folios_x_mes_c`(
	IN	pr_id_grupo_empresa					INT,
	-- IN	pr_id_sucursal						INT,
    -- IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_graf_folios_x_mes_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_graf_folios_x_mes_c';
	END;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		IFNULL(SUM(no_folios_facturas), 0) no_facturas,
		IFNULL(SUM(no_folios_nc), 0) no_egresos,
		IFNULL(SUM(no_folios_documentos), 0) no_documentos_servicio,
		IFNULL(SUM(no_folios_documentos_credito), 0) no_documentos_credito,
		IFNULL(SUM(no_folios_comprobantes_cc), 0) no_comprobantes_cc,
		IFNULL(SUM(no_folios_comprobantes_sc), 0) no_comprobantes_sc
	FROM ic_fac_tr_folios_historico_uso_mensual
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
