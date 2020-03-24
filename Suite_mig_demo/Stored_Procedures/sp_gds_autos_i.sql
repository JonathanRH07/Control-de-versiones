DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_autos_i`(
	IN  pr_id_factura_detalle 	INT(11),
    IN  pr_id_boleto 			INT(11), -- >
    IN  pr_id_arrendadora		INT(11),
    IN  pr_id_gds_general 		INT(11),
    IN	pr_id_sucursal			INT(11),
    IN  pr_provedor				VARCHAR(10),
	IN  pr_numero_boleto 		VARCHAR(15),
    IN  pr_serie				CHAR(5),
    IN  pr_fac_numero			INT(1),
	IN  pr_clave_reserva 		VARCHAR(20),
	IN  pr_clave_confirmacion 	VARCHAR(20),
	IN  pr_clave_pax 			VARCHAR(20),
    IN  pr_nombre_pax			VARCHAR(30),
    IN  pr_fecha_recoge 		DATE,
	IN  pr_fecha_entrega 		DATE,
	IN  pr_fecha_emision 		DATE,
    IN  pr_fecha_solicitud 		DATE,
	IN  pr_numero_dias 			SMALLINT(6),
	IN  pr_tipo_auto 			CHAR(4),
    IN  pr_numero_autos			INT(11),
    IN  pr_cve_moneda			CHAR(3),
	IN  pr_tarifa_facturada 	DECIMAL(18,6),
	IN  pr_tarifa_regular 		DECIMAL(18,6),
	IN  pr_tarifa_ofrecida 		DECIMAL(18,6),
    IN  pr_tarifa_diaria		DECIMAL(18,6),
    IN  pr_tarifa_total			DECIMAL(18,6),
    IN  pr_impuesto				DECIMAL(18,6),
    IN  pr_comision				DECIMAL(18,6),
    IN  pr_tipo_cambio			DECIMAL(16,4),
    IN  pr_voucher				VARCHAR(20),
    IN  pr_forma_pago			CHAR(2),
    IN  pr_tarjeta				VARCHAR(20),
    IN  pr_cve_ciudad_renta		CHAR(4),
    IN  pr_nombre_ciudad_renta	VARCHAR(30),
	IN  pr_cp_recoge 			VARCHAR(20),
	IN  pr_cp_entrega 			VARCHAR(20),
	IN  pr_ciudad_recoge 		VARCHAR(100),
	IN  pr_ciudad_entrega 		VARCHAR(100),
	IN  pr_direccion_recoge 	VARCHAR(255),
	IN  pr_direccion_entrega 	VARCHAR(255),
    IN  pr_cancelacion			CHAR(1),
    IN  pr_id_usuario			INT,
    IN	pr_estatus				ENUM('ACTIVO','INACTIVO'),
    IN	pr_id_proveedor			INT,
    IN	pr_ruta					VARCHAR(50), -- >
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	        	VARCHAR(500))
BEGIN
	/*
		@nombre: 		ic_gds_autos
		@fecha: 		14/09/2017
		@descripcion: 	SP para inseratr en gds_autos
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store ic_gds_autos';
        SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

	INSERT INTO ic_gds_tr_autos (
		id_factura_detalle,
		id_arrendadora,
		id_gds_general,
		id_sucursal,
		provedor,
		numero_boleto,
		serie,
		fac_numero,
		clave_reserva,
		clave_confirmacion,
		clave_pax,
		nombre_pax,
		fecha_recoge,
		fecha_entrega,
		fecha_emision,
		fecha_solicitud,
		numero_dias,
		tipo_auto,
		numero_autos,
		cve_moneda,
		tarifa_facturada,
		tarifa_regular,
		tarifa_ofrecida,
		tarifa_diaria,
		tarifa_total,
		impuesto,
		comision,
		tipo_cambio,
		voucher,
		forma_pago,
		tarjeta,
		cve_ciudad_renta,
		nombre_ciudad_renta,
		cp_recoge,
		cp_entrega,
		ciudad_recoge,
		ciudad_entrega,
		direccion_recoge,
		direccion_entrega,
		cancelacion,
		fecha_mod,
		id_usuario
	) VALUE (
		pr_id_factura_detalle,
		pr_id_arrendadora,
		pr_id_gds_general,
		pr_id_sucursal,
		pr_provedor,
		pr_numero_boleto,
		pr_serie,
		pr_fac_numero,
		pr_clave_reserva,
		pr_clave_confirmacion,
		pr_clave_pax,
		pr_nombre_pax,
		pr_fecha_recoge,
		pr_fecha_entrega,
		pr_fecha_emision,
		pr_fecha_solicitud,
		pr_numero_dias,
		pr_tipo_auto,
		pr_numero_autos,
		pr_cve_moneda,
		pr_tarifa_facturada,
		pr_tarifa_regular,
		pr_tarifa_ofrecida,
		pr_tarifa_diaria,
		pr_tarifa_total,
		pr_impuesto,
		pr_comision,
		pr_tipo_cambio,
		pr_voucher,
		pr_forma_pago,
		pr_tarjeta,
		pr_cve_ciudad_renta,
		pr_nombre_ciudad_renta,
		pr_cp_recoge,
		pr_cp_entrega,
		pr_ciudad_recoge,
		pr_ciudad_entrega,
		pr_direccion_recoge,
		pr_direccion_entrega,
		pr_cancelacion,
		SYSDATE(),
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
