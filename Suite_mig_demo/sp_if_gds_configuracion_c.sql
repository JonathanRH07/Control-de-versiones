DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_configuracion_c`(
	IN 	pr_cve_gds				VARCHAR(2),
    IN  pr_id_grupo_empresa 	INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_gds_configuracion_c
	@fecha: 		03/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_configuracion_c';
	END ;

	SELECT
		*
	FROM ic_gds_tr_configuracion con
	JOIN ic_glob_tr_info_sys inf ON
		 con.id_grupo_empresa = inf.id_grupo_empresa
	WHERE con.cve_gds = pr_cve_gds
    AND   con.id_grupo_empresa=pr_id_grupo_empresa;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
