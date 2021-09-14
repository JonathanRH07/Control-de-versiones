DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_proveedores_compras_x_servicio_u`(
	IN	pr_id_compras_x_servicio				INT,
    IN	pr_id_grupo_empresa						INT,
	IN	pr_id_tc_corporativa					INT,
    IN	pr_id_factura							INT,
    IN	pr_id_proveedor							INT,
    IN  pr_id_moneda      						INT,
    IN  pr_no_tarjeta_credito					CHAR(45),
    IN  pr_origen_compra						ENUM('FACTURACION','INTERFACE'),
    IN  pr_tipo_cambio							DECIMAL(18,4),
    IN  pr_importe								DECIMAL(18,4),
    IN  pr_importe_moneda_base					DECIMAL(18,4),
    IN  pr_importe_usd							DECIMAL(18,4),
    IN  pr_importe_euros						DECIMAL(18,4),
    IN  pr_propietario_tc						ENUM('T.C. CLIENTE','CORPORATIVA','NO APLICA'),
    IN  pr_importe_tc							DECIMAL(15,2),
    IN  pr_importe_moneda_base_tc				DECIMAL(15,2),
    IN  pr_importe_usd_tc						DECIMAL(15,2),
    IN  pr_importe_euros_tc						DECIMAL(15,2),
    IN  pr_forma_pago_prov_efectivo				ENUM('CREDITO PROVEEDOR','CONTADO','NO APLICA'),
    IN  pr_importe_efectivo						DECIMAL(15,2),
    IN  pr_importe_moneda_base_efectivo			DECIMAL(15,2),
    IN  pr_importe_usd_2						DECIMAL(15,2),
    IN  pr_importe_euros_2						DECIMAL(15,2),
    IN  pr_referencia							CHAR(20),
    IN  pr_fecha_cargo							DATE,
    IN  pr_fecha_corte							DATE,
    IN  pr_fecha_vencimiento					DATE,
    OUT pr_affect_rows	        				INT,
    OUT pr_message 	  							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_proveedores_compras_x_servicio_u
	@fecha:			16/05/2019
	@descripcion:	Sp para actualizar operaciones en la tabla
	@autor: 		Jonathan Ramirez
	@
*/

	DECLARE lo_id_tc_corporativa				VARCHAR(200) DEFAULT '';
    DECLARE lo_id_proveedor						VARCHAR(200) DEFAULT '';
    DECLARE lo_id_moneda						VARCHAR(200) DEFAULT '';
    DECLARE lo_no_tarjeta_credito				VARCHAR(200) DEFAULT '';
    DECLARE lo_origen_compra					VARCHAR(200) DEFAULT '';
    DECLARE lo_tipo_cambio						VARCHAR(200) DEFAULT '';
    DECLARE lo_importe							VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_moneda_base				VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_usd						VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_euros					VARCHAR(200) DEFAULT '';
    DECLARE lo_propietario_tc					VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_tc						VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_moneda_base_tc			VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_usd_tc					VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_euros_tc					VARCHAR(200) DEFAULT '';
    DECLARE lo_forma_pago_prov_efectivo			VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_efectivo					VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_moneda_base_efectivo		VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_usd_2					VARCHAR(200) DEFAULT '';
    DECLARE lo_importe_euros_2					VARCHAR(200) DEFAULT '';
    DECLARE lo_referencia						VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_cargo						VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_corte						VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_vencimiento				VARCHAR(200) DEFAULT '';
    DECLARE lo_tipo_cambio_usd					DECIMAL(13,4);
    DECLARE lo_tipo_cambio_eur					DECIMAL(13,4);


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_proveedores_compras_x_servicio_u';
	END ;

    IF pr_id_tc_corporativa > 0 THEN
		SET lo_id_tc_corporativa = CONCAT('id_tc_corporativa = ',pr_id_tc_corporativa,',');
    END IF;

    IF pr_id_proveedor > 0 THEN
		SET lo_id_proveedor = CONCAT('id_proveedor = ',pr_id_proveedor,',');
    END IF;

    IF pr_id_moneda > 0 THEN
		SET lo_id_moneda = CONCAT('id_moneda = ',pr_id_moneda,',');
    END IF;

	IF pr_no_tarjeta_credito != '' THEN
		SET lo_no_tarjeta_credito = CONCAT('no_tarjeta_credito = ''',pr_no_tarjeta_credito,''',');
    END IF;

	IF pr_origen_compra != '' THEN
		SET lo_origen_compra = CONCAT('origen_compra = ''',pr_origen_compra,''',');
    END IF;

	IF pr_tipo_cambio > 0 THEN
		SET lo_tipo_cambio = CONCAT('tipo_cambio = ',pr_tipo_cambio,',');
    END IF;

    IF pr_importe > 0 THEN
		SET lo_importe = CONCAT('importe = ',pr_importe,',');
    END IF;

    IF pr_importe_moneda_base > 0 THEN
		SET lo_importe_moneda_base = CONCAT('importe_moneda_base = ',pr_importe_moneda_base,',');
    END IF;

	IF pr_importe_euros	> 0 THEN
		SET lo_importe_euros = CONCAT('importe_euros = ',pr_importe_euros,',');
    END IF;

	IF pr_propietario_tc != '' THEN
		SET lo_propietario_tc = CONCAT('propietario_tc = ''',pr_propietario_tc,''',');
    END IF;

	IF pr_importe_tc > 0 THEN
		SET lo_importe_tc = CONCAT('importe_tc = ',pr_importe_tc,',');
    END IF;

	IF pr_importe_moneda_base_tc > 0 THEN
		SET lo_importe_moneda_base_tc = CONCAT('importe_moneda_base_tc = ',pr_importe_moneda_base_tc,',');
    END IF;

	IF pr_forma_pago_prov_efectivo != '' THEN
		SET lo_forma_pago_prov_efectivo = CONCAT('forma_pago_prov_efectivo = ''',pr_forma_pago_prov_efectivo,''',');
    END IF;

    IF pr_importe_efectivo > 0 THEN
		SET lo_importe_efectivo = CONCAT('importe_efectivo = ',pr_importe_efectivo,',');
    END IF;

	IF pr_importe_moneda_base_efectivo > 0 THEN
		SET lo_importe_moneda_base_efectivo = CONCAT('importe_moneda_base_efectivo = ',pr_importe_moneda_base_efectivo,',');
    END IF;

	IF pr_referencia != 0 THEN
		SET lo_referencia = CONCAT('referencia = ''',pr_referencia,''',');
    END IF;

	IF pr_fecha_cargo != '0000-00-00' THEN
		SET lo_fecha_cargo = CONCAT('fecha_cargo = ''',pr_fecha_cargo,''',');
    END IF;

	IF pr_fecha_corte != '0000-00-00' THEN
		SET lo_fecha_corte = CONCAT('fecha_corte = ''',pr_fecha_corte,''',');
    END IF;

	IF pr_fecha_vencimiento != '0000-00-00' THEN
		SET lo_fecha_vencimiento = CONCAT('fecha_vencimiento = ''',pr_fecha_vencimiento,''',');
    END IF;

    	/*Dolares*/
	IF pr_id_moneda = 149 THEN
		SET lo_tipo_cambio_usd = pr_tipo_cambio;
	ELSE
		SET lo_tipo_cambio_usd = ( SELECT
										IFNULL(tipo_cambio,0)
									FROM suite_mig_conf.st_adm_tr_config_moneda conf_moneda
									JOIN ct_glob_tc_moneda cat_moneda ON
										conf_moneda.id_moneda = cat_moneda.id_moneda
									WHERE clave_moneda = 'USD'
									AND conf_moneda.id_grupo_empresa = pr_id_grupo_empresa);
	END IF;

    /*Euros*/
	IF pr_id_moneda = 49 THEN
		SET lo_tipo_cambio_eur = pr_tipo_cambio;
	ELSE
		SET lo_tipo_cambio_eur = ( SELECT
										IFNULL(tipo_cambio,0)
									FROM suite_mig_conf.st_adm_tr_config_moneda conf_moneda
									JOIN ct_glob_tc_moneda cat_moneda ON
										conf_moneda.id_moneda = cat_moneda.id_moneda
									WHERE clave_moneda = 'EUR'
									AND conf_moneda.id_grupo_empresa = pr_id_grupo_empresa);
	END IF;


	IF pr_importe_usd > 0 THEN
		SET lo_importe_usd = CONCAT('importe_usd = ',(pr_importe_moneda_base / lo_tipo_cambio_usd),',');
    END IF;

    IF pr_importe_euros	> 0 THEN
		SET lo_importe_euros = CONCAT('importe_euros = ',(pr_importe_moneda_base / lo_tipo_cambio_eur),',');
    END IF;

	IF pr_importe_usd_tc > 0 THEN
		SET lo_importe_usd_tc = CONCAT('importe_usd_tc = ',(pr_importe_moneda_base_tc / lo_tipo_cambio_usd),',');
    END IF;

	IF pr_importe_euros_tc > 0 THEN
		SET lo_importe_euros_tc = CONCAT('importe_euros_tc = ',(pr_importe_moneda_base_tc / lo_tipo_cambio_eur),',');
    END IF;

	IF pr_importe_usd_2 > 0 THEN
		SET lo_importe_usd_2 = CONCAT('importe_usd_2 = ',(pr_importe_moneda_base_efectivo / lo_tipo_cambio_usd),',');
    END IF;

	IF pr_importe_euros_2 > 0 THEN
		SET lo_importe_euros_2 = CONCAT('importe_euros_2 = ',(pr_importe_moneda_base_efectivo / lo_tipo_cambio_eur),',');
    END IF;

    SET @query = CONCAT('
						UPDATE ic_fac_tr_compras_x_servicio
						SET ','
							',lo_id_tc_corporativa,'
                              ',lo_id_proveedor,'
                              ',lo_id_moneda,'
                              ',lo_no_tarjeta_credito,'
                              ',lo_origen_compra,'
                              ',lo_tipo_cambio,'
                              ',lo_importe,'
                              ',lo_importe_moneda_base,'
                              ',lo_importe_usd,'
                              ',lo_importe_euros,'
                              ',lo_propietario_tc,'
                              ',lo_importe_tc,'
                              ',lo_importe_moneda_base_tc,'
                              ',lo_importe_usd_tc,'
                              ',lo_importe_euros_tc,'
                              ',lo_forma_pago_prov_efectivo,'
                              ',lo_importe_efectivo,'
                              ',lo_importe_moneda_base_efectivo,'
                              ',lo_importe_usd_2,'
                              ',lo_importe_euros_2,'
                              ',lo_referencia,'
                              ',lo_fecha_cargo,'
                              ',lo_fecha_corte,'
                              ',lo_fecha_vencimiento,'
                            fecha_vencimiento = SYSDATE()
						WHERE id_compras_x_servicio = ',pr_id_compras_x_servicio,'
                        AND id_grupo_empresa = ',pr_id_grupo_empresa,'
                        AND id_factura = ',pr_id_factura
						);

	-- SELECT @query;
    PREPARE stmt FROM @query;
	EXECUTE stmt;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
