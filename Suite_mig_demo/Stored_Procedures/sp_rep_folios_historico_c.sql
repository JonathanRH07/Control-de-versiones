DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_folios_historico_c`(
	IN	pr_id_grupo_empresa				INT,
    OUT pr_message						VARCHAR(500)
    )
BEGIN
/*
	@nombre:		sp_rep_folios_historico_c
	@fecha:			22/05/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_rep_folios_historico_c';
	END;

    /* ------------------------------------------------------- */

	SELECT
		id_folios,
		fecha,
		no_folios_comprados,
		no_folios_acumulados
	FROM(
	SELECT
		id_folios,
		fecha,
		no_folios_comprados no_folios_comprados,
		no_folios_acumulados no_folios_acumulados
	FROM ic_fac_tr_folios_historico
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND metodo_pago = 'P'
	UNION
	SELECT
		id_folios,
		fecha,
		no_folios_comprados no_folios_comprados,
		no_folios_acumulados no_folios_acumulados
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND metodo_pago = 'P') a
	GROUP BY fecha
	ORDER BY fecha, no_folios_acumulados ASC;

    /*
    SELECT
		id_folios,
		fecha,
		no_folios_comprados no_folios_comprados,
		no_folios_acumulados no_folios_acumulados
	FROM ic_fac_tr_folios_historico
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND metodo_pago = 'P'
    UNION
	SELECT
		id_folios,
		fecha,
		no_folios_comprados no_folios_comprados,
		no_folios_acumulados no_folios_acumulados
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND metodo_pago = 'P'
    ORDER BY fecha, no_folios_acumulados ASC;
    */

    /* ------------------------------------------------------- */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
