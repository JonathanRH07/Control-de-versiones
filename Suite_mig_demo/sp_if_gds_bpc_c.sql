DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_bpc_c`(
	IN  pr_bpc 					VARCHAR(10),
	IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_cve_gds 				CHAR(2),
    IN  pr_tipo_bpc 			CHAR(1),
    IN  pr_busca_usando 		VARCHAR(20),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_gds_bpc_c
	@fecha: 		02/02/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_bpc_c';
	END ;

    IF pr_cve_gds != '' AND pr_id_grupo_empresa > 0 AND pr_bpc != '' AND pr_tipo_bpc != '' THEN
    	SELECT
			ic_gds_tr_bpc.id_bpc,
			ic_gds_tr_bpc.id_serie,
			ic_cat_tr_serie.cve_serie,
			ic_cat_tr_serie.id_sucursal,
			ic_gds_tr_bpc.tipo_bpc,
			ic_gds_tr_bpc.bpc_consolid,
			ic_gds_tr_bpc.bpc
        FROM ic_gds_tr_bpc
        INNER JOIN ic_cat_tr_serie
			ON ic_cat_tr_serie.id_serie=ic_gds_tr_bpc.id_serie
        WHERE cve_gds = pr_cve_gds
        AND ic_gds_tr_bpc.id_grupo_empresa = pr_id_grupo_empresa
        AND bpc = pr_bpc
        AND tipo_bpc = pr_tipo_bpc AND ic_gds_tr_bpc.estatus = 'ACTIVO';

	ELSEIF pr_cve_gds != '' AND pr_id_grupo_empresa > 0 AND pr_busca_usando = 'gds_empresa' THEN
        SELECT
			ic_gds_tr_bpc.id_bpc,
			ic_gds_tr_bpc.id_serie,
			ic_cat_tr_serie.cve_serie,
			ic_cat_tr_serie.id_sucursal,
			ic_gds_tr_bpc.tipo_bpc,
			ic_gds_tr_bpc.bpc_consolid,
			ic_gds_tr_bpc.bpc
		FROM ic_gds_tr_bpc
        INNER JOIN ic_cat_tr_serie
			ON ic_cat_tr_serie.id_serie=ic_gds_tr_bpc.id_serie
        WHERE ic_gds_tr_bpc.id_grupo_empresa = pr_id_grupo_empresa
        AND ic_gds_tr_bpc.cve_gds = pr_cve_gds AND ic_gds_tr_bpc.estatus = 'ACTIVO';

	ELSEIF pr_bpc != '' AND pr_id_grupo_empresa > 0 THEN
        SELECT
			ic_gds_tr_bpc.id_bpc,
			ic_gds_tr_bpc.id_serie,
			ic_cat_tr_serie.cve_serie,
			ic_cat_tr_serie.id_sucursal,
			ic_gds_tr_bpc.tipo_bpc,
			ic_gds_tr_bpc.bpc_consolid,
			ic_gds_tr_bpc.bpc
		FROM ic_gds_tr_bpc
        INNER JOIN ic_cat_tr_serie
			ON ic_cat_tr_serie.id_serie=ic_gds_tr_bpc.id_serie
        WHERE ic_gds_tr_bpc.id_grupo_empresa = pr_id_grupo_empresa
        AND bpc = pr_bpc AND ic_gds_tr_bpc.estatus = 'ACTIVO';
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
