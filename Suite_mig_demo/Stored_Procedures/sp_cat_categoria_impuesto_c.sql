DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_categoria_impuesto_c`(
	IN	pr_id_grupo_empresa			INT,
	OUT	pr_message 					VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_categoria_impuesto_c
	@fecha: 		27/09/2016
	@descripcion: 	SP para consultar las categorías de los impuestos
	@autor: 		Alan Olivares
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_categoria_impuesto_c';
	END ;

	SELECT
		id_categoria_impuesto,
        categoria_impuesto,
        estatus_categoria_impuesto
	FROM
		ic_cat_tc_categoria_impuesto
	WHERE
		(id_grupo_empresa = pr_id_grupo_empresa
        OR id_grupo_empresa = 0)
        AND estatus_categoria_impuesto = 1;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
