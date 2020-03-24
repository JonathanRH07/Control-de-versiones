DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_por_sustitucion_f`(
	IN	pr_id_grupo_empresa			 	INT,
    IN	pr_id_sucursal				 	INT,
    IN 	pr_sucursal						VARCHAR(100),
	IN 	pr_serie                     	VARCHAR(100),
	IN 	pr_numero                    	VARCHAR(100),
	IN 	pr_razon_social              	VARCHAR(100),
	IN 	pr_fecha_emision_I             	VARCHAR(100),
    IN 	pr_fecha_emision_F             	VARCHAR(100),
	IN 	pr_clave_moneda              	VARCHAR(100),
	IN 	pr_total_pago_moneda_base    	VARCHAR(100),
	IN 	pr_motivo_cancelacion        	VARCHAR(100),
	IN 	pr_fecha_cancelacion_I         	VARCHAR(100),
    IN 	pr_fecha_cancelacion_F         	VARCHAR(100),
	IN 	pr_uuid                      	VARCHAR(100),
	IN  pr_importe                      VARCHAR(100),
	IN  pr_fecha_captura_recibo			VARCHAR(100),
    IN  pr_ini_pag					 	INT(11),
	IN  pr_fin_pag					 	INT(11),
    IN  pr_order_by				     	VARCHAR(100),
    IN  pr_consulta_gral				CHAR(30),
    OUT pr_rows_tot_table			 	INT,
    OUT	pr_message					 	VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_pagos_por_sustitucion_c
	@fecha: 		31/10/2018
	@descripción: 	Sp para obtenber registros de las tablas ic_fac_tr_pagos
	@autor : 		Jonathan Ramirez
	@cambios:   	@mario  fitrado especifico @gral
*/
	DECLARE lo_matriz					INT;
	DECLARE lo_matriz_campo				VARCHAR(200)  DEFAULT '';
	DECLARE lo_sucursal 	            VARCHAR(2000) DEFAULT '';
	DECLARE lo_serie 	                VARCHAR(2000) DEFAULT '';
	DECLARE lo_numero 	                VARCHAR(2000) DEFAULT '';
	DECLARE lo_razon_social 	        VARCHAR(2000) DEFAULT '';
	DECLARE lo_fecha_emision_I 	        VARCHAR(2000) DEFAULT '';
    DECLARE lo_fecha_emision_F 	        VARCHAR(2000) DEFAULT '';
	DECLARE lo_clave_moneda 	        VARCHAR(2000) DEFAULT '';
	DECLARE lo_total_pago_moneda_base 	VARCHAR(2000) DEFAULT '';
	DECLARE lo_motivo_cancelacion 	    VARCHAR(2000) DEFAULT '';
	DECLARE lo_fecha_cancelacion_I 	    VARCHAR(2000) DEFAULT '';
    DECLARE lo_fecha_cancelacion_F 	    VARCHAR(2000) DEFAULT '';
	DECLARE lo_uuid 	                VARCHAR(2000) DEFAULT '';
    DECLARE lo_order_by 				VARCHAR(200)  DEFAULT '';
	DECLARE lo_importe 				    VARCHAR(200)  DEFAULT '';
    DECLARE lo_fecha_captura_recibo		VARCHAR(200)  DEFAULT '';
     DECLARE lo_consulta_gral			VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = RETURNED_SQLSTATE;
	END ;

    IF (pr_consulta_gral != '' ) THEN
	SET lo_consulta_gral = CONCAT(' AND (suc.cve_sucursal LIKE "%',pr_consulta_gral, '%"
									OR  ser.cve_serie					LIKE "%',pr_consulta_gral, '%"
									OR  pag.numero						LIKE "%',pr_consulta_gral, '%"
									OR  pag.razon_social				LIKE "%',pr_consulta_gral, '%"
									OR  pag.fecha_captura_recibo		LIKE "%',pr_consulta_gral, '%"
									OR  mon.clave_moneda				LIKE "%',pr_consulta_gral, '%"
									OR  pag.total_pago_moneda_base		LIKE "%',pr_consulta_gral, '%"
									OR  raz.descripcion					LIKE "%',pr_consulta_gral, '%"
									OR  pag.fecha_cancelacion			LIKE "%',pr_consulta_gral, '%"
									OR  cfdi.uuid						LIKE "%',pr_consulta_gral, '%"
									OR  pag.total_pago_moneda_base		LIKE "%',pr_consulta_gral, '%"
									OR  pag.fecha_captura_recibo		LIKE "%',pr_consulta_gral, '%"  )
								');
	END IF;

	IF pr_sucursal != '' THEN
	SET lo_sucursal = CONCAT('AND suc.cve_sucursal LIKE ''%',pr_sucursal,'%'' ');
	END IF;

	IF pr_serie != '' THEN
	SET lo_serie = CONCAT(' AND ser.cve_serie LIKE ''%',pr_serie,'%'' ');
	END IF;

	IF pr_numero != '' THEN
	SET lo_numero = CONCAT(' AND pag.numero LIKE ''%',pr_numero,'%'' ');
	END IF;

	IF pr_razon_social != '' THEN
	SET lo_razon_social = CONCAT(' AND pag.razon_social LIKE ''%',pr_razon_social,'%'' ');
	END IF;

	IF pr_fecha_emision_I != '' THEN
	SET lo_fecha_emision_I = CONCAT(' AND pag.fecha_captura_recibo >= "',pr_fecha_emision_I,'" ');
	END IF;

    IF pr_fecha_emision_F != '' THEN
	SET lo_fecha_emision_F = CONCAT(' AND pag.fecha_captura_recibo <= "',pr_fecha_emision_F,'" ');
	END IF;

	IF pr_clave_moneda != '' THEN
	SET lo_clave_moneda = CONCAT(' AND mon.clave_moneda LIKE ''%',pr_clave_moneda,'%'' ');
	END IF;

	IF pr_total_pago_moneda_base != '' THEN
	SET lo_total_pago_moneda_base = CONCAT(' AND pag.total_pago_moneda_base LIKE ''%',REPLACE(pr_total_pago_moneda_base,',',''),'%'' ');
	END IF;

	IF pr_motivo_cancelacion != '' THEN
	SET lo_motivo_cancelacion = CONCAT(' AND raz.descripcion  LIKE ''%',pr_motivo_cancelacion,'%'' ');
	END IF;

	IF pr_fecha_cancelacion_I != '' THEN
	SET lo_fecha_cancelacion_I = CONCAT('AND pag.fecha_cancelacion >= "',pr_fecha_cancelacion_I,'" ');
	END IF;

    IF pr_fecha_cancelacion_F != '' THEN
	SET lo_fecha_cancelacion_F = CONCAT('AND pag.fecha_cancelacion <= "',pr_fecha_cancelacion_F,'" ');
	END IF;

	IF pr_uuid != '' THEN
	SET lo_uuid = CONCAT('AND cfdi.uuid LIKE ''%',pr_uuid,'%'' ');
	END IF;

    IF pr_importe != '' THEN
	SET lo_importe = CONCAT('AND pag.total_pago_moneda_base LIKE ''%',pr_importe,'%'' ');
	END IF;

	IF pr_fecha_captura_recibo != '' THEN
	SET lo_fecha_captura_recibo = CONCAT('AND pag.fecha_captura_recibo LIKE ''%',pr_fecha_captura_recibo,'%'' ');
	END IF;

	IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	SELECT
		matriz
	INTO
		lo_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

	IF lo_matriz = 0 THEN
		SET lo_matriz_campo = CONCAT(' AND suc.id_sucursal = ',pr_id_sucursal);
	END IF;

	SET @query = CONCAT('SELECT
							pag.id_pago,
							suc.cve_sucursal sucursal,
							ser.cve_serie serie,
							pag.numero,
							pag.razon_social,
							pag.fecha_captura_recibo fecha_emision,
							mon.clave_moneda,
							FORMAT(pag.total_pago_moneda_base,2) as total_pago_moneda_base,
							raz.descripcion motivo_cancelacion,
							pag.fecha_cancelacion,
							cfdi.uuid
						FROM ic_fac_tr_pagos pag
						JOIN ic_cat_tr_sucursal suc ON
							pag.id_sucursal = suc.id_sucursal
						JOIN ic_cat_tr_serie ser ON
							pag.id_serie = ser.id_serie
						JOIN ct_glob_tc_moneda mon ON
							pag.id_moneda = mon.id_moneda
						JOIN ic_fac_tc_razon_cancelacion raz ON
							pag.id_razon_cancelacion = raz.id_razon_cancelacion
						JOIN ic_fac_tr_pagos_cfdi cfdi ON
							pag.id_pago = cfdi.id_pago
						WHERE pag.estatus = ''CANCELADO''
						AND pag.id_grupo_empresa = ?
						AND pag.id_pago_sustituido_por = 0
						AND pag.id_pago_sustituye_a = 0
							',lo_matriz_campo
							,lo_serie
							,lo_numero
							,lo_razon_social
							,lo_fecha_emision_I
                            ,lo_fecha_emision_F
							,lo_clave_moneda
							,lo_total_pago_moneda_base
							,lo_motivo_cancelacion
							,lo_fecha_cancelacion_I
                            ,lo_fecha_cancelacion_F
							,lo_uuid
                            ,lo_fecha_captura_recibo
                            ,lo_importe
							,lo_order_by
                            ,lo_consulta_gral
							,' LIMIT ?,?'
						);

		-- SELECT @query;
		PREPARE stmt FROM @query;
		SET @id_grupo_empresa = pr_id_grupo_empresa;
		SET @ini = pr_ini_pag;
		SET @fin = pr_fin_pag;
		EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
		DEALLOCATE PREPARE stmt;

	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('SELECT
									COUNT(*)
								INTO
									@pr_rows_tot_table
								FROM ic_fac_tr_pagos pag
								JOIN ic_cat_tr_sucursal suc ON
									pag.id_sucursal = suc.id_sucursal
								JOIN ic_cat_tr_serie ser ON
									pag.id_serie = ser.id_serie
								JOIN ct_glob_tc_moneda mon ON
									pag.id_moneda = mon.id_moneda
								JOIN ic_fac_tc_razon_cancelacion raz ON
									pag.id_razon_cancelacion = raz.id_razon_cancelacion
								JOIN ic_fac_tr_pagos_cfdi cfdi ON
									pag.id_pago = cfdi.id_pago
								WHERE pag.estatus = ''CANCELADO''
								AND pag.id_grupo_empresa = ?
								AND pag.id_pago_sustituido_por = 0
								AND pag.id_pago_sustituye_a = 0
									',lo_matriz_campo
									,lo_serie
									,lo_numero
									,lo_razon_social
									,lo_fecha_emision_I
                                    ,lo_fecha_emision_F
									,lo_clave_moneda
									,lo_total_pago_moneda_base
									,lo_motivo_cancelacion
									,lo_fecha_cancelacion_I
                                    ,lo_fecha_cancelacion_F
									,lo_uuid
									,lo_fecha_captura_recibo
									,lo_importe
									,lo_order_by
									,lo_consulta_gral
								);

	-- SELECT @queryTotalRows;
    PREPARE stmt FROM @queryTotalRows;
    SET @id_grupo_empresa = pr_id_grupo_empresa;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

    SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
