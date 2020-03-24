DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_compras_x_servicio_i`(
	IN  pr_id_grupo_empresa					INT(11),
	IN  pr_id_tc_corporativa				INT(11),
	IN  pr_id_factura				        INT(11),
    IN	pr_id_proveedor						INT(11),
	IN  pr_id_moneda						INT(11),
	IN  pr_no_tarjeta_credito				CHAR(45),
	IN  pr_origen_compra					ENUM('FACTURACION','INTERFACE'),
	IN  pr_tipo_cambio						DECIMAL(18,4),
	IN  pr_importe							DECIMAL(18,4),
	IN  pr_importe_moneda_base				DECIMAL(18,4),
	IN  pr_importe_usd						DECIMAL(18,4),
	IN  pr_importe_euros					DECIMAL(18,4),
	IN  pr_propietario_tc					ENUM('T.C. CLIENTE','CORPORATIVA','NO APLICA'),
	IN  pr_importe_tc						DECIMAL(18,4),
	IN  pr_importe_moneda_base_tc			DECIMAL(18,4),
	IN  pr_importe_usd_tc					DECIMAL(18,4),
	IN  pr_importe_euros_tc					DECIMAL(18,4),
	IN  pr_forma_pago_prov_efectivo			ENUM('CREDITO PROVEEDOR','CONTADO','NO APLICA'),
	IN  pr_importe_efectivo					DECIMAL(18,4),
	IN  pr_importe_moneda_base_efectivo		DECIMAL(18,4),
	IN  pr_importe_usd_2					DECIMAL(18,4),
	IN  pr_importe_euros_2					DECIMAL(18,4),
	IN  pr_referencia						CHAR(20),
	IN  pr_fecha_cargo						DATE,
	IN  pr_fecha_corte						DATE,
	IN  pr_fecha_vencimiento				DATE,
	IN  pr_estatus							ENUM('ACTIVO','CANCELADO'),
    OUT pr_inserted_id						INT,
    OUT pr_affect_rows      				INT,
    OUT pr_message 	         				VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_fac_compras_x_servicio_i
	@fecha: 		15/03/2019
	@descripcion: 	SP para insertar en ic_fac_tr_compras_x_servicio
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_compras_x_servicio_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

    INSERT INTO ic_fac_tr_compras_x_servicio
	(
		id_grupo_empresa,
		id_tc_corporativa,
		id_factura,
        id_proveedor,
		id_moneda,
		no_tarjeta_credito,
		origen_compra,
		tipo_cambio,
		importe,
		importe_moneda_base,
		importe_usd,
		importe_euros,
		propietario_tc,
		importe_tc,
		importe_moneda_base_tc,
		importe_usd_tc,
		importe_euros_tc,
		forma_pago_prov_efectivo,
		importe_efectivo,
		importe_moneda_base_efectivo,
		importe_usd_2,
		importe_euros_2,
		referencia,
		fecha_cargo,
		fecha_corte,
		fecha_vencimiento,
		estatus
	)
	VALUES
	(
		pr_id_grupo_empresa,
		pr_id_tc_corporativa,
		pr_id_factura,
        pr_id_proveedor,
		pr_id_moneda,
		pr_no_tarjeta_credito,
		pr_origen_compra,
		pr_tipo_cambio,
		pr_importe,
		pr_importe_moneda_base,
		pr_importe_usd,
		pr_importe_euros,
		pr_propietario_tc,
		pr_importe_tc,
		pr_importe_moneda_base_tc,
		pr_importe_usd_tc,
		pr_importe_euros_tc,
		pr_forma_pago_prov_efectivo,
		pr_importe_efectivo,
		pr_importe_moneda_base_efectivo,
		pr_importe_usd_2,
		pr_importe_euros_2,
		pr_referencia,
		pr_fecha_cargo,
		pr_fecha_corte,
		pr_fecha_vencimiento,
		pr_estatus
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
