DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_citypair_i`(
	IN  pr_id_gds_vuelos 			INT(11),
	IN  pr_id_moneda 				INT(11),
	IN  pr_clave_linea_aerea 		CHAR(2),
	IN  pr_cve_aeropuerto_origen 	CHAR(4),
	IN  pr_cve_aeropuerto_destino 	CHAR(4),
	IN  pr_numero_segmento 			SMALLINT(2),
	IN  pr_clase_reservada 			CHAR(1),
	IN  pr_fare_basis 				VARCHAR(10),
	IN  pr_tarifa_citypair 			DECIMAL(15,2),
	IN  pr_millas_citypair 			INT(11),
	IN  pr_nombre_ciudad_origen 	VARCHAR(30),
	IN  pr_nombre_ciudad_destino 	VARCHAR(30),
	IN  pr_ticket_designator 		VARCHAR(10),
    OUT pr_inserted_id				INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		ic_gds_vuelos_citypair_i
	@fecha: 		14/09/2017
	@descripcion: 	SP para inseratr en ic_gds_vuelos_citypair
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store ic_gds_vuelos_citypair_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_gds_tr_vuelos_citypair(
		id_gds_vuelos,
		id_moneda,
		clave_linea_aerea,
		cve_aeropuerto_origen,
		cve_aeropuerto_destino,
		numero_segmento,
		clase_reservada,
		fare_basis,
		tarifa_citypair,
		millas_citypair,
		nombre_ciudad_origen,
		nombre_ciudad_destino,
		ticket_designator
		)
	VALUE
		(
		pr_id_gds_vuelos,
		pr_id_moneda,
		pr_clave_linea_aerea,
		pr_cve_aeropuerto_origen,
		pr_cve_aeropuerto_destino,
		pr_numero_segmento,
		pr_clase_reservada,
		pr_fare_basis,
		pr_tarifa_citypair,
		pr_millas_citypair,
		pr_nombre_ciudad_origen,
		pr_nombre_ciudad_destino,
		pr_ticket_designator
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
