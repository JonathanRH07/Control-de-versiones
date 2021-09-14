DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_folios_metodo_pago_c`(
	IN	pr_id_grupo_empresa				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_folios_detalle_c
	@fecha:			22/05/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_rep_folios_detalle_c';
	END;

	/* ------------------------------------------------ */

	SELECT
		metodo_pago
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	ORDER BY fecha DESC
	LIMIT 1;

	/* ------------------------------------------------ */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
