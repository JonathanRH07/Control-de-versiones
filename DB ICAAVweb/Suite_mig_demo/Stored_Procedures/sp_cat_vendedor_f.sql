DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_vendedor_f`(
	IN 	pr_id_grupo_empresa	INT,
    IN 	pr_id_sucursal 		INT,
    IN 	pr_clave 			CHAR(10),
    IN 	pr_nombre 			CHAR(90),
    IN 	pr_email 			VARCHAR(100),
    IN 	pr_id_comision 		INT,
    IN 	pr_id_comision_aux	INT,
    IN 	pr_estatus 			ENUM('ACTIVO','INACTIVO','TODOS'),
    IN	pr_id_vendedor		INT,
    IN  pr_consulta_gral	VARCHAR(200),
    IN  pr_ini_pag 			INT,
    IN  pr_fin_pag 			INT,
    IN  pr_order_by			VARCHAR(30),
    OUT pr_rows_tot_table  	INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_vendedores_f
	@fecha:			13/08/2016
	@descripcion:	SP para filtrar registros de catalogo vendedores.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE	lo_id_sucursal 		VARCHAR(300) DEFAULT '';
    DECLARE	lo_clave 			VARCHAR(300) DEFAULT '';
    DECLARE	lo_nombre 			VARCHAR(300) DEFAULT '';
    DECLARE	lo_email 			VARCHAR(300) DEFAULT '';
    DECLARE	lo_id_comision 		VARCHAR(300) DEFAULT '';
    DECLARE	lo_id_comision_aux	VARCHAR(300) DEFAULT '';
    DECLARE	lo_id_vendedor		VARCHAR(300) DEFAULT '';
    DECLARE	lo_estatus 			VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  	VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_vendedores_f';
	END ;

    IF pr_id_sucursal  > 0 THEN
		SET lo_id_sucursal   = CONCAT(' AND ic_cat_tr_vendedor.id_sucursal =  ', pr_id_sucursal);
    END IF;

	IF pr_clave != '' THEN
		SET lo_clave = CONCAT(' AND ic_cat_tr_vendedor.clave LIKE "%', pr_clave, '%" ');
	END IF;

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT(' AND ic_cat_tr_vendedor.nombre LIKE "%', pr_nombre, '%" ');
	END IF;

	IF pr_email != '' THEN
		SET lo_email = CONCAT(' AND ic_cat_tr_vendedor.email LIKE "%', pr_email, '%" ');
	END IF;

	IF pr_id_comision  > 0 THEN
		SET lo_id_comision = CONCAT(' AND ic_cat_tr_vendedor.id_comision =  ', pr_id_comision);
    END IF;

	IF pr_id_comision_aux  > 0 THEN
		SET lo_id_comision_aux   = CONCAT(' AND ic_cat_tr_vendedor.id_comision_aux =  ', pr_id_comision_aux);
    END IF;

	IF pr_id_vendedor > 0 THEN
		SET lo_id_vendedor = CONCAT(' AND ic_cat_tr_vendedor.id_vendedor = ',pr_id_vendedor);
    END IF;

    IF (pr_estatus != '' AND pr_estatus != 'TODOS')THEN
		SET lo_estatus  = CONCAT(' AND ic_cat_tr_vendedor.estatus  = "', pr_estatus  ,'"');
	END IF;

    IF (pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (ic_cat_tr_vendedor.clave LIKE "%'				, pr_consulta_gral, '%"
										OR ic_cat_tr_vendedor.nombre LIKE "%'			, pr_consulta_gral, '%"
										OR ic_cat_tr_sucursal.nombre LIKE "%'			, pr_consulta_gral, '%"
                                        OR ic_cat_tr_vendedor.email LIKE "%'			, pr_consulta_gral, '%"
                                        OR ic_cat_tr_vendedor.estatus LIKE "%'			, pr_consulta_gral, '%" ) ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	 SET @query = CONCAT('SELECT
								ic_cat_tr_vendedor.id_vendedor,
                                ic_cat_tr_vendedor.id_sucursal,
                                ic_cat_tr_sucursal.nombre as nom_sucursal,
                                ic_cat_tr_vendedor.clave,
                                ic_cat_tr_vendedor.nombre,
                                ic_cat_tr_vendedor.email,
                                ic_cat_tr_vendedor.id_comision,
                                ic_cat_tr_vendedor.id_comision_aux,
                                ic_cat_tr_vendedor.estatus,
                                com.cve_plan_comision as cve_plan,
                                com_aux.cve_plan_comision as cve_plan_aux,
                                ic_cat_tr_vendedor.fecha_mod,
								concat(usuario.nombre_usuario," ",
								usuario.paterno_usuario) usuario_mod
							FROM ic_cat_tr_vendedor
							INNER JOIN ic_cat_tr_sucursal
								ON ic_cat_tr_sucursal.id_sucursal= ic_cat_tr_vendedor.id_sucursal
							LEFT JOIN ic_cat_tr_plan_comision com
								ON com.id_plan_comision = ic_cat_tr_vendedor.id_comision
							LEFT JOIN ic_cat_tr_plan_comision com_aux
								ON com_aux.id_plan_comision = ic_cat_tr_vendedor.id_comision_aux
							INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
								ON usuario.id_usuario=ic_cat_tr_vendedor.id_usuario
							WHERE ic_cat_tr_vendedor.id_grupo_empresa = ? '
								,lo_id_sucursal
								,lo_clave
								,lo_nombre
								,lo_email
								,lo_id_comision
								,lo_id_comision_aux
                                ,lo_id_vendedor
								,lo_estatus
                                ,lo_consulta_gral
								,lo_order_by
								,'LIMIT ?,?'

    );

    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;

    # START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('SELECT
									COUNT(*)
								  INTO
									 @pr_rows_tot_table
								  FROM ic_cat_tr_vendedor
								  INNER JOIN ic_cat_tr_sucursal
									ON ic_cat_tr_sucursal.id_sucursal= ic_cat_tr_vendedor.id_sucursal
								  LEFT JOIN ic_cat_tr_plan_comision com
									ON com.id_plan_comision = ic_cat_tr_vendedor.id_comision
								  LEFT JOIN ic_cat_tr_plan_comision com_aux
									ON com_aux.id_plan_comision = ic_cat_tr_vendedor.id_comision_aux
								  INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
									ON usuario.id_usuario=ic_cat_tr_vendedor.id_usuario
								  WHERE ic_cat_tr_vendedor.id_grupo_empresa = ? '
									,lo_id_sucursal
									,lo_clave
									,lo_nombre
									,lo_email
									,lo_id_comision
									,lo_id_comision_aux
                                    ,lo_id_vendedor
									,lo_estatus
									,lo_consulta_gral
								 	,lo_order_by

    );

    PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	# Mensaje de ejecución.
	SET pr_rows_tot_table = @pr_rows_tot_table;
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
