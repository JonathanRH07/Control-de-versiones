DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_bsp_contenido_ventas_x_tipo_prov_c`(
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
	@nombre:		sp_dash_bsp_contenido_ventas_x_tipo_prov_c
	@fecha:			30/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por dia
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(255);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_bsp_grafica_comparativa_x_dia_c';
	END ;

    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_suma_tipo_prov_ing;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_egr;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* TOTAL INGRESOS */
    SET @queryprov_ing = CONCAT(
								'CREATE TEMPORARY TABLE tmp_suma_tipo_prov_ing
								SELECT
									pro_typ.id_tipo_proveedor,
									pro_typ.desc_tipo_proveedor,
									CASE
										WHEN serv.alcance = 1 THEN
											SUM(tarifa_moneda_base',lo_moneda_reporte,')
										ELSE
											0.00
									END total_nacionales,
									CASE
										WHEN serv.alcance = 2 THEN
											SUM(tarifa_moneda_base',lo_moneda_reporte,')
										ELSE
											0.00
									END total_internacionales
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								LEFT JOIN ic_gds_tr_vuelos vuelos ON
									det.id_factura_detalle = vuelos.id_factura_detalle
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								LEFT JOIN ic_cat_tr_proveedor prov ON
									det.id_proveedor = prov.id_proveedor
								LEFT JOIN ic_cat_tc_tipo_proveedor pro_typ ON
									prov.id_tipo_proveedor = pro_typ.id_tipo_proveedor
								WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
								AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND fac.id_sucursal = ',pr_id_sucursal,'
								AND serv.id_producto = 1
								AND prov.id_tipo_proveedor IN (1, 2, 3)
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''I''
								-- AND vuelos.clave_linea_aerea IS NOT NULL
								GROUP BY fac.id_factura;');

	-- SELECT @queryprov_ing;
	PREPARE stmt FROM @queryprov_ing;
	EXECUTE stmt;

	SET @queryprov_egr = CONCAT(
								'CREATE TEMPORARY TABLE tmp_suma_tipo_prov_egr
								SELECT
									pro_typ.id_tipo_proveedor,
									pro_typ.desc_tipo_proveedor,
									CASE
										WHEN serv.alcance = 1 THEN
											SUM(tarifa_moneda_base',lo_moneda_reporte,')
										ELSE
											0.00
									END total_nacionales,
									CASE
										WHEN serv.alcance = 2 THEN
											SUM(tarifa_moneda_base',lo_moneda_reporte,')
										ELSE
											0.00
									END total_internacionales
								FROM ic_fac_tr_factura fac
								JOIN ic_fac_tr_factura_detalle det ON
									fac.id_factura = det.id_factura
								LEFT JOIN ic_gds_tr_vuelos vuelos ON
									det.id_factura_detalle = vuelos.id_factura_detalle
								JOIN ic_cat_tc_servicio serv ON
									det.id_servicio = serv.id_servicio
								LEFT JOIN ic_cat_tr_proveedor prov ON
									det.id_proveedor = prov.id_proveedor
								LEFT JOIN ic_cat_tc_tipo_proveedor pro_typ ON
									prov.id_tipo_proveedor = pro_typ.id_tipo_proveedor
								WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
								AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND fac.id_sucursal = ',pr_id_sucursal,'
								AND serv.id_producto = 1
								AND prov.id_tipo_proveedor IN (1, 2, 3)
								AND fac.estatus != 2
								AND fac.tipo_cfdi = ''E''
								-- AND vuelos.clave_linea_aerea IS NOT NULL
								GROUP BY fac.id_factura;');

	-- SELECT @queryprov_egr;
	PREPARE stmt FROM @queryprov_egr;
	EXECUTE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		COUNT(*)
	INTO
		pr_rows_tot_table
	FROM(
		SELECT
			COUNT(*)
		FROM tmp_suma_tipo_prov_ing ingreso
		LEFT JOIN tmp_suma_tipo_prov_egr egreso ON
			ingreso.id_tipo_proveedor = egreso.id_tipo_proveedor
		GROUP BY ingreso.id_tipo_proveedor) a;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		ingreso.id_tipo_proveedor,
		ingreso.desc_tipo_proveedor,
		IFNULL(SUM(IFNULL(ingreso.total_nacionales, 0) - IFNULL(egreso.total_nacionales, 0)), 0) total_nacionales,
		IFNULL(SUM(IFNULL(ingreso.total_internacionales, 0) - IFNULL(egreso.total_internacionales, 0)), 0) total_internacionales,
        (IFNULL(SUM(IFNULL(ingreso.total_nacionales, 0) - IFNULL(egreso.total_nacionales, 0)), 0)) + (IFNULL(SUM(IFNULL(ingreso.total_internacionales, 0) - IFNULL(egreso.total_internacionales, 0)), 0)) suma_peridod
	FROM tmp_suma_tipo_prov_ing ingreso
	LEFT JOIN tmp_suma_tipo_prov_egr egreso ON
		ingreso.id_tipo_proveedor = egreso.id_tipo_proveedor
	GROUP BY ingreso.id_tipo_proveedor
    LIMIT pr_ini_pag, pr_fin_pag;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
