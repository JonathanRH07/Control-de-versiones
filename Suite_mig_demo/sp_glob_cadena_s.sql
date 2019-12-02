DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_cadena_s`(
	IN  pr_consulta 			VARCHAR(255),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_cadena_s
		@fecha: 		27/09/2017
		@descripcion : 	Consulta para filtro de cadena
		@autor : 		Griselda Medina Medina
	*/

    DECLARE lo_param_A 		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_cadena_s';
	END ;

    SET lo_param_A = CONCAT('CONCAT(ltrim(rtrim(cadena)))');

	SET @query = CONCAT('
		SELECT
			 *
			,CONCAT(ltrim(rtrim(cadena))) AS general
			,',lo_param_A,' AS particular
		FROM ct_glob_tc_cadena
		WHERE ',lo_param_A,' LIKE "%',pr_consulta,'%"
		ORDER BY cadena ASC
		LIMIT 50
	');
    PREPARE stmt FROM @query;
    EXECUTE stmt ;
	DEALLOCATE PREPARE stmt;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
