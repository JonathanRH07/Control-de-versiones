DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_servicio_fs`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_servicio			INT(11),
	IN  pr_cve_servicio			CHAR(45),
	IN  pr_descripcion			VARCHAR(100),
	IN  pr_alcance				ENUM('NACIONAL','INTERNACIONAL'),
	IN  pr_id_producto			INT(11),
	IN  pr_valida_adicis		ENUM('SI','NO'),
	IN  pr_estatus				ENUM('ACTIVO','INACTIVO','TODOS'),
	IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_tipo_busqueda		CHAR(1),
	IN  pr_ini_pag				INT,
	IN  pr_fin_pag				INT,
	IN  pr_order_by				VARCHAR(30),
	OUT pr_rows_tot_table		INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_cat_servicio_f
		@fecha: 		28/11/2016
		@descripcion: 	SP para filtrar registros de catalogo servicio.
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE  lo_cve_servicio			VARCHAR(500) DEFAULT '';
    DECLARE  lo_descripcion				VARCHAR(500) DEFAULT '';
    DECLARE  lo_alcance					VARCHAR(500) DEFAULT '';
    DECLARE  lo_id_producto				VARCHAR(500) DEFAULT '';
    DECLARE  lo_valida_adicis			VARCHAR(500) DEFAULT '';
	DECLARE  lo_estatus					VARCHAR(500) DEFAULT '';
    DECLARE  lo_id_servicio				VARCHAR(500) DEFAULT '';
    DECLARE	 lo_order_by				VARCHAR(500) DEFAULT '';
    DECLARE  lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_joins						VARCHAR(1000) DEFAULT '';
    DECLARE  lo_additional_fields			VARCHAR(1000) DEFAULT '';

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_servicio_f';
	END ;*/

	IF (pr_estatus !='' AND pr_estatus !='TODOS' ) THEN
		SET lo_estatus = CONCAT(' AND serv.estatus = "', pr_estatus, '" ');
	END IF;

	IF pr_id_producto > 0 THEN
		SET lo_id_producto = CONCAT(' AND serv.id_producto =  "', pr_id_producto, '" ');
	END IF;

	IF pr_id_servicio > 0 THEN
		SET lo_id_servicio = CONCAT(' AND serv.id_servicio =  "', pr_id_servicio, '" ');
	END IF;

	IF pr_cve_servicio  != '' THEN
		SET lo_cve_servicio = CONCAT(' AND serv.cve_servicio  LIKE "%', pr_cve_servicio , '%" ');
	END IF;

	IF pr_alcance  != '' THEN
		SET lo_alcance = CONCAT(' AND serv.alcance ="', pr_alcance , '" ');
	END IF;

	IF pr_descripcion  != '' THEN
		SET lo_descripcion = CONCAT(' AND serv.descripcion  LIKE "%', pr_descripcion , '%" ');
	END IF;

	IF pr_valida_adicis  != '' THEN
		SET lo_valida_adicis = CONCAT(' AND serv.valida_adicis  LIKE "%', pr_valida_adicis , '%" ');
	END IF;

	# Visualizacion de los datos en orden.
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	# Busqueda General
	# Realiza la Buqueda en qualquier campo por texto o carácter Alfanumérico
    IF ( pr_consulta_gral !='' ) THEN
		IF pr_tipo_busqueda = 'F' THEN
			SET lo_consulta_gral = CONCAT('
					AND (serv.cve_servicio LIKE "%'	, pr_consulta_gral, '%"
					OR serv.descripcion LIKE "%'	, pr_consulta_gral, '%"
					OR serv.alcance LIKE "%'		, pr_consulta_gral, '%"
					OR prod.descripcion LIKE "%'	, pr_consulta_gral, '%"
					OR serv.valida_adicis LIKE "%'	, pr_consulta_gral, '%"
					OR serv.estatus LIKE "%'		, pr_consulta_gral, '%" )
			');
		ELSE
			SET lo_consulta_gral = CONCAT(' AND (  serv.cve_servicio LIKE CONCAT(''%',pr_consulta_gral,'%'') OR serv.descripcion LIKE CONCAT(''%',pr_consulta_gral,'%'')  ) ');
        END IF;
	END IF;

     IF pr_tipo_busqueda = 'F' THEN
		SET lo_joins = ' INNER JOIN ic_cat_tc_producto  AS prod
							ON prod.id_producto= serv.id_producto
						INNER JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
							on usuario.id_usuario=serv.id_usuario
						LEFT JOIN ic_cat_tc_unidad_medida AS unidad
							ON serv.id_unidad_medida = unidad.id_unidad_medida
						LEFT JOIN sat_productos_servicios AS sat_prod
							ON sat_prod.c_ClaveProdServ = serv.c_ClaveProdServ ';

		SET lo_additional_fields =
				',serv.fecha_mod,
							concat(usuario.nombre_usuario," ",usuario.paterno_usuario) AS usuario_mod,
                            prod.descripcion as desc_producto,
							unidad.c_ClaveUnidad,
                            unidad.descripcion as desc_unidad_medida,
                            unidad.cve_unidad_medida,
                            sat_prod.descripcion as desc_ClaveProdServ ';
    END IF;

	SET @query = CONCAT('SELECT
							serv.id_servicio,
							serv.cve_servicio,
							serv.descripcion,
							serv.alcance,
							serv.id_producto,
							serv.c_ClaveProdServ,
                            serv.id_unidad_medida,
							serv.valida_adicis,
							serv.estatus
                            ',lo_additional_fields,'
						FROM ic_cat_tc_servicio AS serv '
						,lo_joins,
						' WHERE serv.id_grupo_empresa = ? ',
								lo_estatus,
                                lo_id_servicio,
								lo_cve_servicio,
								lo_descripcion,
								lo_alcance,
								lo_id_producto,
								lo_valida_adicis,
                                lo_consulta_gral,
								lo_order_by,
								' LIMIT ?,? '
	);

	PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
    DEALLOCATE PREPARE stmt;

    SET @pr_rows_tot_table = '';

	IF pr_tipo_busqueda = 'F' THEN
		# START count rows query

		SET @queryTotalRows = CONCAT('
						SELECT COUNT(*) INTO @pr_rows_tot_table
						FROM ic_cat_tc_servicio AS serv
						INNER JOIN ic_cat_tc_producto  AS prod
							ON prod.id_producto = serv.id_producto
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							on usuario.id_usuario = serv.id_usuario
						LEFT JOIN ic_cat_tc_unidad_medida AS unidad
							ON serv.id_unidad_medida = unidad.id_unidad_medida
						WHERE serv.id_grupo_empresa = ? ',
							lo_estatus,
							lo_cve_servicio,
							lo_id_servicio,
							lo_descripcion,
							lo_alcance,
							lo_id_producto,
							lo_valida_adicis,
							lo_consulta_gral
		);

		PREPARE stmt FROM @queryTotalRows;
		EXECUTE stmt USING @id_grupo_empresa;
		DEALLOCATE PREPARE stmt;


    END IF;

	SET pr_rows_tot_table = @pr_rows_tot_table;
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
