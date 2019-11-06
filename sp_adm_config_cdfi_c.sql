DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_cdfi_c`(
	IN  pr_id_grupo_empresa		INT(11),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_adm_config_cdfi_c
	@fecha: 		17/05/2017
	@descripcion : 	Sp de consulta configuracion cfdi
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_config_cdfi_c';
	END ;

	SELECT
		cfdi.*,
        cfdi.fecha_mod fecha_mod,
		concat(usuario.nombre_usuario," ",
		usuario.paterno_usuario) usuario_mod
	FROM st_adm_tr_config_cfdi cfdi
    INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario ON
		usuario.id_usuario = cfdi.id_usuario
    WHERE cfdi.id_grupo_empresa = pr_id_grupo_empresa;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
