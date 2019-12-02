DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_prueba_c`(
	IN  pr_cve_gds 				CHAR(2),
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_iu0pcc 				VARCHAR(10),
	IN  pr_iu0isn 				VARCHAR(10),
    OUT pr_uso_iu0isn 			BOOLEAN,
	OUT pr_cve_serie 			VARCHAR(5),
	OUT pr_id_serie 			INT(11),
	OUT pr_cve_sucursal 		VARCHAR(30),
	OUT pr_id_sucursal 			INT(11),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_gds_cxs_c
	@fecha: 		24/01/2018
	@descripción: 	Procedimiento que permite seleccionar informacion de la tabla ic_gds_tr_cxs
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	# Declaración de variables.
	DECLARE li_consolidada  	VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_serie  		VARCHAR(1000) DEFAULT '';
    DECLARE lo_id_sucursal  	VARCHAR(1000) DEFAULT '';
    DECLARE lo_cve_serie  		VARCHAR(1000) DEFAULT '';
    DECLARE lo_cve_sucursal  	VARCHAR(1000) DEFAULT '';
	DECLARE li_bpc_consolid  	VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_prueba_c';
	END ;

	SELECT consolidada
		INTO li_consolidada
	FROM ic_glob_tr_info_sys
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

	IF li_consolidada = 'S' THEN
		SELECT bpc_consolid
			INTO li_bpc_consolid
		FROM ic_gds_tr_bpc
		WHERE (id_bpc = pr_iu0pcc OR id_bpc = pr_iu0isn) AND id_grupo_empresa = pr_id_grupo_empresa;

		IF li_bpc_consolid = 1 THEN
			SET pr_uso_iu0isn = TRUE;
		END IF;

	END IF;


	SELECT ic_gds_tr_bpc.id_serie, ic_gds_tr_bpc.id_sucursal, cve_serie, cve_sucursal
		INTO lo_id_serie,lo_id_sucursal,lo_cve_serie,lo_cve_sucursal
    FROM ic_gds_tr_bpc
	INNER JOIN ic_cat_tr_serie
		ON ic_cat_tr_serie.id_serie=ic_gds_tr_bpc.id_serie
	INNER JOIN ic_cat_tr_sucursal
		ON ic_cat_tr_sucursal.id_sucursal=ic_gds_tr_bpc.id_sucursal
	WHERE cve_gds = pr_cve_gds AND (id_bpc = pr_iu0pcc AND tipo_bpc = 'R') AND ic_gds_tr_bpc.id_grupo_empresa = pr_id_grupo_empresa;

    SET pr_id_serie=lo_id_serie;
    SET pr_id_sucursal=lo_id_sucursal;
    SET pr_cve_serie=lo_cve_serie;
    SET pr_cve_sucursal=lo_cve_sucursal;
   select 1;
    -- ------------------------------------------------
    -- IF (pr_id_serie is null) THEN
		SELECT ic_gds_tr_bpc.id_serie, ic_gds_tr_bpc.id_sucursal, cve_serie, cve_sucursal
			INTO lo_id_serie,lo_id_sucursal,lo_cve_serie,lo_cve_sucursal
		FROM ic_gds_tr_bpc
		INNER JOIN ic_cat_tr_serie
			ON ic_cat_tr_serie.id_serie=ic_gds_tr_bpc.id_serie
		INNER JOIN ic_cat_tr_sucursal
			ON ic_cat_tr_sucursal.id_sucursal=ic_gds_tr_bpc.id_sucursal
		WHERE cve_gds = pr_cve_gds AND (id_bpc = pr_iu0pcc AND tipo_bpc = 'B') AND ic_gds_tr_bpc.id_grupo_empresa = pr_id_grupo_empresa;

         SET pr_id_serie=lo_id_serie;
    SET pr_id_sucursal=lo_id_sucursal;
    SET pr_cve_serie=lo_cve_serie;
    SET pr_cve_sucursal=lo_cve_sucursal;

	-- END IF;

select 2;
    SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
