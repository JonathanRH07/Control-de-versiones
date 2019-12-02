DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_sat_productos_servicios_c`(
	IN  pr_valor 		VARCHAR(100),
	OUT pr_message 		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_sat_productos_servicios_c
		@fecha: 		07/03/2017
		@descripcion : 	Sp de consulta sat_productos_servicios
		@autor : 		Hugo Luna
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_sat_productos_servicios_c';
	END ;

	SELECT
		*, CONCAT(c_ClaveProdServ,' - ', descripcion ) AS general
    FROM sat_productos_servicios
    WHERE
		   descripcion LIKE CONCAT('%',pr_valor,'%')
        OR c_ClaveProdServ LIKE CONCAT('%',pr_valor,'%')
	LIMIT 100 ;

    -- ct_sat_productos_servicios;
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
