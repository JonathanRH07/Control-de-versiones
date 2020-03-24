DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_glob_proveedor_inventario_s`(
	IN  pr_id_grupo_empresa 		INT,
    IN  pr_id_tipo_proveedor 		INT,
    IN  pr_cve_proveedor			VARCHAR(10),
    IN	pr_razon_social				VARCHAR(255),
    IN  pr_nombre_comercial			VARCHAR(255),
    IN  pr_ini_pag 					INT,
    IN  pr_fin_pag 					INT,
    IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table 			INT,
	OUT pr_message 					VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_cat_proveedor_s
	@fecha: 		31/08/2017
	@descripcion : 	Sp de consulta
	@autor : 		Jonathan Ramirez
*/

	DECLARE lo_id_tipo_proveedor  	VARCHAR(5000) DEFAULT '';
    DECLARE lo_cve_proveedor	  	VARCHAR(500) DEFAULT '';
    DECLARE lo_razon_social			VARCHAR(500) DEFAULT '';
    DECLARE lo_nombre_comercial     VARCHAR(500) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_proveedor_s';
	END ;

     IF pr_id_tipo_proveedor > 0 THEN
		SET lo_id_tipo_proveedor = CONCAT('AND id_tipo_proveedor = ',pr_id_tipo_proveedor);
	END IF;

    IF pr_cve_proveedor != '' THEN
		SET lo_cve_proveedor = CONCAT('  AND cve_proveedor LIKE CONCAT(''%',pr_cve_proveedor,'%'')');
    END IF;

    IF pr_razon_social != '' THEN
		SET lo_razon_social = CONCAT(' AND razon_social LIKE CONCAT(''%',pr_razon_social,'%'')');
    END IF;

    IF pr_nombre_comercial != '' THEN
		SET lo_nombre_comercial = CONCAT(' AND nombre_comercial LIKE CONCAT(''%',pr_nombre_comercial,'%'')');
    END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    SET @query = CONCAT('SELECT
						 	prov.*,
						 	CONCAT(cve_proveedor,'' ||| '',nombre_comercial) general
						 FROM ic_cat_tr_proveedor prov
						 JOIN ic_cat_tr_proveedor_conf invent ON
						 	prov.id_proveedor = invent.id_proveedor
						 WHERE prov.id_grupo_empresa = ',pr_id_grupo_empresa,'
						 ',lo_id_tipo_proveedor,'
                         ',lo_cve_proveedor,'
                         ',lo_razon_social,'
                         ',lo_nombre_comercial,'
                         AND prov.estatus = ''ACTIVO''
                         AND invent.inventario = 1
						 AND prov.tipo_proveedor_operacion != ''EGRESO'''
						 '',lo_order_by,''
                         ' LIMIT ',pr_ini_pag,',',pr_fin_pag);

	-- SELECT @query;
    PREPARE stmt FROM @query;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    # START count rows query
	SET @pr_affect_rows = '';
	SET @queryTotalRows = CONCAT('SELECT
									COUNT(*)
								INTO
									@pr_affect_rows
								FROM ic_cat_tr_proveedor prov
								JOIN ic_cat_tr_proveedor_conf invent ON
									prov.id_proveedor = invent.id_proveedor
								WHERE prov.id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_id_tipo_proveedor,'
								',lo_cve_proveedor,'
								',lo_razon_social,'
								',lo_nombre_comercial,'
								AND prov.estatus = ''ACTIVO''
								AND invent.inventario = 1
								AND prov.tipo_proveedor_operacion != ''EGRESO''
								',lo_order_by
								);

    -- SELECT @queryTotalRows;
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_affect_rows;
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
