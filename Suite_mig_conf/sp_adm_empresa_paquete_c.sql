DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_empresa_paquete_c`(
	OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_adm_empresa_paquete_c
	@fecha: 		05/12/2019
	@descripcion : 	Sp de consulta empresas y sus paquetes
	@autor : 		Jonathan Ramirez
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_empresa_paquete_c';
	END ;

    SELECT
		grup_empresa.id_grupo_empresa,
		empresa.id_empresa,
		empresa.razon_social,
		paquete.id_tipo_paquete
	FROM st_adm_tr_empresa empresa
	JOIN st_adm_tr_grupo_empresa grup_empresa ON
		empresa.id_empresa = grup_empresa.id_empresa
	JOIN st_adm_tc_tipo_paquete paquete ON
		empresa.id_tipo_paquete = paquete.id_tipo_paquete
	WHERE estatus_empresa = 1;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
