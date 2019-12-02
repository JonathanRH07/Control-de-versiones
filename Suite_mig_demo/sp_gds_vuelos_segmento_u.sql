DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_segmento_u`(
	IN  pr_id_gds_vuelos_segmento 					INT(11),
	IN  pr_id_acred 								INT(11),
	IN  pr_clave_linea_area 						CHAR(2),
	IN  pr_numero_vuelo 							BIGINT(11),
	IN  pr_cve_airport_origen 						CHAR(4),
	IN  pr_cve_airport_destino 						CHAR(4),
	IN  pr_nombre_ciudad_origen 					VARCHAR(30),
	IN  pr_nombre_ciudad_destino 					VARCHAR(30),
	IN  pr_tarifa_regular 							DECIMAL(15,2),
	IN  pr_tarifa_ofrecida 							DECIMAL(15,2),
	IN  pr_codigo_razon 							VARCHAR(10),
	IN  pr_cve_origen 								CHAR(4),
	IN  pr_cve_clase_reserva 						CHAR(1),
	IN  pr_cve_clase_equiva 						CHAR(1),
	IN  pr_intdom 									CHAR(1),
	IN  pr_consecutivo 								INT(11),
    IN  pr_fecha_salida 							DATE,
	IN  pr_hora_salida 								TIME,
	IN  pr_hora_llegada 							TIME,
	IN  pr_servicio_comida 							CHAR(3),
	IN  pr_equipo 									CHAR(3),
	IN  pr_millas 									BIGINT(11),
	IN  pr_millas_pax_frecuente 					BIGINT(11),
	IN  pr_no_escalas 								CHAR(1),
	IN  pr_cambio_fecha_llegada 					CHAR(1),
	IN  pr_tarifa_segmento 							DECIMAL(18,6),
	IN  pr_numero_segmento 							BIGINT(20),
	IN  pr_conexion 								CHAR(1),
	IN  pr_cargo_combustible 						DECIMAL(15,2),
	IN  pr_cargo_seguridad 							DECIMAL(15,2),
	IN  pr_terminal_salida 							VARCHAR(26),
	IN  pr_puerta_salida 							CHAR(4),
	IN  pr_terminal_llegada 						VARCHAR(26),
	IN  pr_puerta_llegada 							CHAR(4),
	IN  pr_asiento 									CHAR(4),
	IN  pr_duracion_vuelo 							CHAR(8),
	IN  pr_pnr_la 									CHAR(8),
	IN  pr_year 									CHAR(5),
	IN  pr_fare_basis 								VARCHAR(10),
	IN  pr_id_usuario 								INT,
	OUT pr_affect_rows	        					INT,
	OUT pr_message		        					VARCHAR(500))
BEGIN
	/*
	@nombre:		sp_cat_cliente_contable_u
	@fecha:			04/01/2017
	@descripcion:	SP para actualizar registros en Cliente_contable
	@autor:			Griselda Medina Medina
	@cambios:
	*/

	#Declaracion de variables.
	DECLARE lo_id_acred 							VARCHAR(200) DEFAULT '';
	DECLARE lo_clave_linea_area 					VARCHAR(200) DEFAULT '';
	DECLARE lo_numero_vuelo 						VARCHAR(200) DEFAULT '';
	DECLARE lo_cve_airport_origen 					VARCHAR(200) DEFAULT '';
	DECLARE lo_cve_airport_destino 					VARCHAR(200) DEFAULT '';
	DECLARE lo_nombre_ciudad_origen 				VARCHAR(200) DEFAULT '';
	DECLARE lo_nombre_ciudad_destino 				VARCHAR(200) DEFAULT '';
	DECLARE lo_tarifa_regular 						VARCHAR(200) DEFAULT '';
	DECLARE lo_tarifa_ofrecida 						VARCHAR(200) DEFAULT '';
	DECLARE lo_codigo_razon 						VARCHAR(200) DEFAULT '';
	DECLARE lo_cve_origen 							VARCHAR(200) DEFAULT '';
	DECLARE lo_cve_clase_reserva 					VARCHAR(200) DEFAULT '';
	DECLARE lo_cve_clase_equiva 					VARCHAR(200) DEFAULT '';
	DECLARE lo_intdom 								VARCHAR(200) DEFAULT '';
	DECLARE lo_consecutivo 							VARCHAR(200) DEFAULT '';
	DECLARE lo_fecha_salida 						VARCHAR(200) DEFAULT '';
	DECLARE lo_hora_salida 							VARCHAR(200) DEFAULT '';
	DECLARE lo_hora_llegada 						VARCHAR(200) DEFAULT '';
	DECLARE lo_servicio_comida 						VARCHAR(200) DEFAULT '';
	DECLARE lo_equipo 								VARCHAR(200) DEFAULT '';
	DECLARE lo_millas 								VARCHAR(200) DEFAULT '';
	DECLARE lo_millas_pax_frecuente 				VARCHAR(200) DEFAULT '';
	DECLARE lo_no_escalas 							VARCHAR(200) DEFAULT '';
	DECLARE lo_cambio_fecha_llegada 				VARCHAR(200) DEFAULT '';
	DECLARE lo_tarifa_segmento 						VARCHAR(200) DEFAULT '';
	DECLARE lo_numero_segmento 						VARCHAR(1000) DEFAULT '';
	DECLARE lo_conexion 							VARCHAR(200) DEFAULT '';
	DECLARE lo_cargo_combustible 					VARCHAR(200) DEFAULT '';
	DECLARE lo_cargo_seguridad 						VARCHAR(200) DEFAULT '';
	DECLARE lo_terminal_salida 						VARCHAR(200) DEFAULT '';
	DECLARE lo_puerta_salida 						VARCHAR(200) DEFAULT '';
	DECLARE lo_terminal_llegada 					VARCHAR(200) DEFAULT '';
	DECLARE lo_puerta_llegada 						VARCHAR(200) DEFAULT '';
	DECLARE lo_asiento 								VARCHAR(200) DEFAULT '';
	DECLARE lo_duracion_vuelo 						VARCHAR(200) DEFAULT '';
	DECLARE lo_pnr_la 								VARCHAR(200) DEFAULT '';
	DECLARE lo_year 								VARCHAR(200) DEFAULT '';
	DECLARE lo_fare_basis 							VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_vuelos_segmento_u';
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

	IF pr_id_acred > 0 THEN
		SET lo_id_acred = CONCAT('id_acred = ', pr_id_acred, ',');
	END IF;

	IF pr_clave_linea_area != '' THEN
		SET lo_clave_linea_area = CONCAT('clave_linea_area = ''', pr_clave_linea_area, ''',');
	END IF;

	IF pr_numero_vuelo > 0 THEN
		SET lo_numero_vuelo = CONCAT('numero_vuelo = ', pr_numero_vuelo, ',');
	END IF;

	IF pr_cve_airport_origen != '' THEN
		SET lo_cve_airport_origen = CONCAT('cve_airport_origen = ''', pr_cve_airport_origen, ''',');
	END IF;

	IF pr_cve_airport_destino != '' THEN
		SET lo_cve_airport_destino = CONCAT('cve_airport_destino = ''', pr_cve_airport_destino, ''',');
	END IF;

	IF pr_nombre_ciudad_origen != '' THEN
		SET lo_nombre_ciudad_origen = CONCAT('nombre_ciudad_origen = ''', pr_nombre_ciudad_origen, ''',');
	END IF;

	IF pr_nombre_ciudad_destino != '' THEN
		SET lo_nombre_ciudad_destino = CONCAT('nombre_ciudad_destino = ''', pr_nombre_ciudad_destino, ''',');
	END IF;

	IF pr_tarifa_regular > 0 THEN
		SET lo_tarifa_regular = CONCAT('tarifa_regular = ', pr_tarifa_regular, ',');
	END IF;

	IF pr_tarifa_ofrecida > 0 THEN
		SET lo_tarifa_ofrecida = CONCAT('tarifa_ofrecida = ', pr_tarifa_ofrecida, ',');
	END IF;

	IF pr_codigo_razon != '' THEN
		SET lo_codigo_razon = CONCAT('codigo_razon = ''', pr_codigo_razon, ''',');
	END IF;

	IF pr_cve_origen != '' THEN
		SET lo_cve_origen = CONCAT('cve_origen = ''', pr_cve_origen, ''',');
	END IF;

	IF pr_cve_clase_reserva != '' THEN
		SET lo_cve_clase_reserva = CONCAT('cve_clase_reserva = ''', pr_cve_clase_reserva, ''',');
	END IF;

	IF pr_cve_clase_equiva != '' THEN
		SET lo_cve_clase_equiva = CONCAT('cve_clase_equiva = ''', pr_cve_clase_equiva, ''',');
	END IF;

	IF pr_intdom != '' THEN
		SET lo_intdom = CONCAT('intdom = ''', pr_intdom, ''',');
	END IF;

	IF pr_consecutivo > 0 THEN
		SET lo_consecutivo = CONCAT('consecutivo = ', pr_consecutivo, ',');
	END IF;

	IF pr_fecha_salida != '0000-00-00' THEN
		SET lo_fecha_salida = CONCAT('fecha_salida = ''', pr_fecha_salida, ''',');
	END IF;

    IF pr_hora_salida != '00:00:00' AND pr_hora_salida !='' THEN
		SET lo_hora_salida = CONCAT('hora_salida = ''', pr_hora_salida ,''',');
	ELSE
		SET lo_hora_salida = CONCAT('hora_salida = NULL ,');
	END IF;

    IF pr_hora_llegada != '00:00:00' AND pr_hora_llegada !='' THEN
		SET lo_hora_llegada = CONCAT('hora_llegada = ''', pr_hora_llegada ,''',');
	ELSE
		SET lo_hora_llegada = CONCAT('hora_llegada = NULL ,');
	END IF;

	IF pr_servicio_comida != '' THEN
		SET lo_servicio_comida = CONCAT('servicio_comida = ''', pr_servicio_comida, ''',');
	END IF;

	IF pr_equipo != '' THEN
		SET lo_equipo = CONCAT('equipo = ''', pr_equipo, ''',');
	END IF;

	IF pr_millas > 0 THEN
		SET lo_millas = CONCAT('millas = ', pr_millas, ',');
	END IF;

	IF pr_millas_pax_frecuente > 0 THEN
		SET lo_millas_pax_frecuente = CONCAT('millas_pax_frecuente = ', pr_millas_pax_frecuente, ',');
	END IF;

	IF pr_no_escalas != '' THEN
		SET lo_no_escalas = CONCAT('no_escalas = ''', pr_no_escalas, ''',');
	END IF;

	IF pr_cambio_fecha_llegada != '' THEN
		SET lo_cambio_fecha_llegada = CONCAT('cambio_fecha_llegada = ''', pr_cambio_fecha_llegada, ''',');
	END IF;

	IF pr_tarifa_segmento > 0 THEN
		SET lo_tarifa_segmento = CONCAT('tarifa_segmento = ', pr_tarifa_segmento, ',');
	END IF;

	IF pr_numero_segmento > 0 THEN
		SET lo_numero_segmento = CONCAT('numero_segmento = ', pr_numero_segmento, ',');
	END IF;

	IF pr_conexion != '' THEN
		SET lo_conexion = CONCAT('conexion = ''', pr_conexion, ''',');
	END IF;

	IF pr_cargo_combustible > 0 THEN
		SET lo_cargo_combustible = CONCAT('cargo_combustible = ', pr_cargo_combustible, ',');
	END IF;

	IF pr_cargo_seguridad > 0 THEN
		SET lo_cargo_seguridad = CONCAT('cargo_seguridad = ', pr_cargo_seguridad, ',');
	END IF;

	IF pr_terminal_salida != '' THEN
		SET lo_terminal_salida = CONCAT('terminal_salida = ''', pr_terminal_salida, ''',');
	END IF;

	IF pr_puerta_salida != '' THEN
		SET lo_puerta_salida = CONCAT('puerta_salida = ''', pr_puerta_salida, ''',');
	END IF;

	IF pr_terminal_llegada != '' THEN
		SET lo_terminal_llegada = CONCAT('terminal_llegada = ''', pr_terminal_llegada, ''',');
	END IF;

	IF pr_puerta_llegada != '' THEN
		SET lo_puerta_llegada = CONCAT('puerta_llegada = ''', pr_puerta_llegada, ''',');
	END IF;

	IF pr_asiento != '' THEN
		SET lo_asiento = CONCAT('asiento = ''', pr_asiento, ''',');
	END IF;

	IF pr_duracion_vuelo != '' THEN
		SET lo_duracion_vuelo = CONCAT('duracion_vuelo = ''', pr_duracion_vuelo, ''',');
	END IF;

	IF pr_pnr_la != '' THEN
		SET lo_pnr_la = CONCAT('pnr_la = ''', pr_pnr_la, ''',');
	END IF;

	IF pr_year != '' THEN
		SET lo_year = CONCAT('year = ''', pr_year, ''',');
	END IF;

	IF pr_fare_basis != '' THEN
		SET lo_fare_basis = CONCAT('fare_basis = ''', pr_fare_basis, ''',');
	END IF;

	SET @query = CONCAT('
		UPDATE ic_gds_tr_vuelos_segmento
			SET ',
				lo_id_acred,
				lo_clave_linea_area,
				lo_numero_vuelo,
				lo_cve_airport_origen,
				lo_cve_airport_destino,
				lo_nombre_ciudad_origen,
				lo_nombre_ciudad_destino,
				lo_tarifa_regular,
				lo_tarifa_ofrecida,
				lo_codigo_razon,
				lo_cve_origen,
				lo_cve_clase_reserva,
				lo_cve_clase_equiva,
				lo_intdom,
				lo_consecutivo,
				lo_fecha_salida,
				lo_hora_salida,
				lo_hora_llegada,
				lo_servicio_comida,
				lo_equipo,
				lo_millas,
				lo_millas_pax_frecuente,
				lo_no_escalas,
				lo_cambio_fecha_llegada,
				lo_tarifa_segmento,
				lo_numero_segmento,
				lo_conexion,
				lo_cargo_combustible,
				lo_cargo_seguridad,
				lo_terminal_salida,
				lo_puerta_salida,
				lo_terminal_llegada,
				lo_puerta_llegada,
				lo_asiento,
				lo_duracion_vuelo,
				lo_pnr_la,
				lo_year,
				lo_fare_basis,
				' id_usuario = ',pr_id_usuario,
				', fecha_mod = NOW()
			WHERE id_gds_vuelos_segmento = ?'
	);

    -- SELECT @query;
	PREPARE stmt FROM @query;
	SET @id_gds_vuelos_segmento = pr_id_gds_vuelos_segmento;
	EXECUTE stmt USING @id_gds_vuelos_segmento;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual; 	#Devuelve el numero de registros insertados
    SET pr_message =  'SUCCESS';
	-- COMMIT;

END$$
DELIMITER ;
