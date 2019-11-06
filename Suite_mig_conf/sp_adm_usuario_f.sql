DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_f`(
	IN	pr_id_grupo_empresa 	INT,
    IN	pr_id_idioma 			INT,
	IN  pr_usuario				VARCHAR(50),
    IN  pr_nombre_role			VARCHAR(50),
	IN  pr_correo			    VARCHAR(50),
    IN  pr_nombre_empresa		VARCHAR(50),
    IN  pr_estatus_usuario  	ENUM('ACTIVO', 'INACTIVO', 'TODOS'),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
	IN  pr_order_by				VARCHAR(30),
    OUT pr_rows_tot_table    	INT,
    OUT pr_message 			 	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_adm_usuario_f
		@fecha: 		02/12/2016
		@descripcion:	SP para filtrar registros de catalogo origen venta.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	# Declaración de variables.
	DECLARE lo_usuario      		VARCHAR(1000) DEFAULT '';
    DECLARE lo_paterno_usuario      VARCHAR(100) DEFAULT '';
    DECLARE lo_materno_usuario      VARCHAR(100) DEFAULT '';
    DECLARE lo_nombre_role			VARCHAR(100) DEFAULT '';
    DECLARE lo_correo          		VARCHAR(100) DEFAULT '';
    DECLARE lo_nombre_empresa       VARCHAR(100) DEFAULT '';
    DECLARE lo_estatus_usuario  	VARCHAR(1000) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(200) DEFAULT '';
    DECLARE lo_consulta_gral  		VARCHAR(2000) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	/*BEGIN
		SET pr_message = 'ERROR store sp_adm_usuario_f';
     END;*/

	IF pr_usuario  != '' THEN
		SET lo_usuario  = CONCAT(' AND usuario.nombre_usuario  LIKE "%',pr_usuario,'%" OR usuario.paterno_usuario LIKE "%',pr_usuario,'%" OR usuario.materno_usuario LIKE "%',pr_usuario,'%"' );
    END IF;

	IF pr_nombre_role != '' THEN
		SET lo_nombre_role = CONCAT(' AND role.nombre_role LIKE "%', pr_nombre_role, '%"');
	END IF;

	IF pr_correo != '' THEN
		SET lo_correo = CONCAT(' AND usuario.correo LIKE "%', pr_correo, '%" ');
	END IF;

    IF pr_nombre_empresa != '' THEN
		SET lo_nombre_empresa = CONCAT(' AND empresa.nom_empresa LIKE "%', pr_nombre_empresa, '%" ');
	END IF;

    IF (pr_estatus_usuario != '' AND pr_estatus_usuario != 'TODOS' )  THEN
		SET lo_estatus_usuario = CONCAT(' AND usuario.estatus_usuario = "', pr_estatus_usuario,'"');
	END IF;

    IF pr_order_by !=  '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    IF pr_consulta_gral !='' THEN
			SET lo_consulta_gral = CONCAT(' AND (usuario.nombre_usuario  LIKE "%'	, pr_consulta_gral, '%"
											OR usuario.paterno_usuario LIKE "%'		, pr_consulta_gral, '%"
                                            OR usuario.materno_usuario LIKE "%'		, pr_consulta_gral, '%"
											OR role.nombre_role LIKE "%'			, pr_consulta_gral, '%"
                                            OR empresa.nom_empresa LIKE "%'			, pr_consulta_gral, '%"
                                            OR usuario.correo LIKE "%'				, pr_consulta_gral, '%"
                                            OR usuario.estatus_usuario LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

   SET @query = CONCAT('
			SELECT
				usuario.id_usuario,
				usuario.id_grupo_empresa,
				usuario.id_role,
                IFNULL(trans.nombre_role, role.nombre_role) as nombre_role,
				usuario.usuario,
				usuario.password_usuario,
				usuario.nombre_usuario,
				usuario.paterno_usuario,
				usuario.materno_usuario,
				concat(usuario.nombre_usuario," ",usuario.paterno_usuario," ",usuario.materno_usuario) AS user_alias,
				usuario.estatus_usuario,
				usuario.registra_usuario,
				usuario.fecha_registro_usuario,
				usuario.correo,
                usuario.acceso_ip,
                usuario.acceso_horario,
                usuario.hora_acceso_ini,
				usuario.hora_acceso_fin,
				usuario.id_usuario_mod,
                usuario.id_idioma,
                usuario.fecha_registro_usuario as fecha_mod,
				GROUP_CONCAT(empresa.nom_empresa SEPARATOR ", ") nombre_empresa,
				CONCAT(user.nombre_usuario," ",user.paterno_usuario) usuario_mod
			FROM suite_mig_conf.st_adm_tr_usuario as usuario
            LEFT JOIN st_adm_tr_empresa_usuario emp_user
				ON emp_user.id_usuario = usuario.id_usuario
			INNER JOIN suite_mig_conf.st_adm_tc_role role
				ON role.id_role=usuario.id_role
			LEFT JOIN suite_mig_conf.st_adm_tc_role_trans trans
				ON trans.id_role=usuario.id_role
			AND trans.id_idioma = ?
			LEFT JOIN st_adm_tr_empresa empresa
				ON empresa.id_empresa = emp_user.id_empresa
			INNER JOIN
				suite_mig_conf.st_adm_tr_usuario as user
			WHERE usuario.id_usuario_mod = user.id_usuario
			AND usuario.id_grupo_empresa= ?
            AND  usuario.estatus_usuario != 3',
				lo_usuario,
				lo_nombre_role,
                lo_correo,
                lo_nombre_empresa,
                lo_estatus_usuario,
                lo_consulta_gral,
                ' GROUP BY usuario.id_usuario ',
				lo_order_by,
			' LIMIT ?,?'
	);

    PREPARE stmt FROM @query;
    SET @id_idioma = pr_id_idioma;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_idioma, @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
			SELECT
				COUNT(distinct(usuario.id_usuario))
			INTO
				@pr_rows_tot_table
			FROM suite_mig_conf.st_adm_tr_usuario as usuario
            LEFT JOIN st_adm_tr_empresa_usuario emp_user
				ON emp_user.id_usuario = usuario.id_usuario
			INNER JOIN suite_mig_conf.st_adm_tc_role role
				ON role.id_role=usuario.id_role
			LEFT JOIN suite_mig_conf.st_adm_tc_role_trans trans
				ON trans.id_role=usuario.id_role
			AND trans.id_idioma = ?
			LEFT JOIN st_adm_tr_empresa empresa
				ON empresa.id_empresa = emp_user.id_empresa
			INNER JOIN
				suite_mig_conf.st_adm_tr_usuario as user
			WHERE usuario.id_usuario_mod = user.id_usuario
			AND usuario.id_grupo_empresa= ?',
				lo_usuario,
				lo_nombre_role,
                lo_correo,
                lo_nombre_empresa,
                lo_estatus_usuario,
                lo_consulta_gral
	);
-- select @queryTotalRows;
	PREPARE stmt FROM @queryTotalRows;
	SET @id_idioma = pr_id_idioma;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
	EXECUTE stmt USING @id_idioma, @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table 	= @pr_rows_tot_table;
	SET pr_message 			= 'SUCCESS';
END$$
DELIMITER ;
