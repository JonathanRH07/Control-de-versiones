DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_graf_comparativa_x_tipo_prov_c`(
	IN	pr_id_grupo_empresa					INT,
	IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_graf_comparativa_x_tipo_prov_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(100);
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_graf_comparativa_x_tipo_prov_c';
	END;

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

    DROP TABLE IF EXISTS tmp_suma_tipo_prov_ventas_ing;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_ventas_egr;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_ventas_1;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_ventas_2;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_ventas;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_comisiones_ing;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_comisiones_egr;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_comisiones_1;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_comisiones_2;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_comisiones;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @queryventas_x_tipo_ing = CONCAT(
							'
                            CREATE TEMPORARY TABLE tmp_suma_tipo_prov_ventas_ing
							SELECT
								pro_typ.id_tipo_proveedor,
								pro_typ.desc_tipo_proveedor,
								SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total
							FROM ic_fac_tr_factura fac
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							JOIN ic_cat_tr_proveedor prov ON
								det.id_proveedor = prov.id_proveedor
							JOIN ic_cat_tc_tipo_proveedor pro_typ ON
								prov.id_tipo_proveedor = pro_typ.id_tipo_proveedor
							WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
							AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                            ',lo_sucursal,'
							AND fac.estatus != 2
                            AND fac.tipo_cfdi = ''I''
							GROUP BY prov.id_tipo_proveedor');

    	-- SELECT @queryventas_x_tipo_ing;
	PREPARE stmt FROM @queryventas_x_tipo_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @queryventas_x_tipo_egr = CONCAT(
							'
                            CREATE TEMPORARY TABLE tmp_suma_tipo_prov_ventas_egr
							SELECT
								pro_typ.id_tipo_proveedor,
								pro_typ.desc_tipo_proveedor,
								SUM((det.tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,') - (descuento',lo_moneda_reporte,')) total
							FROM ic_fac_tr_factura fac
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							JOIN ic_cat_tr_proveedor prov ON
								det.id_proveedor = prov.id_proveedor
							JOIN ic_cat_tc_tipo_proveedor pro_typ ON
								prov.id_tipo_proveedor = pro_typ.id_tipo_proveedor
							WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
							AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                            ',lo_sucursal,'
							AND fac.estatus != 2
                            AND fac.tipo_cfdi = ''E''
							GROUP BY prov.id_tipo_proveedor');

    	-- SELECT @queryventas_x_tipo_egr;
	PREPARE stmt FROM @queryventas_x_tipo_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_suma_tipo_prov_ventas_1
	SELECT
		ingreso.id_tipo_proveedor,
		ingreso.desc_tipo_proveedor,
		IFNULL((IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0) total
	FROM tmp_suma_tipo_prov_ventas_ing ingreso
	LEFT JOIN tmp_suma_tipo_prov_ventas_egr egreso ON
		ingreso.id_tipo_proveedor = egreso.id_tipo_proveedor;

	CREATE TEMPORARY TABLE tmp_suma_tipo_prov_ventas_2
	SELECT
		IFNULL(ingreso.id_tipo_proveedor, egreso.id_tipo_proveedor) id_tipo_proveedor,
		IFNULL(ingreso.desc_tipo_proveedor, egreso.desc_tipo_proveedor) nombre,
		IFNULL((IFNULL(ingreso.total, 0) - IFNULL(egreso.total, 0)), 0) total
	FROM tmp_suma_tipo_prov_ventas_ing ingreso
	RIGHT JOIN tmp_suma_tipo_prov_ventas_egr egreso ON
		ingreso.id_tipo_proveedor = egreso.id_tipo_proveedor
	WHERE ingreso.id_tipo_proveedor IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_suma_tipo_prov_ventas_2;

    IF @lo_contador = 0 THEN
		CREATE TEMPORARY TABLE tmp_suma_tipo_prov_ventas
        SELECT *
        FROM tmp_suma_tipo_prov_ventas_1;
	ELSE
		CREATE TEMPORARY TABLE tmp_suma_tipo_prov_ventas
		SELECT *
        FROM tmp_suma_tipo_prov_ventas_1
		UNION
        SELECT *
        FROM tmp_suma_tipo_prov_ventas_2;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET @queryventas_x_tipo_comis_ing = CONCAT(
							'
                            CREATE TEMPORARY TABLE tmp_suma_tipo_prov_comisiones_ing
							SELECT
								pro_typ.id_tipo_proveedor,
								SUM(comision_agencia',lo_moneda_reporte,') total_comision
							FROM ic_fac_tr_factura fac
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							JOIN ic_cat_tr_proveedor prov ON
								det.id_proveedor = prov.id_proveedor
							JOIN ic_cat_tc_tipo_proveedor pro_typ ON
								prov.id_tipo_proveedor = pro_typ.id_tipo_proveedor
							WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
							AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_sucursal,'
                            AND fac.estatus != 2
                            AND fac.tipo_cfdi = ''E''
							GROUP BY prov.id_tipo_proveedor;

			');

	-- SELECT @queryventas_x_tipo_comis_ing;
	PREPARE stmt FROM @queryventas_x_tipo_comis_ing;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	SET @queryventas_x_tipo_comis_egr = CONCAT(
							'
                            CREATE TEMPORARY TABLE tmp_suma_tipo_prov_comisiones_egr
							SELECT
								pro_typ.id_tipo_proveedor,
								SUM(comision_agencia',lo_moneda_reporte,') total_comision
							FROM ic_fac_tr_factura fac
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							JOIN ic_cat_tr_proveedor prov ON
								det.id_proveedor = prov.id_proveedor
							JOIN ic_cat_tc_tipo_proveedor pro_typ ON
								prov.id_tipo_proveedor = pro_typ.id_tipo_proveedor
							WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
							AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_sucursal,'
                            AND fac.estatus != 2
                            AND fac.tipo_cfdi = ''E''
							GROUP BY prov.id_tipo_proveedor;

			');

	-- SELECT @queryventas_x_tipo_comis_egr;
	PREPARE stmt FROM @queryventas_x_tipo_comis_egr;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CREATE TEMPORARY TABLE tmp_suma_tipo_prov_comisiones_1
	SELECT
		ingreso.id_tipo_proveedor,
		IFNULL((IFNULL(ingreso.total_comision, 0) - IFNULL(egreso.total_comision, 0)), 0) total_comision
	FROM tmp_suma_tipo_prov_comisiones_ing ingreso
	LEFT JOIN tmp_suma_tipo_prov_comisiones_egr egreso ON
		ingreso.id_tipo_proveedor = egreso.id_tipo_proveedor;

	CREATE TEMPORARY TABLE tmp_suma_tipo_prov_comisiones_2
	SELECT
		IFNULL(ingreso.id_tipo_proveedor, egreso.id_tipo_proveedor) id_tipo_proveedor,
		IFNULL((IFNULL(ingreso.total_comision, 0) - IFNULL(egreso.total_comision, 0)), 0) total_comision
	FROM tmp_suma_tipo_prov_comisiones_ing ingreso
	RIGHT JOIN tmp_suma_tipo_prov_comisiones_egr egreso ON
		ingreso.id_tipo_proveedor = egreso.id_tipo_proveedor
	WHERE ingreso.id_tipo_proveedor IS NULL;

    SELECT
		COUNT(*)
	INTO
		@lo_contador
	FROM tmp_suma_tipo_prov_comisiones_2;

    IF @lo_contador = 0 THEN
		CREATE TEMPORARY TABLE tmp_suma_tipo_prov_comisiones
        SELECT *
        FROM tmp_suma_tipo_prov_comisiones_1;
	ELSE
		CREATE TEMPORARY TABLE tmp_suma_tipo_prov_comisiones
		SELECT *
        FROM tmp_suma_tipo_prov_comisiones_1
		UNION
        SELECT *
        FROM tmp_suma_tipo_prov_comisiones_2;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		a.id_tipo_proveedor,
		a.desc_tipo_proveedor,
		IFNULL(a.total, 0.00) total_ventas,
		IFNULL(b.total_comision, 0.00) total_comision
	FROM tmp_suma_tipo_prov_ventas a
	LEFT JOIN tmp_suma_tipo_prov_comisiones b ON
		a.id_tipo_proveedor = b.id_tipo_proveedor;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
