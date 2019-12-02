DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_prove_imp_serv_c`(
	IN  pr_id_prove_servicio 	INT(11),
    IN  pr_id_impuesto			INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_prove_imp_serv_c
	@fecha: 		22/01/2018
	@descripción: 	Sp para mostrar informacion de las tablas ic_fac_tr_prove_imp_serv y ic_cat_tr_impuesto
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_prove_imp_serv_c';
	END ;

	IF pr_id_prove_servicio > 0 AND pr_id_impuesto > 0 THEN
		SELECT
			*
		FROM
			ic_fac_tr_prove_imp_serv
		INNER JOIN  ic_cat_tr_impuesto
			ON ic_cat_tr_impuesto.id_impuesto=ic_fac_tr_prove_imp_serv.id_impuesto
		WHERE id_prove_servicio = pr_id_prove_servicio
		AND ic_fac_tr_prove_imp_serv.id_impuesto=pr_id_impuesto;
	ELSEIF pr_id_prove_servicio > 0 THEN
		SELECT
			*
		FROM
			ic_fac_tr_prove_imp_serv
		INNER JOIN  ic_cat_tr_impuesto
			ON ic_cat_tr_impuesto.id_impuesto=ic_fac_tr_prove_imp_serv.id_impuesto
		WHERE id_prove_servicio = pr_id_prove_servicio;
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
