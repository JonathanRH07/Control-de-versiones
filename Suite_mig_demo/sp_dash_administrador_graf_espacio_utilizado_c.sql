DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_graf_espacio_utilizado_c`(
	IN	pr_id_grupo_empresa					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_graf_espacio_utilizado_c		
	@fecha:			17/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de administador.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_espacio_utilizado			DECIMAL(13,2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_graf_espacio_utilizado_c';
	END;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET lo_espacio_utilizado = 0;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT lo_espacio_utilizado;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

     # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
