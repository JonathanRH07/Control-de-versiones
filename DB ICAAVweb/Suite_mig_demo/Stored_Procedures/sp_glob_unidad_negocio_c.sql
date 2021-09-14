DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_unidad_negocio_c`(
	IN  pr_id_grupo_empresa  	INT(11),
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_sucursal_c
	@fecha: 		01/11/2016
	@descripcion : 	Sp de consulta del catalogo sucursales
	@autor : 		Hugo Luna
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_unidad_negocio_c';
	END ;

	SELECT
		*
   FROM
		ic_cat_tc_unidad_negocio uni_negocio
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
