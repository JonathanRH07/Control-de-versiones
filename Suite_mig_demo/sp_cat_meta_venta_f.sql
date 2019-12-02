DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_meta_venta_f`(
	IN 	pr_id_grupo_empresa		INT,
    IN 	pr_id_meta_venta		INT,
    IN 	pr_id_sucursal			INT,
    IN  pr_clave 				VARCHAR(15),
    IN  pr_descripcion			VARCHAR(255),
    IN  pr_fecha_mes_inicio		INT,
    IN  pr_fecha_mes_fin		INT,
    IN  pr_fecha_anio_inicio	INT,
    IN  pr_fecha_anio_fin		INT,
    IN  pr_min_meta 			DOUBLE,
    IN  pr_max_meta 			DOUBLE,
    IN  pr_estatus   			ENUM('ACTIVO','INACTIVO','TODOS'),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(30),
    OUT pr_rows_tot_table  		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_meta_venta_f
	@fecha:			01/10/2019
	@descripcion:	SP para filtrar registros de catalogo sp_cat_meta_venta_f.
	@autor:			Yazbek Kido
	@cambios:
*/
	DECLARE lo_id_meta_venta  	    VARCHAR(300) DEFAULT '';
	DECLARE lo_id_sucursal  	    VARCHAR(300) DEFAULT '';
    DECLARE lo_estatus				VARCHAR(300) DEFAULT '';
    DECLARE lo_clave				VARCHAR(300) DEFAULT '';
    DECLARE lo_min_meta				VARCHAR(300) DEFAULT '';
    DECLARE lo_max_meta				VARCHAR(300) DEFAULT '';
    DECLARE lo_descripcion			VARCHAR(300) DEFAULT '';
    DECLARE lo_fecha_mes_inicio		VARCHAR(500) DEFAULT '';
    DECLARE lo_fecha_mes_fin		VARCHAR(300) DEFAULT '';
    DECLARE lo_fecha_anio_inicio	VARCHAR(500) DEFAULT '';
    DECLARE lo_fecha_anio_fin		VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  		VARCHAR(2000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'SALES_TARGET.MESSAGE_ERROR_LIST_SALESTARGET';
	END ;

    IF pr_id_meta_venta  > 0 THEN
		SET lo_id_meta_venta   = CONCAT(' AND meta.id_meta_venta =  ', pr_id_meta_venta);
    END IF;

	IF pr_clave != '' THEN
		SET lo_clave = CONCAT(' AND meta.clave LIKE "%', pr_clave, '%" ');
	END IF;

	IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT(' AND meta.descripcion LIKE "%', pr_descripcion, '%" ');
	END IF;

    IF pr_fecha_mes_inicio > 0 THEN
		SET lo_fecha_mes_inicio= CONCAT(' AND  DATE_FORMAT(meta.fecha_inicio,"%c") = "', pr_fecha_mes_inicio, '" ');
    END IF;

    IF pr_fecha_mes_fin > 0 THEN
		SET lo_fecha_mes_fin= CONCAT(' AND  DATE_FORMAT(meta.fecha_fin,"%c") = "', pr_fecha_mes_fin, '" ');
    END IF;

    IF pr_fecha_anio_inicio > 0 THEN
		SET lo_fecha_anio_inicio= CONCAT(' AND  DATE_FORMAT(meta.fecha_inicio,"%Y") = "', pr_fecha_anio_inicio, '" ');
    END IF;

    IF pr_fecha_anio_fin > 0 THEN
		SET lo_fecha_anio_fin= CONCAT(' AND  DATE_FORMAT(meta.fecha_fin,"%Y") = "', pr_fecha_anio_fin, '" ');
    END IF;

    IF pr_min_meta > 0 THEN
		SET lo_min_meta = CONCAT(' AND meta.total >= ', pr_min_meta, ' ');
    END IF;

    IF pr_max_meta > 0 THEN
		SET lo_max_meta = CONCAT(' AND meta.total <= ', pr_max_meta, ' ');
    END IF;

    IF ( pr_consulta_gral !='' ) THEN
			SET lo_consulta_gral = CONCAT(' AND (meta.clave  LIKE "%'	, pr_consulta_gral, '%"
											OR meta.descripcion LIKE "%'		, pr_consulta_gral, '%"
                                            OR  meta.fecha_inicio LIKE "%'	, pr_consulta_gral, '%"
											OR  meta.fecha_fin LIKE "%'	, pr_consulta_gral, '%"
                                            OR meta.total LIKE "%'	, pr_consulta_gral, '%" ) ');

	END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	SET @query = CONCAT('SELECT
							meta.*,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM
							ic_cat_tr_meta_venta meta
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=meta.id_usuario
						WHERE meta.id_grupo_empresa = ? ',
							lo_id_meta_venta,
							lo_id_sucursal,
							lo_estatus,
							lo_clave,
							lo_min_meta,
							lo_max_meta,
							lo_fecha_mes_inicio,
							lo_fecha_mes_fin,
							lo_fecha_anio_inicio,
							lo_fecha_anio_fin,
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
									FROM
										ic_cat_tr_meta_venta meta
									INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
										ON usuario.id_usuario=meta.id_usuario
									WHERE meta.id_grupo_empresa = ?',
										lo_id_meta_venta,
										lo_id_sucursal,
										lo_estatus,
										lo_clave,
										lo_min_meta,
										lo_max_meta,
										lo_fecha_mes_inicio,
										lo_fecha_mes_fin,
										lo_fecha_anio_inicio,
										lo_fecha_anio_fin,
                                        lo_consulta_gral);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
     # Mensaje de ejecucion.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
