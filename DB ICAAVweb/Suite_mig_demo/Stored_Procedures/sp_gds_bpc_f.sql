DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_bpc_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_cve_gds				CHAR(2),
	IN  pr_id_bpc				INT(11),
	IN  pr_cve_serie			CHAR(5),
	IN  pr_nombre				VARCHAR(50),
	IN  pr_bpc					VARCHAR(10),
	IN  pr_tipo_bpc				CHAR(1),
	IN  pr_estatus				ENUM('ACTIVO','INACTIVO'),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_bpc_f
	@fecha: 		04/04/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_bpc
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_id_bpc			VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_serie		VARCHAR(300) DEFAULT '';
	DECLARE lo_nombre			VARCHAR(300) DEFAULT '';
	DECLARE lo_bpc				VARCHAR(300) DEFAULT '';
	DECLARE lo_tipo_bpc			VARCHAR(300) DEFAULT '';
	DECLARE lo_estatus			VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_gds			VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  	VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_bpc_f';
	END ;

	IF pr_id_bpc > 0 THEN
		SET lo_id_bpc = CONCAT(' AND ic_gds_tr_bpc.id_bpc LIKE "%', pr_id_bpc, '%" ');
	END IF;

	IF pr_cve_serie != '' THEN
		SET lo_cve_serie = CONCAT(' AND ic_cat_tr_serie.cve_serie LIKE "%', pr_cve_serie, '%" ');
	END IF;

    IF pr_nombre !='' THEN
		SET lo_nombre = CONCAT(' AND ic_cat_tr_sucursal.nombre LIKE "%', pr_nombre, '%" ');
    END IF;

	IF pr_bpc != '' THEN
		SET lo_bpc = CONCAT(' AND ic_gds_tr_bpc.bpc LIKE "%', pr_bpc, '%" ');
	END IF;

    IF pr_tipo_bpc != '' THEN
		SET lo_tipo_bpc = CONCAT(' AND ic_gds_tr_bpc.tipo_bpc LIKE "%', pr_tipo_bpc, '%" ');
	END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT(' AND ic_gds_tr_bpc.estatus = "', pr_estatus, '" ');
	END IF;

	IF pr_cve_gds != '' THEN
		SET lo_cve_gds = CONCAT(' AND ic_gds_tr_bpc.cve_gds LIKE "%', pr_cve_gds, '%" ');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (ic_cat_tr_serie.cve_serie LIKE "%'	, pr_consulta_gral, '%"
										OR ic_cat_tr_sucursal.nombre LIKE "%'	, pr_consulta_gral, '%"
                                        OR gds.nombre LIKE "%'	, pr_consulta_gral, '%"
										OR ic_gds_tr_bpc.bpc LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

	SET @query = CONCAT('Select
							ic_gds_tr_bpc.id_bpc,
							ic_gds_tr_bpc.id_serie,
							ic_cat_tr_serie.cve_serie,
                            ic_cat_tr_serie.descripcion_serie,
							ic_gds_tr_bpc.id_grupo_empresa,
							ic_gds_tr_bpc.imprime,
							ic_gds_tr_bpc.cve_gds,
							ic_cat_tr_sucursal.id_sucursal,
							ic_cat_tr_sucursal.cve_sucursal,
							ic_cat_tr_sucursal.nombre,
							ic_gds_tr_bpc.tipo_bpc,
							ic_gds_tr_bpc.bpc_consolid,
							ic_gds_tr_bpc.bpc,
                            ic_gds_tr_bpc.estatus,
                            IF(ic_gds_tr_bpc.tipo_bpc="R","RESERVA","BOLETEA") nombre_tipo_bpc,
                            CONCAT(st_adm_tr_usuario.nombre_usuario," ",st_adm_tr_usuario.paterno_usuario) usuario_mod,
                            ic_gds_tr_bpc.fecha_mod,
                            gds.nombre as nombre_gds
						FROM ic_gds_tr_bpc
                        JOIN ic_cat_tc_gds gds ON
							gds.cve_gds = ic_gds_tr_bpc.cve_gds
						INNER JOIN suite_mig_conf.st_adm_tr_usuario_interfase userint ON
							userint.cve_gds = ic_gds_tr_bpc.cve_gds AND userint.id_grupo_empresa = ?
						INNER JOIN ic_cat_tr_serie
							ON ic_cat_tr_serie.id_serie=ic_gds_tr_bpc.id_serie
						INNER JOIN ic_cat_tr_sucursal
							ON ic_cat_tr_sucursal.id_sucursal=ic_cat_tr_serie.id_sucursal
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario ON
							 st_adm_tr_usuario.id_usuario = ic_gds_tr_bpc.id_usuario
						WHERE ic_gds_tr_bpc.id_grupo_empresa = ? AND userint.estatus = "ACTIVO" ',
							lo_id_bpc,
							lo_cve_serie,
							lo_nombre,
							lo_bpc,
							lo_tipo_bpc,
                            lo_estatus,
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
					FROM ic_gds_tr_bpc
                        JOIN ic_cat_tc_gds gds ON
							gds.cve_gds = ic_gds_tr_bpc.cve_gds
						INNER JOIN suite_mig_conf.st_adm_tr_usuario_interfase userint ON
							userint.cve_gds = ic_gds_tr_bpc.cve_gds AND userint.id_grupo_empresa = ?
						INNER JOIN ic_cat_tr_serie
							ON ic_cat_tr_serie.id_serie=ic_gds_tr_bpc.id_serie
						INNER JOIN ic_cat_tr_sucursal
							ON ic_cat_tr_sucursal.id_sucursal=ic_cat_tr_serie.id_sucursal
						LEFT JOIN suite_mig_conf.st_adm_tr_usuario ON
							 st_adm_tr_usuario.id_usuario = ic_gds_tr_bpc.id_usuario
						WHERE ic_gds_tr_bpc.id_grupo_empresa = ?',
						lo_id_bpc,
						lo_cve_serie,
						lo_nombre,
						lo_bpc,
						lo_tipo_bpc,
						lo_estatus,
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
