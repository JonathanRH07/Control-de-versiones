DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_banco_c`(
	OUT	pr_message 					VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_glob_banco_c	
	@fecha: 		20/02/2017
	@descripcion: 	SP para consultar los bancos
	@autor: 		Alan Olivares
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_banco_c';
	END ;

	SELECT
		*
	FROM
		ct_glob_tc_banco
	WHERE
		estatus = 1;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
