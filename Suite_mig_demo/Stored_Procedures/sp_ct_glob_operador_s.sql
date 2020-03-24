DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_ct_glob_operador_s`(
	OUT pr_message 				VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_ct_glob_operador_s
	@fecha: 		15/03/2019
	@descripción: 	Sp para mostrar registros de la tabla ct_glob_tc_operador y mostrarlos en un selector
	@autor : 		Jonathan Ramirez.
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_ct_glob_operador_s';
	END ;

	SELECT
		id_operador,
		clave,
		nombre
	FROM ct_glob_tc_operador
	WHERE estatus = 1;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
