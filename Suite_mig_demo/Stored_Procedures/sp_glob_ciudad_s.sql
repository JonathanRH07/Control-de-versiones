DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_ciudad_s`(
	IN  pr_consulta 			VARCHAR(255),
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_glob_ciudad_s
		@fecha: 		01/09/2017
		@descripcion : 	Consulta para filtro de input
		@autor : 		Shani Glez
	*/

    DECLARE lo_param_A 		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_ciudad_s';
	END ;

    SET lo_param_A = CONCAT('CONCAT(ltrim(rtrim(ciudad.ciudad))," (",ltrim(rtrim(ciudad.clave_ciudad)),") , ",ltrim(rtrim(pais.pais))  )');

	SET @query = CONCAT('
		SELECT
			 ciudad.*
			,CONCAT(  pais.pais,"|||",ciudad.ciudad,"|||",ciudad.clave_ciudad  ) general
			,',lo_param_A,' AS particular
		FROM ct_glob_tc_ciudad AS ciudad
		INNER JOIN ct_glob_tc_pais AS pais
			ON pais.id_pais = ciudad.id_pais
		WHERE
			ciudad.estatus = "ACTIVO"
			AND ',lo_param_A,' LIKE "%',pr_consulta,'%"
		ORDER BY
			ciudad.ciudad ASC, pais.pais ASC
		LIMIT 50
	');
    PREPARE stmt FROM @query;
    EXECUTE stmt ;
	DEALLOCATE PREPARE stmt;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
