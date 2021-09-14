DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_ine_tipo_proc_c`(
	OUT pr_message 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_cat_ine_tipo_proc_c
	@fecha: 		12/11/2018
	@descripcion: 	Sp para consultar los registros de la tabla ic_cat_tc_ine_tipo_proceso
	@autor: 		Carol Mejía
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_ine_tipo_proc_c';
	END ;

	SELECT 	*
	FROM ic_cat_tc_ine_tipo_proceso;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
