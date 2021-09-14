DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_consultar_tabla`(
	IN  pr_modulo 				VARCHAR(45),
    IN  pr_id_grupo_empresa     INT(11),
    IN  pr_cve_pais			    CHAR(3),
    OUT pr_row_count 	     	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN

	DECLARE lo_id_grupo_empresa_G	VARCHAR(100) DEFAULT '';
    DECLARE lo_id_grupo_empresa_im	VARCHAR(100) DEFAULT '';
	DECLARE lo_id_grupo_empresa_P	VARCHAR(100) DEFAULT '';
    DECLARE lo_modulo				VARCHAR(100) DEFAULT '';
    DECLARE lo_where				VARCHAR(10000) DEFAULT '';
    DECLARE lo_where_im				VARCHAR(10000) DEFAULT '';
    DECLARE lo_select				VARCHAR(10000) DEFAULT '';
    DECLARE lo_select_extra			VARCHAR(10000) DEFAULT '';
    DECLARE lo_select_extra2		VARCHAR(10000) DEFAULT '';
	DECLARE lo_select_extra3		VARCHAR(10000) DEFAULT '';
    DECLARE lo_select_extra4		VARCHAR(10000) DEFAULT '';
    DECLARE lo_select_extra5		VARCHAR(10000) DEFAULT '';
    DECLARE lo_select_extra6		VARCHAR(10000) DEFAULT '';
    DECLARE lo_select_prov 			VARCHAR(10000) DEFAULT '';
    DECLARE lo_select_fac 			VARCHAR(10000) DEFAULT '';
    DECLARE lo_order_un				VARCHAR(10000) DEFAULT '';
    DECLARE lo_order_gf				VARCHAR(10000) DEFAULT '';
    DECLARE lo_order_ov				VARCHAR(10000) DEFAULT '';
    DECLARE lo_order_sc				VARCHAR(10000) DEFAULT '';
    DECLARE lo_order_fp				VARCHAR(10000) DEFAULT '';
    DECLARE lo_order_cl				VARCHAR(10000) DEFAULT '';
    DECLARE lo_order_pc				VARCHAR(10000) DEFAULT '';
    DECLARE lo_select_inv_bol 		VARCHAR(10000) DEFAULT '';


    SET lo_id_grupo_empresa_G 	=CONCAT( ' WHERE id_grupo_empresa = ',pr_id_grupo_empresa);
    SET lo_id_grupo_empresa_im 	=CONCAT( ' WHERE cve_pais = "',pr_cve_pais,'"
											order by cve_impuesto_cat asc ');
    SET lo_order_un 			=CONCAT( '  order by cve_unidad_negocio asc');
    SET lo_order_gf				=CONCAT( '  order by cve_codigo_grupo asc');
    SET lo_order_ov				=CONCAT( '  order by cve asc');
    SET lo_order_sc				=CONCAT( '  order by cve_sucursal asc');
    SET lo_order_cl				=CONCAT( '  order by cve_cliente asc');
    SET lo_order_fp				=CONCAT( '  order by cve_forma_pago asc');
    SET lo_order_pc				=CONCAT( '  order by cve_plan_comision asc');

    SET lo_id_grupo_empresa_P 	=CONCAT( ' id_grupo_empresa = ',pr_id_grupo_empresa);
    SET lo_select_extra			=CONCAT(' ic_cat_tr_vendedor.id_vendedor,
											ic_cat_tr_vendedor.id_sucursal,
											ic_cat_tr_sucursal.nombre as nom_sucursal,
											ic_cat_tr_vendedor.clave,
											ic_cat_tr_vendedor.nombre,
											ic_cat_tr_vendedor.email,
											ic_cat_tr_vendedor.id_comision,
                                            plan_c.cve_plan_comision cve,
											ic_cat_tr_vendedor.id_comision_aux,
											plan_c2.cve_plan_comision cve2,
											ic_cat_tr_vendedor.estatus');

	SET lo_select_extra2		=CONCAT(' serv.id_servicio,
											serv.cve_servicio,
											serv.descripcion,
											serv.alcance,
											serv.id_producto,
											prod.descripcion as desc_producto,
											serv.valida_adicis,
											serv.unidad_clave_sat,
											serv.estatus ');

	SET lo_select_extra3		=CONCAT(' usuario,
											nombre_role,
											correo,
											estatus_usuario ');

	SET lo_select_extra4		=CONCAT(' nombre_role ROLE,
											st_adm_tr_submodulo.traduccion SUBMODULO,
											group_concat(st_adm_tc_tipo_permiso.traduccion SEPARATOR "|") PERMISOS ');

	SET lo_select_extra5		=CONCAT(' corp.id_corporativo,
											corp.cve_corporativo,
											corp.nom_corporativo,
											format(truncate(corp.limite_credito_corporativo,0),0) limite_credito_corporativo,
											corp.fecha_mod_corporativo fecha_mod,
											concat(usuario.nombre_usuario," ",usuario.paterno_usuario) usuario_mod,
											corp.estatus_corporativo ');

	SET lo_select_extra6		=CONCAT(' cve_unidad_medida,
											uni_med.descripcion,
											concat(uni_med.c_ClaveUnidad,"-",nombre) c_ClaveUnidad,
											estatus ');

    IF pr_modulo = 'UNM' THEN
		SET lo_modulo = 'ic_cat_tc_unidad_medida ';
        SET lo_where = lo_id_grupo_empresa_G;
    END IF;

    IF pr_modulo = 'UN' THEN
		SET lo_modulo = 'ic_cat_tc_unidad_negocio ';
        SET lo_where = lo_id_grupo_empresa_G;
    END IF;

    IF pr_modulo = 'TP' THEN
		SET lo_modulo = 'ic_cat_tc_tipo_proveedor ';
        SET lo_where = lo_id_grupo_empresa_G;
    END IF;

    IF pr_modulo = 'GF' THEN
		SET lo_modulo = 'ic_fac_tc_grupo_fit ';
        SET lo_where = lo_id_grupo_empresa_G;
    END IF;

    IF pr_modulo = 'OV' THEN
		SET lo_modulo = 'ic_cat_tr_origen_venta ';
        SET lo_where = lo_id_grupo_empresa_G;
    END IF;

    IF pr_modulo = 'FP' THEN
		SET lo_modulo = 'ic_glob_tr_forma_pago ';
        SET lo_where = lo_id_grupo_empresa_G;
    END IF;

    IF pr_modulo = 'SC' THEN
		SET lo_modulo = 'ic_cat_tr_sucursal ';
        SET lo_where = lo_id_grupo_empresa_G;
    END IF;

    IF pr_modulo = 'IM' AND pr_cve_pais !='' THEN
		SET lo_modulo = 'ic_cat_tr_impuesto ';
        SET lo_where_im = lo_id_grupo_empresa_im;
    END IF;

    IF pr_modulo = 'PC' THEN
		SET lo_modulo = 'ic_cat_tr_plan_comision ';
        SET lo_where = lo_id_grupo_empresa_G;
    END IF;

    IF pr_modulo = 'CL' THEN
		SET lo_modulo = 'ic_cat_tr_cliente ';
        SET lo_where = lo_id_grupo_empresa_G;
    END IF;

	IF pr_modulo = 'SR' THEN
		SET lo_modulo = 'ic_cat_tc_servicio serv ';
        SET lo_where =  CONCAT(' INNER JOIN ic_cat_tc_producto  AS prod ON prod.id_producto= serv.id_producto
								WHERE serv.', lo_id_grupo_empresa_P,
                                ' order by cve_servicio asc');
    END IF;

    IF pr_modulo = 'USR' THEN
		SET lo_modulo = 'suite_mig_conf.st_adm_tr_usuario';
        SET lo_where =  CONCAT(' INNER JOIN suite_mig_conf.st_adm_tc_role ON st_adm_tc_role.id_role=st_adm_tr_usuario.id_role
								WHERE st_adm_tr_usuario.', lo_id_grupo_empresa_P,
                                ' order by usuario asc');
    END IF;


    IF pr_modulo = 'RO' THEN
		SET lo_modulo = 'suite_mig_conf.st_adm_tc_role';
        SET lo_where =  CONCAT(' INNER JOIN suite_mig_conf.st_adm_tr_permiso_role
									ON st_adm_tr_permiso_role.id_role=st_adm_tc_role.id_role
								INNER JOIN suite_mig_conf.st_adm_tc_tipo_permiso
									ON st_adm_tc_tipo_permiso.id_tipo_permiso=st_adm_tr_permiso_role.id_tipo_permiso
								INNER JOIN suite_mig_conf.st_adm_tr_submodulo
									ON st_adm_tr_submodulo.id_submodulo=st_adm_tr_permiso_role.id_submodulo
								AND st_adm_tc_role.', lo_id_grupo_empresa_P,
								' GROUP BY nombre_role,nombre_submodulo
									order by nombre_role asc'
								);
    END IF;

    IF pr_modulo = 'CORP' THEN
		SET lo_modulo = 'ic_cat_tr_corporativo corp';
        SET lo_where = CONCAT(' INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
									ON usuario.id_usuario=corp.id_usuario
								WHERE corp.',lo_id_grupo_empresa_P,
                                ' order by corp.cve_corporativo asc');
    END IF;

    IF pr_modulo = 'UNM' THEN
		SET lo_modulo = 'ic_cat_tc_unidad_medida uni_med';
        SET lo_where = CONCAT(' INNER JOIN sat_unidades_medida
									ON sat_unidades_medida.c_ClaveUnidad=uni_med.c_ClaveUnidad
								WHERE ',lo_id_grupo_empresa_P,
                                ' order by cve_unidad_medida asc');
    END IF;


	IF pr_modulo = 'VE' THEN
		SET lo_modulo = 'ic_cat_tr_vendedor ';
        SET lo_where = CONCAT(' INNER JOIN ic_cat_tr_sucursal
									ON ic_cat_tr_sucursal.id_sucursal= ic_cat_tr_vendedor.id_sucursal
								INNER JOIN ic_cat_tr_plan_comision as plan_c
									ON plan_c.id_plan_comision= ic_cat_tr_vendedor.id_comision
								INNER JOIN ic_cat_tr_plan_comision plan_c2
									ON plan_c2.id_plan_comision= ic_cat_tr_vendedor.id_comision_aux
								WHERE ic_cat_tr_vendedor.', lo_id_grupo_empresa_P,
                                ' order by clave asc');
    END IF;

	IF pr_modulo = 'SE' THEN
		SET lo_modulo = 'ic_cat_tr_serie serie';
        SET lo_where = CONCAT(' INNER JOIN ic_cat_tr_tipo_doc  as tipdoc
									ON tipdoc.cve_tipo_doc= serie.cve_tipo_doc
								INNER JOIN ic_cat_tc_tipo_serie as tip_serie
									ON tip_serie.cve_tipo_serie= serie.cve_tipo_serie
								INNER JOIN ic_cat_tr_sucursal as suc
									ON suc.id_sucursal= serie.id_sucursal
								WHERE serie.', lo_id_grupo_empresa_P,
                                ' order by cve_serie asc');
	END IF;

    IF pr_modulo = 'PR' THEN
		SET lo_modulo= 'ic_cat_tr_proveedor prov';
        SET lo_where= CONCAT(' INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
									ON usuario.id_usuario=prov.id_usuario
								INNER JOIN ct_glob_tc_direccion dir
									ON dir.id_direccion= prov.id_direccion
								LEFT JOIN ic_glob_tc_tipo_ope_sat tip_ope
									ON tip_ope.id_sat_tipo_operacion= prov.id_sat_tipo_operacion
								INNER JOIN ic_cat_tc_tipo_proveedor tip_prov
									ON tip_prov.id_tipo_proveedor= prov.id_tipo_proveedor
                                WHERE prov.' , lo_id_grupo_empresa_P,
                                ' order by cve_proveedor asc');

		SET lo_select_prov = CONCAT(' prov.cve_proveedor, prov.razon_social, prov.nombre_comercial, tip_prov.desc_tipo_proveedor, tip_ope.origen, prov.estatus ');
	END IF;

    IF pr_modulo = 'VC' THEN
		SET lo_modulo= 'ic_fac_tr_factura fac';
        SET lo_where= CONCAT(' INNER JOIN ic_cat_tr_cliente cli
									ON cli.id_cliente= fac.id_cliente
								INNER JOIN ic_cat_tr_serie serie
									ON serie.id_serie= fac.id_serie
								INNER JOIN ic_cat_tr_sucursal suc
									ON suc.id_sucursal = fac.id_sucursal
                                WHERE fac.' , lo_id_grupo_empresa_P,
                                ' order by cve_serie, fac_numero ASC');

		SET lo_select_fac = CONCAT(' fac.id_factura, fac.id_cliente, cli.nombre_comercial, fac.id_serie, serie.cve_serie, fac.fac_numero, fac.fecha_factura, fac.id_sucursal, suc.nombre, fac.estatus ');
	END IF;

  -- -- -  -  -- - -
    IF pr_modulo = 'IB' THEN
		SET lo_modulo= 'ic_glob_tr_inventario_boletos inv_bol';
        SET lo_where= CONCAT(' INNER JOIN ic_cat_tr_proveedor prov
									ON prov.id_proveedor=inv_bol.id_proveedor
                                WHERE inv_bol.' , lo_id_grupo_empresa_P,
                                 ' order by fecha ASC');

		SET lo_select_inv_bol = CONCAT(' fecha,prov.nombre_comercial,bol_inicial,bol_final,descripcion ,inv_bol.estatus ');
	END IF;


	IF pr_modulo = 'VE'  THEN
		SET @query = CONCAT('SELECT ', lo_select_extra , '  FROM ', lo_modulo , lo_where );
    END IF;

    IF pr_modulo = 'CORP'  THEN
		SET @query = CONCAT('SELECT ', lo_select_extra5 , '  FROM ', lo_modulo , lo_where );
    END IF;

    IF pr_modulo = 'UNM'  THEN
		SET @query = CONCAT('SELECT ', lo_select_extra6 , '  FROM ', lo_modulo , lo_where );
    END IF;

    IF pr_modulo = 'SR' THEN
		SET @query = CONCAT('SELECT ', lo_select_extra2 , '  FROM ', lo_modulo , lo_where );
    END IF;

     IF pr_modulo = 'USR' THEN
		SET @query = CONCAT('SELECT ', lo_select_extra3 , '  FROM ', lo_modulo , lo_where );
    END IF;

    IF pr_modulo = 'RO' THEN
		SET @query = CONCAT('SELECT ', lo_select_extra4 , '  FROM ', lo_modulo , lo_where );
    END IF;

    IF pr_modulo = 'PR' THEN
		SET @query = CONCAT('SELECT ', lo_select_prov , '  FROM ', lo_modulo , lo_where );
    END IF;

    IF pr_modulo = 'VC' THEN
		SET @query = CONCAT('SELECT ', lo_select_fac , '  FROM ', lo_modulo , lo_where );
    END IF;

    IF pr_modulo = 'IB' THEN
		SET @query = CONCAT('SELECT ', lo_select_inv_bol , '  FROM ', lo_modulo , lo_where );
    END IF;

	IF (   pr_modulo 	= 'TP'
        OR pr_modulo 	= 'SE'
        ) THEN

		SET @query = CONCAT('SELECT * FROM ', lo_modulo , lo_where );
	END IF;

    IF ( pr_modulo 	= 'IM') THEN
        SET @query = CONCAT('SELECT * FROM ', lo_modulo , lo_where_im );
	END IF;

    IF ( pr_modulo 	= 'UN') THEN
        SET @query = CONCAT('SELECT * FROM ', lo_modulo , lo_where, lo_order_un );
	END IF;

	IF ( pr_modulo 	= 'GF') THEN
        SET @query = CONCAT('SELECT * FROM ', lo_modulo , lo_where, lo_order_gf );
	END IF;

    IF ( pr_modulo 	= 'OV') THEN
        SET @query = CONCAT('SELECT * FROM ', lo_modulo , lo_where, lo_order_ov );
	END IF;

    IF ( pr_modulo 	= 'SC') THEN
        SET @query = CONCAT('SELECT * FROM ', lo_modulo , lo_where, lo_order_sc );
	END IF;

    IF ( pr_modulo 	= 'CL') THEN
        SET @query = CONCAT('SELECT * FROM ', lo_modulo , lo_where, lo_order_cl );
	END IF;

    IF ( pr_modulo 	= 'FP') THEN
        SET @query = CONCAT('SELECT * FROM ', lo_modulo , lo_where, lo_order_fp );
	END IF;

    IF ( pr_modulo 	= 'PC') THEN
        SET @query = CONCAT('SELECT * FROM ', lo_modulo , lo_where, lo_order_pc );
	END IF;
 -- select @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	#SET pr_row_count = @pr_rows_tot_table;

END$$
DELIMITER ;
