DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_tr_prove_imp_serv_activo_b`(
	IN	pr_id_prove_servicio		 INT,
	IN	pr_id_impuesto				 INT,
    /*
	IN	pr_id_proveedor				 INT,
	IN	pr_id_servicio				 INT,
    */
    OUT pr_message 					 VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_tr_prove_imp_serv_activo_b
	@fecha: 		30/10/2018
	@descripción: 	Sp para consultar los datos de ic_fac_tr_prove_imp_serv
	@autor : 		Jonathan Ramirez.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_tr_prove_imp_serv_activo_b';
	END ;

    SELECT
		id_prov_imp_serv
	FROM ic_fac_tr_prove_imp_serv prov_imp_serv
	JOIN ic_fac_tr_prove_servicio prov_serv ON
		prov_imp_serv.id_prove_servicio = prov_serv.id_prove_servicio
	WHERE prov_imp_serv.id_prove_servicio = pr_id_prove_servicio
	AND prov_imp_serv.id_impuesto = pr_id_impuesto;
	/*
    AND prov_serv.id_proveedor = pr_id_proveedor
	AND prov_serv.id_servicio = pr_id_servicio;
    */
    SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
