DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_folios_historico_c`(
	IN	pr_id_grupo_empresa				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_folios_historico_c
	@fecha:			22/03/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_fac_compra_folios';
	END;

	SELECT *
	FROM ic_fac_tr_folios_historico
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

END$$
DELIMITER ;
