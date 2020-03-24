DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_citypair_c`(
	IN  pr_id_gds_vuelos 	INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_vuelos_citypair_c
		@fecha:			19/09/2017
		@descripcion:	Sp para consutar la tabla de gds_vuelos_citypair
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_vuelos_citypair_c';
	END ;

	SELECT
			 *
	FROM ic_gds_tr_vuelos_citypair

	WHERE
		id_gds_vuelos = pr_id_gds_vuelos;


	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
