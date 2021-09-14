DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_moneda_u`(
	IN  pr_id_moneda_empresa	INT(11),
    IN  pr_id_moneda	        INT(11),
    IN  pr_tipo_cambio			DECIMAL(16,4),
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_moneda_nacional 		CHAR(1),
	IN  pr_tipo_cambio_auto 	CHAR(1),
	IN  pr_estatus 				ENUM('ACTIVO','INACTIVO'),
	IN  pr_id_usuario 			INT(11),
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_config_moneda_u
	@fecha: 		15/12/2016
	@descripcion: 	SP para actualizar registro en catalogo adm_config_moneda
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE lo_id_moneda 				VARCHAR(1000) DEFAULT '';
	DECLARE lo_tipo_cambio 				VARCHAR(1000) DEFAULT '';
    DECLARE lo_moneda_nacional 			VARCHAR(1000) DEFAULT '';
    DECLARE lo_tipo_cambio_auto 		VARCHAR(1000) DEFAULT '';
    DECLARE lo_estatus 					VARCHAR(1000) DEFAULT '';
    DECLARE lo_base_datos				VARCHAR(200) DEFAULT '';
    DECLARE lo_count					INT;
    DECLARE lo_execute					INT DEFAULT 1;

	/* VARIABLES PARA VALIDAR MONEDA NACIONAL */
    DECLARE lo_mn_moneda_nacional		CHAR(1);
    DECLARE lo_current_id_moneda		INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'CONFIGURATION.MESSAGE_ERROR_UPDATE_MONEDAS';
        SET pr_affect_rows = 0;

	END;

	SELECT
		CONCAT(dba.nombre,'.ic_fac_tr_factura')
	INTO
		lo_base_datos
	FROM suite_mig_conf.st_adm_tr_grupo_empresa grup_empr
	JOIN suite_mig_conf.st_adm_tr_empresa emp ON
		grup_empr.id_empresa = emp.id_empresa
	JOIN suite_mig_conf.st_adm_tc_base_datos dba ON
		emp.id_base_datos = dba.id_base_datos
	WHERE grup_empr.id_grupo_empresa = pr_id_grupo_empresa
    LIMIT 1;

	SELECT
		moneda_nacional,
        id_moneda
	INTO
		lo_mn_moneda_nacional,
        lo_current_id_moneda
	FROM st_adm_tr_config_moneda
	WHERE id_moneda_empresa = pr_id_moneda_empresa;

	SET @lo_count = 0;
	SET @queryfacts = CONCAT('SELECT
								COUNT(*)
							INTO
								@lo_count
							FROM ',lo_base_datos,'
							WHERE id_moneda = ',lo_current_id_moneda,'
							AND id_grupo_empresa = ',pr_id_grupo_empresa);

	PREPARE stmt1 FROM @queryfacts;
	EXECUTE stmt1;
	SET lo_count = @lo_count;

	# Falta validar que el usuario no se este usando en otras tablas
    IF pr_id_moneda > 0 THEN
		SET lo_id_moneda = CONCAT(' id_moneda = ', pr_id_moneda, ',');
	END IF;

    IF pr_tipo_cambio > 0 THEN
		SET lo_tipo_cambio = CONCAT(' tipo_cambio = ', pr_tipo_cambio, ',');
	END IF;

    IF pr_tipo_cambio = 0 THEN
		SET lo_tipo_cambio = CONCAT(' tipo_cambio = NULL ,');
	END IF;

	IF pr_moneda_nacional != '' THEN
		SET lo_moneda_nacional = CONCAT(' moneda_nacional = "', pr_moneda_nacional, '",');
	END IF;

    IF pr_tipo_cambio_auto != '' THEN
		SET lo_tipo_cambio_auto = CONCAT(' tipo_cambio_auto = "', pr_tipo_cambio_auto, '",');
	END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT(' estatus = "', pr_estatus, '",');
	END IF;
    IF pr_moneda_nacional = 'N' AND lo_mn_moneda_nacional = 'S' AND lo_count > 0 THEN
		SET pr_message = 'CONFIGURATION.MESSAGE_ERROR_USED_CURRENCY';
		SET pr_affect_rows = 0;
	ELSEIF pr_moneda_nacional = 'S' AND pr_estatus = 'INACTIVO' THEN
		SET pr_message = 'CONFIGURATION.MESSAGE_ERROR_INACTIVE_CURRENCY';
		SET pr_affect_rows = 0;
	ELSE
		SET @query = CONCAT('UPDATE suite_mig_conf.st_adm_tr_config_moneda
								SET ',
								lo_id_moneda,
								lo_tipo_cambio,
								lo_tipo_cambio_auto,
								lo_estatus,
								'fecha_mod  = sysdate()
								WHERE id_moneda_empresa = ?');
		-- SELECT @query;

		PREPARE stmt FROM @query;
		SET @id_moneda_empresa= pr_id_moneda_empresa;
		EXECUTE stmt USING @id_moneda_empresa;
		DEALLOCATE PREPARE stmt;

		#Devuelve el numero de registros insertados
		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;
		# Mensaje de ejecucion.
		SET pr_message = 'SUCCESS';

	END IF;
END$$
DELIMITER ;
