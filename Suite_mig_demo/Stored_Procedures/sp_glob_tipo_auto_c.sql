DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipo_auto_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_tipo_auto_c
	@fecha: 		20/09/2017
	@descripción: 	Sp para obtener informacion de tipo de autos
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_tipo_auto_c';
	END ;

	SELECT
		*
	FROM
		ct_glob_tc_tipo_auto
	WHERE
		estatus = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
