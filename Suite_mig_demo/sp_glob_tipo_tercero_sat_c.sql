DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipo_tercero_sat_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_tipo_tercero_sat_c
		@fecha: 		09/12/2016
		@descripción: 	Sp para obtenber Tipo Terceros.
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_tipo_tercero_sat_c';
	END ;

	SELECT
		id_sat_tipo_tercero,
        origen
	FROM
		ic_glob_tc_tipo_tercero_sat
	WHERE
		estatus = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
