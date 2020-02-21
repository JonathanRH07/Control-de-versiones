DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `ic_gds_hoteles_i`(
	IN  pr_id_detalle_factura 	INT(11),
	IN  pr_id_boleto 			INT(11),
	IN  pr_clave_reserva 		VARCHAR(20),
	IN  pr_clave_confirmacion 	VARCHAR(20),
	IN  pr_clave_pax 			VARCHAR(20),
	IN  pr_fecha_emision 		DATE,
	IN  pr_fecha_solicitud 		DATE,
	IN  pr_cadena 				VARCHAR(10),
	IN  pr_hotel_nombre 		VARCHAR(100),
	IN  pr_numero_noches 		SMALLINT(6),
	IN  pr_tipo_habitacion 		CHAR(4),
	IN  pr_pais 				VARCHAR(20),
	IN  pr_ciudad 				VARCHAR(20),
	IN  pr_direccion 			VARCHAR(100),
	IN  pr_tarifa_facturada 	DECIMAL(18,6),
	IN  pr_tarifa_regular 		DECIMAL(18,6),
	IN  pr_tarifa_ofrecida 		DECIMAL(18,6),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		ic_gds_hoteles_i
	@fecha: 		14/09/2017
	@descripcion: 	SP para insertar en gds_autos
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store ic_gds_hoteles_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_gds_tr_hoteles (
		id_detalle_factura,
		id_boleto,
		clave_reserva,
		clave_confirmacion,
		clave_pax,
		fecha_emision,
		fecha_solicitud,
		cadena,
		hotel_nombre,
		numero_noches,
		tipo_habitacion,
		pais,
		ciudad,
		direccion,
		tarifa_facturada,
		tarifa_regular,
		tarifa_ofrecida
		)
	VALUE
		(
		pr_id_detalle_factura,
		pr_id_boleto,
		pr_clave_reserva,
		pr_clave_confirmacion,
		pr_clave_pax,
		pr_fecha_emision,
		pr_fecha_solicitud,
		pr_cadena,
		pr_hotel_nombre,
		pr_numero_noches,
		pr_tipo_habitacion,
		pr_pais,
		pr_ciudad,
		pr_direccion,
		pr_tarifa_facturada,
		pr_tarifa_regular,
		pr_tarifa_ofrecida
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
