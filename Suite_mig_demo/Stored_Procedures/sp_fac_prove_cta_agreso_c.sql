DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_agreso_c`(
	IN  pr_id_proveedor				INT(11),
	OUT pr_message					VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_fac_prove_cta_agreso_c
		@fecha:			16/01/2017
		@descripcion:	SP para consultar registros en prove_servicio
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_servicio_c';
	END ;

	SELECT * FROM ic_fac_tr_prove_cta_egreso WHERE i_proveedor=pr_id_proveedor AND estatus=1;
	SET pr_message	= 'SUCCESS';
END$$
DELIMITER ;
