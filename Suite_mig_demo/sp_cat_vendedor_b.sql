DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_vendedor_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			VARCHAR(30),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN

/*
	@nombre:		sp_cat_vendedor_b
	@fecha: 		21/12/2016
	@descripcion:	Sp consutla de catalogo vendedores.
	@autor:			Griselda Medina Medina
	@cambios:
*/
	# Declaración de variables.

	DECLARE lo_cve_impuesto 			VARCHAR(200) DEFAULT '';
	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_cve_impuesto_cat 		VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus_impuesto			VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

/*
                                        OR ic_cat_tr_vendedor.id_comision LIKE "%'		, pr_consulta_gral, '%"
										OR ic_cat_tr_vendedor.id_comision_aux LIKE "%'	, pr_consulta_gral, '%"
*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_vendedor_b';
     END;

    IF (pr_consulta_gral !='' ) THEN
	SET lo_consulta_gral = CONCAT(' AND (ic_cat_tr_vendedor.clave LIKE "%'				, pr_consulta_gral, '%"
										OR ic_cat_tr_vendedor.nombre LIKE "%'			, pr_consulta_gral, '%"
										OR ic_cat_tr_sucursal.nombre LIKE "%'			, pr_consulta_gral, '%"
                                        OR ic_cat_tr_vendedor.email LIKE "%'			, pr_consulta_gral, '%"
                                        OR ic_cat_tr_vendedor.estatus LIKE "%'			, pr_consulta_gral, '%" ) ');
    ELSE
		SET lo_first_select = ' AND ic_cat_tr_vendedor.estatus = "ACTIVO" ';
    END IF;

    # Busqueda por ORDER BY
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
                                ic_cat_tr_vendedor.fecha_mod,
								concat(usuario.nombre_usuario," ",
								usuario.paterno_usuario) usuario_mod
							FROM ic_cat_tr_vendedor
							INNER JOIN ic_cat_tr_sucursal
								ON ic_cat_tr_sucursal.id_sucursal= ic_cat_tr_vendedor.id_sucursal
							INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
								ON usuario.id_usuario=ic_cat_tr_vendedor.id_usuario
							LEFT JOIN ic_cat_tr_plan_comision as plan_c
									ON plan_c.id_plan_comision= ic_cat_tr_vendedor.id_comision
							LEFT JOIN ic_cat_tr_plan_comision plan_c2
									ON plan_c2.id_plan_comision= ic_cat_tr_vendedor.id_comision_aux
							WHERE ic_cat_tr_vendedor.id_grupo_empresa = ?'
								,lo_first_select
								,lo_consulta_gral
								,lo_order_by
								,'LIMIT ?,?');

    PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;
	#END main query
	# START count rows query
/*	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_cat_tr_vendedor
					INNER JOIN ic_cat_tr_sucursal
						ON ic_cat_tr_sucursal.id_sucursal= ic_cat_tr_vendedor.id_sucursal
					INNER join suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario=ic_cat_tr_vendedor.id_usuario
					WHERE ic_cat_tr_vendedor.id_grupo_empresa = ?'
						,lo_first_select
						,lo_consulta_gral
	);

		PREPARE stmt FROM @queryTotalRows;
		EXECUTE stmt USING @id_grupo_empresa;
		DEALLOCATE PREPARE stmt;*/

		# Mensaje de ejecución.
	-- 	SET pr_rows_tot_table = @pr_rows_tot_table;

        SET pr_rows_tot_table = FOUND_ROWS();
		SET pr_message 	   = 'SUCCESS';
    END$$
DELIMITER ;
