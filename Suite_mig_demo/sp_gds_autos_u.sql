DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_autos_u`(
	IN  pr_id_gds_autos 		INT(11),
	IN  pr_id_factura_detalle 	INT(11),
	IN  pr_id_arrendadora		INT(11),
	IN  pr_numero_boleto 		VARCHAR(15),
	IN  pr_clave_reserva 		VARCHAR(20),
	IN  pr_clave_confirmacion 	VARCHAR(20),
	IN  pr_clave_pax 			VARCHAR(20),
    IN  pr_nombre_pax 			VARCHAR(30),
	IN  pr_fecha_recoge 		DATE,
	IN  pr_fecha_entrega 		DATE,
	IN  pr_fecha_emision 		DATE,
    IN  pr_fecha_solicitud 		DATE,
    IN  pr_numero_dias 			SMALLINT(6),
	IN  pr_tipo_auto 			CHAR(4),
	IN  pr_tarifa_facturada 	DECIMAL(18,6),
	IN  pr_tarifa_regular 		DECIMAL(18,6),
	IN  pr_tarifa_ofrecida 		DECIMAL(18,6),
    IN  pr_comision			 	DECIMAL(18,6),
	IN  pr_cp_recoge 			VARCHAR(20),
	IN  pr_cp_entrega 			VARCHAR(20),
	IN  pr_ciudad_recoge 		VARCHAR(100),
	IN  pr_ciudad_entrega 		VARCHAR(100),
	IN  pr_direccion_recoge 	VARCHAR(255),
	IN  pr_direccion_entrega 	VARCHAR(255),
    IN  pr_id_usuario			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_cliente_contacto_u
		@fecha:			04/01/2017
		@descripcion:	SP para actualizar registro en Clientes Contacto
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	#Declaracion de variables.
	DECLARE lo_id_factura_detalle 	VARCHAR(500) DEFAULT '';
	DECLARE	lo_id_arrendadora		VARCHAR(200) DEFAULT '';
    DECLARE	lo_numero_boleto		VARCHAR(200) DEFAULT '';
	DECLARE	lo_clave_reserva 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_clave_confirmacion 	VARCHAR(200) DEFAULT '';
	DECLARE	lo_clave_pax			VARCHAR(200) DEFAULT '';
    DECLARE	lo_nombre_pax			VARCHAR(200) DEFAULT '';
	DECLARE	lo_fecha_recoge 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_fecha_entrega 		VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_emision		VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_solicitud		VARCHAR(200) DEFAULT '';
	DECLARE	lo_numero_dias 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_tipo_auto 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_tarifa_facturada 	VARCHAR(200) DEFAULT '';
	DECLARE	lo_tarifa_regular 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_tarifa_ofrecida 		VARCHAR(200) DEFAULT '';
    DECLARE	lo_cp_recoge 			VARCHAR(200) DEFAULT '';
    DECLARE	lo_cp_entrega 			VARCHAR(200) DEFAULT '';
    DECLARE	lo_ciudad_recoge 		VARCHAR(200) DEFAULT '';
    DECLARE	lo_ciudad_entrega 		VARCHAR(200) DEFAULT '';
    DECLARE	lo_direccion_recoge 	VARCHAR(200) DEFAULT '';
    DECLARE	lo_direccion_entrega 	VARCHAR(200) DEFAULT '';
    DECLARE	lo_comision			 	VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_contacto_u';
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

    IF pr_id_factura_detalle  > 0 THEN
		SET lo_id_factura_detalle = CONCAT('id_factura_detalle = "', pr_id_factura_detalle, '",');
	END IF;

    IF pr_id_arrendadora > 0 THEN
		SET lo_id_arrendadora = CONCAT('id_arrendadora = ', pr_id_arrendadora, ',');
	END IF;

    IF pr_numero_boleto != '' THEN
		SET lo_numero_boleto = CONCAT('numero_boleto = "', pr_numero_boleto, '",');
	END IF;

    IF pr_clave_reserva != '' THEN
		SET lo_clave_reserva = CONCAT('clave_reserva = "', pr_clave_reserva, '",');
	END IF;

    IF pr_clave_confirmacion != '' THEN
		SET lo_clave_confirmacion = CONCAT('clave_confirmacion = "', pr_clave_confirmacion, '",');
	END IF;

    IF pr_clave_pax != '' THEN
		SET lo_clave_pax = CONCAT('clave_pax = "', pr_clave_pax, '",');
	END IF;

    IF pr_nombre_pax != '' THEN
		SET lo_nombre_pax = CONCAT('nombre_pax = "', pr_nombre_pax, '",');
	END IF;

    IF pr_fecha_recoge != '0000-00-00' THEN
		SET lo_fecha_recoge = CONCAT('fecha_recoge = "', pr_fecha_recoge, '",');
	END IF;

    IF pr_fecha_entrega != '0000-00-00' THEN
		SET lo_fecha_entrega = CONCAT('fecha_entrega = "', pr_fecha_entrega, '",');
	END IF;

    IF pr_fecha_emision != '0000-00-00' THEN
		SET lo_fecha_emision = CONCAT('fecha_emision = "', pr_fecha_emision, '",');
	END IF;

    IF pr_fecha_solicitud != '0000-00-00' THEN
		SET lo_fecha_solicitud = CONCAT('fecha_solicitud = "', pr_fecha_solicitud ,'",');
	END IF;

	IF pr_numero_dias > 0 THEN
		SET lo_numero_dias = CONCAT('numero_dias = ', pr_numero_dias, ',');
	END IF;

	IF pr_tipo_auto != '' THEN
		SET lo_tipo_auto = CONCAT('tipo_auto = "', pr_tipo_auto, '",');
	END IF;

    IF pr_tarifa_facturada > 0 THEN
		SET lo_tarifa_facturada = CONCAT('tarifa_facturada = ', pr_tarifa_facturada, ',');
	END IF;

    IF pr_tarifa_regular > 0 THEN
		SET lo_tarifa_regular = CONCAT('tarifa_regular = ', pr_tarifa_regular, ',');
	END IF;

    IF pr_tarifa_ofrecida > 0 THEN
		SET lo_tarifa_ofrecida = CONCAT('tarifa_ofrecida = ', pr_tarifa_ofrecida, ',');
	END IF;

    IF pr_cp_recoge != '' THEN
		SET lo_cp_recoge = CONCAT('cp_recoge = "', pr_cp_recoge, '",');
	END IF;

    IF pr_cp_entrega != '' THEN
		SET lo_cp_entrega = CONCAT('cp_entrega = "', pr_cp_entrega, '",');
	END IF;

    IF pr_ciudad_recoge != '' THEN
		SET lo_ciudad_recoge = CONCAT('ciudad_recoge = "', pr_ciudad_recoge, '",');
	END IF;

    IF pr_ciudad_entrega != '' THEN
		SET lo_ciudad_entrega = CONCAT('ciudad_entrega = "', pr_ciudad_entrega, '",');
	END IF;

    IF pr_direccion_recoge != '' THEN
		SET lo_direccion_recoge = CONCAT('direccion_recoge = "', pr_id_arrendadora, '",');
	END IF;

    IF pr_direccion_entrega != '' THEN
		SET lo_direccion_entrega = CONCAT('direccion_entrega = "', pr_direccion_entrega, '",');
	END IF;

    IF pr_comision > 0 THEN
		SET lo_comision = CONCAT('comision = ', pr_comision, ',');
	END IF;

	SET @query = CONCAT('
		UPDATE ic_gds_tr_autos
		SET ',
			lo_id_factura_detalle,
			lo_id_arrendadora,
			lo_numero_boleto,
			lo_clave_reserva,
			lo_clave_confirmacion,
			lo_clave_pax,
            lo_nombre_pax,
			lo_fecha_recoge,
			lo_fecha_entrega,
			lo_fecha_emision,
            lo_fecha_solicitud,
			lo_numero_dias,
			lo_tipo_auto,
			lo_tarifa_facturada,
			lo_tarifa_regular,
			lo_tarifa_ofrecida,
			lo_cp_recoge,
			lo_cp_entrega,
			lo_ciudad_recoge,
			lo_ciudad_entrega,
			lo_direccion_recoge,
			lo_direccion_entrega,
            lo_comision,
			' id_usuario=',pr_id_usuario,
			', fecha_mod  = sysdate()
			WHERE
				id_gds_autos = ?
	');

	PREPARE stmt FROM @query;
	SET @id_gds_autos= pr_id_gds_autos;
	EXECUTE stmt USING @id_gds_autos;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
