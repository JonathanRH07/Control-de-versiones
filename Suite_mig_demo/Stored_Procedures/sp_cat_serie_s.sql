DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_serie_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_consulta 			VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_if_cat_serie_s
		@fecha: 		09/05/2018
		@descripcion : 	Sp de consulta
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_serie_s';
	END ;
	SELECT
		 *
	FROM ic_cat_tr_serie
    WHERE
		estatus_serie = 'ACTIVO' AND id_grupo_empresa = pr_id_grupo_empresa
		AND (  cve_serie LIKE CONCAT('%',pr_consulta,'%') OR descripcion_serie LIKE CONCAT('%',pr_consulta,'%')  )
	ORDER BY cve_serie
    LIMIT 50;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
