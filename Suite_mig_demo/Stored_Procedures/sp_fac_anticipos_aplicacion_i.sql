DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_anticipos_aplicacion_i`(
	IN  pr_id_anticipos 						INT(11),
	IN  pr_id_factura_aplicacion 				INT(11),
	IN  pr_importe_aplicado_mon_facturada 		DECIMAL(13,2),
	IN  pr_importe_aplicado_base 				DECIMAL(13,2),
	IN  pr_tipo_cambio 							DECIMAL(13,2),
	IN  pr_fecha 								DATE,
	IN  pr_id_moneda 							INT(11),
	IN  pr_id_usuario 							INT(11),
    OUT pr_inserted_id							INT,
    OUT pr_affect_rows	        				INT,
	OUT pr_message		        				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_anticipos_aplicacion_i
	@fecha:			23/03/2018
	@descripcion:	SP para insertar registro en la tabla ic_fac_tr_anticipos_aplicacion
	@autor:			Griselda Medina Medina
	@cambios:
*/

	-- DECLARE lo_importe_aplicado_usd 	DECIMAL(13,2);
	-- DECLARE lo_importe_aplicado_eur		DECIMAL(13,2);
    DECLARE lo_tipo_cambio_usd			DECIMAL(13,2);
    DECLARE lo_tipo_cambio_eur			DECIMAL(13,2);
    DECLARE lo_id_grupo_empresa			INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_anticipos_aplicacion_i';
		SET pr_affect_rows = 0;
		-- ROLLBACK;
	END;

	-- START TRANSACTION;

	SELECT
		id_grupo_empresa
	INTO
		lo_id_grupo_empresa
	FROM suite_mig_demo.ic_fac_tr_anticipos
	WHERE id_anticipos = pr_id_anticipos;

    /*Dolares*/
    IF pr_id_moneda = 149 THEN
		SET lo_tipo_cambio_usd = pr_tipo_cambio;
	ELSE
		SET lo_tipo_cambio_usd = (SELECT
									ifnull(tipo_cambio,0)
								  FROM suite_mig_conf.st_adm_tr_config_moneda
                                  JOIN ct_glob_tc_moneda ON
										suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
								  WHERE clave_moneda = 'USD'
									AND st_adm_tr_config_moneda.id_grupo_empresa = lo_id_grupo_empresa);
	END IF;

    /*Euros*/
	IF pr_id_moneda = 49 THEN
		SET lo_tipo_cambio_eur = pr_tipo_cambio;
	ELSE
		SET lo_tipo_cambio_eur = (SELECT
									ifnull(tipo_cambio,0)
								  FROM suite_mig_conf.st_adm_tr_config_moneda
                                  JOIN ct_glob_tc_moneda ON
									suite_mig_conf.st_adm_tr_config_moneda.id_moneda = ct_glob_tc_moneda.id_moneda
								  WHERE clave_moneda = 'EUR'
                                  AND st_adm_tr_config_moneda.id_grupo_empresa = lo_id_grupo_empresa);
	END IF;

    /*
    IF pr_id_moneda = 149 THEN
		SET lo_importe_aplicado_usd = (pr_importe_aplicado_base / lo_tipo_cambio_usd);
	END IF;

	IF pr_id_moneda = 49 THEN
		SET lo_importe_aplicado_eur = (pr_importe_aplicado_base / lo_tipo_cambio_eur);
	END IF;
    */

	INSERT INTO ic_fac_tr_anticipos_aplicacion
	(
		id_anticipos,
		id_factura_aplicacion,
		importe_aplicado_mon_facturada,
		importe_aplicado_base,
        importe_aplicado_usd,
        importe_aplicado_eur,
		tipo_cambio,
		fecha,
		id_moneda,
		id_usuario
	)
	VALUES
	(
		pr_id_anticipos,
		pr_id_factura_aplicacion,
		pr_importe_aplicado_mon_facturada,
		pr_importe_aplicado_base,
        (pr_importe_aplicado_base / lo_tipo_cambio_usd),
        (pr_importe_aplicado_base / lo_tipo_cambio_eur),
		pr_tipo_cambio,
		pr_fecha,
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
