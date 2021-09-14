DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_folios_detalle_c`(
	IN	pr_id_grupo_empresa					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_folios_detalle_c
	@fecha:			22/05/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_fecha						VARCHAR(10);
    DECLARE lo_no_folios_comprados_hist		INT;
    DECLARE lo_no_folios_comprados_fol		INT;
    DECLARE lo_no_folios_disponibles		INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_rep_folios_detalle_c';
	END;

    /* ------------------------------------------------------- */

    /* ULTIMA FECHA */
    SELECT
		MAX(fol.fecha) fecha
	INTO
		lo_fecha
	FROM ic_fac_tr_folios fol
	JOIN ic_fac_tr_folios_historico hist ON
		fol.id_grupo_empresa = hist.id_grupo_empresa
	WHERE fol.id_grupo_empresa = pr_id_grupo_empresa
    AND fol.metodo_pago = 'P';

    /* ------------------------------------------------------- */

    SELECT
        SUM(no_folios_comprados)
	INTO
		lo_no_folios_comprados_fol
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa
    AND metodo_pago = 'P';

    /* ------------------------------------------------------- */

    /* FOLIOS DISPONIBLES */
	SELECT
		SUM(no_folios_disponibles) no_folios_disponibles
	INTO
		lo_no_folios_disponibles
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa
    AND metodo_pago = 'P';

    /* ------------------------------------------------------- */

    SELECT
		lo_fecha,
		(lo_no_folios_comprados_fol) lo_no_folios_comprados,
		lo_no_folios_disponibles
	FROM DUAL;

    /* ------------------------------------------------------- */

	 # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
