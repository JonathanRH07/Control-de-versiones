DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_factura_b2`(IN  pr_id_grupo_empresa				INT(11),
	IN  pr_id_cliente					INT,
    IN  pr_id_sucursal					INT,
	IN 	pr_c_MetodoPago					VARCHAR(500),
	IN 	pr_clave_moneda					VARCHAR(500),
	IN 	pr_cve_serie				    VARCHAR(500),
	IN 	pr_cve_sucursal					VARCHAR(500),
	IN 	pr_fac_numero					VARCHAR(500),
	IN 	pr_fecha_emision_I			    VARCHAR(100),
    IN 	pr_fecha_emision_F			    VARCHAR(100),
	IN 	pr_importe_moneda_base			VARCHAR(500),
	IN 	pr_saldo_actual					VARCHAR(500),
	IN 	pr_uuid							VARCHAR(500),
    IN  pr_consulta_gral				VARCHAR(500),
    IN 	pr_ini_pag						INT(11),
	IN 	pr_fin_pag						INT(11),
	IN 	pr_order_by				    	VARCHAR(100),
	OUT pr_rows_tot_table			    INT,
    OUT pr_message 			        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_pagos_factura_b
	@fecha: 		24/04/2018
	@descripción: 	Sp para obtenber registros de las tablas cxc_ modal
	@autor : 		rafa
	@cambios: 	    se agregaron filtros estandars @mario
*/
    DECLARE lo_tipo VARCHAR(100);

    DECLARE lo_c_MetodoPago				VARCHAR(2000) DEFAULT '';
	DECLARE lo_clave_moneda				VARCHAR(2000) DEFAULT '';
	DECLARE lo_cve_serie				VARCHAR(2000) DEFAULT '';
	DECLARE lo_cve_sucursal				VARCHAR(2000) DEFAULT '';
	DECLARE lo_fac_numero				VARCHAR(2000) DEFAULT '';
	DECLARE lo_fecha_emision_I			VARCHAR(2000) DEFAULT '';
    DECLARE lo_fecha_emision_F			VARCHAR(2000) DEFAULT '';
	DECLARE lo_importe_moneda_base		VARCHAR(2000) DEFAULT '';
	DECLARE lo_pagos_facturado			VARCHAR(2000) DEFAULT '';
	DECLARE lo_saldo_actual				VARCHAR(2000) DEFAULT '';
	DECLARE lo_saldo_moneda_base		VARCHAR(2000) DEFAULT '';
	DECLARE lo_uuid						VARCHAR(2000) DEFAULT '';
    DECLARE lo_order_by					VARCHAR(2000) DEFAULT '';
    DECLARE lo_sucursal					VARCHAR(2000) DEFAULT '';
    DECLARE lo_consulta_gral			VARCHAR(1000) DEFAULT '';


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = RETURNED_SQLSTATE;
	END ;

	SELECT
		tipo
	INTO
		lo_tipo
	FROM ic_cat_tr_sucursal
    WHERE id_sucursal = pr_id_sucursal;

    IF pr_c_MetodoPago != '' THEN
		SET lo_c_MetodoPago = CONCAT('AND mtp.c_MetodoPago   LIKE ''%',pr_c_MetodoPago,'%'' ');
	END IF;

	IF pr_clave_moneda != '' THEN
		SET lo_clave_moneda = CONCAT('AND mon.clave_moneda  LIKE ''%',pr_clave_moneda,'%'' ');
	END IF;

	IF pr_cve_serie != '' THEN
		SET lo_cve_serie = CONCAT('AND cxc.cve_serie  LIKE ''%',pr_cve_serie,'%'' ');
	END IF;
	IF pr_cve_sucursal != '' THEN
		SET lo_cve_sucursal = CONCAT('AND suc.cve_sucursal  LIKE ''%',pr_cve_sucursal,'%'' ');
	END IF;

	IF pr_fac_numero != '' THEN
		SET lo_fac_numero = CONCAT('AND cxc.fac_numero LIKE ''%',pr_fac_numero,'%'' ');
	END IF;

	IF pr_fecha_emision_I != ''  THEN
		SET lo_fecha_emision_I = CONCAT('AND cxc.fecha_emision  >= "',pr_fecha_emision_I,'" ');
	END IF;

	IF pr_fecha_emision_F != '' THEN
		SET lo_fecha_emision_F = CONCAT('AND cxc.fecha_emision  <= "',pr_fecha_emision_F,'" ');
	END IF;

	IF pr_importe_moneda_base != '' THEN
		SET lo_importe_moneda_base = CONCAT('AND cxc.importe_moneda_base  LIKE ''%',pr_importe_moneda_base,'%'' ');
	END IF;

	IF pr_saldo_actual != '' THEN
		SET lo_saldo_actual = CONCAT('AND cxc.saldo_moneda_base  LIKE ''%',pr_saldo_actual,'%'' ');
	END IF;

	IF pr_uuid != '' THEN
		SET lo_uuid = CONCAT('AND cxc.uuid ''%',pr_uuid,'%'' ');
	END IF;


   	IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	ELSE
		SET lo_order_by = ' ORDER BY cxc.saldo_moneda_base DESC ';
	END IF;

    IF (pr_consulta_gral !='')THEN
     SET lo_consulta_gral = CONCAT('
     AND (mtp.c_MetodoPago LIKE "%', pr_consulta_gral,'%"
     OR mon.clave_moneda LIKE "%', pr_consulta_gral,'%"
     OR cxc.cve_serie LIKE "%', pr_consulta_gral,'%"
     OR suc.cve_sucursal LIKE "%', pr_consulta_gral,'%"
     OR cxc.fac_numero LIKE "%', pr_consulta_gral,'%"
     OR cxc.importe_moneda_base LIKE "%', REPLACE(pr_consulta_gral,',',''),'%"
     OR cxc.saldo_moneda_base LIKE "%', REPLACE(pr_consulta_gral,',',''),'%"
     OR cxc.uuid LIKE "%', pr_consulta_gral,'%")');

	END IF;


	IF lo_tipo != 'CORPORATIVO' THEN
		SET lo_sucursal = CONCAT(' AND cxc.id_sucursal = ',pr_id_sucursal);
	END IF;

    	SET @query = CONCAT('SELECT
								suc.cve_sucursal,
								cxc.cve_serie,
								cxc.cve_tipo_serie as cveTipoSerie,
								mtp.descripcion,
								IF (cxc.cve_tipo_serie = "DOCS", "", mtp.c_MetodoPago) AS c_MetodoPago,
								cxc.fac_numero,
								cxc.fecha_emision,
								mon.clave_moneda,
								cxc.importe_moneda_base,
								cxc.saldo_moneda_base AS saldo_actual,
								cxc.saldo_moneda_base,
								cxc.saldo_moneda_base as orderc,
								cxc.estatus,
								cxc.uuid,
								cxc.id_cxc
							FROM ic_glob_tr_cxc cxc
							JOIN ic_cat_tr_sucursal suc ON
								cxc.id_sucursal = suc.id_sucursal
							JOIN ct_glob_tc_moneda mon ON
								cxc.id_moneda = mon.id_moneda
							LEFT JOIN sat_metodo_pago mtp ON
								mtp.c_MetodoPago = cxc.c_MetodoPago
							WHERE cxc.id_cliente= ',pr_id_cliente,'
                            AND cxc.id_grupo_empresa = ?
							AND cxc.saldo_facturado > 0 AND cxc.estatus = 1
							AND ((cve_tipo_serie = "DOCS" ) OR ( cve_tipo_serie = "FACT" AND UUID IS NOT NULL))
							',lo_sucursal,'
							',lo_c_MetodoPago,'
							',lo_clave_moneda,'
							',lo_cve_serie,'
							',lo_cve_sucursal,'
							',lo_fac_numero,'
							',lo_fecha_emision_I,'
                            ',lo_fecha_emision_F,'
							',lo_importe_moneda_base,'
							',lo_pagos_facturado,'
							',lo_saldo_actual,'
							',lo_saldo_moneda_base,'
							',lo_uuid,'
                            ',lo_consulta_gral,'
							',lo_order_by
							,' LIMIT ?,?'

							);

    -- SELECT @query;
    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;

    SET @pr_rows_tot_table = 0;
	SET @queryTotalRows = CONCAT('SELECT
									COUNT(*)
								INTO
									@pr_rows_tot_table
								FROM ic_glob_tr_cxc cxc
								JOIN ic_cat_tr_sucursal suc ON
									cxc.id_sucursal = suc.id_sucursal
								JOIN ct_glob_tc_moneda mon ON
									cxc.id_moneda = mon.id_moneda
								LEFT JOIN sat_metodo_pago mtp ON
									mtp.c_MetodoPago = cxc.c_MetodoPago
								WHERE cxc.id_cliente= ',pr_id_cliente,' AND
									cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND cxc.saldo_facturado > 0 AND cxc.estatus = 1
								AND ((cve_tipo_serie = "DOCS" ) OR ( cve_tipo_serie = "FACT" AND UUID IS NOT NULL))
								',lo_sucursal,'
                                ',lo_c_MetodoPago,'
								',lo_clave_moneda,'
								',lo_cve_serie,'
								',lo_cve_sucursal,'
								',lo_fac_numero,'
								',lo_fecha_emision_I,'
                                ',lo_fecha_emision_F,'
								',lo_importe_moneda_base,'
								',lo_pagos_facturado,'
								',lo_saldo_actual,'
								',lo_saldo_moneda_base,'
								',lo_uuid,'
								',lo_consulta_gral
								);


	-- SELECT @queryTotalRows;
    PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
