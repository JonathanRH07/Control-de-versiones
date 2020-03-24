DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_origen_venta_f`(
	IN	pr_id_grupo_empresa 	INT,
	IN  pr_id_origen_venta		INT,
    IN  pr_cve				  	VARCHAR(45),
    IN  pr_descripcion			VARCHAR(100),
    IN  pr_estatus				ENUM('ACTIVO', 'INACTIVO','TODOS'),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 			 	INT,
    IN  pr_fin_pag 			 	INT,
    IN  pr_order_by				VARCHAR(30),
    OUT pr_rows_tot_table    	INT,
    OUT pr_message 			 	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_origen_venta_c
	@fecha: 		02/12/2016
	@descripcion:	SP para filtrar registros de catalogo origen venta.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	# Declaración de variables.
	DECLARE lo_id_origen_venta      VARCHAR(100) DEFAULT '';
    DECLARE lo_estatus				VARCHAR(100) DEFAULT '';
    DECLARE lo_cve					VARCHAR(200) DEFAULT '';
    DECLARE lo_descripcion 			VARCHAR(200) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(200) DEFAULT '';
    DECLARE lo_consulta_gral  		VARCHAR(2000) DEFAULT '';


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_origen_venta_c';
     END;

	IF pr_id_origen_venta  > 0 THEN
		SET lo_id_origen_venta  = CONCAT(' AND id_origen_venta  =  ', pr_id_origen_venta);
    END IF;

	IF pr_cve != '' THEN
		SET lo_cve = CONCAT(' AND cve LIKE "%', pr_cve, '%" ');
	END IF;

	IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT(' AND descripcion LIKE "%', pr_descripcion, '%" ');
	END IF;

    IF (pr_estatus != '' AND pr_estatus != 'TODOS')THEN
		SET lo_estatus  = CONCAT(' AND estatus  = "', pr_estatus  ,'"');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (cve  LIKE 		"%'		, pr_consulta_gral, '%"
											OR descripcion LIKE	"%'	, pr_consulta_gral, '%"
                                            OR estatus LIKE 	"%'	, pr_consulta_gral, '%" )
                                            ');
	END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

   SET @query = CONCAT('SELECT
							id_origen_venta,
							cve,
							descripcion,
							estatus,
                            fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM
							ic_cat_tr_origen_venta
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=ic_cat_tr_origen_venta.id_usuario
						WHERE ic_cat_tr_origen_venta.id_grupo_empresa = ?',
							lo_id_origen_venta,
							lo_estatus,
							lo_cve,
							lo_descripcion,
                            lo_consulta_gral,
							lo_order_by,
							'LIMIT ?,?');

    PREPARE stmt
	FROM @query;

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
					FROM
							ic_cat_tr_origen_venta
					INNER join suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario=ic_cat_tr_origen_venta.id_usuario
					WHERE ic_cat_tr_origen_venta.id_grupo_empresa = ?',
						lo_id_origen_venta,
						lo_estatus,
						lo_cve,
						lo_descripcion,
                        lo_consulta_gral);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
