DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cat_grupo_fit_f`(
	IN 	pr_id_grupo_empresa					INT,
    IN 	pr_id_grupo_fit						INT,
    IN  pr_cve_codigo_grupo 				VARCHAR(45),
    IN  pr_desc_grupo_fit					TEXT,
    IN  pr_fecha_ini_grupo_fit				DATE,
    IN  pr_fecha_fin_grupo_fit				DATE,
    IN	pr_observaciones_grupo_fit 			TEXT,
    IN  pr_estatus_grupo_fit   				ENUM('ACTIVO','INACTIVO','TODOS'),
    IN  pr_consulta_gral					VARCHAR(200),
    IN  pr_ini_pag 							INT,
    IN  pr_fin_pag 							INT,
    IN  pr_order_by							VARCHAR(30),
    OUT pr_rows_tot_table  					INT,
    OUT pr_message 							VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_grupo_fit_f
	@fecha:			13/08/2016
	@descripcion:	SP para filtrar registros de catalogo grupo_fit.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_id_grupo_fit  	    		VARCHAR(300) DEFAULT '';
    DECLARE lo_estatus_grupo_fit			VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_codigo_grupo				VARCHAR(300) DEFAULT '';
    DECLARE lo_desc_grupo_fit				VARCHAR(300) DEFAULT '';
    DECLARE lo_fecha_ini_grupo_fit			VARCHAR(500) DEFAULT '';
    DECLARE lo_fecha_fin_grupo_fit			VARCHAR(300) DEFAULT '';
    DECLARE lo_observaciones_grupo_fit		VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 					VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  				VARCHAR(2000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'PROJECTS.MESSAGE_ERROR_UPDATE_GRUPOFIT';
	END ;

    IF pr_id_grupo_fit  > 0 THEN
		SET lo_id_grupo_fit   = CONCAT(' AND grupo_f.id_grupo_fit =  ', pr_id_grupo_fit);
    END IF;

	IF pr_cve_codigo_grupo != '' THEN
		SET lo_cve_codigo_grupo = CONCAT(' AND grupo_f.cve_codigo_grupo LIKE "%', pr_cve_codigo_grupo, '%" ');
	END IF;

	IF pr_desc_grupo_fit != '' THEN
		SET lo_desc_grupo_fit = CONCAT(' AND grupo_f.desc_grupo_fit LIKE "%', pr_desc_grupo_fit, '%" ');
	END IF;

    IF pr_fecha_ini_grupo_fit > "0000-00-00" THEN
		SET lo_fecha_ini_grupo_fit= CONCAT(' AND  grupo_f.fecha_ini_grupo_fit >= "', pr_fecha_ini_grupo_fit, '" ');
    END IF;

    IF pr_fecha_fin_grupo_fit > "0000-00-00" THEN
		SET  lo_fecha_fin_grupo_fit = CONCAT(' AND grupo_f.fecha_fin_grupo_fit <= "', pr_fecha_fin_grupo_fit, '" ');
    END IF;

    IF pr_observaciones_grupo_fit != '' THEN
		SET lo_observaciones_grupo_fit = CONCAT(' AND grupo_f.observaciones_grupo_fit  = "', pr_observaciones_grupo_fit  ,'"');
    END IF;

    IF (pr_estatus_grupo_fit != '' AND pr_estatus_grupo_fit != 'TODOS')THEN
		SET lo_estatus_grupo_fit  = CONCAT(' AND grupo_f.estatus_grupo_fit  = "', pr_estatus_grupo_fit  ,'"');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
			SET lo_consulta_gral = CONCAT(' AND (grupo_f.cve_codigo_grupo  LIKE "%'	, pr_consulta_gral, '%"
											OR grupo_f.desc_grupo_fit LIKE "%'		, pr_consulta_gral, '%"
                                            OR grupo_f.fecha_ini_grupo_fit LIKE "%'	, pr_consulta_gral, '%"
                                            OR grupo_f.fecha_fin_grupo_fit LIKE "%'	, pr_consulta_gral, '%"
                                            OR grupo_f.estatus_grupo_fit LIKE "%'	, pr_consulta_gral, '%" ) ');

	END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	SET @query = CONCAT('SELECT
							grupo_f.id_grupo_fit,
							grupo_f.cve_codigo_grupo,
							grupo_f.desc_grupo_fit,
							grupo_f.fecha_ini_grupo_fit ,
							grupo_f.fecha_fin_grupo_fit,
							grupo_f.estatus_grupo_fit,
                            grupo_f.fecha_mod_grupo_fit fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod,
                            grupo_f.observaciones_grupo_fit
						FROM
							ic_fac_tc_grupo_fit grupo_f
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=grupo_f.id_usuario
						WHERE grupo_f.id_grupo_empresa = ?',
							lo_id_grupo_fit,
							lo_estatus_grupo_fit,
							lo_cve_codigo_grupo,
							lo_desc_grupo_fit,
							lo_fecha_ini_grupo_fit,
							lo_fecha_fin_grupo_fit,
                            lo_observaciones_grupo_fit,
                            lo_consulta_gral,
							lo_order_by,
						   'LIMIT ?,?');

    PREPARE stmt
	FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;

    # START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
									SELECT
										COUNT(*)
									INTO
										@pr_rows_tot_table
									FROM
										ic_fac_tc_grupo_fit grupo_f
									INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
										ON usuario.id_usuario=grupo_f.id_usuario
									WHERE grupo_f.id_grupo_empresa = ?',
										lo_id_grupo_fit,
										lo_estatus_grupo_fit,
										lo_cve_codigo_grupo,
										lo_desc_grupo_fit,
										lo_fecha_ini_grupo_fit,
										lo_fecha_fin_grupo_fit,
                                        lo_observaciones_grupo_fit,
                                        lo_consulta_gral);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
     # Mensaje de ejecucion.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
