DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_plan_comision_f`(
    IN 	pr_id_grupo_empresa		INT,
    IN  pr_cve_plan_comision 	CHAR(15),
    IN  pr_descripcion			VARCHAR(255),
    IN  pr_fecha_ini 			DATE,
    IN  pr_fecha_fin 			DATE,
    IN  pr_estatus      		ENUM('ACTIVO', 'INACTIVO','TODOS'),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    IN  pr_consulta_gral		VARCHAR(200),
    OUT pr_rows_tot_table  		INT,
    OUT pr_message 				VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_cat_plan_comision_f
	@fecha: 		05/01/2017
	@descripcion: 	SP para filtrar registros del catalogo de plan de comision.
	@autor:  		Griselda Medina Medina
	@cambios:
*/

    # Declaración de variables.
	DECLARE lo_cve_plan_comision	VARCHAR(300) DEFAULT '';
    DECLARE lo_descripcion			VARCHAR(300) DEFAULT '';
    DECLARE lo_fecha_ini 			VARCHAR(300) DEFAULT '';
    DECLARE lo_fecha_fin 			VARCHAR(300) DEFAULT '';
	DECLARE lo_estatus 				VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_plan_comision_f';
	END ;

	IF pr_cve_plan_comision != '' THEN
		SET lo_cve_plan_comision = CONCAT(' AND cve_plan_comision LIKE "%', pr_cve_plan_comision, '%" ');
	END IF;

	IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT(' AND descripcion LIKE "%', pr_descripcion, '%" ');
	END IF;

    IF pr_fecha_ini > 0000-00-00 THEN
		SET lo_fecha_ini = CONCAT(' AND fecha_ini >= "', pr_fecha_ini, '" ');
    END IF;

    IF pr_fecha_fin > 0000-00-00 THEN
		SET lo_fecha_fin = CONCAT(' AND fecha_fin <= "', pr_fecha_fin, '" ');
    END IF;

    IF (pr_estatus != '' AND pr_estatus != 'TODOS')THEN
		SET lo_estatus  = CONCAT(' AND estatus  = "', pr_estatus  ,'"');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	#Busqueda de filtro GENERAL
	IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (cve_plan_comision LIKE "%'	, pr_consulta_gral, '%"
										OR descripcion LIKE "%'			, pr_consulta_gral, '%"
										OR fecha_ini LIKE "%'			, pr_consulta_gral, '%"
										OR fecha_fin LIKE "%'			, pr_consulta_gral, '%"
										OR estatus LIKE "%'				, pr_consulta_gral, '%" ) ');
	END IF;

	SET @query = CONCAT('SELECT
							id_plan_comision,
							cve_plan_comision,
							descripcion,
							cuota_minima,
							cuota_minima_monto,
							comisiones_por,
							fecha_ini,
							fecha_fin,
							estatus,
							fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM ic_cat_tr_plan_comision plan
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=plan.id_usuario
						WHERE plan.id_grupo_empresa = ?',
							lo_cve_plan_comision,
							lo_descripcion,
							lo_fecha_ini,
							lo_fecha_fin,
							lo_estatus,
                            lo_consulta_gral,
							lo_order_by,
							' LIMIT ?,?');

    PREPARE stmt
		FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
								SELECT
									COUNT(*)
										INTO
											@pr_rows_tot_table
								FROM ic_cat_tr_plan_comision plan
								INNER join suite_mig_conf.st_adm_tr_usuario usuario
									ON usuario.id_usuario=plan.id_usuario
								WHERE plan.id_grupo_empresa = ? ',
									lo_cve_plan_comision,
									lo_descripcion,
									lo_fecha_ini,
									lo_fecha_fin,
									lo_estatus);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
    #SET pr_message   = @query;
END$$
DELIMITER ;
