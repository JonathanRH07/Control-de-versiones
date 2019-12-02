DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_sucursal_s`(
	IN  pr_id_grupo_empresa 	INT,
	IN  pr_consulta 			VARCHAR(255),
	OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_sucursal_s
		@fecha: 		01/09/2017
		@descripcion : 	Consulta para filtro de input
		@autor : 		Shani Glez
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_sucursal_s';
	END ;

    SELECT
		 *
        ,CONCAT(cve_sucursal,' ||| ',nombre) AS general
	FROM ic_cat_tr_sucursal
    WHERE
		estatus = 'ACTIVO'
		AND (  cve_sucursal LIKE CONCAT('%',pr_consulta,'%') OR nombre LIKE CONCAT('%',pr_consulta,'%')  )
        AND id_grupo_empresa = pr_id_grupo_empresa
    LIMIT 50;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
