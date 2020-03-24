DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_sat_bancos_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_sat_bancos_c
	@fecha: 		2018/02/19
	@descripción: 	Sp para obtenber registros de las tablas sat_bancos
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_sat_bancos_c';
	END ;

	SELECT
		*
	FROM
		sat_bancos;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
