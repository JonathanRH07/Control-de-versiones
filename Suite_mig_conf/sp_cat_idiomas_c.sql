DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cat_idiomas_c`(
	OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_adm_idiomas_c
	@fecha: 		17/05/2017
	@descripcion : 	Sp de consultar los idiomas disponibles
	@autor : 		Jonathan Ramirez
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_config_moneda_c';
	END ;

	SELECT
		id_idioma,
        cve_idioma,
        idioma
	FROM suite_mig_demo.ct_glob_tc_idioma;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
