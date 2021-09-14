DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_serie_fs`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_id_sucursal_auth			INT(11),
    IN  pr_sucursal_tipo_auth		ENUM('CORPORATIVO', 'SUCURSAL', 'INPLANT'),
	IN  pr_id_sucursal				INT(11),
	IN  pr_cve_serie 				CHAR(50),
	IN  pr_cve_tipo_serie  			CHAR(4),
	IN  pr_cve_tipo_doc 			CHAR(4),
	IN  pr_descripcion_serie		VARCHAR(50),
	IN  pr_estatus_serie	 		ENUM('ACTIVO', 'INACTIVO','TODOS'),
    IN  pr_tipo_busqueda			CHAR(1),
    IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag 					INT(11),
	IN  pr_fin_pag 					INT(11),
	IN  pr_order_by					VARCHAR(100),
	OUT pr_rows_tot_table  			INT,
	OUT pr_message 					VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_serie_f
	@fecha: 		28/11/2016
	@descripcion: 	SP para filtrar registros de catalogo series.
	@autor: 		Griselda Medina Medina
	@cambios:
*/

	DECLARE  lo_id_sucursal				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cve_serie 				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cve_tipo_serie  		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cve_tipo_doc 			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_descripcion_serie		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_estatus_serie 			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_order_by 				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_first_select			VARCHAR(200) DEFAULT '';
    DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_serie_f';
	END;*/

	IF pr_cve_serie != '' THEN
		SET lo_cve_serie  = CONCAT(' AND serie.cve_serie  LIKE "%', pr_cve_serie  ,'%"');
	END IF;

	IF pr_descripcion_serie != '' THEN
		SET lo_descripcion_serie  = CONCAT(' AND serie.descripcion_serie LIKE "%', pr_descripcion_serie  ,'%"');
	END IF;

	IF pr_cve_tipo_serie != '' THEN
		SET lo_cve_tipo_serie  = CONCAT(' AND serie.cve_tipo_serie = "', pr_cve_tipo_serie,'"');
	END IF;

	IF pr_cve_tipo_doc != '' THEN
		SET lo_cve_tipo_doc  = CONCAT(' AND tipdoc.cve_tipo_doc = "', pr_cve_tipo_doc,'"');
	END IF;

	IF pr_id_sucursal != '' THEN
		IF pr_sucursal_tipo_auth = 'CORPORATIVO' THEN
			SET lo_id_sucursal = CONCAT(' AND suc.id_sucursal = ', pr_id_sucursal);
		ELSE
			SET lo_id_sucursal = CONCAT(' AND suc.id_sucursal = ', pr_id_sucursal_auth);
		END IF;
	ELSE
		IF pr_sucursal_tipo_auth <> 'CORPORATIVO' THEN
			SET lo_id_sucursal = CONCAT(' AND suc.id_sucursal = ', pr_id_sucursal_auth);
        END IF;
	END IF;

	IF (pr_estatus_serie != '' AND pr_estatus_serie != 'TODOS')THEN
		SET lo_estatus_serie  = CONCAT(' AND serie.estatus_serie  = "', pr_estatus_serie  ,'"');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
		IF pr_tipo_busqueda = 'F' THEN
			SET lo_consulta_gral = CONCAT(' AND (serie.cve_serie  LIKE "%'					, pr_consulta_gral, '%"
											OR serie.descripcion_serie LIKE "%'				, pr_consulta_gral, '%"
                                            OR tipdoc.descripcion_tipo_doc LIKE "%'			, pr_consulta_gral, '%"
                                            OR tip_serie.descripcion_tipo_serie LIKE "%'	, pr_consulta_gral, '%"
                                            OR suc.nombre LIKE "%'							, pr_consulta_gral, '%"
                                            OR serie.estatus_serie LIKE "%'					, pr_consulta_gral, '%" ) '
			);
		ELSE
			SET lo_consulta_gral = CONCAT(' AND ( serie.cve_serie LIKE CONCAT(''%',pr_consulta_gral,'%'') OR serie.descripcion_serie LIKE CONCAT(''%',pr_consulta_gral,'%'')  ) ');
        END IF;
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('
		SELECT
			SELECT
			serie.*,
			tipdoc.descripcion_tipo_doc AS descripcion_tipo_doc,
			tip_serie.descripcion_tipo_serie AS descripcion_tipo_serie,
			suc.nombre
		FROM ic_cat_tr_serie as serie
		LEFT JOIN ic_cat_tr_tipo_doc  as tipdoc
			ON tipdoc.cve_tipo_doc= serie.cve_tipo_doc
		LEFT JOIN ic_cat_tc_tipo_serie as tip_serie
			ON tip_serie.cve_tipo_serie= serie.cve_tipo_serie
		LEFT JOIN ic_cat_tr_sucursal as suc
			ON suc.id_sucursal= serie.id_sucursal
		WHERE
			suc.estatus="ACTIVO"
		AND
			serie.id_grupo_empresa = ? ',
			lo_first_select,
			lo_estatus_serie,
			lo_descripcion_serie,
			lo_id_sucursal,
			lo_cve_tipo_doc,
			lo_cve_tipo_serie,
			lo_cve_serie,
            lo_consulta_gral,
			lo_order_by,
		' LIMIT ?,?
	');
--  select @query;
	PREPARE stmt FROM @query;
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
		FROM ic_cat_tr_serie as serie
		LEFT JOIN ic_cat_tr_tipo_doc  as tipdoc
			ON tipdoc.cve_tipo_doc= serie.cve_tipo_doc
		LEFT JOIN ic_cat_tc_tipo_serie as tip_serie
			ON tip_serie.cve_tipo_serie= serie.cve_tipo_serie
		LEFT JOIN ic_cat_tr_sucursal as suc
			ON suc.id_sucursal= serie.id_sucursal
		WHERE
			suc.estatus="ACTIVO"
		AND
			serie.id_grupo_empresa = ? ',
				lo_first_select,
				lo_estatus_serie,
				lo_descripcion_serie,
				lo_id_sucursal,
				lo_cve_tipo_doc,
				lo_cve_tipo_serie,
				lo_cve_serie,
                lo_consulta_gral
	);

    PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	# Mensaje de ejecución.
	SET pr_rows_tot_table = @pr_rows_tot_table;
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
