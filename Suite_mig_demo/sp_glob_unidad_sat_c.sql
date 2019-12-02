DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_unidad_sat_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_glob_monedas_c
	@fecha: 		2016/08/19
	@descripción: 	Sp para obtenber las monedas.
	@autor : 		Alan Olivares
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_unidad_sat_c';
	END ;

	SELECT
		c_ClaveUnidad,
        nombre as desc_unidades_sat,
        descripcion as descripcion
	FROM
		sat_unidades_medida;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
