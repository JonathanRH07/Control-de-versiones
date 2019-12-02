DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_glob_zona_horaria_c`(
	OUT pr_message 			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_glob_zona_horaria_c
	@fecha: 		22/11/2017
	@descripción: 	sp para consultar la tabla ct_glob_zona_horaria
	@autor : 		Jonathan Ramirez.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_adicional_c';
	END ;

    SELECT *
	FROM ct_glob_zona_horaria;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
