DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_graf_consumo_espacio_x_mes_c`(
	IN	pr_id_grupo_empresa					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_graf_consumo_espacio_x_mes_c
	@fecha:			17/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de administador.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_consumo						DECIMAL(13,2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_graf_consumo_espacio_x_mes_c';
	END;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET lo_consumo = 0;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT lo_consumo;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

     # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
