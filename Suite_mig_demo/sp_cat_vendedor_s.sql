DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_vendedor_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_consulta 			VARCHAR(255),
    OUT pr_rows_tot_table 		INT,
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_vendedor_s
		@fecha: 		04/07/2018
		@descripcion : 	Sp de consulta
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_vendedor_s';
	END ;
	SELECT
		 vend.*,
         suc.nombre nom_sucursal
	FROM ic_cat_tr_vendedor vend
    JOIN ic_cat_tr_sucursal suc ON
		vend.id_sucursal = suc.id_sucursal
    WHERE
		vend.estatus = 'ACTIVO' AND vend.id_grupo_empresa = pr_id_grupo_empresa
		AND (  vend.clave LIKE CONCAT('%',pr_consulta,'%') OR vend.nombre LIKE CONCAT('%',pr_consulta,'%')  )
	ORDER BY vend.clave
    LIMIT 50;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
