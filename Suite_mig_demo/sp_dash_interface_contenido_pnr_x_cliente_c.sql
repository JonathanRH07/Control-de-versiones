DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_interface_contenido_pnr_x_cliente_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
	IN  pr_ini_pag							INT,
    IN  pr_fin_pag							INT,
    OUT pr_rows_tot_table					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_interface_contenido_pnr_x_vendedor_c
	@fecha:			06/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda						VARCHAR(100);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_interface_graf_x_gds_c';
	END ;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
        SET lo_moneda = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
        SET lo_moneda = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_cliente_recibidos;
    DROP TABLE IF EXISTS tmp_cliente_facturados;
    DROP TABLE IF EXISTS tmp_cliente_cxs;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* IMPORTE FACTURADO */
    SET @querycli_facturado = CONCAT(
							'
							CREATE TEMPORARY TABLE tmp_cliente_facturados
							SELECT
								cli.id_cliente,
								cli.razon_social,
								SUM((tarifa_moneda_base',lo_moneda,') + (importe_markup',lo_moneda,') - (descuento',lo_moneda,')) total_facturado,
								COUNT(*) contador
							FROM ic_gds_tr_general gen
							JOIN ic_cat_tr_cliente cli ON
								gen.cve_cliente = cli.cve_cliente
							JOIN ic_fac_tr_factura fac ON
								gen.fac_numero = fac.fac_numero
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND gen.id_sucursal = ',pr_id_sucursal,'
							AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
							AND gen.fac_numero IS NOT NULL
							GROUP BY cli.id_cliente');

    -- SELECT @querycli_facturado;
	PREPARE stmt FROM @querycli_facturado;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* IMPORTE FACTURADO CXS */
    SET @querycli_cxs = CONCAT(
							'
                            CREATE TEMPORARY TABLE tmp_cliente_cxs
							SELECT
								cli.id_cliente,
								cli.razon_social,
								SUM((tarifa_moneda_base',lo_moneda,') + (importe_markup',lo_moneda,') - (descuento',lo_moneda,')) total_cxs,
								COUNT(*) contador
							FROM ic_gds_tr_general gen
							JOIN ic_cat_tr_cliente cli ON
								gen.cve_cliente = cli.cve_cliente
							JOIN ic_fac_tr_factura fac ON
								gen.fac_numero_cxs = fac.fac_numero
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND gen.id_sucursal = ',pr_id_sucursal,'
							AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
							AND gen.fac_numero IS NOT NULL
							GROUP BY cli.id_cliente;');

	-- SELECT @querycli_cxs;
	PREPARE stmt FROM @querycli_cxs;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		fac.razon_social,
		IFNULL((fac.contador + cxs.contador), 0) contador_pnr,
		IFNULL(fac.total_facturado, 0) total_facturado,
		IFNULL(cxs.total_cxs, 0) total_cxs
	FROM tmp_cliente_facturados fac
	LEFT JOIN tmp_cliente_cxs cxs ON
		fac.id_cliente = cxs.id_cliente
	LIMIT pr_ini_pag, pr_fin_pag;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		COUNT(*)
	INTO
		pr_rows_tot_table
	FROM tmp_cliente_facturados fac
	LEFT JOIN tmp_cliente_cxs cxs ON
		fac.id_cliente = cxs.id_cliente;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
