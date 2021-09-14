DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_unidad_negocio_c`(IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_cve_unidad_negocio 	VARCHAR(10),
    IN  pr_id_unidad_negocio	INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_unidad_negocio_c
		@fecha: 		18/01/2018
		@descripción: 	Sp para consultar registros en la tabla ic_cat_tc_unidad_negocio
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_unidad_negocio_c';
	END ;

    IF(pr_id_grupo_empresa >0 AND pr_cve_unidad_negocio != '')THEN
		SELECT
			*
		FROM ic_cat_tc_unidad_negocio
		WHERE id_grupo_empresa=pr_id_grupo_empresa
		AND cve_unidad_negocio=pr_cve_unidad_negocio AND estatus_unidad_negocio = 'ACTIVO';
	END IF;

    IF(pr_id_grupo_empresa >0 AND pr_id_unidad_negocio >0) THEN
		SELECT
			*
		FROM ic_cat_tc_unidad_negocio
        WHERE id_grupo_empresa=pr_id_grupo_empresa
        AND id_unidad_negocio=pr_id_unidad_negocio AND estatus_unidad_negocio = 'ACTIVO';
	END IF;


	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
