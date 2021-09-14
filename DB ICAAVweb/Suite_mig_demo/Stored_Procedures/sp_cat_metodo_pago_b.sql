DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_metodo_pago_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre:		sp_cat_metodo_pago_c
	@fecha:			02/12/2016
	@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo metodo de pago.
	@autor:			Griselda Medina Medina
	@cambios:
*/

	# Declaración de variables.
    DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_estatus_metodo_pago		VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_metodo_pago_b';
	END ;

	 IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (mp.cve_metodo_pago LIKE "%', 	pr_consulta_gral, '%"
										OR mp.desc_metodo_pago LIKE "%', 	pr_consulta_gral, '%"
                                        OR mp.tipo_metodo_pago LIKE "%', 	pr_consulta_gral, '%"
                                        OR mp.estatus_metodo_pago LIKE "%', pr_consulta_gral, '%" ) ');
	ELSE
		# Buqueda Inicial
		# Muestra solo los registros que esten activos
		SET lo_first_select = ' AND mp.estatus_metodo_pago = "ACTIVO" ';
	END IF;

	# Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							mp.id_metodo_pago,
							mp.id_metodo_pago_sat,
							mp.cve_metodo_pago,
							mp.desc_metodo_pago,
							mp.tipo_metodo_pago,
							mp.estatus_metodo_pago,
                            mp.fecha_mod_metodo_pago fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod
						FROM ic_glob_tr_metodo_pago mp
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=mp.id_usuario
						WHERE mp.id_grupo_empresa= ? '
							,lo_first_select
							,lo_consulta_gral
							,lo_order_by
							,'LIMIT ?,?');

    PREPARE stmt
    FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa,
    @ini, @fin;

	DEALLOCATE PREPARE stmt;
	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
									SELECT
										COUNT(*)
									INTO
										@pr_rows_tot_table
									FROM ic_glob_tr_metodo_pago mp
									INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
										ON usuario.id_usuario=mp.id_usuario
									WHERE mp.id_grupo_empresa= ? '
										,lo_first_select
										,lo_consulta_gral);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
