DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_imp_ser_prov_c`(
	IN  pr_id_imp_ser_prov 	INT,
    OUT pr_message 		VARCHAR(500))
BEGIN
	/*
	Nombre		: sp_fac_imp_ser_prov_c
	Fecha		: 05/09/2016
	Descripcion	: SP para consultar id_prove_servicio y id_impuesto.
	Autor		: Odeth Negrete
	Cambios		:
	*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_imp_ser_prov_c';
	END ;

	SELECT
		   id_imp_ser_prov,
		   isp.id_prove_servicio,
           isp.id_impuesto,
		   cve_impuesto,
           desc_impuesto
	FROM  ic_fac_tr_imp_ser_prov isp
	JOIN  ic_fac_tr_prove_servicio pse
          ON isp.id_prove_servicio = pse.id_prove_servicio
	JOIN  ic_cat_tc_impuesto imp
          ON isp.id_impuesto = imp.id_impuesto
	WHERE id_imp_ser_prov = pr_id_imp_ser_prov
		AND estatus_imp_ser_prov = 1
	;
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
