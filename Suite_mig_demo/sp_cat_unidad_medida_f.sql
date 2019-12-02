DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_medida_f`(IN  pr_id_grupo_empresa         INT,
	IN	pr_id_unidad_medida			INT,
    IN	pr_cve_unidad_medida		CHAR(10),
    IN  pr_descripcion 				VARCHAR(90),
    IN  pr_c_ClaveUnidad      		CHAR(3),
	IN  pr_estatus					ENUM('ACTIVO', 'INACTIVO','TODOS'),
    IN  pr_consulta_gral			VARCHAR(100),
    IN  pr_ini_pag 					INT,
    IN  pr_fin_pag 					INT,
    IN  pr_order_by					VARCHAR(30),
    OUT pr_rows_tot_table  			INT,
    OUT pr_message 					VARCHAR(500))
BEGIN
/*
    @nombre:		sp_cat_unidad_medida_f
	@fecha:			12/07/2017
	@descripción : 	SP para consultar registros de catalogo unidad de medida
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_cve_unidad_medida 	VARCHAR(100) DEFAULT '';
    DECLARE lo_id_unidad_medida		VARCHAR(100) DEFAULT '';
    DECLARE lo_descripcion			VARCHAR(100) DEFAULT '';
    DECLARE lo_c_ClaveUnidad		VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus 				VARCHAR(200) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(200) DEFAULT '';
    DECLARE lo_consulta_gral		VARCHAR(500) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_unidad_medida_f';
	END ;

	IF pr_cve_unidad_medida != '' THEN
		SET lo_cve_unidad_medida = CONCAT(' AND cve_unidad_medida LIKE "%', pr_cve_unidad_medida, '%" ');
	END IF;

    IF pr_id_unidad_medida > 0 THEN
		SET lo_id_unidad_medida = CONCAT(' AND id_unidad_medida LIKE "%', pr_id_unidad_medida, '%" ');
	END IF;

    IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT(' AND uni_med.descripcion LIKE "%', pr_descripcion, '%" ');
	END IF;


	IF pr_c_ClaveUnidad != '' THEN
		SET lo_c_ClaveUnidad = CONCAT(' AND concat(uni_med.c_ClaveUnidad,"-",nombre) LIKE "%', pr_c_ClaveUnidad, '%" ');
	END IF;


	IF (pr_estatus !='' AND pr_estatus !='TODOS' ) THEN
		SET lo_estatus = CONCAT(' AND estatus = "', pr_estatus, '" ');
	END IF;

    IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (cve_unidad_medida LIKE "%'									, pr_consulta_gral, '%"
											OR uni_med.descripcion LIKE "%'								, pr_consulta_gral, '%"
                                            OR concat(uni_med.c_ClaveUnidad,"-",nombre) LIKE "%'		, pr_consulta_gral, '%"
                                            OR estatus LIKE "%'											, pr_consulta_gral, '%"   ) ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    SET @query = CONCAT('SELECT
                            id_unidad_medida,
							cve_unidad_medida,
							uni_med.descripcion,
							concat(uni_med.c_ClaveUnidad,"-",nombre) c_grid_ClaveUnidad,
                            uni_med.c_ClaveUnidad c_ClaveUnidad,
                            nombre,
                            sat_unidades_medida.descripcion desc_sat,
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
						WHERE uni_med.id_grupo_empresa = ?',
								lo_cve_unidad_medida,
                                lo_id_unidad_medida,
								lo_descripcion,
								lo_c_ClaveUnidad,
								lo_estatus,
                                lo_consulta_gral,
								lo_order_by,
								' LIMIT ?,?');

	PREPARE stmt
	FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	#SELECT @query;

    EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;

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
					WHERE uni_med.id_grupo_empresa = ?',
						lo_cve_unidad_medida,
						lo_descripcion,
						lo_c_ClaveUnidad,
                        lo_consulta_gral,
						lo_estatus);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

    SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
