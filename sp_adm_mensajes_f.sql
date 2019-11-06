DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_mensajes_f`( 
	IN  pr_id_grupo_empresa		INT,
	IN  pr_id_usuario			INT,
    IN  pr_id_message			INT,
    IN  pr_leido				CHAR(1),
    IN  pr_dias_desde			INT,
    IN  pr_consulta_gral		VARCHAR(500),
	IN  pr_ini_pag				INT,
	IN  pr_fin_pag				INT,
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_adm_mensajes_f
		@fecha 		: 27/07/2019
		@descripcion: SP para filtrar mensajes
		@autor 		: Yazbek Quido
		@cambios 	:
	*/

	DECLARE  lo_id_usuario			VARCHAR(1000) DEFAULT '';
    DECLARE  lo_id_mensaje			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_leido				VARCHAR(1000) DEFAULT '';
    DECLARE  lo_desde				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_consulta_gral  		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_mensajes_f';
	END ;

	IF pr_id_usuario > 0 THEN
		SET lo_id_usuario = CONCAT(' AND msj_user.id_usuario LIKE  "%', pr_id_usuario  , '%" ');
	END IF;

    IF pr_id_message > 0 THEN
		SET lo_id_mensaje = CONCAT(' AND mensaje.id_alertas LIKE  "%', pr_id_message  , '%" ');
	END IF;

    IF pr_leido !='' THEN
		SET lo_leido = CONCAT(' AND msj_user.leido = "', pr_leido, '" ');
	END IF;

    IF pr_dias_desde > 0 THEN
		SET lo_desde = CONCAT(' AND  mensaje.fecha_alta >= DATE_SUB(NOW(),INTERVAL ', pr_dias_desde, ' day) ');
	END IF;

	IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (mensaje.notificacion LIKE "%', pr_consulta_gral, '%"
										OR concat(usuario.nombre_usuario," ",usuario.paterno_usuario)  LIKE "%'			, pr_consulta_gral, '%"
                                        OR mensaje.fecha_alta LIKE "%'	, pr_consulta_gral, '%" ) ');
	END IF;

	SET @query = CONCAT('SELECT
							msj_user.id_alerta_usuarios,
                            msj_user.leido,
                            mensaje.id_alertas,
                            mensaje.notificacion,
                            mensaje.fecha_alta fecha_envio,
                            mensaje.id_usuario id_usuario_emisor,
                            concat(usuario.nombre_usuario," ",
							usuario.paterno_usuario) usuario_emisor
						FROM st_adm_tr_alertas_usuarios msj_user
                        INNER JOIN suite_mig_conf.st_adm_tr_alertas mensaje
							ON mensaje.id_alertas=msj_user.id_alerta
						INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
							ON usuario.id_usuario=mensaje.id_usuario
						WHERE mensaje.id_grupo_empresa = ? ','
						',lo_id_usuario,'
						',lo_id_mensaje,'
                        ',lo_leido,'
						',lo_desde,'
						',lo_consulta_gral,'
						ORDER BY mensaje.fecha_alta DESC LIMIT ?,?'
	);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;





	# START count rows query
	SET @pr_affect_rows = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_affect_rows
					FROM suite_mig_conf.st_adm_tr_alertas_usuarios msj_user
					INNER JOIN suite_mig_conf.st_adm_tr_alertas mensaje
						ON mensaje.id_alertas=msj_user.id_alerta
					INNER JOIN suite_mig_conf.st_adm_tr_usuario usuario
						ON usuario.id_usuario=mensaje.id_usuario
					WHERE mensaje.id_grupo_empresa = ?  ',
						lo_id_usuario,
						lo_leido,
                        lo_consulta_gral,
                        lo_id_mensaje
							);
	-- SELECT @queryTotalRows;
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;


	SET pr_affect_rows	= @pr_affect_rows;
	SET pr_message			= 'SUCCESS';
END$$
DELIMITER ;
