DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_arrendadora_s`(
	IN  pr_consulta 		VARCHAR(255),
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_sucursal_s
		@fecha: 		21/09/2017
		@descripcion : 	Consulta para filtro de input
		@autor : 		Shani Glez
	*/

    DECLARE lo_param_A 		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_arrendadora_s';
	END ;

    SET lo_param_A = CONCAT('CONCAT(ltrim(rtrim(nombre_comercial)),", ",ltrim(rtrim(razon_social)))');

	SET @query = CONCAT('
		SELECT
			 *
			,CONCAT(ltrim(rtrim(nombre_comercial)),"|||",ltrim(rtrim(razon_social))) AS general
			,',lo_param_A,' AS particular
		FROM ct_glob_tc_arrendadora
		WHERE
			estatus = "ACTIVO"
			AND ',lo_param_A,' LIKE "%',pr_consulta,'%"
		ORDER BY nombre_comercial ASC, razon_social ASC
		LIMIT 50
	');
    PREPARE stmt FROM @query;
    EXECUTE stmt ;
	DEALLOCATE PREPARE stmt;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
