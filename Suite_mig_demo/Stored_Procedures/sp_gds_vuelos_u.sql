DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_u`(
	IN  pr_id_gds_vuelos			INT(11),
	IN  pr_id_factura_detalle 		INT(11),
	IN  pr_id_boleto 				INT(11),
	IN  pr_clave_linea_aerea 		CHAR(2),
	IN  pr_clave_reservacion 		VARCHAR(20),
	IN  pr_clave_pax 				VARCHAR(20),
    IN  pr_nombre_pax				VARCHAR(30),
	IN  pr_tarifa_facturada 		DECIMAL(15,2),
	IN  pr_tarifa_regular 			DECIMAL(15,2),
	IN  pr_tarifa_ofrecida 			DECIMAL(15,2),
	IN  pr_clase_principal 			CHAR(1),
	IN  pr_clase_alta 				CHAR(1),
	IN  pr_clase_baja 				CHAR(1),
	IN  pr_codigo_razon 			VARCHAR(10),
	IN  pr_origen 					CHAR(4),
	IN  pr_destino_principal 		CHAR(4),
    IN  pr_fecha_regreso 			DATE,
	IN  pr_fecha_salida 			DATE,
	IN  pr_fecha_emision 			DATE,
	IN  pr_fecha_solicitud 			DATE,
    IN  pr_comision					DECIMAL(18,6),
	IN  pr_codigo_razon_realizado 	VARCHAR(100),
	IN  pr_codigo_razon_rechazo 	VARCHAR(100),
    IN  pr_boleto_conjunto 			TEXT,
    IN  pr_boleto_contra 			TEXT,
    IN  pr_boleto_cancelado 		CHAR(1),
	IN  pr_tour_code 				VARCHAR(25),
	IN  pr_intdom 					ENUM('NACIONAL','INTERNACIONAL'),
	IN  pr_id_usuario				INT,
	OUT pr_affect_rows				INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_vuelos_u
		@fecha:			03/10/2017
		@descripcion:	SP para actualizar los gds_vuelos
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	#Declaracion de variables.
    DECLARE lo_id_factura_detalle 		VARCHAR(500) DEFAULT'';
	DECLARE lo_id_boleto 				VARCHAR(500) DEFAULT'';
	DECLARE lo_clave_linea_aerea 		VARCHAR(500) DEFAULT'';
	DECLARE lo_clave_reservacion 		VARCHAR(500) DEFAULT'';
	DECLARE lo_clave_pax 				VARCHAR(500) DEFAULT'';
    DECLARE lo_nombre_pax 				VARCHAR(500) DEFAULT'';
	DECLARE lo_tarifa_facturada 		VARCHAR(500) DEFAULT'';
	DECLARE lo_tarifa_regular 			VARCHAR(500) DEFAULT'';
	DECLARE lo_tarifa_ofrecida 			VARCHAR(500) DEFAULT'';
	DECLARE lo_clase_principal 			VARCHAR(500) DEFAULT'';
	DECLARE lo_clase_alta 				VARCHAR(500) DEFAULT'';
	DECLARE lo_clase_baja 				VARCHAR(500) DEFAULT'';
	DECLARE lo_codigo_razon 			VARCHAR(500) DEFAULT'';
	DECLARE lo_origen 					VARCHAR(500) DEFAULT'';
	DECLARE lo_destino_principal 		VARCHAR(500) DEFAULT'';
    DECLARE lo_fecha_regreso 			VARCHAR(500) DEFAULT'';
	DECLARE lo_fecha_salida 			VARCHAR(500) DEFAULT'';
	DECLARE lo_fecha_emision 			VARCHAR(500) DEFAULT'';
	DECLARE lo_fecha_solicitud 			VARCHAR(500) DEFAULT'';
    DECLARE lo_codigo_razon_realizado 	VARCHAR(500) DEFAULT'';
	DECLARE lo_codigo_razon_rechazo 	VARCHAR(500) DEFAULT'';
	DECLARE lo_tour_code 				VARCHAR(500) DEFAULT'';
	DECLARE lo_intdom 					VARCHAR(500) DEFAULT'';
    DECLARE lo_boleto_conjunto 			VARCHAR(500) DEFAULT'';
    DECLARE lo_boleto_contra 			VARCHAR(500) DEFAULT'';
    DECLARE lo_boleto_cancelado 		VARCHAR(500) DEFAULT'';
    DECLARE	lo_comision					VARCHAR(500) DEFAULT'';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_vuelos_u';
	-- ROLLBACK;
	END;

	-- START TRANSACTION;

    IF pr_id_factura_detalle  > 0 THEN
		SET lo_id_factura_detalle = CONCAT('id_factura_detalle = "', pr_id_factura_detalle, '",');
	END IF;

	IF pr_id_boleto != '' THEN
		SET lo_id_boleto = CONCAT('id_boleto = "', pr_id_boleto, '",');
	END IF;

	IF pr_clave_linea_aerea != '' THEN
		SET lo_clave_linea_aerea = CONCAT('clave_linea_aerea = "', pr_clave_linea_aerea, '",');
	END IF;

	IF pr_tarifa_facturada  > 0 THEN
		SET lo_tarifa_facturada = CONCAT('tarifa_facturada = "', pr_tarifa_facturada, '",');
	END IF;

	IF pr_tarifa_regular  > 0 THEN
		SET lo_tarifa_regular = CONCAT('tarifa_regular = "', pr_tarifa_regular, '",');
	END IF;

	IF pr_tarifa_ofrecida  > 0 THEN
		SET lo_tarifa_ofrecida = CONCAT('tarifa_ofrecida = "', pr_tarifa_ofrecida, '",');
	END IF;

	IF pr_clase_principal != '' THEN
		SET lo_clase_principal = CONCAT('clase_principal = "', pr_clase_principal, '",');
	END IF;

	IF pr_clase_alta != '' THEN
		SET lo_clase_alta = CONCAT('clase_alta = "', pr_clase_alta, '",');
	END IF;

	IF pr_clase_baja != '' THEN
		SET lo_clase_baja = CONCAT('clase_baja = "', pr_clase_baja, '",');
	END IF;

	IF pr_origen != '' THEN
		SET lo_origen = CONCAT('origen = "', pr_origen, '",');
	END IF;

	IF pr_destino_principal != '' THEN
		SET lo_destino_principal = CONCAT('destino_principal = "', pr_destino_principal, '",');
	END IF;

	IF pr_fecha_regreso != '0000-00-00' THEN
		SET lo_fecha_regreso = CONCAT('fecha_regreso = "', pr_fecha_regreso ,'", ');
	END IF;

    IF pr_fecha_salida != '0000-00-00' THEN
		SET lo_fecha_salida = CONCAT('fecha_salida = "', pr_fecha_salida, '",');
	END IF;

	IF pr_fecha_emision != '0000-00-00' THEN
		SET lo_fecha_emision = CONCAT('fecha_emision = "', pr_fecha_emision, '",');
	END IF;

	IF pr_fecha_solicitud != '0000-00-00' THEN
		SET lo_fecha_solicitud = CONCAT('fecha_solicitud = "', pr_fecha_solicitud, '",');
	END IF;

	IF pr_tour_code != '' THEN
		SET lo_tour_code = CONCAT('tour_code = "', pr_tour_code, '",');
	END IF;

	IF pr_intdom != '' THEN
		SET lo_intdom = CONCAT('intdom = "', pr_intdom, '",');
	END IF;

    IF pr_comision  > 0 THEN
		SET lo_comision = CONCAT('comision = ', pr_comision, ',');
	END IF;

    SET lo_clave_reservacion 		= CONCAT('clave_reservacion = "'		, pr_clave_reservacion ,'",');
	SET lo_clave_pax 				= CONCAT('clave_pax = "'				, pr_clave_pax ,'",');
    SET lo_nombre_pax 				= CONCAT('nombre_pax = "'				, pr_nombre_pax ,'",');
    SET lo_codigo_razon 			= CONCAT('codigo_razon = "'				, pr_codigo_razon ,'",');
    SET lo_codigo_razon_rechazo 	= CONCAT('codigo_razon_rechazo = "'		, pr_codigo_razon_rechazo ,'",');
    SET lo_codigo_razon_realizado 	= CONCAT('codigo_razon_realizado = "'	, pr_codigo_razon_realizado ,'",');


	SET lo_boleto_conjunto 	= CONCAT('boleto_conjunto = "'	, pr_boleto_conjunto ,'",');
	SET lo_boleto_contra 	= CONCAT('boleto_contra = "'	, pr_boleto_contra ,'",');
	SET lo_boleto_cancelado = CONCAT('boleto_cancelado = "'	, pr_boleto_cancelado ,'",');




	SET @query = CONCAT('UPDATE ic_gds_tr_vuelos
					SET ',
						lo_id_factura_detalle,
						lo_id_boleto,
						lo_clave_linea_aerea,
						lo_clave_reservacion,
						lo_clave_pax,
                        lo_nombre_pax,
						lo_tarifa_facturada,
						lo_tarifa_regular,
						lo_tarifa_ofrecida,
						lo_clase_principal,
						lo_clase_alta,
						lo_clase_baja,
						lo_codigo_razon,
						lo_origen,
						lo_destino_principal,
						lo_fecha_regreso,
						lo_fecha_salida,
						lo_fecha_emision,
						lo_fecha_solicitud,
                        lo_codigo_razon_realizado,
						lo_codigo_razon_rechazo,
						lo_tour_code,
						lo_intdom,
                        lo_comision,
                        lo_boleto_conjunto,
                        lo_boleto_contra,
                        lo_boleto_cancelado,
						'  id_usuario =',pr_id_usuario,
						' ,fecha_mod = sysdate()
					WHERE
						id_gds_vuelos = ?'
	);
	PREPARE stmt FROM @query;
	SET @id_gds_vuelos= pr_id_gds_vuelos;
	EXECUTE stmt USING @id_gds_vuelos;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
