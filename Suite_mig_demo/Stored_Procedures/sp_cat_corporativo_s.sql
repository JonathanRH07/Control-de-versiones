DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_corporativo_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_consulta 			VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_cliente_s
		@fecha: 		15/02/2018
		@descripcion : 	Sp de consulta
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_corporativo_s';
	END ;

    SELECT
		 *
	FROM ic_cat_tr_corporativo
    WHERE
		estatus_corporativo = 'ACTIVO' AND id_grupo_empresa = pr_id_grupo_empresa
		AND (cve_corporativo LIKE CONCAT('%',pr_consulta,'%') OR nom_corporativo LIKE CONCAT('%',nom_corporativo,'%')  )

    ORDER BY cve_corporativo
    LIMIT 50;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
