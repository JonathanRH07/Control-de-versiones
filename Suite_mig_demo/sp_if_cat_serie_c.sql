DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_serie_c`(
	IN  pr_id_serie 			INT,
    IN  pr_id_grupo_empresa 	INT,
    IN  pr_cve_serie 			CHAR(5),
    IN  pr_id_sucursal			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_if_cat_serie_c
		@fecha: 		18/01/2018
		@descripción: 	Sp para consultar registros en la tabla series
		@autor : 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_serie_c';
	END ;

    IF pr_cve_serie != '' THEN
		SELECT
			*
        FROM ic_cat_tr_serie
        WHERE cve_serie = pr_cve_serie
		AND id_grupo_empresa=pr_id_grupo_empresa AND estatus_serie = 'ACTIVO';
	ELSEIF pr_id_serie > 0 AND pr_id_sucursal > 0 AND pr_id_grupo_empresa > 0 THEN
		SELECT
			*
        FROM ic_cat_tr_serie
        WHERE id_serie = pr_id_serie
		AND id_grupo_empresa = pr_id_grupo_empresa
        AND id_sucursal = pr_id_sucursal AND estatus_serie = 'ACTIVO';
	ELSEIF pr_id_serie > 0 THEN
		SELECT
			*
        FROM ic_cat_tr_serie
        WHERE id_serie = pr_id_serie
		AND id_grupo_empresa=pr_id_grupo_empresa AND estatus_serie = 'ACTIVO';
    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
