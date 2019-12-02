DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_forma_pago_c`(IN  pr_cve_forma_pago 		VARCHAR(10),
    IN  pr_id_forma_pago		INT(11),
    IN  pr_id_grupo_empresa		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_forma_pago_c
	@fecha: 		04/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_forma_pago_c';
	END ;

    IF(pr_cve_forma_pago !='' AND pr_id_grupo_empresa !='')THEN
    	SELECT
			*
		FROM
			ic_glob_tr_forma_pago
		LEFT JOIN sat_formas_pago ON
			sat_formas_pago.c_FormaPago = ic_glob_tr_forma_pago.id_forma_pago_sat
		WHERE cve_forma_pago = pr_cve_forma_pago
		AND estatus_forma_pago='ACTIVO'
		AND id_grupo_empresa=pr_id_grupo_empresa;
	END IF;

    IF(pr_id_forma_pago !='' AND pr_id_grupo_empresa !='')THEN
		SELECT
			*
		FROM ic_glob_tr_forma_pago
        LEFT JOIN sat_formas_pago ON
			sat_formas_pago.c_FormaPago = ic_glob_tr_forma_pago.id_forma_pago_sat
		WHERE id_forma_pago = pr_id_forma_pago
		AND estatus_forma_pago='ACTIVO'
		AND id_grupo_empresa=pr_id_grupo_empresa;
	END IF;


	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
