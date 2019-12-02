DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_cons_bol_global`(
	IN	pr_id_grupo_empresa				INT,
    IN  pr_id_sucursal					INT,
    IN	pr_id_tipo_proveedor			INT,
    IN	pr_id_proveedor					INT,
	IN	pr_id_estatus_boleto			INT,
    IN	pr_id_tipo_consulta_boleto		INT,
    IN	pr_numero_bol					VARCHAR(13),
    IN	pr_bol_inicial					CHAR(15),
    IN	pr_bol_final					CHAR(15),
    IN	pr_consulta						INT,  /*ENUM('FACTURA','EMISION'),*/
    IN	pr_fecha						VARCHAR(15),
    IN  pr_id_inventario				TEXT,
    IN	pr_consulta_gral				VARCHAR(100),
	-- IN	pr_estatus					VARCHAR(15),
	IN	pr_cve_proveedor				VARCHAR(10),
	IN	pr_clave_aerolinea				CHAR(3),
	IN	pr_cve_servicio					CHAR(10),
	IN	pr_nombre_pasajero 				VARCHAR(15),
	IN	pr_ruta							VARCHAR(30),
	IN	pr_cve_serie					CHAR(5),
	IN	pr_fac_numero					INT(11),
	IN	pr_cve_sucursal					VARCHAR(30),
	IN	pr_fac_estatus 					ENUM('ACTIVO', 'CANCELADA'),
	IN	pr_fecha_factura				DATE,
    IN  pr_order_by						VARCHAR(100),
    IN	pr_pag_ini						INT,
    IN	pr_pag_fin						INT,
    OUT	pr_rows_tot_table				INT,
	OUT pr_message						VARCHAR(500))
BEGIN
/*
    @nombre:		sp_fac_cons_bol_global_v2
	@fecha:			2018/11/21
	@descripcion:	SP para consultar registro en la tabla ic_fac_tc_tipo_consulta_boleto
	@autor:			David Roldan Solares
	@cambios:
*/

	DECLARE	lo_estatus_boleto		VARCHAR(200);
    DECLARE lo_fecha				VARCHAR(200);
	DECLARE lo_matriz				INT;
    DECLARE lo_matriz_campo			VARCHAR(200) DEFAULT '';
    DECLARE lo_consulta				VARCHAR(200) DEFAULT '';
    DECLARE lo_complemento			VARCHAR(200) DEFAULT '';
    DECLARE lo_inventario			VARCHAR(200) DEFAULT '';
    DECLARE lo_consulta_gral		VARCHAR(20000) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(200) DEFAULT '';

    DECLARE lo_estatus_filtro		VARCHAR(20000) DEFAULT '';
    DECLARE lo_cve_proveedor		VARCHAR(20000) DEFAULT '';
    DECLARE lo_clave_aerolinea		VARCHAR(20000) DEFAULT '';
    DECLARE lo_cve_servicio			VARCHAR(20000) DEFAULT '';
    DECLARE lo_nombre_pasajero 		VARCHAR(20000) DEFAULT '';
    DECLARE lo_ruta					VARCHAR(20000) DEFAULT '';
    DECLARE lo_cve_serie			VARCHAR(20000) DEFAULT '';
    DECLARE lo_fac_numero			VARCHAR(20000) DEFAULT '';
    DECLARE lo_cve_sucursal			VARCHAR(20000) DEFAULT '';
    DECLARE lo_fac_estatus 			VARCHAR(20000) DEFAULT '';
    DECLARE	lo_fecha_factura		VARCHAR(20000) DEFAULT '';
    DECLARE	lo_numero_boleto		VARCHAR(20000) DEFAULT '';



	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_cons_bol_global_v2';
	END ;

    /* VALIDAR SUCURSAL SI ES CORPORATIVO */
    SELECT
		matriz
	INTO
		lo_matriz
    FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF lo_matriz = 0 THEN
		SET lo_matriz_campo = CONCAT(' AND bol.id_sucursal = ',pr_id_sucursal);
    END IF;

    /* VALIDAR ESTATUS */
    IF pr_id_estatus_boleto = 1 THEN
		SET lo_estatus_boleto = ' bol.estatus = ''FACTURADO'' ';
        SET lo_estatus_filtro = ' AND bol.estatus = ''FACTURADO'' ';
	ELSEIF pr_id_estatus_boleto = 2 THEN
        SET lo_estatus_boleto = ' bol.estatus = ''ACTIVO'' ';
        SET lo_estatus_filtro = ' AND bol.estatus = ''ACTIVO'' ';
	ELSEIF	pr_id_estatus_boleto = 3 THEN
        SET lo_estatus_boleto = ' bol.estatus = ''CANCELADO'' ';
        SET lo_estatus_filtro = ' AND bol.estatus = ''CANCELADO'' ';
	END IF;

	# Busqueda por ORDER BY
	IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	ELSE
		SET lo_order_by = ' ORDER BY bol.numero_bol ASC';
	END IF;

    IF pr_id_tipo_consulta_boleto > 0 THEN
		/* VALIDAR TIPO DE CONSULTA */
		IF pr_id_tipo_consulta_boleto = 1 THEN
		/* Se manda llamar al sp para el tipo de consulta "Todos los boletos y Dotaciones" */
			IF pr_consulta > 0 THEN
				IF pr_consulta = 1 OR pr_consulta = 'FACTURA' THEN
					SET lo_consulta = CONCAT(' AND  date_format(fac.fecha_factura,''%Y-%m'') = ''',pr_fecha,'''');
				ELSEIF pr_consulta = 2 OR pr_consulta = 'EMISION' THEN
					SET lo_consulta = CONCAT(' AND  date_format(bol.fecha_emision,''%Y-%m'') = ''',pr_fecha,'''');
				END IF;
            END IF;
		ELSEIF pr_id_tipo_consulta_boleto = 2 THEN
			/* Se manda llamar al sp para el tipo de consulta "Rango de Boletos" */
			SET lo_consulta = CONCAT(' AND bol.numero_bol >= ',pr_bol_inicial,'
									AND bol.numero_bol <= ',pr_bol_final);
		ELSEIF pr_id_tipo_consulta_boleto = 3 THEN
			/* Se manda llamar al sp para el tipo de consulta "Boleto" */
			SET lo_consulta = CONCAT(' AND bol.numero_bol = ''',pr_numero_bol,'''');
		ELSEIF pr_id_tipo_consulta_boleto = 4 THEN
			/* Se manda llamar al sp para el tipo de consulta "Dotación" */
			SET lo_consulta = CONCAT(' AND bol.id_inventario IN (',pr_id_inventario,')');
			SET lo_inventario = 'JOIN ic_glob_tr_inventario_boletos inv_bol ON
									bol.id_inventario = inv_bol.id_inventario_boletos';
		END IF;
    END IF;

    /* PARAMETROS EN 0 */
    IF pr_id_proveedor > 0 THEN
		SET lo_complemento = CONCAT(' AND   bol.id_proveedor = ',pr_id_proveedor);
    END IF;

    IF pr_consulta_gral != '' THEN
		SET lo_consulta_gral = CONCAT(' AND bol.numero_bol     	LIKE ''%', pr_consulta_gral, '%''
									   /* ESTATUS */
									   OR  pro.cve_proveedor  	LIKE ''%', pr_consulta_gral, '%''
                                       OR  clave_aerolinea    	LIKE ''%', pr_consulta_gral, '%''
                                       OR  cve_servicio       	LIKE ''%', pr_consulta_gral, '%''
                                       OR  nombre_pasajero	  	LIKE ''%', pr_consulta_gral, '%''
                                       OR  det.concepto		  	LIKE ''%', pr_consulta_gral, '%''
                                       OR  cve_serie		  	LIKE ''%', pr_consulta_gral, '%''
                                       OR  fac_numero		  	LIKE ''%', pr_consulta_gral, '%''
                                       OR  cve_sucursal		  	LIKE ''%', pr_consulta_gral, '%''
                                       OR  fac.estatus		  	LIKE ''%', pr_consulta_gral, '%''
                                       OR  fecha_factura	  	LIKE ''%', pr_consulta_gral, '%'' '
                                       );
    END IF;
/*
	IF pr_estatus != '' THEN
		IF pr_estatus = 'FACTURADO' THEN
			SET lo_estatus_filtro = ' AND bol.id_factura_detalle > 0 AND bol.estatus = ''ACTIVO'' ';
		ELSEIF pr_estatus = 'ACTIVO' THEN
			SET lo_estatus_filtro = ' AND bol.id_factura_detalle = 0 AND bol.estatus = ''ACTIVO'' ';
		ELSEIF pr_estatus = 'CANCELADO' THEN
			SET lo_estatus_filtro = ' AND bol.estatus = ''INACTIVO'' ';
		END IF;
    END IF;
 */
    IF pr_cve_proveedor != '' THEN
		SET lo_cve_proveedor = CONCAT(' AND pro.cve_proveedor LIKE ''%',pr_cve_proveedor,'%'' ');
    END IF;

	IF pr_clave_aerolinea != '' THEN
		SET lo_clave_aerolinea = CONCAT(' AND clave_aerolinea LIKE ''%',pr_clave_aerolinea,'%'' ');
    END IF;

	IF pr_cve_servicio != '' THEN
		SET lo_cve_servicio = CONCAT(' AND cve_servicio LIKE ''%',pr_cve_servicio,'%'' ');
    END IF;

	IF pr_nombre_pasajero != '' THEN
		SET lo_nombre_pasajero = CONCAT(' AND nombre_pasajero LIKE ''%',pr_nombre_pasajero,'%'' ');
    END IF;

	IF pr_ruta != '' THEN
		SET lo_ruta = CONCAT(' AND det.concepto LIKE ''%',pr_ruta,'%'' ');
    END IF;

	IF pr_cve_serie	!= '' THEN
		SET lo_cve_serie = CONCAT(' AND cve_serie LIKE ''%',pr_cve_serie,'%'' ');
    END IF;

	IF pr_fac_numero > 0 THEN
		SET lo_fac_numero = CONCAT(' AND fac_numero LIKE ''%',pr_fac_numero,'%'' ');
    END IF;

    IF pr_cve_sucursal != '' THEN
		SET lo_cve_sucursal = CONCAT(' AND cve_sucursal LIKE ''%',pr_cve_sucursal,'%'' ');
    END IF;

    IF pr_fac_estatus !='' THEN
			SET pr_fac_estatus = CONCAT(' AND fac.estatus = "',pr_fac_estatus,'" ');
	END IF;

    IF pr_fecha_factura != '0000-00-00' THEN
		SET lo_fecha_factura = CONCAT(' AND fecha_factura = ''',pr_fecha_factura,'''');
    END IF;

    IF pr_numero_bol !='' THEN
		SET lo_numero_boleto = CONCAT(' AND bol.numero_bol like ''%',pr_numero_bol,'%''');
    END IF;

	SET @query = CONCAT('
							SELECT
								bol.id_boletos,
								bol.id_inventario,
								bol.numero_bol,
								bol.estatus estatus_bol,
								pro.cve_proveedor,
								vuelos.clave_linea_aerea clave_aerolinea,
								cve_servicio,
								nombre_pasajero,
								det.concepto ruta,
								cve_serie,
								fac.fac_numero,
								cve_sucursal,
								fac.estatus estatus_fac,
								fecha_factura
							FROM ic_glob_tr_boleto bol
							LEFT JOIN ic_fac_tr_factura_detalle det ON
								bol.id_factura_detalle = det.id_factura_detalle
							LEFT JOIN ic_cat_tc_servicio ser ON
								det.id_servicio = ser.id_servicio
							LEFT JOIN ic_fac_tr_factura fac ON
								det.id_factura = fac.id_factura
							LEFT JOIN ic_cat_tr_serie seri ON
								fac.id_serie = seri.id_serie
							LEFT JOIN ic_cat_tr_sucursal suc ON
								fac.id_sucursal = suc.id_sucursal
							JOIN ic_cat_tr_proveedor pro ON
								bol.id_proveedor = pro.id_proveedor
							LEFT JOIN ic_gds_tr_vuelos vuelos ON
								det.id_factura_detalle = vuelos.id_factura_detalle
							',lo_inventario,'
							WHERE bol.id_grupo_empresa = ',pr_id_grupo_empresa,'
                            AND   pro.id_tipo_proveedor = ',pr_id_tipo_proveedor,'
                            AND ',lo_estatus_boleto,'
							',lo_numero_boleto,'
                            ',lo_matriz_campo,'
							',lo_complemento,'
							',lo_consulta,'
                            ',lo_estatus_filtro,'
                            ',lo_cve_proveedor,'
                            ',lo_clave_aerolinea,'
                            ',lo_cve_servicio,'
                            ',lo_nombre_pasajero,'
                            ',lo_ruta,'
                            ',lo_cve_serie,'
                            ',lo_fac_numero,'
                            ',lo_cve_sucursal,'
                            ',lo_fac_estatus,'
                            ',lo_fecha_factura,'
							',lo_consulta_gral,'
                            ',lo_order_by,'
							LIMIT ',pr_pag_ini,',',pr_pag_fin);

	-- SELECT @query FROM DUAL;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	/* CONTEO DE REGISTROS */
    SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('SELECT
								COUNT(*)
							INTO
								@pr_rows_tot_table
							FROM ic_glob_tr_boleto bol
							LEFT JOIN ic_fac_tr_factura_detalle det ON
								bol.id_factura_detalle = det.id_factura_detalle
							LEFT JOIN ic_cat_tc_servicio ser ON
								det.id_servicio = ser.id_servicio
							LEFT JOIN ic_fac_tr_factura fac ON
								det.id_factura = fac.id_factura
							LEFT JOIN ic_cat_tr_serie seri ON
								fac.id_serie = seri.id_serie
							LEFT JOIN ic_cat_tr_sucursal suc ON
								fac.id_sucursal = suc.id_sucursal
							JOIN ic_cat_tr_proveedor pro ON
								bol.id_proveedor = pro.id_proveedor
							JOIN ic_cat_tc_tipo_proveedor tip ON
								pro.id_tipo_proveedor = tip.id_tipo_proveedor
							LEFT JOIN ic_cat_tr_proveedor_aero proa ON
								pro.id_proveedor = proa.id_proveedor
							LEFT JOIN ct_glob_tc_aerolinea aer ON
								proa.codigo_bsp = aer.codigo_bsp
							',lo_inventario,'
							WHERE bol.id_grupo_empresa = ',pr_id_grupo_empresa,'
                            AND   pro.id_tipo_proveedor = ',pr_id_tipo_proveedor,'
                            AND ',lo_estatus_boleto,'
							',lo_numero_boleto,'
                            ',lo_matriz_campo,'
							',lo_complemento,'
							',lo_consulta,'
                            ',lo_estatus_filtro,'
                            ',lo_cve_proveedor,'
                            ',lo_clave_aerolinea,'
                            ',lo_cve_servicio,'
                            ',lo_nombre_pasajero,'
                            ',lo_ruta,'
                            ',lo_cve_serie,'
                            ',lo_fac_numero,'
                            ',lo_cve_sucursal,'
                            ',lo_fac_estatus,'
                            ',lo_fecha_factura,'
							',lo_consulta_gral,'
                            ',lo_order_by);

	-- SELECT @queryTotalRows FROM DUAL;
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;

    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
