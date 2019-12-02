DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_justificacion_tarifas_c`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_cve_justificacion	Char(10),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_justificacion_tarifas_c
		@fecha:			06/04/2018
		@descripcion:	Sp para consutar la tabla de ic_gds_tr_justificacion_tarifas
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_justificacion_tarifas_c';
	END ;

	SELECT
		  *
	FROM ic_gds_tr_justificacion_tarifas
	WHERE id_grupo_empresa=pr_id_grupo_empresa
	AND cve_justificacion=pr_cve_justificacion;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
