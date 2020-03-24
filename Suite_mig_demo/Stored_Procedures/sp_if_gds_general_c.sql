DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_general_c`(
	IN  pr_id_grupo_empresa		INT,
    IN  pr_cve_gds 				CHAR(2),
    IN  pr_record_localizador 	VARCHAR(4),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_gds_general_c
		@fecha: 		22/03/2017
		@descripción: 	Sp para consultar registros en la tabla ic_gds_tr_general
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_general_c';
	END ;

	SELECT
		*
	FROM
		ic_gds_tr_general
	WHERE  id_grupo_empresa = pr_id_grupo_empresa
    AND cve_gds=pr_cve_gds
    AND record_localizador=pr_record_localizador;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
