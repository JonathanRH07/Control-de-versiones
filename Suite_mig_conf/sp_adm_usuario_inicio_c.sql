DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_inicio_c`(
    IN 	pr_usuario			VARCHAR(100),
    IN 	pr_password_usuario	VARCHAR(256),
    -- IN	pr_tipo_acceso	ENUM('IP', 'MAC'),
    IN 	pr_acceso_ip		VARCHAR(100),
    IN	pr_tipo_usuario		INT,
	OUT pr_message			VARCHAR(500)
    )
BEGIN
/*
	@nombre:		sp_adm_usuario_inicio_c
	@fecha:			06/06/2019
	@descripcion:	SP para buscar usuarios en la tabla usuarios
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_usuario_encontrado		INT DEFAULT 0;
    DECLARE lo_id_grupo_empresa			INT;
    DECLARE lo_id_usuario				INT DEFAULT 0;
    DECLARE lo_usuario					VARCHAR(100);
	DECLARE lo_password_usuario			VARCHAR(256);
    DECLARE lo_id_grupo					INT;
    DECLARE lo_id_empresa				INT;
    DECLARE lo_no_licencias				INT;
    DECLARE lo_count					INT;
    DECLARE lo_inicio_sesion			INT;
    DECLARE lo_intentos_ingreso			INT;
    DECLARE lo_fecha_desbloqueo			DATETIME;
    DECLARE lo_primer_ingreso			INT;
    DECLARE lo_hora_acceso_ini			DATETIME;
	DECLARE lo_hora_acceso_fin			DATETIME;
    DECLARE lo_acceso_ip				INT;
    DECLARE lo_acceso_horario			INT;
    DECLARE lo_mensaje					VARCHAR(100);

    DECLARE lo_usuario_encontrado2		INT DEFAULT 0;
	DECLARE lo_id_grupo_empresa2		INT;
	DECLARE lo_id_usuario2				INT DEFAULT 0;
    DECLARE lo_intentos_ingreso2		INT;
    DECLARE lo_fecha_desbloqueo2		DATETIME;
    DECLARE lo_primer_ingreso2			INT;
	DECLARE lo_hora_acceso_ini2			DATETIME;
	DECLARE lo_hora_acceso_fin2			DATETIME;
	DECLARE lo_acceso_ip2				INT;
	DECLARE lo_acceso_horario2			INT;
    DECLARE lo_estatus_usuario			VARCHAR(75); -- ENUM('ACTIVO', 'INACTIVO', 'SLICENCIA', 'FALTAPAGO');

    DECLARE lo_id_usuario_primer		INT DEFAULT NULL;
    DECLARE	lo_correo					VARCHAR(100) DEFAULT NULL;
    DECLARE lo_contador_acceso_ip		INT DEFAULT 0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_inicio_c';
        ROLLBACK;
	END ;

	/* CONSULTA DE USUARIO SI EXISTE */
	SELECT
		IFNULL(COUNT(*),0),
		id_grupo_empresa,
		id_usuario,
		inicio_sesion,
		intentos_ingreso,
		fecha_desbloqueo,
		primer_ingreso,
		hora_acceso_ini,
		hora_acceso_fin,
		acceso_ip,
		acceso_horario,
		estatus_usuario
	INTO
		lo_usuario_encontrado,
		lo_id_grupo_empresa,
		lo_id_usuario,
		lo_inicio_sesion,
		lo_intentos_ingreso,
		lo_fecha_desbloqueo,
		lo_primer_ingreso,
		lo_hora_acceso_ini,
		lo_hora_acceso_fin,
		lo_acceso_ip,
		lo_acceso_horario,
		lo_estatus_usuario
	FROM st_adm_tr_usuario
	WHERE usuario = BINARY pr_usuario
	AND tipo_usuario = pr_tipo_usuario
	AND password_usuario = pr_password_usuario;
	-- AND estatus_usuario = 1;

    /* CONSULTA EN CASO DE QUE LA CONTRASEÑA NO CORRECTA */
    IF lo_usuario_encontrado = 0 THEN
		SELECT
			IFNULL(COUNT(*),0),
			id_grupo_empresa,
			id_usuario,
			usuario,
			password_usuario,
            intentos_ingreso,
            fecha_desbloqueo,
            estatus_usuario
		INTO
			lo_usuario_encontrado2,
			lo_id_grupo_empresa,
			lo_id_usuario2,
			lo_usuario,
			lo_password_usuario,
			lo_intentos_ingreso2,
			lo_fecha_desbloqueo2,
            lo_estatus_usuario
		FROM st_adm_tr_usuario
		WHERE usuario = BINARY(pr_usuario);
		-- AND estatus_usuario = 1;
    END IF;

    /* CONSULTA DEL GRUPO DEL USUARIO */
	SELECT
		id_grupo,
        id_empresa
	INTO
		lo_id_grupo,
        lo_id_empresa
	FROM st_adm_tr_grupo_empresa
	WHERE id_grupo_empresa = lo_id_grupo_empresa;

	/* CONSULTA DE LICENCIAS DE USUARIO POR GRUPO */
	SELECT
		no_licencias
	INTO
		lo_no_licencias
	FROM st_adm_tr_grupo
	WHERE id_grupo = lo_id_grupo;

    /* CONTADOR DE USUARIO ACTIVOS DEL GRUPO */
    SELECT
		COUNT(*)
	INTO
		lo_count
	FROM st_adm_tr_usuario
	WHERE id_grupo_empresa = lo_id_grupo_empresa
	AND inicio_sesion > 0;

    IF lo_usuario_encontrado > 0 THEN

		/* OBTENER IP's DE ACCESO */
		SET @lo_contador_acceso_ip = 0;
		SET @queryips = CONCAT(
						'
						SELECT
							IFNULL(COUNT(*),0)
						INTO
							@lo_contador_acceso_ip
						FROM st_adm_tr_usuario_acceso
						WHERE id_usuario = ',lo_id_usuario,'
						AND id_empresa = ',lo_id_empresa,'
						AND estatus_acceso = 1
						AND acceso_por LIKE ''%',pr_acceso_ip,'%''
						LIMIT 1');

		-- SELECT @queryips;
		PREPARE stmt FROM @queryips;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET lo_contador_acceso_ip = @lo_contador_acceso_ip ;

	END IF;

    /*
    LISTA DE ERRORES
	(-1) USUARIO INEXISTENTE
    (1) INICIA SESION
    (2) MAXIMO USUARIOS CONECTADOS POR GRUPO
    (3) USUARIO YA CONECTADO
    (4) PRIMERA VEZ -Cambio de contraseña-
    (5) CAMBIO DE CONTRASEÑA
    (6) MAXIMO DE INTENTOS ERRONEOS
    (7) USUARIO BLOQUEADO
    (8) USUARIO FUERA DE HORARIO
    (9) IP INCORRECTA
    (10) SIN LICENCIA
    */

    START TRANSACTION;
    IF lo_estatus_usuario != 'SLICENCIA' THEN
		/* EN CASO DE QUE LA CONTRASEÑA Y USUARIO ESTEN INGRESADOS CORRECTAMENTE */
		IF lo_usuario_encontrado > 0 AND lo_estatus_usuario = 'ACTIVO' THEN
			/* VALIDAR LA SI TIENE ACCESO POR IP */
			IF lo_acceso_ip > 0 THEN
				IF lo_contador_acceso_ip > 0 THEN
					/* VALIDAR QUE EL USUARIO NO SEA NUEVO */
					IF lo_primer_ingreso = 0 THEN
						/* VALIDAMOS QUE NO TENGA RESTRINCION DE HORARIO */
						IF lo_acceso_horario = 0 THEN
							/* VALIDAMOS QUE EL USUARIO NO ESTE CONECTADO ANTERIORMENTE Y NO ESTE BLOQUEADO*/
							IF lo_inicio_sesion = 0 THEN
								IF lo_intentos_ingreso < 3 THEN
									/* VALIDAR QUE NO SOBREPASE EL NUMERO DE LICENCIAS POR GRUPO */
									IF lo_count < lo_no_licencias THEN
										/* INICIAR SESION */
										SET lo_mensaje = '1';

										/* RESTABLECEMOS INTENTOS DE CONEXION Y EL CAMPO DE INICIO DE SESION*/
										UPDATE st_adm_tr_usuario
										SET intentos_ingreso = 0,
											inicio_sesion = 1,
											fecha_desbloqueo = NULL,
											fecha_ult_conexion = NOW()
										WHERE id_usuario = lo_id_usuario;

									ELSE

										/* DE LO CONTRARIO MANDA EL ERROR: 'Hay demasiados usuarios conectados' */
										SET lo_mensaje = '2';
									END IF;

								ELSEIF lo_intentos_ingreso = 3 AND lo_fecha_desbloqueo > NOW() THEN
									/* MANDAMOS EL ERROR: El usuario esta bloqueado */
									SET lo_mensaje = '7';

									SELECT
										correo
									INTO
										lo_correo
									FROM st_adm_tr_usuario
									WHERE id_usuario = lo_id_usuario;

								ELSEIF lo_intentos_ingreso = 3 AND lo_fecha_desbloqueo <= NOW() THEN
									/* ACTUALIZAR LA HORA DE DESBLOQUEO */
									UPDATE st_adm_tr_usuario
									SET fecha_desbloqueo = NULL,
										inicio_sesion = 1,
										fecha_ult_conexion = NOW()
									WHERE id_usuario = lo_id_usuario;

									/* RESTABLECEMOS INTENTOS DE CONEXION */
									UPDATE st_adm_tr_usuario
									SET intentos_ingreso = 0
									WHERE id_usuario = lo_id_usuario;

									/* INICIAR SESION */
									SET lo_mensaje = '1';
								END IF;
							ELSE
								/* DE LO CONTRARIO MANDA EL ERROR: 'El Usuario ya se encuentra conectado' */
								SET lo_mensaje = '3';
							END IF; /* ------------------------------------- */
						ELSE
							/* EN CASO DE QUE TENGA RESTRINCION DE HORARIO SE VALIDA ESTE MISMO */
							IF lo_inicio_sesion = 0 AND lo_intentos_ingreso < 3 AND DATE_FORMAT(NOW(), '%H:%i:%S') >= DATE_FORMAT(lo_hora_acceso_ini, '%H:%i:%S') AND DATE_FORMAT(NOW(), '%H:%i:%S') <= DATE_FORMAT(lo_hora_acceso_fin, '%H:%i:%S') THEN
								/* ACTUALIZAR LA HORA DE DESBLOQUEO */
								UPDATE st_adm_tr_usuario
								SET fecha_desbloqueo = NULL,
									inicio_sesion = 1,
									fecha_ult_conexion = NOW()
								WHERE id_usuario = lo_id_usuario;
								/* RESTABLECEMOS INTENTOS DE CONEXION */
								UPDATE st_adm_tr_usuario
								SET intentos_ingreso = 0
								WHERE id_usuario = lo_id_usuario;

								/* SI ESTA EN HORARIO SE INICIA SESION */
								SET lo_mensaje = '1';

							ELSEIF lo_inicio_sesion = 0 AND lo_intentos_ingreso = 3 AND lo_fecha_desbloqueo > NOW() THEN
								SELECT
									correo
								INTO
									lo_correo
								FROM st_adm_tr_usuario
								WHERE id_usuario = lo_id_usuario;

								/* DE LO CONTRARIO MANDA EL ERROR: 'El Usuario esta bloqueado' */
								SET lo_mensaje = '7';

							ELSEIF lo_inicio_sesion = 0 AND lo_intentos_ingreso = 3 AND lo_fecha_desbloqueo <= NOW() THEN
								/* ACTUALIZAR LA HORA DE DESBLOQUEO */
								UPDATE st_adm_tr_usuario
								SET fecha_desbloqueo = NULL,
									inicio_sesion = 1,
									fecha_ult_conexion = NOW()
								WHERE id_usuario = lo_id_usuario;
								/* RESTABLECEMOS INTENTOS DE CONEXION */
								UPDATE st_adm_tr_usuario
								SET intentos_ingreso = 0
								WHERE id_usuario = lo_id_usuario;

								/* INICIAR SESION */
								SET lo_mensaje = '1';

							ELSEIF lo_inicio_sesion = 1 THEN
								/* DE LO CONTRARIO MANDA EL ERROR: 'El Usuario ya se encuentra conectado' */
								SET lo_mensaje = '3';
							ELSE
								/* SI ESTA FUERA DEL HORARIO SE MANDA MENSAJE DE ERROR 'usuario fuera de horario' */
								SET lo_mensaje = '8';
								UPDATE st_adm_tr_usuario
								SET inicio_sesion = 0
								WHERE id_usuario = lo_id_usuario;
							END IF;
						END IF;
					ELSE
						/* MANDAR MENSAJE 'Cambio de contraseña' */
						SET lo_mensaje = '5';
						SET lo_id_usuario_primer = lo_id_usuario;
					END IF;
				ELSE
					SET lo_mensaje = '9';
				END IF;
			ELSE
				/* VALIDAR QUE EL USUARIO NO SEA NUEVO */
				IF lo_primer_ingreso = 0 THEN
					/* VALIDAMOS QUE NO TENGA RESTRINCION DE HORARIO */
					IF lo_acceso_horario = 0 THEN
						/* VALIDAMOS QUE EL USUARIO NO ESTE CONECTADO ANTERIORMENTE Y NO ESTE BLOQUEADO*/
						IF lo_inicio_sesion = 0 AND lo_intentos_ingreso < 3 THEN
							/* VALIDAR QUE NO SOBREPASE EL NUMERO DE LICENCIAS POR GRUPO */
							IF lo_count < lo_no_licencias THEN
								/* INICIAR SESION */
								SET lo_mensaje = '1';

								/* CAMBIAMOS EL CAMPO DE INICIO DE SESION */
								UPDATE st_adm_tr_usuario
								SET inicio_sesion = 1,
									fecha_desbloqueo = NULL,
									fecha_ult_conexion = NOW()
								WHERE id_usuario = lo_id_usuario;
								/* RESTABLECEMOS INTENTOS DE CONEXION */
								UPDATE st_adm_tr_usuario
								SET intentos_ingreso = 0
								WHERE id_usuario = lo_id_usuario;

							ELSE
								/* DE LO CONTRARIO MANDA EL ERROR: 'Hay demasiados usuarios conectados' */
								SET lo_mensaje = '2';
							END IF;

						ELSEIF lo_inicio_sesion = 0 AND lo_intentos_ingreso = 3 AND lo_fecha_desbloqueo > NOW() THEN
							/* MANDAMOS EL ERROR: El usuario esta bloqueado */
							SET lo_mensaje = '7';
							SELECT
								correo
							INTO
								lo_correo
							FROM st_adm_tr_usuario
							WHERE id_usuario = lo_id_usuario;

						ELSEIF lo_inicio_sesion = 0 AND lo_intentos_ingreso = 3 AND lo_fecha_desbloqueo <= NOW() THEN
							/* ACTUALIZAR LA HORA DE DESBLOQUEO */
							UPDATE st_adm_tr_usuario
							SET fecha_desbloqueo = NULL,
								inicio_sesion = 1,
								fecha_ult_conexion = NOW()
							WHERE id_usuario = lo_id_usuario;
							/* RESTABLECEMOS INTENTOS DE CONEXION */
							UPDATE st_adm_tr_usuario
							SET intentos_ingreso = 0
							WHERE id_usuario = lo_id_usuario;

							/* INICIAR SESION */
							SET lo_mensaje = '1';
						ELSE
							/* DE LO CONTRARIO MANDA EL ERROR: 'El Usuario ya se encuentra conectado' */
							SET lo_mensaje = '3';
						END IF;
					ELSE
						/* EN CASO DE QUE TENGA RESTRINCION DE HORARIO SE VALIDA ESTE MISMO */
						IF lo_inicio_sesion = 0 AND lo_intentos_ingreso < 3 AND DATE_FORMAT(NOW(), '%H:%i:%S') >= DATE_FORMAT(lo_hora_acceso_ini, '%H:%i:%S') AND DATE_FORMAT(NOW(), '%H:%i:%S') <= DATE_FORMAT(lo_hora_acceso_fin, '%H:%i:%S') THEN
							/* ACTUALIZAR LA HORA DE DESBLOQUEO */
							UPDATE st_adm_tr_usuario
							SET fecha_desbloqueo = NULL,
								inicio_sesion = 1,
								fecha_ult_conexion = NOW()
							WHERE id_usuario = lo_id_usuario;
							/* RESTABLECEMOS INTENTOS DE CONEXION */
							UPDATE st_adm_tr_usuario
							SET intentos_ingreso = 0
							WHERE id_usuario = lo_id_usuario;

							/* SI ESTA EN HORARIO SE INICIA SESION */
							SET lo_mensaje = '1';

						ELSEIF lo_inicio_sesion = 0 AND lo_intentos_ingreso = 3 AND lo_fecha_desbloqueo > NOW() THEN
							SELECT
								correo
							INTO
								lo_correo
							FROM st_adm_tr_usuario
							WHERE id_usuario = lo_id_usuario;

							/* DE LO CONTRARIO MANDA EL ERROR: 'El Usuario esta bloqueado' */
							SET lo_mensaje = '7';

						ELSEIF lo_inicio_sesion = 0 AND lo_intentos_ingreso = 3 AND lo_fecha_desbloqueo <= NOW() THEN
							/* ACTUALIZAR LA HORA DE DESBLOQUEO */
							UPDATE st_adm_tr_usuario
							SET fecha_desbloqueo = NULL,
								inicio_sesion = 1,
								fecha_ult_conexion = NOW()
							WHERE id_usuario = lo_id_usuario;
							/* RESTABLECEMOS INTENTOS DE CONEXION */
							UPDATE st_adm_tr_usuario
							SET intentos_ingreso = 0
							WHERE id_usuario = lo_id_usuario;

							/* INICIAR SESION */
							SET lo_mensaje = '1';

						ELSEIF lo_inicio_sesion = 1 THEN
							/* DE LO CONTRARIO MANDA EL ERROR: 'El Usuario ya se encuentra conectado' */
							SET lo_mensaje = '3';
						ELSE
							/* SI ESTA FUERA DEL HORARIO SE MANDA MENSAJE DE ERROR 'usuario fuera de horario' */
							SET lo_mensaje = '8';
							UPDATE st_adm_tr_usuario
							SET inicio_sesion = 0
							WHERE id_usuario = lo_id_usuario;
						END IF;
					END IF;
				ELSE
					/* MANDAR MENSAJE 'Cambio de contraseña' */
					SET lo_mensaje = '5';
					SET lo_id_usuario_primer = lo_id_usuario;
				END IF;
			END IF;

		/* EN CASO DE CONTRASEÑA INCORRECTA  */
		ELSEIF lo_usuario_encontrado = 0 AND lo_usuario_encontrado2 > 0 AND lo_estatus_usuario = 'ACTIVO' THEN

			/* VALIDAMOS QUE EL USUARIO ESTE NO TENGA MAS DE 2 INTENTOS ERRONEOS DE INICIO DE SESION */
			IF lo_intentos_ingreso2 = 0 THEN
				/* ACTUALIZAMOS EL CAMPO DE INTENTOS DE INGRESO */
				UPDATE st_adm_tr_usuario
				SET intentos_ingreso = (intentos_ingreso + 1)
				WHERE id_usuario = lo_id_usuario2;

				SET lo_mensaje = '-1';

			ELSEIF lo_intentos_ingreso2 = 1 THEN
				/* SE MUESTRA EL ERROR 'El Usuario esta a punto de ser bloqueado' */
				SET lo_mensaje = '6';
				/* ACTUALIZAMOS EL CAMPO DE INTENTOS DE INGRESO */
				UPDATE st_adm_tr_usuario
				SET intentos_ingreso = (intentos_ingreso + 1)
				WHERE id_usuario = lo_id_usuario2;

			ELSEIF lo_intentos_ingreso2 = 2 THEN

				/* ACTUALIZAMOS EL CAMPO DE INTENTOS DE INGRESO */
				UPDATE st_adm_tr_usuario
				SET intentos_ingreso = (intentos_ingreso + 1)
				WHERE id_usuario = lo_id_usuario2;

				/* ACTUALIZAR LA HORA DE DESBLOQUEO */
				UPDATE st_adm_tr_usuario
				SET fecha_desbloqueo = DATE_ADD(NOW(), INTERVAL 15 MINUTE)
				WHERE id_usuario = lo_id_usuario2;

				SELECT
					fecha_desbloqueo
				INTO
					lo_fecha_desbloqueo
				FROM st_adm_tr_usuario
				WHERE id_usuario = lo_id_usuario2;

				/* DE LO CONTRARIO MANDA EL ERROR: 'El Usuario esta bloqueado' */
				SET lo_mensaje = '7';

				/* OBTENEMOS EL CORREO */
				SELECT
					correo
				INTO
					lo_correo
				FROM st_adm_tr_usuario
				WHERE id_usuario = lo_id_usuario2;
			ELSE
				/* DE LO CONTRARIO MANDA EL ERROR: 'Usuario no encontrado' */
				SET lo_mensaje = '-1';
			END IF;
		ELSE
			/* DE LO CONTRARIO MANDA EL ERROR: 'Usuario no encontrado' */
			SET lo_mensaje = '-1';
		END IF;
	ELSEIF lo_estatus_usuario IS NULL THEN
		SET lo_mensaje = '-1';
    ELSE
		SET lo_mensaje = '10';
    END IF;

    SELECT lo_mensaje,TIMEDIFF(IFNULL(lo_fecha_desbloqueo2,lo_fecha_desbloqueo),NOW()) fecha_desbloqueo, lo_id_usuario_primer id_usuario, lo_correo correo;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
    COMMIT;
END$$
DELIMITER ;
