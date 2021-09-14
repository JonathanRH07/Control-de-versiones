DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_c1`(
	 IN  pr_id_grupo_empresa	INT,
     OUT pr_message				VARCHAR(500)
)
BEGIN
/*
	@nombre:	sp_cat_forma_pago_c
	@fecha: 		07/08/2018
	@descripción: 	Muestra las formas de pago
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_forma_pago_c';
	END ;

	SELECT
		*
	FROM
		ic_glob_tr_forma_pago
	WHERE id_grupo_empresa = pr_id_grupo_empresa
    AND	  estatus_forma_pago = 1;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
