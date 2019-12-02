DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_folios_credito_periodo_c`(
	IN	pr_id_grupo_empresa				INT,
    IN  pr_id_idioma					INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_folios_credito_periodo_c
	@fecha:			22/05/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_rep_folios_credito_periodo_c';
	END;

	/* ------------------------------------------------------- */

	/* PERIODO */
	SELECT
		CONCAT(mes,' ',DATE_FORMAT(fol.fecha,'%Y')) periodo
	FROM ic_fac_tr_folios fol
	RIGHT JOIN ct_glob_tc_meses mes ON
		SUBSTRING(fol.fecha, 6, 2) = mes.num_mes
	WHERE fol.id_grupo_empresa = pr_id_grupo_empresa
	AND mes.id_idioma = pr_id_idioma
    AND fol.metodo_pago = 'C'
	AND fol.estatus = 'ACTIVO';

	/* ------------------------------------------------------- */

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
