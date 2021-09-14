DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_sucursal_b`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_consulta_gral		CHAR(30),
	IN  pr_ini_pag				INT(11),
	IN  pr_fin_pag				INT(11),
	IN  pr_order_by				VARCHAR(100),
	OUT pr_rows_tot_table		INT,
	OUT pr_message				VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_sucursal_b
		@fecha:			28/11/2016
		@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo sucursal.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_consulta_gral  		VARCHAR(1000) DEFAULT '';
	DECLARE lo_estatus				VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 			VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select			VARCHAR(200) DEFAULT '';
	DECLARE lo_valida_corp 			INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_cat_sucursal_b';
	END ;

	IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT('
				AND (suc.tipo LIKE "%'			, pr_consulta_gral, '%"
				OR suc.cve_sucursal LIKE "%'	, pr_consulta_gral, '%"
				OR suc.nombre LIKE "%'			, pr_consulta_gral, '%"
				OR suc.email LIKE "%'			, pr_consulta_gral, '%"
				OR suc.estatus LIKE "%'			, pr_consulta_gral, '%"
				OR suc.pertenece LIKE "%'		, pr_consulta_gral, '%" )'
		);
	ELSE
		SET lo_first_select = ' AND suc.estatus = "ACTIVO" ';
    END IF;

    # Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							suc.id_sucursal,
							suc.cve_sucursal,
							suc.nombre,
							suc.tipo,
							(SELECT CASE WHEN suc.email = "null" THEN "" ELSE suc.email END) AS email,
							suc.estatus,
							suc.id_direccion,
							suc.iata_nacional,
							suc.iata_internacional,
							suc.matriz,
							(SELECT CASE WHEN suc.telefono = "null" THEN "" ELSE suc.telefono END) AS telefono,
							suc.iva_local,
							dir.cve_pais,
							dir.codigo_postal,
							suc.fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) AS usuario_mod
						FROM ic_cat_tr_sucursal AS suc
						INNER JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
							ON usuario.id_usuario=suc.id_usuario
						INNER JOIN ct_glob_tc_direccion AS dir
							ON dir.id_direccion= suc.id_direccion
						WHERE suc.id_grupo_empresa = ? '
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
	SET @queryTotalRows = CONCAT('
			SELECT COUNT(*) INTO @pr_rows_tot_table
			FROM ic_cat_tr_sucursal AS suc
			INNER JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
				ON usuario.id_usuario=suc.id_usuario
			INNER JOIN ct_glob_tc_direccion AS dir
				ON dir.id_direccion= suc.id_direccion
			WHERE
				suc.id_grupo_empresa = ? '
				,lo_first_select
				,lo_consulta_gral
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table	= @pr_rows_tot_table;
	SET pr_message			= 'SUCCESS';
END$$
DELIMITER ;
