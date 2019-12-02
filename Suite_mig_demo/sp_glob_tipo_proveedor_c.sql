DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipo_proveedor_c`(
	OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_tipo_proveedor_c
		@fecha: 		09/01/2017
		@descripción: 	Sp para obtener registros de tipo_proveedor.
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_tipo_proveedor_c';
	END ;

	SELECT
		*
        ,CONCAT('GTIPPROV.',cve_tipo_proveedor) as etiqueta
	FROM
		ic_cat_tc_tipo_proveedor
	WHERE
		estatus_tipo_proveedor = 1
	ORDER BY desc_tipo_proveedor ASC;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
