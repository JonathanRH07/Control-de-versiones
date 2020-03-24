DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_corporativo_b`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_cat_corporativo_b
	@fecha: 		02/12/2016
	@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en catalogo corporativos.
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_estatus					VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
    DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_corporativo_b';
	END ;

    # Busqueda General
	# Realiza la Buqueda en qualquier campo por texto o carácter Alfanumérico
    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (corp.cve_corporativo LIKE "%'			, pr_consulta_gral, '%"
										OR corp.nom_corporativo LIKE "%'			, pr_consulta_gral, '%"
                                        OR corp.limite_credito_corporativo LIKE "%'	, pr_consulta_gral, '%"
                                        OR corp.estatus_corporativo LIKE "%'		, pr_consulta_gral, '%" ) ');
	ELSE
		# Buqueda Inicial
		# Muestra solo los registros que esten activos
		SET lo_first_select = ' AND corp.estatus_corporativo = "ACTIVO" ';
	END IF;

	# Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							corp.id_corporativo,
							corp.cve_corporativo,
							corp.nom_corporativo,
							corp.limite_credito_corporativo,
							corp.fecha_mod_corporativo fecha_mod,
							concat(usuario.nombre_usuario," ",usuario.paterno_usuario) usuario_mod,
							corp.estatus_corporativo
						FROM
						ic_cat_tr_corporativo corp
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=corp.id_usuario
						WHERE corp.id_grupo_empresa = ?'
							,lo_first_select
							,lo_consulta_gral
							,lo_order_by
							,'LIMIT ?,?');

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
					FROM ic_cat_tr_corporativo corp
					INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario=corp.id_usuario
					WHERE corp.id_grupo_empresa = ? '
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
