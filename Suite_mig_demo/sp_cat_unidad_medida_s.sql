DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_medida_s`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_id_unidad_medida 	INT,
	IN  pr_consulta 			VARCHAR(255),
	OUT pr_message 				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_unidad_medida_s
		@fecha: 		12/11/2018
		@descripcion : 	Busqueda de Unidades de Medida
		@autor : 		Yazbek Kido
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_unidad_medida_s';
	END ;

    IF pr_id_unidad_medida > 0 THEN
		SELECT
			*
		FROM ic_cat_tc_unidad_medida
		WHERE
			estatus = 'ACTIVO' AND id_grupo_empresa = pr_id_grupo_empresa AND id_unidad_medida = pr_id_unidad_medida;
    ELSE
		SELECT
			*
		FROM ic_cat_tc_unidad_medida
		WHERE
			estatus = 'ACTIVO' AND id_grupo_empresa = pr_id_grupo_empresa
			AND (  cve_unidad_medida LIKE CONCAT('%',pr_consulta,'%') OR descripcion LIKE CONCAT('%',pr_consulta,'%')  )
		LIMIT 50;
	END IF;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
