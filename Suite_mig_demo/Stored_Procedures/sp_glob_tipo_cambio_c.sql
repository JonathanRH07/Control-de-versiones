DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipo_cambio_c`(
	IN  pr_fecha		TIMESTAMP,
    OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_glob_tipo_cambio_c
	@fecha: 		2017/06/02
	@descripción: 	Sp para obtenber los tipos de cambio
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_tipo_cambio_c';
	END ;

	SELECT
		*
	FROM
		ic_glob_tc_tipo_cambio
	WHERE
		fecha_cambio=pr_fecha;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
