DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_sat_unidades_medida_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_sat_unidades_medida_c
	@fecha: 		31/05/2017
	@descripcion : 	Sp de consultar las unidades medidas sat
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_sat_unidades_medida_c';
	END ;

	SELECT
		T1.*,
        CONCAT('(', T1.simbolo,' ) -  ', T1.nombre) nombre_completo
	FROM sat_unidades_medida T1
	GROUP BY T1.c_ClaveUnidad
    ORDER BY T1.nombre asc;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
