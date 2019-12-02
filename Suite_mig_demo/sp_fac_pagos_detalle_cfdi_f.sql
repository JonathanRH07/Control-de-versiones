DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_detalle_cfdi_f`(
	IN  pr_id_grupo_empresa INT,
    IN  pr_cve_serie		VARCHAR(50),
    IN  pr_numero			INT,
    IN  pr_sucursal			VARCHAR(250),
    IN  pr_cliente			VARCHAR(250),
    IN  pr_razon_social		VARCHAR(250),
    IN  pr_fecha			VARCHAR(10),
    IN  pr_importe			DECIMAL(16,4),
    IN  pr_timbrada			CHAR(2),
    IN  pr_ini_pag 			INT,
    IN  pr_fin_pag 			INT,
    IN  pr_order_by			VARCHAR(100),
    OUT pr_rows_tot_table	INT,
    OUT pr_message 			VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_fac_pagos_detalle_cfdi_f
	@fecha: 		11/09/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_fac_tr_pagos por cfdi
	@autor:  		David Roldan Solares
	@cambios:
*/

# Declaración de variables.
    DECLARE lo_cve_serie		VARCHAR(500) DEFAULT '';
    DECLARE lo_numero			VARCHAR(500) DEFAULT '';
    DECLARE lo_sucursal			VARCHAR(500) DEFAULT '';
    DECLARE lo_cliente			VARCHAR(500) DEFAULT '';
    DECLARE lo_razon_social		VARCHAR(500) DEFAULT '';
    DECLARE lo_fecha			VARCHAR(500) DEFAULT '';
    DECLARE lo_importe			VARCHAR(500) DEFAULT '';
    DECLARE lo_timbrada			VARCHAR(500) DEFAULT '';
    DECLARE lo_order_by 		VARCHAR(300) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_pagos_detalle_cfdi_f';
	END ;

    IF pr_cve_serie != '' THEN
		SET lo_cve_serie = CONCAT(' AND ser.cve_serie LIKE "%', pr_cve_serie, '%" ');
	END IF;

    IF pr_numero > 0 THEN
		SET lo_numero = CONCAT(' AND pag.numero LIKE "%', pr_numero, '%" ');
	END IF;

    IF pr_sucursal != '' THEN
		SET lo_sucursal = CONCAT(' AND suc.cve_sucursal LIKE "%', pr_sucursal, '%" ');
	END IF;

    IF pr_cliente != '' THEN
		SET lo_cliente = CONCAT(' AND cli.cve_cliente LIKE "%', pr_cliente, '%" ');
	END IF;

    IF pr_razon_social != '' THEN
		SET lo_razon_social = CONCAT(' AND cli.razon_social LIKE "%', pr_razon_social, '%" ');
	END IF;

    IF pr_fecha != '' THEN
		SET lo_fecha = CONCAT(' AND pag.fecha LIKE "%', pr_fecha, '%" ');
	END IF;

    IF pr_importe > 0 THEN
		SET lo_importe = CONCAT(' AND total_pago LIKE "%', pr_importe, '%" ');
	END IF;

    IF pr_order_by != '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

    SET @query = CONCAT('SELECT
							ser.cve_serie,
							pag.numero,
							suc.cve_sucursal,
							cli.cve_cliente,
							cli.razon_social,
							pag.fecha,
							FORMAT(pag.total_pago,2) total_pago,
							moneda.clave_moneda,
							pag.tpo_cambio,
							FORMAT(pag.total_pago_moneda_base,2) total_pago_moneda_base,
							pag.total_pago_moneda_base,
							CONCAT(fpago.id_forma_pago_sat,"-",fpago.cve_forma_pago)  cve_forma_pago
						FROM ic_fac_tr_pagos pag
						LEFT JOIN ic_cat_tr_serie ser ON
							pag.id_serie = ser.id_serie
						LEFT JOIN ic_cat_tr_sucursal suc ON
							pag.id_sucursal = suc.id_sucursal
						LEFT JOIN ic_cat_tr_cliente cli ON
							pag.id_cliente = cli.id_cliente
						LEFT JOIN ct_glob_tc_moneda AS moneda ON
							moneda.id_moneda = pag.id_moneda
						LEFT JOIN ic_glob_tr_forma_pago AS fpago ON
							fpago.id_forma_pago = pag.id_forma_pago
						JOIN ic_fac_tr_pagos_detalle det ON
						pag.id_pago = det.id_pago
						JOIN ic_glob_tr_cxc cxc ON
							det.id_cxc = cxc.id_cxc
						AND cxc.c_MetodoPago = "PPD"
						WHERE pag.id_grupo_empresa = ? ',
						lo_cve_serie,
						lo_numero,
						lo_sucursal,
						lo_cliente,
						lo_razon_social,
						lo_fecha,
						lo_importe,
						lo_order_by,
						' LIMIT ?,?');

    PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
	SET @ini = pr_ini_pag;
	SET @fin = pr_fin_pag;

    -- SELECT @query;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;

	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('SELECT
							COUNT(*)
						INTO
							@pr_affect_rows
						FROM ic_fac_tr_pagos pag
						JOIN ic_cat_tr_serie ser ON
							pag.id_serie = ser.id_serie
						JOIN ic_cat_tr_sucursal suc ON
							pag.id_sucursal = suc.id_sucursal
						JOIN ic_cat_tr_cliente cli ON
							pag.id_cliente = cli.id_cliente
						WHERE pag.id_grupo_empresa = ? ',
                        lo_cve_serie,
                        lo_numero,
                        lo_sucursal,
                        lo_cliente,
                        lo_razon_social,
                        lo_fecha,
                        lo_importe);
    PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;

    DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table	= @pr_rows_tot_table;
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
