DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_anticipos_i`(
	IN  pr_id_grupo_empresa 						INT(11),
	IN  pr_id_factura 								INT(11),
	IN  pr_id_cliente 								INT(11),
	IN  pr_anticipo_moneda_facturada 				DECIMAL(13,2),
	IN  pr_anticipo_moneda_base 					DECIMAL(13,2),
	IN  pr_tipo_cambio 								DECIMAL(13,4),
	IN  pr_fecha 									DATE,
	IN  pr_importe_aplicado_moneda_facturada 		DECIMAL(13,2),
	IN  pr_importe_aplicado_base 					DECIMAL(13,2),
	IN  pr_id_grupo_fit 							INT(11),
	IN  pr_id_moneda 								INT(11),
	IN  pr_id_usuario 								INT(11),
    OUT pr_inserted_id								INT,
    OUT pr_affect_rows	        					INT,
	OUT pr_message		        					VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_anticipos_i
	@fecha:			23/03/2018
	@descripcion:	SP para insertar registro en la tabla ic_fac_tr_anticipos
	@autor:			Griselda Medina Medina
	@cambios:
*/
	DECLARE lo_anticipo_usd 			DECIMAL(13,2);
    DECLARE lo_anticipo_eur				DECIMAL(13,2);
    DECLARE lo_importe_aplicado_usd		DECIMAL(13,2) DEFAULT 0;
    DECLARE lo_importe_aplicado_eur		DECIMAL(13,2) DEFAULT 0;

	DECLARE lo_tipo_cambio_usd			DECIMAL(13,4);
    DECLARE lo_tipo_cambio_eur			DECIMAL(13,4);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_anticipos_i';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

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

	/*Dolares*/
	SET lo_anticipo_usd = IFNULL((pr_anticipo_moneda_base / lo_tipo_cambio_usd),0);
    -- SET lo_importe_aplicado_usd = IFNULL((pr_importe_aplicado_base / lo_tipo_cambio_eur),0);
    /*Euros*/
	SET lo_anticipo_eur = IFNULL((pr_anticipo_moneda_base / lo_tipo_cambio_eur),0);
	-- SET lo_importe_aplicado_eur = IFNULL((pr_importe_aplicado_base / lo_tipo_cambio_eur),0);

	INSERT INTO ic_fac_tr_anticipos (
		id_grupo_empresa,
		id_factura,
		id_cliente,
		anticipo_moneda_facturada,
		anticipo_moneda_base,
		tipo_cambio,
		fecha,
		importe_aplicado_moneda_facturada,
		importe_aplicado_base,
        anticipo_usd,
        anticipo_eur,
        importe_aplicado_usd,
        importe_aplicado_eur,
		id_grupo_fit,
		id_moneda,
		id_usuario
		)
	VALUES
		(
		pr_id_grupo_empresa,
		pr_id_factura,
		pr_id_cliente,
		pr_anticipo_moneda_facturada,
		pr_anticipo_moneda_base,
		pr_tipo_cambio,
		pr_fecha,
		pr_importe_aplicado_moneda_facturada,
		pr_importe_aplicado_base,
        lo_anticipo_usd,
        lo_anticipo_eur,
        lo_importe_aplicado_usd,
        lo_importe_aplicado_eur,
		pr_id_grupo_fit,
		pr_id_moneda,
		pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
	-- COMMIT;

END$$
DELIMITER ;
