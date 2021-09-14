DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_servicio_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_consulta 			VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_servicio_s
		@fecha: 		12/01/2018
		@descripcion : 	Sp de consulta
		@autor : 		Griselda Medina Medina
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_servicio_s';
	END ;

    SELECT
		 serv.*
        ,CONCAT(serv.cve_servicio,' ||| ', serv.descripcion) general,
        prod.cve_producto
	FROM ic_cat_tc_servicio serv
		LEFT JOIN ic_cat_tc_producto prod ON
			serv.id_producto = prod.id_producto
    WHERE
		serv.estatus = 'ACTIVO' AND serv.id_grupo_empresa = pr_id_grupo_empresa
		AND (  serv.cve_servicio LIKE CONCAT('%',pr_consulta,'%') OR serv.descripcion LIKE CONCAT('%',pr_consulta,'%')  )
	ORDER BY serv.cve_servicio
    LIMIT 50;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
