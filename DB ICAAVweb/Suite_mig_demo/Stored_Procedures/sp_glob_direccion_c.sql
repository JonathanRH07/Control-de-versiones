DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_direccion_c`(
	IN  pr_id_direccion   	   		INT,
	OUT pr_affect_rows				INT(11),
	OUT pr_message					VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_glob_direccion_c
		@fecha: 		23/08/2016
		@descripción: 	SP para insertar Direccion para el catalogo a utilizar.
		@autor: 		Odeth Negrete
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_direccion_c';
	END ;

	SELECT
		id_direccion,
        cve_pais,
        calle,
        num_exterior,
        IFNULL(num_interior, '')num_interior,
        colonia,
        municipio,
        ciudad,
        estado,
        codigo_postal
	FROM ct_glob_tc_direccion
	WHERE id_direccion = pr_id_direccion;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
