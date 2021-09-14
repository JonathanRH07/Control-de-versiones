DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_role_catalogo_c`(
	OUT pr_message			VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_adm_role_catalogo_c
	@fecha: 		05/12/2019
	@descripcion : 	Sp de consulta de los roles del sistema
	@autor : 		Jonathan Ramirez
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_role_catalogo_c';
	END ;

    SELECT
		id_role,
		nombre_role,
		id_tipo_paquete
	FROM suite_mig_conf.st_adm_tc_role
	WHERE id_grupo_empresa = 0;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
