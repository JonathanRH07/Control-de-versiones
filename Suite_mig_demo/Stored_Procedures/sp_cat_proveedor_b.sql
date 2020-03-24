DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			CHAR(30),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_cat_proveedor_b
		@fecha:			28/11/2016
		@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo sucursal.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_estatus					VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_b';
	END ;


	IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND ( prov.cve_proveedor LIKE "%'			, pr_consulta_gral, '%"
											OR prov.razon_social LIKE "%'			, pr_consulta_gral, '%"
											OR prov.nombre_comercial LIKE "%'		, pr_consulta_gral, '%"
											OR tip_prov.cve_tipo_proveedor LIKE "%'	, pr_consulta_gral, '%"
											OR tip_ope.origen LIKE "%'				, pr_consulta_gral, '%"
											OR prov.estatus LIKE "%'				, pr_consulta_gral, '%"  )'
										);
	ELSE
		SET lo_first_select = ' AND prov.estatus = "ACTIVO" ';
    END IF;

    # Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('
			SELECT
				prov.id_proveedor,
				prov.id_tipo_proveedor,
                prov.id_direccion,
				prov.id_sucursal,
                prov.id_sat_tipo_tercero,
				prov.id_sat_tipo_operacion,
                prov.cve_proveedor,
				prov.tipo_proveedor_operacion,
				prov.tipo_persona,
				prov.rfc,
				prov.razon_social,
				prov.nombre_comercial,
                prov.email,
                prov.porcentaje_prorrateo,
				prov.estatus,
                prov.fecha_mod,
                (SELECT CASE WHEN prov.telefono = "null" THEN "" ELSE prov.telefono END) telefono,
				(SELECT CASE WHEN prov.email = "null" THEN "" ELSE prov.email END) email,
				(SELECT CASE WHEN prov.concepto_pago = "null" THEN "" ELSE prov.concepto_pago END) concepto_pago,
                tip_prov.cve_tipo_proveedor,
                CONCAT("GTIPPROV.",tip_prov.cve_tipo_proveedor) as etiqueta_tipprov,
				conf.inventario,
				conf.ctrl_comisiones,
				conf.no_contab_comision,
				(SELECT CASE WHEN conf.num_dias_credito = 0 THEN "" ELSE conf.num_dias_credito END) num_dias_credito,
				tip_ope.origen,
				dir.cve_pais,
				dir.codigo_postal,
				concat(usuario.nombre_usuario," ",usuario.paterno_usuario) usuario_mod
			FROM ic_cat_tr_proveedor prov
			INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
				ON usuario.id_usuario=prov.id_usuario
			INNER JOIN ct_glob_tc_direccion dir
				ON dir.id_direccion= prov.id_direccion
			LEFT JOIN ic_glob_tc_tipo_ope_sat tip_ope
				ON tip_ope.id_sat_tipo_operacion= prov.id_sat_tipo_operacion
			INNER JOIN ic_cat_tc_tipo_proveedor tip_prov
				ON tip_prov.id_tipo_proveedor= prov.id_tipo_proveedor
			INNER JOIN ic_cat_tr_proveedor_conf conf
				ON conf.id_proveedor=prov.id_proveedor
			WHERE
				prov.id_grupo_empresa =  ? '
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

	-- SELECT @query FROM DUAL;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
			SELECT
				COUNT(*)
			INTO @pr_rows_tot_table
			FROM
				ic_cat_tr_proveedor prov
			INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
				ON usuario.id_usuario=prov.id_usuario
			INNER JOIN ct_glob_tc_direccion dir
				ON dir.id_direccion= prov.id_direccion
			LEFT JOIN ic_glob_tc_tipo_ope_sat tip_ope
				ON tip_ope.id_sat_tipo_operacion= prov.id_sat_tipo_operacion
			INNER JOIN ic_cat_tc_tipo_proveedor tip_prov
				ON tip_prov.id_tipo_proveedor= prov.id_tipo_proveedor
			INNER JOIN ic_cat_tr_proveedor_conf conf
				ON conf.id_proveedor=prov.id_proveedor
			WHERE prov.id_grupo_empresa =  ?  '
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
