DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_prove_servicio_c`(
	IN  pr_id_proveedor 	INT(11),
	IN  pr_id_servicio 		INT(11),
    OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_prove_servicio_c
	@fecha: 		04/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_prove_servicio_c';
	END ;

	SELECT
		*
	FROM
		ic_fac_tr_prove_servicio
	WHERE id_proveedor = pr_id_proveedor
    AND id_servicio=pr_id_servicio;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
