DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_servicios_b`(
	IN  pr_id_grupo_empresa  	INT(11),
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_servicio_b
	@fecha: 		08/03/2017
	@descripcion : 	Sp de consulta de servicios
	@autor : 		Griselda Medina Medina
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_servicio_b';
	END ;

	SELECT
		*
	FROM
		ic_cat_tc_servicio serv
	WHERE  id_grupo_empresa = pr_id_grupo_empresa
	AND    estatus = 1;

	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
