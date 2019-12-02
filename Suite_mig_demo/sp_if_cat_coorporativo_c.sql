DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_coorporativo_c`(
	IN  pr_id_corporativo		INT,
    IN  pr_id_grupo_empresa		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_coorporativo_c
		@fecha: 		22/03/2017
		@descripción: 	Sp para consultar registros en la tabla ic_cat_tr_corporativo
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_coorporativo_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tr_corporativo
	WHERE  id_corporativo = pr_id_corporativo AND id_grupo_empresa = pr_id_grupo_empresa;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
