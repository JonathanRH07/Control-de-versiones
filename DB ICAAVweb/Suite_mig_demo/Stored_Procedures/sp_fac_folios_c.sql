DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_folios_c`(
	IN	pr_id_grupo_empresa				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_compra_folios
	@fecha:			19/03/2019
	@descripcion:	SP para consultar registros en la tabla de folios.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_fac_compra_folios';
	END;

    IF pr_id_grupo_empresa > 0 THEN
		SELECT *
		FROM ic_fac_tr_folios
		WHERE id_grupo_empresa = pr_id_grupo_empresa;

    else
		# Rsultados usados en job que revisa los folios disponibles
		SELECT
        id_grupo_empresa, metodo_pago,
        sum(no_folios_disponibles) as no_folios_disponibles
        FROM suite_mig_demo.ic_fac_tr_folios
        where estatus = "ACTIVO"
        group by id_grupo_empresa having metodo_pago = "P";
    END IF;

	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

END$$
DELIMITER ;
