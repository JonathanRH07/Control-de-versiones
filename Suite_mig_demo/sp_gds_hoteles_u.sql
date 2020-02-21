DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_hoteles_u`(IN  pr_id_gds_hoteles 		INT(11),
	IN  pr_id_factura_detalle 	INT(11),
	IN  pr_id_boleto 			INT(11),
	IN  pr_clave_reserva 		VARCHAR(20),
	IN  pr_clave_confirmacion 	VARCHAR(20),
	IN  pr_clave_pax 			VARCHAR(20),
    IN  pr_fecha_entrada		DATE,
    IN  pr_fecha_salida			DATE,
	IN  pr_fecha_emision 		DATE,
    IN  pr_fecha_solicitud 		DATE,
	IN  pr_cadena 				INT(11),
	IN  pr_hotel_nombre 		VARCHAR(100),
	IN  pr_numero_noches 		SMALLINT(6),
	IN  pr_tipo_habitacion 		CHAR(4),
	IN  pr_ciudad 				VARCHAR(20),
    IN  pr_codigo_postal		VARCHAR(20),
	IN  pr_direccion 			VARCHAR(100),
	IN  pr_tarifa_facturada 	DECIMAL(18,6),
	IN  pr_tarifa_regular 		DECIMAL(18,6),
	IN  pr_tarifa_ofrecida 		DECIMAL(18,6),
    IN  pr_comision		 		DECIMAL(18,6),
    IN  pr_id_usuario 			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_hoteles_u
		@fecha:			14/09/2017
		@descripcion:	SP para actualizar registro gds_hoteles
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	#Declaracion de variables.
    DECLARE lo_id_factura_detalle 	VARCHAR(500) DEFAULT'';
	DECLARE	lo_id_boleto 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_clave_reserva		VARCHAR(200) DEFAULT '';
	DECLARE	lo_clave_confirmacion	VARCHAR(200) DEFAULT '';
	DECLARE	lo_clave_pax 			VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_entrada		VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_salida			VARCHAR(200) DEFAULT '';
    DECLARE	lo_fecha_emision		VARCHAR(200) DEFAULT '';
    DECLARE	lo_fecha_solicitud		VARCHAR(200) DEFAULT '';
    DECLARE lo_cadena 				VARCHAR(200) DEFAULT '';
    DECLARE	lo_hotel_nombre			VARCHAR(200) DEFAULT '';
	DECLARE	lo_numero_noches 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_tipo_habitacion 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_ciudad				VARCHAR(200) DEFAULT '';
    DECLARE lo_codigo_postal		VARCHAR(200) DEFAULT '';
	DECLARE	lo_direccion 		 	VARCHAR(200) DEFAULT '';
	DECLARE	lo_tarifa_facturada 	VARCHAR(200) DEFAULT '';
    DECLARE	lo_tarifa_regular 		VARCHAR(200) DEFAULT '';
    DECLARE	lo_tarifa_ofrecida 		VARCHAR(200) DEFAULT '';
    DECLARE	lo_comision		 		VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_hoteles_u';
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

    IF pr_id_factura_detalle  > 0 THEN
		SET lo_id_factura_detalle = CONCAT('id_factura_detalle = "', pr_id_factura_detalle, '",');
	END IF;

    IF pr_id_boleto > 0 THEN
		SET lo_id_boleto = CONCAT('id_boleto = ', pr_id_boleto, ', ');
	END IF;

    IF pr_clave_reserva != '' THEN
		SET lo_clave_reserva = CONCAT('clave_reserva = "', pr_clave_reserva, '", ');
	END IF;

    IF pr_clave_confirmacion != '' THEN
		SET lo_clave_confirmacion = CONCAT('clave_confirmacion = "', pr_clave_confirmacion, '", ');
	END IF;

    IF pr_clave_pax != '' THEN
		SET lo_clave_pax = CONCAT('clave_pax = "', pr_clave_pax, '", ');
	END IF;

    IF pr_fecha_entrada != '' THEN
		SET lo_fecha_entrada = CONCAT('fecha_entrada = "', pr_fecha_entrada, '", ');
	END IF;

    IF pr_fecha_salida != '' THEN
		SET lo_fecha_salida = CONCAT('fecha_salida = "', pr_fecha_salida, '", ');
	END IF;

    IF pr_fecha_emision != '' THEN
		SET lo_fecha_emision = CONCAT('fecha_emision = "', pr_fecha_emision, '", ');
	END IF;

    IF pr_fecha_solicitud != '' THEN
		SET lo_fecha_solicitud = CONCAT('fecha_solicitud = "', pr_fecha_solicitud, '", ');
	END IF;

    IF pr_cadena != '' THEN
		SET lo_cadena = CONCAT('cadena = ', pr_cadena, ', ');
	END IF;

    IF pr_hotel_nombre != '' THEN
		SET lo_hotel_nombre = CONCAT('hotel_nombre = "', pr_hotel_nombre, '",');
	END IF;

    IF pr_numero_noches > 0 THEN
		SET lo_numero_noches = CONCAT('numero_noches = ', pr_numero_noches, ', ');
	END IF;

    IF pr_tipo_habitacion != '' THEN
		SET lo_tipo_habitacion = CONCAT('tipo_habitacion = "', pr_tipo_habitacion, '", ');
	END IF;

	IF pr_ciudad != '' THEN
		SET lo_ciudad = CONCAT('ciudad = "', pr_ciudad, '",');
	END IF;

    IF pr_codigo_postal != '' THEN
		SET lo_codigo_postal = CONCAT('codigo_postal = ', pr_codigo_postal, ', ');
	END IF;

    IF pr_direccion != '' THEN
		SET lo_direccion = CONCAT('direccion = "', pr_direccion, '",');
	END IF;

    IF pr_tarifa_facturada > 0 THEN
		SET lo_tarifa_facturada = CONCAT('tarifa_facturada = ', pr_tarifa_facturada, ', ');
	END IF;

    IF pr_tarifa_regular > 0 THEN
		SET lo_tarifa_regular = CONCAT('tarifa_regular = ', pr_tarifa_regular, ', ');
	END IF;

    IF pr_tarifa_ofrecida > 0 THEN
		SET lo_tarifa_ofrecida = CONCAT('tarifa_ofrecida = ', pr_tarifa_ofrecida, ', ');
	END IF;

    IF pr_comision > 0 THEN
		SET lo_comision = CONCAT('comision = ', pr_comision, ', ');
	END IF;


	SET @query = CONCAT('
			UPDATE ic_gds_tr_hoteles
			SET ',
				lo_id_factura_detalle,
				lo_id_boleto,
				lo_clave_reserva,
				lo_clave_confirmacion,
				lo_clave_pax,
                lo_fecha_entrada,
				lo_fecha_salida,
				lo_fecha_emision,
                lo_fecha_solicitud,
				lo_cadena,
				lo_hotel_nombre,
				lo_numero_noches,
				lo_tipo_habitacion,
				lo_ciudad,
                lo_codigo_postal,
				lo_direccion,
				lo_tarifa_facturada,
				lo_tarifa_regular,
				lo_tarifa_ofrecida,
                lo_comision,
                ' id_usuario = ',pr_id_usuario,'
                , fecha_mod = sysdate()
			WHERE
				id_gds_hoteles = ?
	');

	PREPARE stmt FROM @query;
	SET @id_gds_hoteles= pr_id_gds_hoteles;
	EXECUTE stmt USING @id_gds_hoteles;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
