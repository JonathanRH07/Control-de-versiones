DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `ic_gds_vuelos_i`(
	IN  pr_id_boleto 				INT(11),
	IN  pr_id_detalle_factura 		INT(11),
	IN  pr_clave_linea_aerea 		CHAR(2),
	IN  pr_clave_confirmacion 		VARCHAR(20),
	IN  pr_clave_pax 				VARCHAR(20),
	IN  pr_tarifa_facturada 		DECIMAL(15,2),
	IN  pr_tarifa_regular 			DECIMAL(15,2),
	IN  pr_tarifa_ofrecida 			DECIMAL(15,2),
	IN  pr_codigo_razon 			VARCHAR(10),
	IN  pr_origen 					CHAR(4),
	IN  pr_destino_principal 		CHAR(4),
	IN  pr_clase_principal 			CHAR(1),
	IN  pr_fecha_salida 			DATE,
	IN  pr_fecha_regreso 			DATE,
	IN  pr_fecha_emision 			DATE,
	IN  pr_fecha_solicitud 			DATE,
	IN  pr_tipo_servicio 			CHAR(1),
	IN  pr_codigo_razon_realizado 	VARCHAR(100),
	IN  pr_tour_code 				VARCHAR(25),
    OUT pr_inserted_id				INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		ic_gds_vuelos_i
	@fecha: 		14/09/2017
	@descripcion: 	SP para inseratr en ic_gds_vuelos
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store ic_gds_vuelos_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_gds_tr_vuelos (
		id_boleto,
		id_detalle_factura,
		clave_linea_aerea,
		clave_confirmacion,
		clave_pax,
		tarifa_facturada,
		tarifa_regular,
		tarifa_ofrecida,
		codigo_razon,
		origen,
		destino_principal,
		clase_principal,
		fecha_salida,
		fecha_regreso,
		fecha_emision,
		fecha_solicitud,
		tipo_servicio,
		codigo_razon_realizado,
		tour_code
		)
	VALUE
		(
		pr_id_boleto,
		pr_id_detalle_factura,
		pr_clave_linea_aerea,
		pr_clave_confirmacion,
		pr_clave_pax,
		pr_tarifa_facturada,
		pr_tarifa_regular,
		pr_tarifa_ofrecida,
		pr_codigo_razon,
		pr_origen,
		pr_destino_principal,
		pr_clase_principal,
		pr_fecha_salida,
		pr_fecha_regreso,
		pr_fecha_emision,
		pr_fecha_solicitud,
		pr_tipo_servicio,
		pr_codigo_razon_realizado,
		pr_tour_code
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
