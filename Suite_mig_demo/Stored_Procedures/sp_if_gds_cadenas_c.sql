DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_cadenas_c`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_cve_cadena	 		Char(3),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_arrendadoras_c
		@fecha:			06/04/2018
		@descripcion:	Sp para consutar la tabla de ic_gds_tr_arrendadoras
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_arrendadoras_c';
	END ;

	SELECT
		  *
	FROM ic_gds_tr_cadenas
	WHERE id_grupo_empresa=pr_id_grupo_empresa
	AND cve_cadena=pr_cve_cadena;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
