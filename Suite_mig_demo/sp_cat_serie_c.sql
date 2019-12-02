DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_serie_c`(
	 IN  pr_id_grupo_empresa	INT,
     OUT pr_message				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_glob_proveedor_c
	@fecha: 		07/08/2018
	@descripción: 	Muestra las series
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_serie_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tr_serie
	WHERE id_grupo_empresa = pr_id_grupo_empresa
    AND	  estatus_serie = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
