DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_i`(
	IN  pr_id_factura_detalle 		INT(11),
    IN  pr_id_boleto 				INT(11),
    IN  pr_id_gds_general 			INT(11),
	IN  pr_clave_linea_aerea 		CHAR(2),
	IN  pr_clave_reservacion 		VARCHAR(20),
	IN  pr_clave_pax 				VARCHAR(20),
    IN  pr_nombre_pax				VARCHAR(30),
    IN	pr_ruta						VARCHAR(100),
	IN  pr_tarifa_facturada 		DECIMAL(15,2),
	IN  pr_impuesto1				DECIMAL(15,2),
    IN  pr_impuesto2				DECIMAL(15,2),
    IN  pr_impuesto3				DECIMAL(15,2),
	IN  pr_tarifa_regular 			DECIMAL(15,2),
	IN  pr_tarifa_ofrecida 			DECIMAL(15,2),
    IN  pr_clases					VARCHAR(20),
	IN  pr_clase_principal 			CHAR(1),
    IN  pr_clase_alta 				CHAR(1),
    IN  pr_clase_baja 				CHAR(1),
    IN  pr_codigo_razon 			VARCHAR(10),
	IN  pr_origen 					CHAR(4),
	IN  pr_destino_principal 		CHAR(4),
    IN  pr_fecha_regreso 			DATE,
    IN  pr_hora_regreso				VARCHAR(5),
	IN  pr_fecha_salida 			DATE,
    IN  pr_hora_salida				VARCHAR(5),
    IN  pr_fecha_emision 			DATE,
    IN  pr_fecha_solicitud 			DATE,
    IN  pr_serie					CHAR(5),
	IN  pr_fac_numero				INT,
    IN  pr_forma_pago				CHAR(2),
    IN  pr_tarjeta					VARCHAR(20),
    IN	pr_comision					DECIMAL(18,6),
    IN  pr_codigo_razon_realizado 	VARCHAR(100),
    IN  pr_codigo_razon_rechazado 	VARCHAR(100),
    IN  pr_boleto_conjunto 			TEXT,
    IN  pr_boleto_contra 			TEXT,
    IN  pr_boleto_cancelado 		CHAR(1),
    IN  pr_boleto_revisado			VARCHAR(15),
    IN  pr_boleto_lowcost			VARCHAR(15),
    IN  pr_tour_code 				VARCHAR(25),
    IN  pr_intdom 					ENUM('NACIONAL','INTERNACIONAL'),
    IN	pr_electronico				CHAR(1),
    IN  pr_conjunto					CHAR(1),
    IN  pr_numero_boleto_conjunto	INT,
    IN	pr_iata						VARCHAR(9),
    IN  pr_tc_propietario			ENUM('AGENCIA', 'CLIENTE'),
    IN  pr_id_usuario 				INT,
    IN	pr_estatus					ENUM('ACTIVO','INACTIVO'),
    IN  pr_id_proveedor				INT, -- >
	IN	pr_id_sucursal				INT, -- >
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
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

	INSERT INTO ic_gds_tr_vuelos (
		id_factura_detalle,
		id_boleto,
		id_gds_general,
		clave_linea_aerea,
		clave_reservacion,
		clave_pax,
		nombre_pax,
		ruta,
		tarifa_facturada,
		impuesto1,
		impuesto2,
		impuesto3,
		tarifa_regular,
		tarifa_ofrecida,
		clases,
		clase_principal,
		clase_alta,
		clase_baja,
		codigo_razon,
		origen,
		destino_principal,
		fecha_regreso,
        hora_regreso,
		fecha_salida,
		hora_salida,
		fecha_emision,
		fecha_solicitud,
		serie,
		fac_numero,
		forma_pago,
		tarjeta,
		comision,
		codigo_razon_realizado,
		codigo_razon_rechazo,
		boleto_conjunto,
		boleto_contra,
		boleto_cancelado,
		boleto_revisado,
		boleto_lowcost,
		tour_code,
		intdom,
		electronico,
		conjunto,
		numero_boleto_conjunto,
		iata,
        tc_propietario,
        fecha_mod,
        id_usuario
	) VALUE (
		pr_id_factura_detalle,
		pr_id_boleto,
		pr_id_gds_general,
		pr_clave_linea_aerea,
		pr_clave_reservacion,
		pr_clave_pax,
		pr_nombre_pax,
		pr_ruta,
		pr_tarifa_facturada,
		pr_impuesto1,
		pr_impuesto2,
		pr_impuesto3,
		pr_tarifa_regular,
		pr_tarifa_ofrecida,
		pr_clases,
		pr_clase_principal,
		pr_clase_alta,
		pr_clase_baja,
		pr_codigo_razon,
		pr_origen,
		pr_destino_principal,
		pr_fecha_regreso,
        pr_hora_regreso,
		pr_fecha_salida,
		pr_hora_salida,
		pr_fecha_emision,
		pr_fecha_solicitud,
		pr_serie,
		pr_fac_numero,
		pr_forma_pago,
		pr_tarjeta,
		pr_comision,
		pr_codigo_razon_realizado,
		pr_codigo_razon_rechazado,
		pr_boleto_conjunto,
		pr_boleto_contra,
		pr_boleto_cancelado,
		pr_boleto_revisado,
		pr_boleto_lowcost,
		pr_tour_code,
		pr_intdom,
		pr_electronico,
		pr_conjunto,
		pr_numero_boleto_conjunto,
		pr_iata,
        pr_tc_propietario,
		sysdate(),
        pr_id_usuario
	);

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_inserted_id 	= @@identity;

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

	SET pr_message 		= 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
