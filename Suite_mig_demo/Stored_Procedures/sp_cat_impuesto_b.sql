DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cat_impuesto_b`(
	IN  pr_id_grupo_empresa INT,
	IN  pr_cve_pais 		CHAR(3),
    IN  pr_consulta_gral 	CHAR(30),
	IN  pr_ini_pag 			INT(11),
	IN  pr_fin_pag 			INT(11),
	IN  pr_order_by 		VARCHAR(100),
    OUT pr_affect_rows 		INT,
	OUT pr_message 			VARCHAR(5000))
BEGIN
	/*
		@Nombre:		sp_cat_impuesto_b
		@fecha:			02/12/2016
		@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo series.
		@autor:			Griselda Medina Medina
		@cambios:
	*/
	DECLARE lo_cve_impuesto 			VARCHAR(200) DEFAULT '';
	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_cve_impuesto_cat 		VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus_impuesto			VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN


																	SET pr_message = 'ERROR store sp_cat_impuesto_b';

		END ;

	#Busqueda de filtro GENERAL
																IF (pr_consulta_gral !='' ) THEN
			SET lo_consulta_gral = CONCAT(' AND (impuesto.cve_impuesto 			LIKE "%', pr_consulta_gral, '%"
										OR impuesto.desc_impuesto		LIKE "%', pr_consulta_gral, '%"
										OR impuesto.cve_impuesto_cat 	LIKE "%', pr_consulta_gral, '%")
								 ');
	ELSE
		SET lo_first_select = ' AND impuesto.estatus_impuesto = "ACTIVO" ';
    END IF;

    # Busqueda por ORDER BY
	IF pr_order_by <> '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	#Select @query ;
	SET @query = CONCAT('SELECT
							impuesto.id_impuesto,
							impuesto.cve_pais,
							provee.c_ClaveProdServ,
							CONCAT(satProdServ.c_ClaveProdServ ," - ", satProdServ.descripcion) AS gen_satProdServ,
							provee.id_unidad,
							CONCAT(satUnidMed.c_ClaveUnidad ," - ", satUnidMed.nombre) AS gen_satUnidMed,
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
							impuesto.id_impuesto = provee.id_impuesto AND
							provee.id_grupo_empresa = ',pr_id_grupo_empresa,'
						LEFT JOIN sat_unidades_medida AS satUnidMed
							ON provee.id_unidad = satUnidMed.id_unidad
						LEFT JOIN sat_productos_servicios AS satProdServ
							ON provee.c_ClaveProdServ = satProdServ.c_ClaveProdServ
						WHERE impuesto.cve_pais = ? '
                            ,lo_first_select
                            ,lo_consulta_gral
							,lo_order_by
							,'LIMIT ?,?'
	);

		#SELECT @query;
			PREPARE stmt FROM @query;
			SET @cve_pais = pr_cve_pais;

			SET @ini = pr_ini_pag;

			SET @fin = pr_fin_pag;

			EXECUTE stmt USING @cve_pais, @ini, @fin;
			DEALLOCATE PREPARE stmt;



	# START count rows query
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
					JOIN ic_cat_tr_impuesto_provee_unidad provee ON
						impuesto.id_impuesto = provee.id_impuesto
					LEFT JOIN sat_unidades_medida AS satUnidMed
						ON provee.id_unidad = satUnidMed.id_unidad
					LEFT JOIN sat_productos_servicios AS satProdServ
						ON provee.c_ClaveProdServ = satProdServ.c_ClaveProdServ
					WHERE impuesto.cve_pais = ? '
						,lo_first_select
						,lo_consulta_gral
	);

			PREPARE stmt FROM @queryTotalRows;
			EXECUTE stmt USING @pr_cve_pais;
			DEALLOCATE PREPARE stmt;

			SET pr_affect_rows	= @pr_affect_rows;



    # Mensaje de ejecucion.
		SET pr_message			= 'SUCCESS';

		END$$
DELIMITER ;
