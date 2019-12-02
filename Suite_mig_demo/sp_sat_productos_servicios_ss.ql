DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_sat_productos_servicios_s`(
	IN  pr_c_ClaveProdServ		CHAR(10),
	IN  pr_consulta 			VARCHAR(255),
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_sat_productos_servicios_s
		@fecha: 		30/01/2018
		@descripcion : 	Sp de consulta
		@autor : 		Griselda Medina Medina
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_sat_productos_servicios_s';
	END ;

	IF pr_c_ClaveProdServ != '' THEN
		SELECT
		 *
		FROM sat_productos_servicios
		WHERE c_ClaveProdServ = pr_c_ClaveProdServ;
    ELSE
		SELECT
		 *
		FROM sat_productos_servicios
		WHERE (  c_ClaveProdServ LIKE CONCAT('%',pr_consulta,'%') OR descripcion LIKE CONCAT('%',pr_consulta,'%')  )
		LIMIT 50;
    END IF;

	SET pr_message = 'SUCCESS';
    END$$
DELIMITER ;
