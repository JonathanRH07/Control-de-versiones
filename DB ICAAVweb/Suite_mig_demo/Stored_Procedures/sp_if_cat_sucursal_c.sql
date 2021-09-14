DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_sucursal_c`(
	IN  pr_cve_sucursal			VARCHAR(30),
    IN  pr_id_sucursal			INT,
    IN  pr_id_grupo_empresa		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_sucursal_c
		@fecha: 		18/01/2018
		@descripción: 	Sp para consultar registros en la tabla ic_cat_tr_sucursal
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_sucursal_c';
	END ;

    IF(pr_cve_sucursal !='' AND pr_id_grupo_empresa >0) THEN
		SELECT
			ic_cat_tr_sucursal.*,
            ct_glob_zona_horaria.zona_horaria
        FROM ic_cat_tr_sucursal
        LEFT JOIN ct_glob_zona_horaria ON
			ct_glob_zona_horaria.id_zona_horaria = ic_cat_tr_sucursal.id_zona_horaria
        WHERE cve_sucursal=pr_cve_sucursal
        AND id_grupo_empresa=pr_id_grupo_empresa AND estatus = 'ACTIVO';
	END IF;


	IF(pr_id_sucursal >0 AND pr_id_grupo_empresa >0) THEN
		SELECT
			ic_cat_tr_sucursal.*,
            ct_glob_zona_horaria.zona_horaria
        FROM ic_cat_tr_sucursal
        LEFT JOIN ct_glob_zona_horaria ON
			ct_glob_zona_horaria.id_zona_horaria = ic_cat_tr_sucursal.id_zona_horaria
        WHERE id_sucursal=pr_id_sucursal
        AND id_grupo_empresa=pr_id_grupo_empresa AND estatus = 'ACTIVO';
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
