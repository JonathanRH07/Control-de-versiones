DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_cxc_detalle_i`(
	IN	pr_id_cxc					INT,
    IN	pr_id_pago					INT,
    IN	pr_id_factura				INT,
    IN	pr_id_poliza				INT,
    IN	pr_id_moneda				INT,
    IN	pr_fecha					DATE,
    IN	pr_concepto					VARCHAR(150),
    IN  pr_importe 					DECIMAL(15,2),
    IN  pr_importe_moneda_base		DECIMAL(15,2),
    IN  pr_tipo_cambio				DECIMAL(17,4),
    IN  pr_referencia_origen		VARCHAR(50),
    OUT pr_inserted_id				INT,
	OUT pr_affect_rows	    		INT,
	OUT pr_message		    		VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_factura_cxc_detalle_i
		@fecha:			23/07/2018
		@descripcion:	Sp para insertar registros a la tabla de ic_glob_tr_cxc_detalle para aplicar notas
		@autor: 		Carol Mejía
		@cambios:
	*/
declare ld_tipo_cambio_usd decimal(15,4);
declare ld_tipo_cambio_eur decimal(15,4);
declare li_id_grupo_empresa integer(11);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_factura_cxc_detalle_i';
	END ;



     set li_id_grupo_empresa = (select id_grupo_empresa from ic_glob_tr_cxc where id_cxc = pr_id_cxc);
  		/*Dolares*/
	IF pr_id_moneda = 149 THEN
		SET ld_tipo_cambio_usd = pr_tipo_cambio;
	ELSE
		SET ld_tipo_cambio_usd = (SELECT ifnull(tipo_cambio,0) FROM suite_mig_conf.st_adm_tr_config_moneda join ct_glob_tc_moneda on
		 suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
		WHERE clave_moneda = 'USD' and st_adm_tr_config_moneda.id_grupo_empresa = li_id_grupo_empresa);
	END IF;
	/*Euros*/
	IF pr_id_moneda = 49 THEN
		SET ld_tipo_cambio_eur = pr_tipo_cambio;
	ELSE
		SET ld_tipo_cambio_eur = (SELECT ifnull(tipo_cambio,0) FROM suite_mig_conf.st_adm_tr_config_moneda join ct_glob_tc_moneda on
			suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
		WHERE clave_moneda = 'EUR' and st_adm_tr_config_moneda.id_grupo_empresa = li_id_grupo_empresa);
	END IF;

   -- START TRANSACTION;

	INSERT INTO ic_glob_tr_cxc_detalle(
		id_cxc,
        id_pago,
		id_factura,
        id_poliza,
		id_moneda,
		fecha,
		concepto,
		importe,
		importe_moneda_base,
		importe_usd,
		importe_eur,
		tipo_cambio,
		referencia_origen
	) VALUES (
		pr_id_cxc,
        pr_id_pago,
		pr_id_factura,
        pr_id_poliza,
		pr_id_moneda,
		pr_fecha,
		pr_concepto,
		pr_importe,
		pr_importe_moneda_base,
        (pr_importe_moneda_base / ld_tipo_cambio_usd),
        (pr_importe_moneda_base / ld_tipo_cambio_eur),
		pr_tipo_cambio,
		pr_referencia_origen
	);
	SET pr_inserted_id 	= @@identity;

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	-- COMMIT;
END$$
DELIMITER ;
