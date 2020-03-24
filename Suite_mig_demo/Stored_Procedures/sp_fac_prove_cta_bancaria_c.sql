DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_cta_bancaria_c`(
	IN  pr_id_proveedor INT,
    OUT pr_message      VARCHAR(500))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_cta_bancaria_c';
	END ;

	SELECT cuenta.* ,
		sat.razon_social nombre_banco
    FROM ic_fac_tr_prove_cta_bancaria  cuenta
    INNER JOIN sat_bancos sat
		ON sat.id_sat_bancos = cuenta.id_banco
    WHERE id_proveedor = pr_id_proveedor;

	SET pr_message     = 'SUCCESS';
END$$
DELIMITER ;
