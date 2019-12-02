DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_acumulados_tipo_proveedor_mes_u`(
	IN  pr_fecha					VARCHAR(7),
	OUT pr_message					VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_acumulados_tipo_proveedor_mes_u
	@fecha:			2019/06/18
	@descripcion:	SP para actualizar registros en la tabla de acumulados
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_contador_total2		INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_acumulados_tipo_proveedor_mes_u';
        ROLLBACK;
	END ;

	DROP TABLE IF EXISTS tmp_tipo_proveedor_acumulado_ingreso;
	DROP TABLE IF EXISTS tmp_tipo_proveedor_acumulado_egreso;
    DROP TABLE IF EXISTS tmp_tipo_proveedor_acumulado_total;
    DROP TABLE IF EXISTS tmp_tipo_proveedor_acumulado_total2;

	/* #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-# */

    /* CONSULTAR LOS INGRESOS */
    CREATE TABLE tmp_tipo_proveedor_acumulado_ingreso
	SELECT
		id_grupo_empresa,
		id_tipo_proveedor,
        id_sucursal,
		SUM(monto_moneda_base) monto_moneda_base,
		SUM(monto_usd) monto_usd,
		SUM(monto_eur) monto_eur,
		fecha
	FROM (
			SELECT
				fac.id_grupo_empresa,
				prov.id_tipo_proveedor,
                fac.id_sucursal,
				IFNULL(SUM(tarifa_moneda_base + importe_markup - descuento),0) monto_moneda_base,
				CASE
					WHEN fac.id_moneda = 149 THEN
						IFNULL(SUM(tarifa_moneda_facturada + importe_markup - descuento),0)
					ELSE
						IFNULL(SUM((tarifa_moneda_base + importe_markup - descuento) / fac.tipo_cambio_usd),0)
				END monto_usd,
				CASE
					WHEN fac.id_moneda = 49 THEN
						IFNULL(SUM(tarifa_moneda_facturada + importe_markup - descuento),0)
					ELSE
						IFNULL(SUM((tarifa_moneda_base + importe_markup - descuento) / fac.tipo_cambio_usd),0)
				END monto_eur,
				DATE_FORMAT(fecha_factura, '%Y-%m') fecha
			FROM ic_fac_tr_factura fac
			JOIN ic_fac_tr_factura_detalle det ON
				fac.id_factura = det.id_factura
			JOIN ic_cat_tr_proveedor prov ON
				det.id_proveedor = prov.id_proveedor
			WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = pr_fecha
			AND tipo_cfdi = 'I'
			AND fac.estatus != 'CANCELADA'
			GROUP BY prov.id_tipo_proveedor, fac.id_grupo_empresa) tabla
	GROUP BY tabla.id_tipo_proveedor, tabla.id_grupo_empresa;

    /* #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-# */

	/* CONSULTA LOS EGRESOS */
	CREATE TABLE tmp_tipo_proveedor_acumulado_egreso
	SELECT
		id_grupo_empresa,
		id_tipo_proveedor,
        id_sucursal,
		SUM(monto_moneda_base) monto_moneda_base,
		SUM(monto_usd) monto_usd,
		SUM(monto_eur) monto_eur,
		fecha
	FROM (
			SELECT
				fac.id_grupo_empresa,
				prov.id_tipo_proveedor,
                fac.id_sucursal,
				IFNULL(SUM(tarifa_moneda_base + importe_markup - descuento),0) monto_moneda_base,
				CASE
					WHEN fac.id_moneda = 149 THEN
						IFNULL(SUM(tarifa_moneda_facturada + importe_markup - descuento),0)
					ELSE
						IFNULL(SUM((tarifa_moneda_base + importe_markup - descuento) / fac.tipo_cambio_usd),0)
				END monto_usd,
				CASE
					WHEN fac.id_moneda = 49 THEN
						IFNULL(SUM(tarifa_moneda_facturada + importe_markup - descuento),0)
					ELSE
						IFNULL(SUM((tarifa_moneda_base + importe_markup - descuento) / fac.tipo_cambio_usd),0)
				END monto_eur,
				DATE_FORMAT(fecha_factura, '%Y-%m') fecha
			FROM ic_fac_tr_factura fac
			JOIN ic_fac_tr_factura_detalle det ON
				fac.id_factura = det.id_factura
			JOIN ic_cat_tr_proveedor prov ON
				det.id_proveedor = prov.id_proveedor
			WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = pr_fecha
			AND tipo_cfdi = 'E'
			AND fac.estatus != 'CANCELADA'
			GROUP BY prov.id_tipo_proveedor, fac.id_grupo_empresa) tabla
	GROUP BY tabla.id_tipo_proveedor, tabla.id_grupo_empresa;

    /* #-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-# */

    CREATE TABLE tmp_tipo_proveedor_acumulado_total
    SELECT
		CASE
			WHEN ing.id_grupo_empresa IS NULL THEN
				egr.id_grupo_empresa
			ELSE
				ing.id_grupo_empresa
		END id_grupo_empresa,
		CASE
			WHEN ing.id_tipo_proveedor IS NULL THEN
				egr.id_tipo_proveedor
			ELSE
				ing.id_tipo_proveedor
		END id_tipo_proveedor,
        CASE
			WHEN ing.id_sucursal IS NULL THEN
				egr.id_sucursal
			ELSE
				ing.id_sucursal
        END id_sucursal,
		IFNULL(ing.monto_moneda_base,0) monto_moneda_base_ing,
		IFNULL(ing.monto_usd,0) monto_usd_ing,
		IFNULL(ing.monto_eur,0) monto_eur_ing,
		IFNULL(egr.monto_moneda_base,0) monto_moneda_base_egre,
		IFNULL(egr.monto_usd,0) monto_usd_egre,
		IFNULL(egr.monto_eur,0) monto_eur_egre,
		CASE
			WHEN ing.monto_moneda_base IS NULL THEN
				IFNULL(egr.monto_moneda_base,0)
			WHEN egr.monto_moneda_base IS NULL THEN
				IFNULL(ing.monto_moneda_base,0)
			ELSE
				IFNULL((ing.monto_moneda_base - egr.monto_moneda_base),0)
		END venta_neta_moneda_base,
		CASE
			WHEN ing.monto_usd IS NULL THEN
				IFNULL(egr.monto_usd,0)
			WHEN egr.monto_usd IS NULL THEN
				IFNULL(ing.monto_usd,0)
			ELSE
				(ing.monto_usd - egr.monto_usd)
		END venta_neta_usd,
		CASE
			WHEN ing.monto_eur IS NULL THEN
				IFNULL(egr.monto_eur,0)
			WHEN egr.monto_eur IS NULL THEN
				IFNULL(ing.monto_eur,0)
			ELSE
			(ing.monto_eur - egr.monto_eur)
		END venta_neta_eur,
		CASE
			WHEN ing.fecha IS NULL THEN
				egr.fecha
			ELSE
				ing.fecha
        END fecha
	FROM tmp_tipo_proveedor_acumulado_ingreso ing
	LEFT JOIN tmp_tipo_proveedor_acumulado_egreso egr ON
		ing.id_tipo_proveedor = egr.id_tipo_proveedor;

	CREATE TABLE tmp_tipo_proveedor_acumulado_total2
	SELECT
		CASE
			WHEN ing.id_grupo_empresa IS NULL THEN
				egr.id_grupo_empresa
			ELSE
				ing.id_grupo_empresa
		END id_grupo_empresa,
		CASE
			WHEN ing.id_tipo_proveedor IS NULL THEN
				egr.id_tipo_proveedor
			ELSE
				ing.id_tipo_proveedor
		END id_tipo_proveedor,
		CASE
			WHEN ing.id_sucursal IS NULL THEN
				egr.id_sucursal
			ELSE
				ing.id_sucursal
        END id_sucursal,
		IFNULL(ing.monto_moneda_base,0) monto_moneda_base_ing,
		IFNULL(ing.monto_usd,0) monto_usd_ing,
		IFNULL(ing.monto_eur,0) monto_eur_ing,
		IFNULL(egr.monto_moneda_base,0) monto_moneda_base_egre,
		IFNULL(egr.monto_usd,0) monto_usd_egre,
		IFNULL(egr.monto_eur,0) monto_eur_egre,
		CASE
			WHEN ing.monto_moneda_base IS NULL THEN
				IFNULL(egr.monto_moneda_base,0)
			WHEN egr.monto_moneda_base IS NULL THEN
				IFNULL(ing.monto_moneda_base,0)
			ELSE
				IFNULL((ing.monto_moneda_base - egr.monto_moneda_base),0)
		END venta_neta_moneda_base,
		CASE
			WHEN ing.monto_usd IS NULL THEN
				IFNULL(egr.monto_usd,0)
			WHEN egr.monto_usd IS NULL THEN
				IFNULL(ing.monto_usd,0)
			ELSE
				(ing.monto_usd - egr.monto_usd)
		END venta_neta_usd,
		CASE
			WHEN ing.monto_eur IS NULL THEN
				IFNULL(egr.monto_eur,0)
			WHEN egr.monto_eur IS NULL THEN
				IFNULL(ing.monto_eur,0)
			ELSE
				(ing.monto_eur - egr.monto_eur)
		END venta_neta_eur,
		CASE
			WHEN ing.fecha IS NULL THEN
				egr.fecha
			ELSE
				ing.fecha
        END fecha
	FROM tmp_tipo_proveedor_acumulado_ingreso ing
	RIGHT JOIN tmp_tipo_proveedor_acumulado_egreso egr ON
		ing.id_tipo_proveedor = egr.id_tipo_proveedor
	WHERE ing.id_tipo_proveedor IS NULL;

	SELECT
		COUNT(*)
	INTO
		lo_contador_total2
	FROM tmp_tipo_proveedor_acumulado_total2;

    START TRANSACTION;

    IF lo_contador_total2 = 0 THEN
		INSERT INTO ic_rep_tr_acumulado_tipo_proveedor (id_grupo_empresa, id_tipo_proveedor, id_sucursal, monto_moneda_base, monto_usd, monto_eur, egresos_moneda_base, egresos_usd, egresos_eur, venta_neta_moneda_base, venta_neta_usd, venta_neta_eur, fecha)
		SELECT *
		FROM tmp_tipo_proveedor_acumulado_total;
	ELSEIF lo_contador_total2 > 0 THEN
		INSERT INTO ic_rep_tr_acumulado_tipo_proveedor (id_grupo_empresa, id_tipo_proveedor, id_sucursal, monto_moneda_base, monto_usd, monto_eur, egresos_moneda_base, egresos_usd, egresos_eur, venta_neta_moneda_base, venta_neta_usd, venta_neta_eur, fecha)
		SELECT *
		FROM tmp_tipo_proveedor_acumulado_total
		UNION
		SELECT *
		FROM tmp_tipo_proveedor_acumulado_total2;
	END IF;

	/*-------------------------------------------------------------------*/


	DROP TABLE IF EXISTS tmp_tipo_proveedor_acumulado_ingreso;
	DROP TABLE IF EXISTS tmp_tipo_proveedor_acumulado_egreso;
    DROP TABLE IF EXISTS tmp_tipo_proveedor_acumulado_total;
    DROP TABLE IF EXISTS tmp_tipo_proveedor_acumulado_total2;

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
    COMMIT;
END$$
DELIMITER ;