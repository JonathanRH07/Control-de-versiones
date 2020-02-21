DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_superuser_contenido_x_provedor_c`(
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
	@nombre:		sp_dash_superuser_contenido_x_provedor_c
	@fecha:			31/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por dia
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(150);
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_superuser_contenido_x_provedor_c';
	END ;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
	IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_ventas_x_proveedor_ing;
    DROP TABLE IF EXISTS tmp_ventas_x_proveedor_egr;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_prov_ing = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_ventas_x_proveedor_ing
                    SELECT
						prov.id_proveedor,
						prov.cve_proveedor,
                        prov.nombre_comercial,
						IFNULL(SUM((IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0) - IFNULL(descuento',lo_moneda_reporte,', 0))), 0) total_venta,
						IFNULL(SUM(IFNULL(comision_agencia',lo_moneda_reporte,', 0)), 0) importe_comision
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_cat_tr_proveedor prov ON
						det.id_proveedor = prov.id_proveedor
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.estatus != 2
                    AND fac.tipo_cfdi = ''I''
					GROUP BY det.id_proveedor');

    -- SELECT @query_prov_ing;
	PREPARE stmt FROM @query_prov_ing;
	EXECUTE stmt;

    SET @query_prov_egr = CONCAT(
					'
					CREATE TEMPORARY TABLE tmp_ventas_x_proveedor_egr
                    SELECT
						prov.id_proveedor,
						IFNULL(SUM((IFNULL(tarifa_moneda_base',lo_moneda_reporte,', 0) + IFNULL(importe_markup',lo_moneda_reporte,', 0) - IFNULL(descuento',lo_moneda_reporte,', 0))), 0) total_venta,
						IFNULL(SUM(IFNULL(comision_agencia',lo_moneda_reporte,', 0)), 0) importe_comision
					FROM ic_fac_tr_factura fac
					JOIN ic_fac_tr_factura_detalle det ON
						fac.id_factura = det.id_factura
					JOIN ic_cat_tr_proveedor prov ON
						det.id_proveedor = prov.id_proveedor
					WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac.estatus != 2
                    AND fac.tipo_cfdi = ''E''
					GROUP BY det.id_proveedor');

    -- SELECT @query_prov_egr;
	PREPARE stmt FROM @query_prov_egr;
	EXECUTE stmt;

    SELECT
		ingreso.cve_proveedor,
        ingreso.nombre_comercial,
        IFNULL((IFNULL(ingreso.total_venta, 0) - IFNULL(egreso.total_venta, 0)), 0) total_venta,
		IFNULL((IFNULL(ingreso.importe_comision, 0) - IFNULL(egreso.importe_comision, 0)), 0) importe_comision
    FROM tmp_ventas_x_proveedor_ing ingreso
    LEFT JOIN tmp_ventas_x_proveedor_egr egreso ON
		ingreso.id_proveedor = egreso.id_proveedor
	ORDER BY importe_comision DESC
	LIMIT pr_ini_pag, pr_fin_pag;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @pr_rows_tot_table = 0;
	SET @query_prov_count = CONCAT(
					'
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM tmp_ventas_x_proveedor_ing ingreso
					LEFT JOIN tmp_ventas_x_proveedor_egr egreso ON
						ingreso.id_proveedor = egreso.id_proveedor');

    -- SELECT @query_prov_count;
	PREPARE stmt FROM @query_prov_count;
	EXECUTE stmt;

    SET pr_rows_tot_table = @pr_rows_tot_table;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
