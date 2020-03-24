DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_tipo_forma_pago_c`(
	IN  pr_id_idioma 			INT,
	OUT pr_message 				VARCHAR(500))
BEGIN
/*
    @nombre:		sp_glob_tipo_forma_pago_c
	@fecha: 		29/10/2019
	@descripcion : 	Sp de consulta del catalogo tipo de forma de pago
	@autor : 		Yazbek Kido
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_tipo_forma_pago_c';
	END ;


		SELECT
			tipo.*,
            trans.descripcion
		FROM
			ic_glob_tc_tipo_forma_pago tipo
		INNER JOIN ic_glob_tc_tipo_forma_pago_trans trans
			ON trans.id_tipo_forma_pago=tipo.id_tipo_forma_pago
		WHERE
			trans.id_idioma = pr_id_idioma;


	 # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
