DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_etiqueta_addenda_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_etiqueta_addenda_c
	@fecha: 		2017/03/30
	@descripción: 	Sp para obtenber las etiquetas de addenda.
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_etiqueta_addenda_c';
	END ;

	SELECT
		*
	FROM
		ic_fac_tc_etiqueta_addenda
	WHERE
		estatus = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
