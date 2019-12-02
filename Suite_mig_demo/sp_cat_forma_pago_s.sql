DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_consulta 			VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_forma_pago_s
		@fecha: 		30/05/2018
		@descripcion : 	Sp de consulta
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_forma_pago_s';
	END ;
	SELECT
		 id_forma_pago,
         cve_forma_pago,
         desc_forma_pago,
         id_forma_pago_sat
        ,CONCAT(cve_forma_pago,' ||| ',desc_forma_pago) general
	FROM ic_glob_tr_forma_pago
    WHERE
		estatus_forma_pago = 'ACTIVO' AND id_grupo_empresa = pr_id_grupo_empresa
		AND (  cve_forma_pago LIKE CONCAT('%',pr_consulta,'%') OR desc_forma_pago LIKE CONCAT('%',pr_consulta,'%')  )
    LIMIT 50;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
