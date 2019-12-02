DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_prove_servicio_f`(
	IN  pr_id_proveedor		INT,
    IN  pr_id_servicio		INT,
    IN  pr_cve_servicio		CHAR(10),
    IN  pr_descripcion 		VARCHAR(100),
    IN  pr_nombre_aerolinea VARCHAR(250),
    IN  pr_contador 		INT,
    IN  pr_ini_pag 			INT,
    IN  pr_fin_pag 			INT,
    IN  pr_order_by			VARCHAR(100),
    OUT pr_rows_tot_table  	INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_prove_servicio_f
		@fecha:			30/05/2017
		@descripcion:	SP para consultar registros de catalogo Tipo proveedor.
		@autor:			Griselda Medina Medina.
		@cambios:
	*/

    DECLARE lo_id_servicio    	VARCHAR(100) DEFAULT '';
	DECLARE lo_cve_servicio    	VARCHAR(100) DEFAULT '';
	DECLARE lo_descripcion		VARCHAR(100) DEFAULT '';
    DECLARE lo_nombre_aerolinea	VARCHAR(100) DEFAULT '';
    DECLARE lo_contador			VARCHAR(100) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_prove_servicio_f';
	END ;

	IF pr_id_servicio  !='' THEN
		SET lo_id_servicio  = CONCAT(' AND prov_serv.id_servicio = ', pr_id_servicio, ' ');
    END IF;

    IF pr_cve_servicio  !='' THEN
		SET lo_cve_servicio  = CONCAT(' AND serv.cve_servicio  LIKE "%', pr_cve_servicio, '%" ');
    END IF;

    IF pr_descripcion  !='' THEN
		SET lo_descripcion  = CONCAT(' AND serv.descripcion  LIKE "%', pr_descripcion, '%" ');
    END IF;

    IF pr_nombre_aerolinea  !='' THEN
		SET lo_nombre_aerolinea  = CONCAT(' AND airline.nombre_aerolinea  LIKE "%', pr_nombre_aerolinea, '%" ');
    END IF;

    IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	ELSE
		SET lo_order_by = ' ';
    END IF;

    SET @query = CONCAT('
			SELECT
				prov_serv.id_prove_servicio,
				prov_serv.id_proveedor,
				prov.nombre_comercial,
				prov_serv.id_servicio,
				serv.descripcion,
				serv.cve_servicio,
                serv.id_unidad_medida,
                unidades.c_ClaveUnidad,
				serv.c_ClaveProdServ,
                prov_serv.id_aerolinea,
				prov_serv.comision,
                prov_serv.id_impuesto,
                imp.valor_impuesto,
				imp.tipo_valor_impuesto,
				prov_serv.tipo_valor_comision,
				prov_serv.margen,
				prov_serv.tipo_valor_margen,
				prov_conf.inventario,
				sat.descripcion AS descripcion_sat,
				',pr_contador,' AS contador,
                unidades.cve_unidad_medida,
                prod.cve_producto,
                airline.nombre_aerolinea,
                produc.cve_producto
			FROM ic_fac_tr_prove_servicio prov_serv
			INNER JOIN ic_cat_tc_servicio serv ON
				serv.id_servicio = prov_serv.id_servicio
			INNER JOIN ic_cat_tr_proveedor prov ON
				prov.id_proveedor = prov_serv.id_proveedor
			INNER JOIN ic_cat_tr_proveedor_conf prov_conf ON
				prov.id_proveedor = prov_conf.id_proveedor
			INNER JOIN sat_productos_servicios sat ON
				serv.c_ClaveProdServ = sat.c_ClaveProdServ
			LEFT JOIN ic_cat_tc_unidad_medida unidades ON
				serv.id_unidad_medida = unidades.id_unidad_medida
			LEFT JOIN ic_cat_tc_producto prod ON
				serv.id_producto = prod.id_producto
			LEFT JOIN ic_cat_tr_impuesto imp ON
				prov_serv.id_impuesto = imp.id_impuesto
			LEFT JOIN ct_glob_tc_aerolinea airline ON
				prov_serv.id_aerolinea = airline.id_aerolinea
            LEFT JOIN ic_cat_tc_producto produc ON
				serv.id_producto = produc.id_producto
			WHERE prov_serv.id_proveedor = ?
			AND serv.estatus = "ACTIVO" ','
			',lo_cve_servicio,'
			',lo_descripcion ,'
			',lo_id_servicio ,'
			',lo_nombre_aerolinea,'
			',lo_order_by,'
			','LIMIT ?,?'
			);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	SET @id_proveedor = pr_id_proveedor;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_proveedor, @ini, @fin;
	DEALLOCATE PREPARE stmt;
	#END main query



	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
			SELECT
				COUNT(*)
			INTO
				@pr_rows_tot_table
			FROM ic_fac_tr_prove_servicio prov_serv
			INNER JOIN ic_cat_tc_servicio serv ON
				serv.id_servicio = prov_serv.id_servicio
			INNER JOIN ic_cat_tr_proveedor prov ON
				prov.id_proveedor = prov_serv.id_proveedor
			INNER JOIN ic_cat_tr_proveedor_conf prov_conf ON
				prov.id_proveedor = prov_conf.id_proveedor
			INNER JOIN sat_productos_servicios sat ON
				serv.c_ClaveProdServ = sat.c_ClaveProdServ
			LEFT JOIN ic_cat_tc_unidad_medida unidades ON
				serv.id_unidad_medida = unidades.id_unidad_medida
			LEFT JOIN ic_cat_tc_producto prod ON
				serv.id_producto = prod.id_producto
			LEFT JOIN ic_cat_tr_impuesto imp ON
				prov_serv.id_impuesto = imp.id_impuesto
			LEFT JOIN ct_glob_tc_aerolinea airline ON
				prov_serv.id_aerolinea = airline.id_aerolinea
            LEFT JOIN ic_cat_tc_producto produc ON
				serv.id_producto = produc.id_producto
			WHERE prov_serv.id_proveedor= ?
			AND serv.estatus = "ACTIVO" ' ,
			lo_cve_servicio ,
			lo_descripcion ,
			lo_id_servicio,
			lo_nombre_aerolinea);

	-- SELECT @queryTotalRows;
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_proveedor;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
