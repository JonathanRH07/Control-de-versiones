DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_prove_cta_ingreso_c`(
	IN  pr_id_prove_servicio 	CHAR(10),
	IN  pr_id_sucursal 			INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_prove_cta_ingreso_c
	@fecha: 		24/01/2018
	@descripción: 	Procedimiento que permite seleccionar todos los campos de la tabla ic_fac_tr_prove_cta_ingreso
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_prove_cta_ingreso_c';
	END ;

	SELECT
		*
	FROM
		ic_fac_tr_prove_cta_ingreso
	WHERE id_prove_servicio = pr_id_prove_servicio
		AND id_sucursal=pr_id_sucursal;


	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
