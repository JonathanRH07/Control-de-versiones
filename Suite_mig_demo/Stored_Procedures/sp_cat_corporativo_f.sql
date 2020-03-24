DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_corporativo_f`(
	IN 	pr_id_grupo_empresa				INT,
    IN  pr_cve_corporativo 				VARCHAR(45),
    IN  pr_nom_corporativo				VARCHAR(80),
    IN  pr_min_limite_credito 			DOUBLE,
    IN  pr_max_limite_credito 			DOUBLE,
    IN  pr_estatus_corporativo      	ENUM('ACTIVO', 'INACTIVO','TODOS'),
    IN  pr_consulta_gral				VARCHAR(200),
    IN  pr_ini_pag 						INT,
    IN  pr_fin_pag 						INT,
    IN  pr_order_by						VARCHAR(100),
    OUT pr_rows_tot_table  				INT,
    OUT pr_message 						VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_corporativo_f
	@fecha: 		02/12/2016
	@descripcion: 	SP para filtrar registros del catalogo de Corporativos.
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_id_corporativo	    		VARCHAR(300) DEFAULT '';
    DECLARE lo_estatus_corporativo			VARCHAR(300) DEFAULT '';
    DECLARE lo_cve_corporativo 				VARCHAR(300) DEFAULT '';
    DECLARE lo_nom_corporativo 				VARCHAR(300) DEFAULT '';
	DECLARE lo_min_limite_credito 			VARCHAR(300) DEFAULT '';
    DECLARE lo_max_limite_credito 			VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 					VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  				VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_corporativo_f';
	END ;

	IF pr_cve_corporativo != '' THEN
		SET lo_cve_corporativo = CONCAT(' AND corp.cve_corporativo LIKE "%', pr_cve_corporativo, '%" ');
	END IF;

	IF pr_nom_corporativo != '' THEN
		SET lo_nom_corporativo = CONCAT(' AND corp.nom_corporativo LIKE "%', pr_nom_corporativo, '%" ');
	END IF;

    IF pr_min_limite_credito > 0 THEN
		SET lo_min_limite_credito = CONCAT(' AND corp.limite_credito_corporativo >= ', pr_min_limite_credito, ' ');
    END IF;

    IF pr_max_limite_credito > 0 THEN
		SET lo_max_limite_credito = CONCAT(' AND corp.limite_credito_corporativo <= ', pr_max_limite_credito, ' ');
    END IF;

    IF (pr_estatus_corporativo != '' AND pr_estatus_corporativo != 'TODOS')THEN
		SET lo_estatus_corporativo  = CONCAT(' AND corp.estatus_corporativo  = "', pr_estatus_corporativo  ,'"');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (corp.cve_corporativo LIKE "%'			, pr_consulta_gral, '%"
										OR corp.nom_corporativo LIKE "%'			, pr_consulta_gral, '%"
                                        OR corp.limite_credito_corporativo LIKE "%'	, pr_consulta_gral, '%"
                                        OR corp.estatus_corporativo LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	SET @query = CONCAT('SELECT
							corp.id_corporativo,
							corp.cve_corporativo,
							corp.nom_corporativo,
							corp.limite_credito_corporativo,
                            corp.fecha_mod_corporativo fecha_mod,
							concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_mod,
							corp.estatus_corporativo
						FROM
							ic_cat_tr_corporativo corp
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=corp.id_usuario
						WHERE corp.id_grupo_empresa = ?',
							lo_id_corporativo,
							lo_estatus_corporativo,
							lo_cve_corporativo,
							lo_nom_corporativo,
							lo_min_limite_credito,
							lo_max_limite_credito,
                            lo_consulta_gral,
							lo_order_by,
						   ' LIMIT ?,?');

    PREPARE stmt FROM @query;
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
						ic_cat_tr_corporativo corp
					INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario=corp.id_usuario
					WHERE corp.id_grupo_empresa = ?',
						lo_id_corporativo,
						lo_estatus_corporativo,
						lo_cve_corporativo,
						lo_nom_corporativo,
						lo_min_limite_credito,
						lo_max_limite_credito,
                        lo_consulta_gral);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
