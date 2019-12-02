DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_grupo_fit_b`(
	IN  pr_id_grupo_empresa			INT(11),
	IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
	OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_grupo_fit_b
		@fecha:			02/12/2016
		@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo grupo_fit.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_consulta_gral  			VARCHAR(2000) DEFAULT '';
	DECLARE lo_estatus_grupo_fit		VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
	DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

    BEGIN
        SET pr_message = 'ERROR store sp_cat_grupo_fit_b';
	END ;

	IF ( pr_consulta_gral !='' ) THEN
			SET lo_consulta_gral = CONCAT(' AND (grupo_f.cve_codigo_grupo  LIKE "%'	, pr_consulta_gral, '%"
											OR grupo_f.desc_grupo_fit LIKE "%'		, pr_consulta_gral, '%"
                                            OR grupo_f.fecha_ini_grupo_fit LIKE "%'	, pr_consulta_gral, '%"
                                            OR grupo_f.fecha_fin_grupo_fit LIKE "%'	, pr_consulta_gral, '%"
                                            OR grupo_f.estatus_grupo_fit LIKE "%'	, pr_consulta_gral, '%" ) ');

	ELSE
		SET lo_first_select = ' AND grupo_f.estatus_grupo_fit = "ACTIVO" ';
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
							usuario.paterno_usuario) usuario_mod
						FROM ic_fac_tc_grupo_fit grupo_f
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=grupo_f.id_usuario
						WHERE grupo_f.id_grupo_empresa = ?'
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



    # START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('	SELECT
										COUNT(*)
									INTO
										@pr_rows_tot_table
									FROM
										ic_fac_tc_grupo_fit grupo_f
									INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
										ON usuario.id_usuario=grupo_f.id_usuario
									WHERE grupo_f.id_grupo_empresa = ?'
									,lo_first_select
									,lo_consulta_gral
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;

    # Mensaje de ejecucion.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
