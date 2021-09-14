DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_hoteles_i`(
	IN  pr_id_factura_detalle 	INT(11),
	IN  pr_id_boleto 			INT(11),
    IN  pr_id_gds_general 		INT(11),
    IN	pr_proveedor			VARCHAR(10),
	IN  pr_clave_reserva 		VARCHAR(20),
	IN  pr_clave_confirmacion 	VARCHAR(20),
	IN  pr_clave_pax 			VARCHAR(20),
    IN  pr_fecha_entrada		DATE,
    IN  pr_fecha_salida			DATE,
	IN  pr_fecha_emision 		DATE,
    IN  pr_fecha_solicitud 		DATE,
	IN  pr_cadena 				INT(11),
    IN  pr_propiedad			CHAR(6),
	IN  pr_hotel_nombre 		VARCHAR(100),
	IN  pr_numero_noches 		SMALLINT(6),
    IN  pr_numero_hab			INT(11),
    IN  pr_cve_habitacion		CHAR(4),
	IN  pr_tipo_habitacion 		CHAR(4),
    IN  pr_costo_hab_noche		DECIMAL(18,6),
	IN  pr_ciudad 				VARCHAR(20),
    IN  pr_codigo_postal		VARCHAR(20),
	IN  pr_direccion 			VARCHAR(100),
    IN  pr_telefono				VARCHAR(20),
    IN  pr_poblacion			VARCHAR(50),
    IN  pr_cve_moneda			CHAR(3),
    IN  pr_tipo_cambio			DECIMAL(16,4),
	IN  pr_tarifa_facturada 	DECIMAL(18,6),
	IN  pr_tarifa_regular 		DECIMAL(18,6),
	IN  pr_tarifa_ofrecida 		DECIMAL(18,6),
    IN  pr_tarifa_total_noches	DECIMAL(18,6),
    IN  pr_tarifa_neta			DECIMAL(18,6),
    IN  pr_impuesto1			DECIMAL(18,6),
    IN  pr_impuesto2			DECIMAL(18,6),
    IN	pr_comision				DECIMAL(18,6),
    IN  pr_forma_pago			CHAR(2),
    IN	pr_tarjeta				VARCHAR(20),
    IN  pr_voucher				VARCHAR(20),
    IN	pr_cancelado			CHAR(1),
    IN  pr_id_usuario 			INT,
	IN	pr_estatus				ENUM('ACTIVO','INACTIVO'),
    IN  pr_id_proveedor			INT, -- >
	IN	pr_id_sucursal			INT, -- >
    IN	pr_ruta					VARCHAR(25), -- >
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	        	VARCHAR(500))
BEGIN
	/*
		@nombre: 		ic_gds_hoteles_i
		@fecha: 		14/09/2017
		@descripcion: 	SP para inseratr en gds_autos
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store ic_gds_hoteles_i';
        SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

	INSERT INTO ic_gds_tr_hoteles (
		id_factura_detalle,
		id_boleto,
		id_gds_general,
		proveedor,
		clave_reserva,
		clave_confirmacion,
		clave_pax,
		fecha_entrada,
		fecha_salida,
		fecha_emision,
		fecha_solicitud,
		cadena,
		propiedad,
		hotel_nombre,
		numero_noches,
		numero_hab,
		cve_habitacion,
		tipo_habitacion,
		costo_hab_noche,
		ciudad,
		codigo_postal,
		direccion,
		telefono,
		poblacion,
		cve_moneda,
		tipo_cambio,
		tarifa_facturada,
		tarifa_regular,
		tarifa_ofrecida,
		tarifa_total_noches,
		tarifa_neta,
		impuesto1,
		impuesto2,
		comision,
		forma_pago,
		tarjeta,
		voucher,
		cancelado,
		fecha_mod,
		id_usuario
	) VALUE (
		pr_id_factura_detalle,
		pr_id_boleto,
		pr_id_gds_general,
		pr_proveedor,
		pr_clave_reserva,
		pr_clave_confirmacion,
		pr_clave_pax,
		pr_fecha_entrada,
		pr_fecha_salida,
		pr_fecha_emision,
		pr_fecha_solicitud,
		pr_cadena,
		pr_propiedad,
		pr_hotel_nombre,
		pr_numero_noches,
		pr_numero_hab,
		pr_cve_habitacion,
		pr_tipo_habitacion,
		pr_costo_hab_noche,
		pr_ciudad,
		pr_codigo_postal,
		pr_direccion,
		pr_telefono,
		pr_poblacion,
		pr_cve_moneda,
		pr_tipo_cambio,
		pr_tarifa_facturada,
		pr_tarifa_regular,
		pr_tarifa_ofrecida,
		pr_tarifa_total_noches,
		pr_tarifa_neta,
		pr_impuesto1,
		pr_impuesto2,
		pr_comision,
		pr_forma_pago,
		pr_tarjeta,
		pr_voucher,
		pr_cancelado,
		sysdate(),
		pr_id_usuario
	);

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_inserted_id 	= @@identity;

    IF pr_id_boleto > 0  THEN
		CALL sp_glob_boleto_u(
			pr_id_boleto,
			pr_id_proveedor, -- >
			pr_id_sucursal, -- >
			pr_id_factura_detalle,
			pr_ruta, -- >
			pr_estatus,
			pr_id_usuario,
			pr_fecha_emision,
			pr_affect_rows,
			pr_message
		);
	END IF;

	SET pr_message 		= 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
