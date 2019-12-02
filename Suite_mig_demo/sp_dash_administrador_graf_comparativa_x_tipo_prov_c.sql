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

    DROP TABLE IF EXISTS tmp_suma_tipo_prov_ventas;
    DROP TABLE IF EXISTS tmp_suma_tipo_prov_comisiones;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @queryventas_x_tipo = CONCAT(
							'
                            CREATE TEMPORARY TABLE tmp_suma_tipo_prov_ventas
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
                            AND fac.id_sucursal = ',pr_id_sucursal,'
							AND fac.estatus != 2
							GROUP BY prov.id_tipo_proveedor');

    	-- SELECT @queryventas_x_tipo;
	PREPARE stmt FROM @queryventas_x_tipo;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET @queryventas_x_tipo_comis = CONCAT(
							'
                            CREATE TEMPORARY TABLE tmp_suma_tipo_prov_comisiones
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
							AND fac.id_sucursal = ',pr_id_sucursal,'
                            AND fac.estatus != 2
							GROUP BY prov.id_tipo_proveedor;

			');

	-- SELECT @queryventas_x_tipo_comis;
	PREPARE stmt FROM @queryventas_x_tipo_comis;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

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
