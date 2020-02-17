DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_notificaciones_f`(
	IN  pr_id_grupo_empresa		INT,
	IN  pr_id_usuario			INT,
    IN  pr_id_notificacion		INT,
    IN  pr_leido				CHAR(1),
    IN  pr_dias_desde			INT,
    IN  pr_consulta_gral		VARCHAR(500),
	IN  pr_ini_pag				INT,
	IN  pr_fin_pag				INT,
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_adm_notificaciones_f
		@fecha 		: 14/10/2019
		@descripcion: SP para filtrar notificaciones
		@autor 		: Yazbek Quido
		@cambios 	:
	*/

	DECLARE  lo_id_usuario			VARCHAR(1000) DEFAULT '';
    DECLARE  lo_id_notificacion		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_leido				VARCHAR(1000) DEFAULT '';
    DECLARE  lo_desde				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_consulta_gral  		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_notificaciones_f';
	END ;

    IF pr_id_notificacion > 0 THEN
		SET lo_id_notificacion = CONCAT('AND noty.id_notificacion LIKE  "%', pr_id_notificacion  , '%" ');
	END IF;

    IF pr_leido !='' THEN
		SET lo_leido = CONCAT('AND noty.leido = "', pr_leido, '" ');
	END IF;

    IF pr_dias_desde > 0 THEN
		SET lo_desde = CONCAT('AND  noty.fecha_alta >= DATE_SUB(NOW(),INTERVAL ', pr_dias_desde, ' day) ');
	END IF;

	/*IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (mensaje.notificacion LIKE "%', pr_consulta_gral, '%"
										OR concat(usuario.nombre_usuario," ",usuario.paterno_usuario)  LIKE "%'			, pr_consulta_gral, '%"
                                        OR mensaje.fecha_alta LIKE "%'	, pr_consulta_gral, '%" ) ');
	END IF;*/

	SET @query = CONCAT('
						SELECT
							noty.*,
                            CASE
							WHEN DATEDIFF(NOW(), noty.fecha_alta) = 0 THEN
							CASE
								WHEN HOUR(TIMEDIFF(NOW(), noty.fecha_alta)) > 24 THEN
									''D''
								ELSE
									CASE
										WHEN SUBSTRING(TIMEDIFF(NOW(), noty.fecha_alta), 1, 2) = ''00'' THEN
											''M''
										ELSE
											''H''
										END
									END
								ELSE
									''D''
							END tipo_tiempo,
							CASE
								WHEN DATEDIFF(NOW(), noty.fecha_alta) = 0 THEN
									CASE
										WHEN HOUR(TIMEDIFF(NOW(), noty.fecha_alta)) > 24 THEN
											DATEDIFF(NOW(), noty.fecha_alta)
										ELSE
											CASE
												WHEN SUBSTRING(TIMEDIFF(NOW(), noty.fecha_alta), 1, 2) = ''00'' THEN
													MINUTE(TIMEDIFF(NOW(), noty.fecha_alta))
												ELSE
													HOUR(TIMEDIFF(NOW(), noty.fecha_alta))
											END
									END
								ELSE
									DATEDIFF(NOW(), noty.fecha_alta)
							END tiempo,
                            type.icon,
                            type.clave
						FROM st_adm_tr_notificaciones noty
                        JOIN st_adm_tc_tipo_notificacion type ON
							type.id_tipo_notificacion = noty.id_tipo_notificacion
						WHERE noty.id_grupo_empresa = ?
                        AND noty.id_usuario = ? ','
						',lo_id_notificacion,'
                        ',lo_leido,'
						',lo_desde,'
						',lo_consulta_gral,'
						ORDER BY noty.fecha_alta DESC
                        LIMIT ?,?'
	);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @id_usuario = pr_id_usuario;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @id_usuario, @ini, @fin;
	DEALLOCATE PREPARE stmt;



	# START count rows query
	SET @pr_affect_rows = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_affect_rows
					FROM suite_mig_conf.st_adm_tr_notificaciones noty
					WHERE noty.id_grupo_empresa = ?
                    AND noty.id_usuario = ? ',
					lo_id_usuario,
					lo_leido,
					lo_consulta_gral,
					lo_id_notificacion
					);
	-- SELECT @queryTotalRows;
	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa, @id_usuario;
	DEALLOCATE PREPARE stmt;


	SET pr_affect_rows	= @pr_affect_rows;
	SET pr_message			= 'SUCCESS';
END$$
DELIMITER ;
