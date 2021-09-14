DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_forma_pago_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_cve_gds				CHAR(2),
	IN  pr_cve_forma_pago		VARCHAR(10),
	IN  pr_forma_pago_gds		VARCHAR(10),
	IN  pr_tarjeta_gds			VARCHAR(10),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_forma_pago_f
	@fecha: 		04/04/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_forma_pago
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_cve_gds				VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_forma_pago		VARCHAR(300) DEFAULT '';
	DECLARE lo_forma_pago_gds		VARCHAR(300) DEFAULT '';
	DECLARE lo_tarjeta_gds			VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_bpc_f';
	END ;

    IF pr_cve_forma_pago != '' THEN
		SET lo_cve_forma_pago = CONCAT(' AND fp.cve_forma_pago LIKE "%', pr_cve_forma_pago, '%" ');
	END IF;

    IF pr_cve_gds != '' THEN
		SET lo_cve_gds = CONCAT(' AND gdsfp.cve_gds LIKE "%', pr_cve_gds, '%" ');
	END IF;

    IF pr_forma_pago_gds != '' THEN
		SET lo_forma_pago_gds = CONCAT(' AND concat(gdscatfp.cve_forma_pago_gds," - ",gdscatfp.desc_forma_pago_gds) LIKE "%', pr_forma_pago_gds, '%" ');
	END IF;

    IF pr_tarjeta_gds != '' THEN
		SET lo_tarjeta_gds = CONCAT(' AND concat(gdsfp.cve_tarjeta_gds," - ",gdsfp.desc_tarjeta_gds) LIKE "%', pr_tarjeta_gds, '%" ');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (concat(coalesce(gdsfp.cve_tarjeta_gds, ','""',')," - ", coalesce(gdsfp.desc_tarjeta_gds, ','""',')) LIKE "%'	, pr_consulta_gral, '%"
									    OR gds.nombre LIKE "%'	, pr_consulta_gral, '%"
										OR concat(coalesce(gdscatfp.cve_forma_pago_gds, ', '""',')," - ", coalesce(gdscatfp.desc_forma_pago_gds, ', '""','))  LIKE "%'	, pr_consulta_gral, '%"
										OR concat(coalesce(gdsfp.cve_tarjeta_gds, ', '""',')," - ", coalesce(gdsfp.desc_tarjeta_gds, ', '""',')) LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

    # Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							gdsfp.id_gds_forma_pago,
                            gdsfp.cve_gds,
                            gdsfp.cve_forma_pago_gds,
							gdsfp.desc_tarjeta_gds,
							gdsfp.cve_tarjeta_gds,
							gdscatfp.desc_forma_pago_gds,
                            concat(coalesce(gdscatfp.cve_forma_pago_gds, ', '""', ')," - ", coalesce(gdscatfp.desc_forma_pago_gds, ','""','))  forma_pago_gds,',
                            'concat(coalesce(gdsfp.cve_tarjeta_gds, ','""',')," - ", coalesce(gdsfp.desc_tarjeta_gds, ','""',')) tarjeta_gds,',
                            'concat(coalesce(fp.cve_forma_pago, ','""',')," - ", coalesce(fp.desc_forma_pago, ','""',')) forma_pago_icaav,',
							'emp.id_gds_forma_pago_emp,
							emp.id_forma_pago,
 							fp.cve_forma_pago,
                            fp.desc_forma_pago,
                            emp.fecha_mod fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod,
                            gds.nombre as nombre_gds
						FROM ic_gds_tr_forma_pago gdsfp
                        JOIN ic_cat_tc_gds gds ON
							gds.cve_gds = gdsfp.cve_gds
						INNER JOIN suite_mig_conf.st_adm_tr_usuario_interfase userint ON
							userint.cve_gds = gdsfp.cve_gds
                        LEFT JOIN ic_gds_tr_forma_pago_emp emp ON
							gdsfp.id_gds_forma_pago = emp.id_gds_forma_pago AND
                            emp.id_grupo_empresa = ?
						LEFT JOIN ic_glob_tr_forma_pago fp
							ON fp.id_forma_pago=emp.id_forma_pago
						LEFT JOIN ic_gds_tc_forma_pago  gdscatfp
							ON gdsfp.cve_forma_pago_gds = gdscatfp.cve_forma_pago_gds
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=emp.id_usuario
						WHERE userint.id_grupo_empresa = ? ',
							lo_cve_gds,
							lo_cve_forma_pago,
							lo_forma_pago_gds,
							lo_tarjeta_gds,
                            lo_consulta_gral,
							lo_order_by,
						   ' LIMIT ?,?');

    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_gds_tr_forma_pago gdsfp
                        JOIN ic_cat_tc_gds gds ON
							gds.cve_gds = gdsfp.cve_gds
						JOIN suite_mig_conf.st_adm_tr_usuario_interfase userint ON
							userint.cve_gds = gdsfp.cve_gds
                        LEFT JOIN ic_gds_tr_forma_pago_emp emp ON
							gdsfp.id_gds_forma_pago = emp.id_gds_forma_pago AND
                            emp.id_grupo_empresa = ?
						LEFT JOIN ic_glob_tr_forma_pago fp
							ON fp.id_forma_pago=emp.id_forma_pago
						LEFT JOIN ic_gds_tc_forma_pago  gdscatfp
							ON gdsfp.cve_forma_pago_gds = gdscatfp.cve_forma_pago_gds
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=emp.id_usuario
						WHERE userint.id_grupo_empresa = ? ',
							lo_cve_gds,
							lo_cve_forma_pago,
							lo_forma_pago_gds,
							lo_tarjeta_gds,
                            lo_consulta_gral
						);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa, @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
