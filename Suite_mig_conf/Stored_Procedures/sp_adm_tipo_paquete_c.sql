DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_tipo_paquete_c`(
	OUT pr_message			VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_adm_tipo_paquete_c
	@fecha: 		05/12/2019
	@descripcion : 	Sp de consulta de los tipos paquetes
	@autor : 		Jonathan Ramirez
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_tipo_paquete_c';
	END ;

    SELECT
		id_tipo_paquete,
		nombre
	FROM suite_mig_conf.st_adm_tc_tipo_paquete;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
