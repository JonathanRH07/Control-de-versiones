DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_serie_b`(
	IN  pr_id_grupo_empresa			INT(11),
	IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
	OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_cat_serie_b
	@fecha: 		28/11/2016
	@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo series.
	@autor: 		Griselda Medina Medina
	@cambios:
*/
		DECLARE lo_consulta_gral  			VARCHAR(2000) DEFAULT '';
		DECLARE lo_estatus					VARCHAR(200) DEFAULT '';
		DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
		DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET pr_message = 'ERROR store sp_cat_serie_c';
		END;

        # Busqueda General
		# Realiza la Buqueda en qualquier campo por texto o carácter Alfanumérico
		IF ( pr_consulta_gral !='' ) THEN
			SET lo_consulta_gral = CONCAT(' AND (serie.cve_serie  LIKE "%'					, pr_consulta_gral, '%"
											OR serie.descripcion_serie LIKE "%'				, pr_consulta_gral, '%"
                                            OR tipdoc.descripcion_tipo_doc LIKE "%'			, pr_consulta_gral, '%"
                                            OR tip_serie.descripcion_tipo_serie LIKE "%'	, pr_consulta_gral, '%"
                                            OR suc.nombre LIKE "%'							, pr_consulta_gral, '%"
                                            OR serie.estatus_serie LIKE "%'					, pr_consulta_gral, '%" ) '
			);
		ELSE
			SET lo_first_select = ' AND serie.estatus_serie = "ACTIVO" ';
		END IF;


		IF pr_order_by > '' THEN
			SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
		END IF;

		SET @query = CONCAT('
								SELECT
									serie.id_serie,
									serie.id_usuario_solicita,
									serie.cve_tipo_doc,
									serie.cve_serie,
									serie.cve_tipo_serie,
									serie.descripcion_serie,
									tipdoc.descripcion_tipo_doc AS descripcion_tipo_doc,
									tip_serie.descripcion_tipo_serie AS descripcion_tipo_serie,
									suc.id_sucursal,
									suc.nombre,
									serie.id_moneda,
									serie.id_revisado_por,
									serie.id_autorizado_por,
									serie.folio_serie,
									serie.copias_serie,
									serie.estatus_serie,
									serie.no_max_ren_serie,
									serie.factura_xcta_terceros,
									serie.id_usuario usuario_mod,
									serie. electronica_serie,
									CONCAT(usuario.nombre_usuario," ",usuario.paterno_usuario) AS usuario_mod,
									serie.fecha_mod_serie AS fecha_mod,
									serie.tipo_formato
								FROM ic_cat_tr_serie as serie
								INNER JOIN ic_cat_tr_tipo_doc  as tipdoc
									ON tipdoc.cve_tipo_doc= serie.cve_tipo_doc
								INNER JOIN ic_cat_tc_tipo_serie as tip_serie
									ON tip_serie.cve_tipo_serie= serie.cve_tipo_serie
								INNER JOIN ic_cat_tr_sucursal as suc
									ON suc.id_sucursal= serie.id_sucursal
								INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
									ON usuario.id_usuario=serie.id_usuario
								WHERE
									suc.estatus="ACTIVO"
								AND
									serie.id_grupo_empresa = ? '
									,lo_first_select
									,lo_consulta_gral
									,lo_order_by
									,'LIMIT ?,?'
		);
		PREPARE stmt FROM @query;
		SET @id_grupo_empresa = pr_id_grupo_empresa;
		SET @ini = pr_ini_pag;
		SET @fin = pr_fin_pag;
		EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
		DEALLOCATE PREPARE stmt;

		#END main query

		# START count rows query
		SET @pr_rows_tot_table = '';
		SET @queryTotalRows = CONCAT('
										SELECT
											COUNT(*)
											INTO
											@pr_rows_tot_table
										FROM ic_cat_tr_serie as serie
										INNER JOIN ic_cat_tr_tipo_doc  as tipdoc
											ON tipdoc.cve_tipo_doc= serie.cve_tipo_doc
										INNER JOIN ic_cat_tc_tipo_serie as tip_serie
											ON tip_serie.cve_tipo_serie= serie.cve_tipo_serie
										INNER JOIN ic_cat_tr_sucursal as suc
											ON suc.id_sucursal= serie.id_sucursal
										INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
											ON usuario.id_usuario=serie.id_usuario
										WHERE
											suc.estatus="ACTIVO"
										AND
											serie.id_grupo_empresa = ? '
											,lo_first_select
											,lo_consulta_gral
											);
		PREPARE stmt FROM @queryTotalRows;
		EXECUTE stmt USING @id_grupo_empresa;
		DEALLOCATE PREPARE stmt;

		# Mensaje de ejecución.
		SET pr_rows_tot_table = @pr_rows_tot_table;
		SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
