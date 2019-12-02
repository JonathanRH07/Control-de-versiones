DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `ic_gds_vuelos_segmento_i`(
	IN  pr_id_gds_vuelos 			INT(11),
	IN  pr_id_acred 				INT(11),
	IN  pr_clave_linea_reaa 		CHAR(2),
	IN  pr_numero_vuelo 			INT(11),
	IN  pr_cve_airport_origen 		CHAR(4),
	IN  pr_cve_airport_destino 		CHAR(4),
	IN  pr_nombre_ciudad_origen 	VARCHAR(30),
	IN  pr_nombre_ciudad_destino 	VARCHAR(30),
	IN  pr_tarifa_regular 			DECIMAL(15,2),
	IN  pr_tarifa_ofrecida 			DECIMAL(15,2),
	IN  pr_codigo_razon 			VARCHAR(10),
	IN  pr_cve_origen 				CHAR(4),
	IN  pr_cve_clase_reserv 		CHAR(1),
	IN  pr_cve_clase_equiva 		CHAR(1),
	IN  pr_intdom 					CHAR(1),
	IN  pr_consecutivo 				INT(11),
	IN  pr_fecha_salida 			DATE,
	IN  pr_hora_salida 				TIME,
	IN  pr_hora_llegada 			TIME,
	IN  pr_servicio_comida 			CHAR(3),
	IN  pr_equipo 					CHAR(3),
	IN  pr_millas 					INT(11),
	IN  pr_millas_pax_frecuente 	INT(11),
	IN  pr_no_escalas 				CHAR(1),
	IN  pr_cambio_fecha_llegada 	CHAR(1),
	IN  pr_tarifa_segmento 			DECIMAL(18,6),
	IN  pr_numero_segmento 			INT(11),
	IN  pr_conexion 				CHAR(1),
	IN  pr_cargo_combustible 		DECIMAL(15,2),
	IN  pr_cargo_seguridad 			DECIMAL(15,2),
	IN  pr_terminal_salida 			VARCHAR(26),
	IN  pr_puerta_salida 			CHAR(4),
	IN  pr_terminal_llegada 		VARCHAR(26),
	IN  pr_puerta_llegada 			CHAR(4),
	IN  pr_asiento 					CHAR(4),
	IN  pr_duracion_vuelo 			CHAR(8),
	IN  pr_pnr_la 					CHAR(8),
	IN  pr_year 					CHAR(5),
	IN  pr_fare_basis			 	VARCHAR(10),
    OUT pr_inserted_id				INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		ic_gds_vuelos_segmento_i
	@fecha: 		14/09/2017
	@descripcion: 	SP para inseratr en ic_gds_vuelos_segmentos
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store ic_gds_vuelos_segmento_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_gds_tr_vuelos_segmento(
		id_gds_vuelos,
		id_acred,
		clave_linea_reaa,
		numero_vuelo,
		cve_airport_origen,
		cve_airport_destino,
		nombre_ciudad_origen,
		nombre_ciudad_destino,
		tarifa_regular,
		tarifa_ofrecida,
		codigo_razon,
		cve_origen,
		cve_clase_reserv,
		cve_clase_equiva,
		intdom,
		consecutivo,
		fecha_salida,
		hora_salida,
		hora_llegada,
		servicio_comida,
		equipo,
		millas,
		millas_pax_frecuente,
		no_escalas,
		cambio_fecha_llegada,
		tarifa_segmento,
		numero_segmento,
		conexion,
		cargo_combustible,
		cargo_seguridad,
		terminal_salida,
		puerta_salida,
		terminal_llegada,
		puerta_llegada,
		asiento,
		duracion_vuelo,
		pnr_la,
		year,
		fare_basis
		)
	VALUE
		(
		pr_id_gds_vuelos,
		pr_id_acred,
		pr_clave_linea_reaa,
		pr_numero_vuelo,
		pr_cve_airport_origen,
		pr_cve_airport_destino,
		pr_nombre_ciudad_origen,
		pr_nombre_ciudad_destino,
		pr_tarifa_regular,
		pr_tarifa_ofrecida,
		pr_codigo_razon,
		pr_cve_origen,
		pr_cve_clase_reserv,
		pr_cve_clase_equiva,
		pr_intdom,
		pr_consecutivo,
		pr_fecha_salida,
		pr_hora_salida,
		pr_hora_llegada,
		pr_servicio_comida,
		pr_equipo,
		pr_millas,
		pr_millas_pax_frecuente,
		pr_no_escalas,
		pr_cambio_fecha_llegada,
		pr_tarifa_segmento,
		pr_numero_segmento,
		pr_conexion,
		pr_cargo_combustible,
		pr_cargo_seguridad,
		pr_terminal_salida,
		pr_puerta_salida,
		pr_terminal_llegada,
		pr_puerta_llegada,
		pr_asiento,
		pr_duracion_vuelo,
		pr_pnr_la,
		pr_year,
		pr_fare_basis
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
