DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_impuesto_f`(
	IN  pr_id_grupo_empresa   	INT(11),
	IN  pr_cve_pais   			CHAR(3),
	IN  pr_cve_impuesto    		CHAR(10),
	IN  pr_desc_impuesto   		CHAR(30),
	IN  pr_cve_impuesto_cat   	CHAR(10),
	IN  pr_estatus_impuesto   	ENUM('ACTIVO', 'INACTIVO', 'TODOS'),
	IN  pr_id_impuesto 			INT(11),
    IN  pr_ini_pag     			INT(11),
	IN  pr_fin_pag     			INT(11),
	IN  pr_order_by     		VARCHAR(100),
    IN  pr_consulta_gral		VARCHAR(200),
    OUT pr_affect_rows    		INT,
	OUT pr_message     			VARCHAR(5000))
BEGIN
	/*
		@Nombre 	: sp_cat_impuesto_f
		@fecha 		: 02/12/2016
		@descripcion: SP para filtrar registros de catalogo Series.
		@autor 		: Griselda Medina Medina
		@cambios 	:
	*/

	DECLARE lo_cve_impuesto    		VARCHAR(200) DEFAULT '';
	DECLARE lo_desc_impuesto     	VARCHAR(200) DEFAULT '';
	DECLARE lo_cve_impuesto_cat   	VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus_impuesto   	VARCHAR(200) DEFAULT '';
    DECLARE lo_id_impuesto 			VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by     		VARCHAR(200) DEFAULT '';
	DECLARE lo_first_select    		VARCHAR(200) DEFAULT '';
    DECLARE lo_consulta_gral  		VARCHAR(1000) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_impuesto_f';
	END ;

	IF pr_cve_impuesto != '' THEN
		SET lo_cve_impuesto = CONCAT(' AND impuesto.cve_impuesto LIKE "%', pr_cve_impuesto, '%" ');
	END IF;

	IF pr_desc_impuesto != '' THEN
		SET lo_desc_impuesto = CONCAT(' AND impuesto.desc_impuesto LIKE "%', pr_desc_impuesto, '%" ');
	END IF;

	IF pr_cve_impuesto_cat !='' THEN
		SET lo_cve_impuesto_cat = CONCAT(' AND impuesto.cve_impuesto_cat LIKE "%', pr_cve_impuesto_cat, '%"  ');
	END IF;

	IF (pr_estatus_impuesto !='' AND pr_estatus_impuesto !='TODOS' ) THEN
		SET lo_estatus_impuesto = CONCAT(' AND impuesto.estatus_impuesto = "', pr_estatus_impuesto, '" ');
	END IF;

    IF pr_id_impuesto > 0 THEN
		SET lo_id_impuesto = CONCAT(' impuesto.id_impuesto LIKE ',pr_id_impuesto,' ');
    END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	#Busqueda de filtro GENERAL
	IF (pr_consulta_gral !='' ) THEN
	SET lo_consulta_gral = CONCAT(' AND (impuesto.cve_impuesto 			LIKE "%', pr_consulta_gral, '%"
										OR impuesto.desc_impuesto		LIKE "%', pr_consulta_gral, '%"
										OR impuesto.cve_impuesto_cat 	LIKE "%', pr_consulta_gral, '%")
								');
	END IF;

	SET @query = CONCAT('SELECT
							impuesto.id_impuesto,
							impuesto.cve_pais,
                            provee.id_impuesto impuesto_empresa,
							provee.c_ClaveProdServ,
							CONCAT(satProdServ.c_ClaveProdServ ," - ", satProdServ.descripcion) AS gen_satProdServ,
							provee.id_unidad,
							satProdServ.descripcion as desc_ClaveProdServ,
							CONCAT(satUnidMed.c_ClaveUnidad ," - ", satUnidMed.nombre) AS gen_satUnidMed,
							satUnidMed.c_ClaveUnidad,
							satUnidMed.nombre as desc_ClaveUnidad,
							impuesto.cve_impuesto,
							impuesto.desc_impuesto,
							sat_impuestos.c_Impuesto,
							impuesto.tipo_valor_impuesto,
							impuesto.valor_impuesto,
							impuesto.cve_impuesto_cat,
							impuesto.por_pagar_impuesto,
							impuesto.tipo,
							impuesto.clase,
							impuesto.estatus_impuesto,
							impuesto.fecha_mod_impuesto AS fecha_mod,
							impuesto.id_usuario,
							CONCAT(usuario.nombre_usuario," ",usuario.paterno_usuario) AS usuario_mod
						FROM ic_cat_tr_impuesto impuesto
						INNER JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
							ON usuario.id_usuario = impuesto.id_usuario
						LEFT JOIN sat_impuestos
							ON sat_impuestos.descripcion=impuesto.cve_impuesto_cat
						LEFT JOIN ic_cat_tr_impuesto_provee_unidad provee ON
							impuesto.id_impuesto = provee.id_impuesto AND provee.id_grupo_empresa = ?
						LEFT JOIN sat_unidades_medida AS satUnidMed
							ON provee.id_unidad = satUnidMed.id_unidad
						LEFT JOIN sat_productos_servicios AS satProdServ
							ON provee.c_ClaveProdServ = satProdServ.c_ClaveProdServ
						WHERE impuesto.cve_pais = ? '
							,lo_first_select
							,lo_cve_impuesto
							,lo_desc_impuesto
							,lo_cve_impuesto_cat
							,lo_estatus_impuesto
                            ,lo_id_impuesto
                            ,lo_consulta_gral
							,lo_order_by
						,'LIMIT ?,?'
	);

    PREPARE stmt FROM @query;
	SET @cve_pais = pr_cve_pais;
    SET @id_grupo_empresa = pr_id_grupo_empresa;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @cve_pais, @ini, @fin;
	DEALLOCATE PREPARE stmt;

    /*
    SELECT @query;
    */


	SET @pr_affect_rows = '';
	SET @queryTotalRows = CONCAT('
			SELECT
				COUNT(*)
			INTO
				@pr_affect_rows
			FROM ic_cat_tr_impuesto impuesto
			INNER JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
				ON usuario.id_usuario = impuesto.id_usuario
			LEFT JOIN sat_impuestos
				ON sat_impuestos.descripcion=impuesto.cve_impuesto_cat
			LEFT JOIN ic_cat_tr_impuesto_provee_unidad provee ON
				impuesto.id_impuesto = provee.id_impuesto AND provee.id_grupo_empresa = ?
			LEFT JOIN sat_unidades_medida AS satUnidMed
				ON provee.id_unidad = satUnidMed.id_unidad
			LEFT JOIN sat_productos_servicios AS satProdServ
				ON provee.c_ClaveProdServ = satProdServ.c_ClaveProdServ
			WHERE impuesto.cve_pais = ? '
				,lo_first_select
				,lo_cve_impuesto
				,lo_desc_impuesto
				,lo_cve_impuesto_cat
				,lo_estatus_impuesto
                ,lo_id_impuesto
                ,lo_consulta_gral
	);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa, @cve_pais ;
	DEALLOCATE PREPARE stmt;
	SET pr_affect_rows = @pr_affect_rows;


	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
