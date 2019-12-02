DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_centro_costo_nivel_c`(
	IN 	pr_id_cliente		INT,
    OUT pr_message 			VARCHAR(500))
    COMMENT 'string'
BEGIN
/*
	@nombre:		sp_cat_centro_costo_nivel_c
	@fecha: 		10/04/2017
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_centro_costo_nivel_c';
	END ;

	SELECT
		*
	FROM
		ic_cat_tr_centro_costo_nivel
	WHERE id_cliente = pr_id_cliente
    AND estatus='ACTIVO';

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
