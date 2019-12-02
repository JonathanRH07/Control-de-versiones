CREATE DEFINER=`suite_deve`@`%` PROCEDURE `ic_gds_autos_i`(
	IN  pr_id_detalle_factura 	INT(11),
	IN  pr_numero_boleto 		VARCHAR(15),
	IN  pr_clave_reserva 		VARCHAR(20),
	IN  pr_clave_confirmacion 	VARCHAR(20),
	IN  pr_clave_pax 			VARCHAR(20),
	IN  pr_fecha_recoge 		DATE,
	IN  pr_fecha_entrega 		DATE,
	IN  pr_fecha_emision 		DATE,
	IN  pr_fecha_solicitud 		DATE,
	IN  pr_hotel_arrendadora 	VARCHAR(100),
	IN  pr_numero_dias 			SMALLINT(6),
	IN  pr_tipo_auto 			CHAR(4),
	IN  pr_direccion 			VARCHAR(100),
	IN  pr_tarifa_facturada 	DECIMAL(18,6),
	IN  pr_tarifa_regular 		DECIMAL(18,6),
	IN  pr_tarifa_ofrecida 		DECIMAL(18,6),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		ic_gds_autos
	@fecha: 		14/09/2017
	@descripcion: 	SP para insertar en gds_autos
	@autor: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store ic_gds_autos';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ic_gds_tr_autos (
		id_detalle_factura,
		numero_boleto,
		clave_reserva,
		clave_confirmacion,
		clave_pax,
		fecha_recoge,
		fecha_entrega,
		fecha_emision,
		fecha_solicitud,
		hotel_arrendadora,
		numero_dias,
		tipo_auto,
		direccion,
		tarifa_facturada,
		tarifa_regular,
		tarifa_ofrecida
		)
	VALUE
		(
		pr_id_detalle_factura,
		pr_numero_boleto,
		pr_clave_reserva,
		pr_clave_confirmacion,
		pr_clave_pax,
		pr_fecha_recoge,
		pr_fecha_entrega,
		pr_fecha_emision,
		pr_fecha_solicitud,
		pr_hotel_arrendadora,
		pr_numero_dias,
		pr_tipo_auto,
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

END
