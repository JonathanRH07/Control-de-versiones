DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_negocio_f`(
	IN  pr_id_grupo_empresa			INT,
    IN  pr_id_unidad_negocio		INT,
    IN  pr_cve_unidad_negocio		VARCHAR(45),
    IN  pr_desc_unidad_negocio		VARCHAR(45),
	IN  pr_estatus_unidad_negocio	ENUM('ACTIVO', 'INACTIVO','TODOS'),
    IN  pr_consulta_gral			VARCHAR(100),
    IN  pr_ini_pag 					INT,
    IN  pr_fin_pag 					INT,
    IN  pr_order_by					VARCHAR(30),
    OUT pr_rows_tot_table  			INT,
    OUT pr_message 					VARCHAR(500))
BEGIN
/*
    @nombre:		sp_cat_unidad_negocio_c
	@fecha:			28/11/2016
	@descripción : 	SP para consultar registros de catalogo unidad de negocio.
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_id_unidad_negocio 		VARCHAR(100) DEFAULT '';
    DECLARE lo_estatus_unidad_negocio	VARCHAR(100) DEFAULT '';
    DECLARE lo_cve_unidad_negocio 		VARCHAR(200) DEFAULT '';
	DECLARE lo_desc_unidad_negocio 		VARCHAR(200) DEFAULT '';
    DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_consulta_gral  			VARCHAR(2000) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_unidad_negocio_c';
	END ;

    IF pr_id_unidad_negocio > 0 THEN
		SET lo_id_unidad_negocio = CONCAT(' AND id_unidad_negocio =  ', pr_id_unidad_negocio);
    END IF;

	IF pr_cve_unidad_negocio != '' THEN
		SET lo_cve_unidad_negocio = CONCAT(' AND cve_unidad_negocio LIKE "%', pr_cve_unidad_negocio, '%" ');
	END IF;

	IF pr_desc_unidad_negocio != '' THEN
		SET lo_desc_unidad_negocio= CONCAT(' AND desc_unidad_negocio LIKE "%', pr_desc_unidad_negocio, '%" ');
	END IF;

	IF (pr_estatus_unidad_negocio !='' AND pr_estatus_unidad_negocio !='TODOS' ) THEN
			SET lo_estatus_unidad_negocio = CONCAT(' AND estatus_unidad_negocio = "', pr_estatus_unidad_negocio, '" ');
	END IF;

    IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (uni_negocio.cve_unidad_negocio LIKE "%'		, pr_consulta_gral, '%"
											OR uni_negocio.desc_unidad_negocio LIKE "%'		, pr_consulta_gral, '%"
                                            OR uni_negocio.estatus_unidad_negocio LIKE "%'	, pr_consulta_gral, '%"   ) ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    SET @query = CONCAT('SELECT
							id_unidad_negocio,
							cve_unidad_negocio,
							desc_unidad_negocio,
							estatus_unidad_negocio,
							uni_negocio.fecha_mod_unidad_negocio fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM
							ic_cat_tc_unidad_negocio uni_negocio
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=uni_negocio.id_usuario
						WHERE uni_negocio.id_grupo_empresa = ?',
							lo_id_unidad_negocio,
							lo_estatus_unidad_negocio,
							lo_cve_unidad_negocio,
							lo_desc_unidad_negocio,
                            lo_consulta_gral,
							lo_order_by,
							' LIMIT ?,?');

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
						ic_cat_tc_unidad_negocio uni_negocio
					INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario=uni_negocio.id_usuario
					WHERE uni_negocio.id_grupo_empresa = ?',
						lo_id_unidad_negocio,
						lo_estatus_unidad_negocio,
						lo_cve_unidad_negocio,
						lo_desc_unidad_negocio,
                        lo_consulta_gral);

	PREPARE stmt
		FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
     # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
