DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipo_habitacion_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_glob_tipo_habitacion_c
	@fecha: 		2017/09/27
	@descripción: 	Sp para obtenber los difrentes tipos de Habitacion
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_tipo_habitacion_c';
	END ;

	SELECT
		*
	FROM
		 ct_glob_tc_tipo_habitacion;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
