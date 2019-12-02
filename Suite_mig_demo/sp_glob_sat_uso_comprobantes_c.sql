DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_sat_uso_comprobantes_c`(
	IN  pr_c_uso			CHAR(3),
	OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_sat_uso_comprobantes_c
	@fecha: 		18/05/2017
	@descripción: 	Sp para consultar los usos del sat
	@autor : 		Griselda Medina Medina.
	@cambios: 		Carol Mejia		05/06/2018

*/

	DECLARE  lo_c_uso		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_sat_uso_comprobantes_c';
	END ;

	IF pr_c_uso != '' THEN
		SET lo_c_uso = CONCAT(' WHERE c_UsoCFDI = "', pr_c_uso, '" ');
	END IF;

	SET @query = CONCAT('SELECT * FROM sat_uso_comprobantes ', lo_c_uso, 'ORDER BY descripcion');

	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
