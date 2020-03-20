DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_b`(
	IN  pr_id_grupo_empresa			INT(11),
	IN  pr_consulta_gral			VARCHAR(200),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
	IN  pr_order_by					VARCHAR(100),
	OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000))
BEGIN
/*
	@nombre:		sp_adm_usuario_sucursal_b
	@fecha:			02/12/2016
	@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en la tabla usuario_sucursal
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_consulta_gral  			VARCHAR(2000) DEFAULT '';
	DECLARE lo_estatus_grupo_fit		VARCHAR(200) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';
	DECLARE lo_first_select				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_sucursal_b';
	END ;

	IF ( pr_consulta_gral !='' ) THEN
			SET lo_consulta_gral = CONCAT(' AND (usuario.nombre_usuario  LIKE "%'	, pr_consulta_gral, '%"
											OR usuario.paterno_usuario LIKE "%'		, pr_consulta_gral, '%"
                                            OR usuario.materno_usuario LIKE "%'		, pr_consulta_gral, '%"
											OR role.nombre_role LIKE "%'			, pr_consulta_gral, '%"
                                            OR usuario.correo LIKE "%'				, pr_consulta_gral, '%"
                                            OR usuario.estatus_usuario LIKE "%'		, pr_consulta_gral, '%" ) ');

	ELSE
		SET lo_first_select = ' AND usuario.estatus_usuario = "ACTIVO" ';
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SET @query = CONCAT('SELECT
							usuario.id_usuario,
							usuario.id_grupo_empresa,
							role.id_role,
							role.nombre_role,
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
                            usuario.hora_acceso_ini,
							usuario.hora_acceso_fin,
                            usuario.acceso_ip,
                            usuario.acceso_horario,
							usuario.id_usuario_mod,
                            usuario.id_idioma,
							fecha_mod,
							concat(user.nombre_usuario," ",user.paterno_usuario) usuario_mod
						FROM suite_mig_conf.st_adm_tr_usuario as usuario
						INNER JOIN suite_mig_conf.st_adm_tr_usuario as user
						INNER JOIN suite_mig_conf.st_adm_tc_role AS role
							ON role.id_role=usuario.id_role
						WHERE usuario.id_usuario_mod = user.id_usuario
						AND usuario.id_grupo_empresa= ?
                        AND  usuario.estatus_usuario != 3'
							,lo_first_select
							,lo_consulta_gral
							,lo_order_by
							,'LIMIT ?,?');

	-- PREPARE stmt FROM @query;
    PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;

    # START count rows query
	SET @pr_rows_tot_table = '';

	SET @queryTotalRows = CONCAT('	SELECT
										COUNT(*)
									INTO
										@pr_rows_tot_table
										-- concat(st_adm_tr_usuario.nombre_usuario," ",st_adm_tr_usuario.paterno_usuario) usuario_mod
									FROM suite_mig_conf.st_adm_tr_usuario as usuario
									INNER JOIN
										suite_mig_conf.st_adm_tr_usuario as user
									INNER JOIN suite_mig_conf.st_adm_tc_role AS role
										ON role.id_role=usuario.id_role
									WHERE usuario.id_usuario_mod = user.id_usuario
									AND usuario.id_grupo_empresa= ?'
									,lo_first_select
									,lo_consulta_gral);

	PREPARE stmt
    FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
     # Mensaje de ejecucion.
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
