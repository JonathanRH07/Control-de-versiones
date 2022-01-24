DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_empresa_reservaciones_c`(
	IN  pr_id_grupo_empresa     INT(11),
    OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_adm_empresa_reservaciones_c
	@fecha: 		17/09/2021
	@descripcion : 	Sp de consulta de la tabla st_adm_tr_empresa_reservaciones
	@autor : 		Jonathan Ramirez
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_empresa_reservaciones_c';
	END ;

   /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	SELECT
		reservacion.*
	FROM suite_mig_conf.st_adm_tr_empresa_reservaciones reservacion
	JOIN suite_mig_conf.st_adm_tr_grupo_empresa grup_empresa ON
		reservacion.id_empresa = grup_empresa.id_empresa
	WHERE grup_empresa.id_grupo_empresa = pr_id_grupo_empresa;

   /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */
	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
