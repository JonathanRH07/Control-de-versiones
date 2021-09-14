DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_serie_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_consulta 			VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_gds_serie_s
		@fecha: 		09/05/2018
		@descripcion : 	Sp de consulta
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_serie_s';
	END ;
	SELECT
		 ic_cat_tr_serie.id_serie,
         ic_cat_tr_serie.cve_serie,
         ic_cat_tr_sucursal.id_sucursal,
         ic_cat_tr_sucursal.nombre
        ,CONCAT(cve_serie,' ||| ',ic_cat_tr_sucursal.nombre) general
	FROM ic_cat_tr_serie
    INNER JOIN ic_cat_tr_sucursal
		ON ic_cat_tr_sucursal.id_sucursal=ic_cat_tr_serie.id_sucursal
    WHERE
		ic_cat_tr_serie.estatus_serie = 'ACTIVO' AND ic_cat_tr_serie.id_grupo_empresa = pr_id_grupo_empresa
		AND (  cve_serie LIKE CONCAT('%',pr_consulta,'%') OR ic_cat_tr_sucursal.nombre LIKE CONCAT('%',pr_consulta,'%')  )
    LIMIT 50;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
