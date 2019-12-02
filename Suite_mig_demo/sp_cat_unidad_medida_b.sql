DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_medida_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			CHAR(30),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
    @nombre: 		sp_cat_unidad_medida_u
	@fecha: 		12/07/2017
	@descripcion: 	SP para buscar registros en la tabla unidades_medida
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_consulta_gral			VARCHAR(500) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_unidad_medida_u';
	END ;

	IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (cve_unidad_medida LIKE "%'									, pr_consulta_gral, '%"
											OR uni_med.descripcion LIKE "%'								, pr_consulta_gral, '%"
                                            OR concat(uni_med.c_ClaveUnidad,"-",nombre) LIKE "%'		, pr_consulta_gral, '%"
                                            OR estatus LIKE "%'											, pr_consulta_gral, '%"   ) ');
	ELSE
		SET lo_first_select = ' AND estatus = "ACTIVO" ';
    END IF;

    # Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

    SET @query = CONCAT('SELECT
                            id_unidad_medida,
							cve_unidad_medida,
							uni_med.descripcion,
							concat(uni_med.c_ClaveUnidad,"-",nombre) c_grid_ClaveUnidad,
                            uni_med.c_ClaveUnidad c_ClaveUnidad,
							estatus,
                            fecha_mod fecha_mod,
                            concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod,
							estatus
						FROM
							ic_cat_tc_unidad_medida uni_med
						INNER JOIN sat_unidades_medida
							ON sat_unidades_medida.c_ClaveUnidad=uni_med.c_ClaveUnidad
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=uni_med.id_usuario
						WHERE uni_med.id_grupo_empresa= ?'
							,lo_first_select
							,lo_consulta_gral
							,lo_order_by
							,' LIMIT ?,?');

    PREPARE stmt
		FROM @query;

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
					 FROM
						ic_cat_tc_unidad_medida uni_med
					INNER JOIN sat_unidades_medida
						ON sat_unidades_medida.c_ClaveUnidad=uni_med.c_ClaveUnidad
					INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario=uni_med.id_usuario
					WHERE uni_med.id_grupo_empresa= ?'
					,lo_first_select
					,lo_consulta_gral);

	PREPARE stmt
		FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
     # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
