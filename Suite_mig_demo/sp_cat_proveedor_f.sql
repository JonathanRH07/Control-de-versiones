DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_f`(
	IN  pr_id_grupo_empresa			INT,
	IN  pr_cve_proveedor			VARCHAR(45),
    IN  pr_razon_social				VARCHAR(255),
	IN  pr_nombre_comercial			VARCHAR(255),
    IN  pr_id_tipo_proveedor		INT,
    IN  pr_tipo_proveedor_operacion	ENUM('INGRESO', 'EGRESO', 'AMBOS'),
    IN  pr_estatus					ENUM('ACTIVO', 'INACTIVO', 'TODOS'),
	IN  pr_ini_pag					INT,
	IN  pr_fin_pag					INT,
	IN  pr_order_by					VARCHAR(45),
    IN	pr_consulta_gral 			VARCHAR(200),
	OUT pr_affect_rows				INT,
	OUT pr_message					VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_proveedor_f
		@fecha:			05/01/2017
		@descripcion:	SP para consultar filtrar registros en sucursal.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE  lo_cve_proveedor				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_razon_social				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nombre_comercial			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_id_tipo_proveedor			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_tipo_proveedor_operacion	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_estatus						VARCHAR(1000) DEFAULT '';
    DECLARE  lo_num_interior            	VARCHAR(1000) DEFAULT '';
    DECLARE  lo_order_by					VARCHAR(1000) DEFAULT '';
    DECLARE  lo_consulta_gral				VARCHAR(1000) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION

   	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_f';
	END ;

	IF pr_cve_proveedor != '' THEN
		SET lo_cve_proveedor = CONCAT(' AND prov.cve_proveedor   LIKE  "%', pr_cve_proveedor  , '%" ');
	END IF;

    IF pr_razon_social != '' THEN
		SET lo_razon_social = CONCAT(' AND prov.razon_social   LIKE  "%', pr_razon_social  , '%" ');
	END IF;

    IF pr_nombre_comercial != '' THEN
		SET lo_nombre_comercial = CONCAT(' AND prov.nombre_comercial  LIKE  "%', pr_nombre_comercial  , '%" ');
	END IF;

  	IF pr_id_tipo_proveedor  > 0 THEN
		SET lo_id_tipo_proveedor  = CONCAT(' AND prov.id_tipo_proveedor  =  ', pr_id_tipo_proveedor);
    END IF;

	IF pr_tipo_proveedor_operacion  != '' THEN
		SET lo_tipo_proveedor_operacion  = CONCAT(' AND prov.tipo_proveedor_operacion  =  "', pr_tipo_proveedor_operacion,'"');
    END IF;

	IF (pr_estatus != '' AND pr_estatus != 'TODOS')THEN
		SET lo_estatus  = CONCAT(' AND prov.estatus  = "', pr_estatus  ,'"');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND ( prov.cve_proveedor LIKE "%'			, pr_consulta_gral, '%"
											OR prov.razon_social LIKE "%'			, pr_consulta_gral, '%"
											OR prov.nombre_comercial LIKE "%'		, pr_consulta_gral, '%"
											OR tip_prov.desc_tipo_proveedor LIKE "%'	, pr_consulta_gral, '%"
											OR prov.tipo_proveedor_operacion  LIKE "%'				, pr_consulta_gral, '%"
											OR prov.estatus LIKE "%'				, pr_consulta_gral, '%"  )'
										);
	END IF;

	SET @query = CONCAT('
			SELECT
				 prov.id_proveedor
				,prov.id_tipo_proveedor
				,prov.id_direccion
				,prov.id_sucursal
                ,prov.id_sat_tipo_tercero
				,prov.id_sat_tipo_operacion
                ,prov.cve_proveedor
				,prov.tipo_proveedor_operacion
				,prov.tipo_persona
				,prov.rfc
				,prov.razon_social
				,prov.nombre_comercial
				,prov.email
				,prov.porcentaje_prorrateo
				,prov.estatus
                ,prov.fecha_mod
                ,(SELECT CASE WHEN prov.email = "null" THEN "" ELSE prov.email END) email
				,(SELECT CASE WHEN prov.concepto_pago = "null" THEN "" ELSE prov.concepto_pago END) concepto_pago
                ,(SELECT CASE WHEN prov.telefono = "null" THEN "" ELSE prov.telefono END) telefono
                ,tip_prov.cve_tipo_proveedor
                ,CONCAT("GTIPPROV.",tip_prov.cve_tipo_proveedor) as etiqueta_tipprov
				,conf.inventario
				-- ,conf.linea_aerea
				,conf.ctrl_comisiones
				,conf.no_contab_comision
				,(SELECT CASE WHEN conf.num_dias_credito = 0 THEN "" ELSE conf.num_dias_credito END) num_dias_credito
                ,tip_ope.origen
				,dir.cve_pais
				,dir.codigo_postal
                ,CONCAT(usuario.nombre_usuario," ",usuario.paterno_usuario) usuario_mod
                ,tip_prov.desc_tipo_proveedor
			FROM ic_cat_tr_proveedor prov
			INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
				ON usuario.id_usuario=prov.id_usuario
			INNER JOIN ct_glob_tc_direccion dir
				ON dir.id_direccion= prov.id_direccion
			LEFT JOIN ic_glob_tc_tipo_ope_sat tip_ope
				ON tip_ope.id_sat_tipo_operacion= prov.id_sat_tipo_operacion
			LEFT JOIN ic_cat_tc_tipo_proveedor tip_prov
				ON tip_prov.id_tipo_proveedor= prov.id_tipo_proveedor
			LEFT JOIN ic_cat_tr_proveedor_conf conf
				ON conf.id_proveedor=prov.id_proveedor
			WHERE
				prov.id_grupo_empresa = ? ',
				lo_cve_proveedor,
				lo_razon_social,
				lo_nombre_comercial,
				lo_id_tipo_proveedor,
				lo_tipo_proveedor_operacion,
				lo_estatus,
				lo_consulta_gral,
				lo_order_by,

			'LIMIT ?,?'
	);
	PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;


	# START count rows query
	SET @pr_affect_rows = '';
	SET @queryTotalRows = CONCAT('
				SELECT
					COUNT(*)
				INTO
					@pr_affect_rows
				FROM ic_cat_tr_proveedor prov
				INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
					ON usuario.id_usuario=prov.id_usuario
				INNER JOIN ct_glob_tc_direccion dir
					ON dir.id_direccion= prov.id_direccion
				LEFT JOIN ic_glob_tc_tipo_ope_sat tip_ope
					ON tip_ope.id_sat_tipo_operacion= prov.id_sat_tipo_operacion
				INNER JOIN ic_cat_tc_tipo_proveedor tip_prov
					ON tip_prov.id_tipo_proveedor= prov.id_tipo_proveedor
				LEFT JOIN ic_cat_tr_proveedor_conf conf
					ON conf.id_proveedor=prov.id_proveedor
				WHERE prov.id_grupo_empresa =  ? ',
					lo_cve_proveedor,
					lo_razon_social,
					lo_nombre_comercial,
					lo_id_tipo_proveedor,
					lo_tipo_proveedor_operacion,
					lo_estatus,
                    lo_consulta_gral
	);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;


	SET pr_affect_rows	= @pr_affect_rows;
	SET pr_message 		= 'SUCCESS';
END$$
DELIMITER ;
