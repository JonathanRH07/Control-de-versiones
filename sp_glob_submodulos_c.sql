DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_submodulos_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_submodulos_c
	@fecha: 		16/03/2017
	@descripcion : 	Sp de consulta de servicios
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_submodulos_c';
	END ;

	SELECT
		submod.id_submodulo,
		submod.id_modulo,
        modu.nombre_modulo,
		submod.nombre_submodulo,
        submod.clave_submodulo,
        submod.traduccion
	FROM st_adm_tr_submodulo submod
	INNER JOIN st_adm_tc_modulo modu
		ON modu.id_modulo = submod.id_modulo ;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
