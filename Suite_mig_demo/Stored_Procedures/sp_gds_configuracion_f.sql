DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_configuracion_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_cve_gds				CHAR(2),
	IN  pr_lencli				INT(11),
	IN  pr_desc_bolint			VARCHAR(50),
	IN  pr_desc_bolnac			VARCHAR(50),
	IN  pr_cve_noneda_nac		VARCHAR(50),
	IN  pr_cve_moneda_int		VARCHAR(50),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_configuracion_f
	@fecha: 		30/08/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_configuracion
	@autor:  		Yazbek Kido
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_lencli			VARCHAR(300) DEFAULT '';
	DECLARE lo_desc_bolint		VARCHAR(300) DEFAULT '';
	DECLARE lo_desc_bolnac		VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_noneda_nac	VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_moneda_int	VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_gds			VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  	VARCHAR(1000) DEFAULT '';

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_configuracion_f';
	END ;*/

	IF pr_lencli > 0 THEN
		SET lo_lencli = CONCAT(' AND conf.lencli = ', pr_lencli, ' ');
	END IF;

	IF pr_desc_bolint != '' THEN
		SET lo_desc_bolint = CONCAT(' AND serint.descripcion LIKE "%', pr_desc_bolint, '%" ');
	END IF;

    IF pr_desc_bolnac !='' THEN
		SET lo_desc_bolnac = CONCAT(' AND sernac.descripcion LIKE "%', pr_desc_bolnac, '%" ');
    END IF;

	IF pr_cve_noneda_nac != '' THEN
		SET lo_cve_noneda_nac = CONCAT(' AND monnac.clave_moneda LIKE "%', pr_cve_noneda_nac, '%" ');
	END IF;

    IF pr_cve_moneda_int != '' THEN
		SET lo_cve_moneda_int = CONCAT(' AND monint.clave_moneda LIKE "%', pr_cve_moneda_int, '%" ');
	END IF;

	IF pr_cve_gds != '' THEN
		SET lo_cve_gds = CONCAT(' AND conf.cve_gds LIKE "%', pr_cve_gds, '%" ');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (sernac.descripcion LIKE "%'	, pr_consulta_gral, '%"
										OR serint.descripcion LIKE "%'	, pr_consulta_gral, '%"
                                        OR monnac.clave_moneda LIKE "%'	, pr_consulta_gral, '%"
                                        OR monint.clave_moneda LIKE "%'	, pr_consulta_gral, '%"
                                        OR gds.nombre LIKE "%'	, pr_consulta_gral, '%"
										OR conf.lencli LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

	SET @query = CONCAT('Select
							conf.id_gds_configuracion,
                            conf.cve_gds,
                            conf.id_moneda_nac,
                            conf.id_moneda_int,
                            conf.id_moneda_lowcost_nac,
                            conf.id_moneda_lowcost_int,
                            conf.id_tipser_bolint,
                            conf.id_tipser_bolnac,
                            conf.id_tipser_lowcost_int,
                            conf.id_tipser_lowcost,
                            conf.boleto_lowcost_inicial,
                            conf.lencli,
                            conf.finpnr,
                            conf.separa,
                            conf.dec_lowcost,
                            gds.nombre as nombre_gds,
                            sernac.descripcion desc_bolnac,
                            serint.descripcion desc_bolint,
                            sernac.cve_servicio cve_bolnac,
                            serint.cve_servicio cve_bolint,
                            monnac.clave_moneda cve_moneda_nac,
                            monint.clave_moneda cve_moneda_int,
                            sernac_lowcost.descripcion desc_lowcost,
                            serint_lowcost.descripcion desc_lowcost_int,
                            sernac_lowcost.cve_servicio cve_lowcost,
                            serint_lowcost.cve_servicio cve_lowcost_int,

                            conf.fecha_mod fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM ic_gds_tr_configuracion conf
                        INNER JOIN suite_mig_conf.st_adm_tr_usuario_interfase userint ON
							userint.cve_gds = conf.cve_gds AND userint.id_grupo_empresa = ?
                        JOIN ic_cat_tc_gds gds ON
							gds.cve_gds = conf.cve_gds
						LEFT JOIN ic_cat_tc_servicio sernac
							ON sernac.id_servicio=conf.id_tipser_bolnac
						LEFT JOIN ic_cat_tc_servicio serint
							ON serint.id_servicio=conf.id_tipser_bolint
						LEFT JOIN ic_cat_tc_servicio sernac_lowcost
							ON sernac_lowcost.id_servicio=conf.id_tipser_lowcost
						LEFT JOIN ic_cat_tc_servicio serint_lowcost
							ON serint_lowcost.id_servicio=conf.id_tipser_lowcost_int
						LEFT JOIN ct_glob_tc_moneda monnac
							ON monnac.id_moneda=conf.id_moneda_nac
						LEFT JOIN ct_glob_tc_moneda monint
							ON monint.id_moneda=conf.id_moneda_int
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=conf.id_usuario
						WHERE conf.id_grupo_empresa = ?',
							lo_lencli,
							lo_desc_bolint,
							lo_desc_bolnac,
							lo_cve_noneda_nac,
							lo_cve_moneda_int,
                            lo_cve_gds,
							lo_consulta_gral,
							lo_order_by,
						   ' LIMIT ?,?');
-- select @query;
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
					FROM ic_gds_tr_configuracion conf
						INNER JOIN suite_mig_conf.st_adm_tr_usuario_interfase userint ON
							userint.cve_gds = conf.cve_gds AND userint.id_grupo_empresa = ?
                        JOIN ic_cat_tc_gds gds ON
							gds.cve_gds = conf.cve_gds
						LEFT JOIN ic_cat_tc_servicio sernac
							ON sernac.id_servicio=conf.id_tipser_bolnac
						LEFT JOIN ic_cat_tc_servicio serint
							ON serint.id_servicio=conf.id_tipser_bolint
						LEFT JOIN ct_glob_tc_moneda monnac
							ON monnac.id_moneda=conf.id_moneda_nac
						LEFT JOIN ct_glob_tc_moneda monint
							ON monint.id_moneda=conf.id_moneda_int
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=conf.id_usuario
						WHERE conf.id_grupo_empresa = ?',
							lo_lencli,
							lo_desc_bolint,
							lo_desc_bolnac,
							lo_cve_noneda_nac,
							lo_cve_moneda_int,
                            lo_cve_gds,
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
