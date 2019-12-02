DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cxc_c`(
	IN  pr_id_cliente 			INT(11),
    IN  pr_id_grupo_empresa 	INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_cxc_c
	@fecha: 		04/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cxc_c';
	END ;

	SELECT
		*
	FROM
		ic_glob_tr_cxc
	WHERE id_cliente = pr_id_cliente
    AND id_grupo_empresa=pr_id_grupo_empresa;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
