DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_consulta 			VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_cliente_s
		@fecha: 		29/06/2018
		@descripcion : 	Sp de consulta
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_cliente_s';
	END ;

    SELECT
		 *
	FROM ic_cat_tr_cliente
    WHERE
		estatus = 'ACTIVO' AND id_grupo_empresa = pr_id_grupo_empresa
		AND (cve_cliente LIKE CONCAT('%',pr_consulta,'%') OR razon_social LIKE CONCAT('%',pr_consulta,'%')  )

    ORDER BY cve_cliente
    LIMIT 50;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
