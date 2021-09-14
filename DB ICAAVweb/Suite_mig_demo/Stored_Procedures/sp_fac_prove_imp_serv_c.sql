DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_imp_serv_c`(
	IN  pr_id_prove_servicio		INT(11),
	OUT pr_message					VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_fac_prove_servicio_c
		@fecha:			09/03/2017
		@descripcion:	Consulta registros se prov_imp_sev
		@autor:			Griselda Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_imp_serv_c';
	END ;

	SELECT
		prov_imp_serv.*,
		imp.cve_impuesto clave,
		desc_impuesto descripcion
	FROM ic_fac_tr_prove_imp_serv prov_imp_serv
	JOIN ic_cat_tr_impuesto imp ON
		prov_imp_serv.id_impuesto = imp.id_impuesto
	WHERE prov_imp_serv.id_prove_servicio = pr_id_prove_servicio;

	SET pr_message	= 'SUCCESS';

END$$
DELIMITER ;
