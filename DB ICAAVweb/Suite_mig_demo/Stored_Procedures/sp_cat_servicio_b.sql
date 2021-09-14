DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_servicio_b`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_consulta_gral		VARCHAR(200),
	IN  pr_ini_pag				INT(11),
	IN  pr_fin_pag				INT(11),
	IN  pr_order_by				VARCHAR(100),
	OUT pr_rows_tot_table		INT,
	OUT pr_message				VARCHAR(5000))
BEGIN
	/*
		@nombre: 		sp_cat_servicio_b
		@fecha: 		28/11/2016
		@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo servicios.
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_estatus					VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_servicios_cg';
	END ;

   # Busqueda General
   # Realiza la Buqueda en qualquier campo por texto o carácter Alfanumérico
    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT('
				AND (serv.cve_servicio LIKE "%'	, pr_consulta_gral, '%"
				OR serv.descripcion LIKE "%'	, pr_consulta_gral, '%"
				OR serv.alcance LIKE "%'		, pr_consulta_gral, '%"
				OR prod.descripcion LIKE "%'	, pr_consulta_gral, '%"
				OR serv.valida_adicis LIKE "%'	, pr_consulta_gral, '%"
				OR serv.estatus LIKE "%'		, pr_consulta_gral, '%" )
		');
	ELSE
		# Buqueda Inicial
		# Muestra solo los registros que esten activos
		SET lo_first_select = ' AND serv.estatus = "ACTIVO" ';
	END IF;

	# Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

    SET @query = CONCAT('
			SELECT
				serv.id_servicio,
				serv.cve_servicio,
				serv.descripcion,
				serv.alcance,
				serv.id_producto,
                serv.id_unidad_medida,
				serv.c_ClaveProdServ,
				prod.descripcion as desc_producto,
				serv.valida_adicis,
				serv.estatus,
				serv.fecha_mod,
				concat(usuario.nombre_usuario," ",usuario.paterno_usuario) AS usuario_mod,
				serv.id_unidad_medida,
                unidad.c_ClaveUnidad
			FROM ic_cat_tc_servicio AS serv
			INNER JOIN ic_cat_tc_producto  AS prod
				ON prod.id_producto= serv.id_producto
			INNER JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
				ON usuario.id_usuario=serv.id_usuario
			LEFT JOIN ic_cat_tc_unidad_medida AS unidad
				ON serv.id_unidad_medida = unidad.id_unidad_medida
			WHERE serv.id_grupo_empresa = ?'
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
			FROM ic_cat_tc_servicio AS serv
			INNER JOIN ic_cat_tc_producto  AS prod
				ON prod.id_producto= serv.id_producto
			INNER JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
				ON usuario.id_usuario=serv.id_usuario
			LEFT JOIN ic_cat_tc_unidad_medida AS unidad
				ON serv.id_unidad_medida = unidad.id_unidad_medida
			WHERE serv.id_grupo_empresa = ? '
				,lo_first_select
				,lo_consulta_gral
	);
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
