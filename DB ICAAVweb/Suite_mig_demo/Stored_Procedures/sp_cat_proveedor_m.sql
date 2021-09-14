DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_m`(
	IN  pr_id_grupo_empresa			INT,
	IN  pr_cve_proveedor			VARCHAR(45),
    IN  pr_razon_social				VARCHAR(255),
	IN  pr_nombre_comercial			VARCHAR(255),
    IN  pr_id_tipo_proveedor		INT,
    IN  pr_estatus					ENUM('ACTIVO', 'INACTIVO', 'TODOS'),
	IN  pr_ini_pag					INT,
	IN  pr_fin_pag					INT,
	IN  pr_order_by					VARCHAR(45),
	OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_proveedor_m
		@fecha:			27/09/2018
		@descripcion:	SP para filtrar registros en el modal de proveedores
		@autor:			Yazbek Kido
		@cambios:
	*/

	DECLARE  lo_cve_proveedor			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_razon_social			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nombre_comercial		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_id_tipo_proveedor		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_estatus					VARCHAR(1000) DEFAULT '';
    DECLARE  lo_num_interior            VARCHAR(1000) DEFAULT '';
    DECLARE  lo_order_by				VARCHAR(1000) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION

   	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_m';
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


	IF (pr_estatus != '' AND pr_estatus != 'TODOS')THEN
		SET lo_estatus  = CONCAT(' AND prov.estatus  = "', pr_estatus  ,'"');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;


	SET @query = CONCAT('
			SELECT prov.*,
				   t_prov.cve_tipo_proveedor,
                   prov_conf.inventario
			FROM ic_cat_tr_proveedor prov
				LEFT JOIN ic_cat_tc_tipo_proveedor t_prov
				  ON t_prov.id_tipo_proveedor = prov.id_tipo_proveedor
				LEFT JOIN ic_cat_tr_proveedor_conf prov_conf
				  ON prov_conf.id_proveedor = prov.id_proveedor
			WHERE
				prov.id_grupo_empresa = ? ',
				lo_cve_proveedor,
				lo_razon_social,
				lo_nombre_comercial,
				lo_id_tipo_proveedor,
				lo_estatus,
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
					LEFT JOIN ic_cat_tc_tipo_proveedor t_prov
					  ON t_prov.id_tipo_proveedor = prov.id_tipo_proveedor
					LEFT JOIN ic_cat_tr_proveedor_conf prov_conf
					  ON prov_conf.id_proveedor = prov.id_proveedor
				WHERE prov.id_grupo_empresa =  ? ',
					lo_cve_proveedor,
					lo_razon_social,
					lo_nombre_comercial,
					lo_id_tipo_proveedor,
					lo_estatus
	);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;


	SET pr_rows_tot_table	= @pr_affect_rows;
	SET pr_message 			= 'SUCCESS';
END$$
DELIMITER ;
