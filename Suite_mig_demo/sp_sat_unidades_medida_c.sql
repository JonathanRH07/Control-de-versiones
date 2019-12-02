DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_sat_unidades_medida_c`(
	IN	pr_id_unidad				INT,
	OUT	pr_message 					VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_cat_categoria_impuesto_c
	@fecha: 		24/10/2018
	@descripcion: 	SP para consultar las unidades de medida del sat
	@autor: 		Jonathan Ramirez
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_sat_unidades_medida_c';
	END ;

    SELECT
		id_unidad,
		c_ClaveUnidad,
		nombre,
		descripcion,
		fechaInicioVigencia,
		fechaFinVigencia,
		simbolo
	FROM sat_unidades_medida
	WHERE id_unidad = pr_id_unidad;

    # Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
