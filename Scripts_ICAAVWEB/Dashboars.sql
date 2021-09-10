/* DASBOARD VENTAS (PENDIENTE) */

SELECT * -- 1675
FROM ic_cat_tr_vendedor
WHERE id_grupo_empresa = 7;

SELECT
	IFNULL(SUM(venta_neta_moneda_base),0)
FROM ic_rep_tr_acumulado_sucursal suc
WHERE id_grupo_empresa = 7
AND   id_sucursal = 98
AND   fecha = DATE_FORMAT(NOW(), '%Y-%m');

SELECT
	SUM((((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_titular))/100) +
	(comision_agencia * (porc_comision_titular/100)) +
	((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_auxiliar))/100) +
	(comision_agencia * (porc_comision_auxiliar/100))) + ((comision_titular) + (comision_auxiliar))/fac.tipo_cambio_usd) comision_neta
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle fac_det ON
	fac.id_factura = fac_det.id_factura
JOIN ic_cat_tr_vendedor vend ON
	fac.id_vendedor_tit = vend.id_vendedor
JOIN ic_cat_tr_plan_comision plan_comis ON
	vend.id_comision = plan_comis.id_plan_comision
LEFT JOIN ic_glob_tr_cxc cxc ON
	fac.id_factura = cxc.id_factura
LEFT JOIN ic_glob_tr_cxc_detalle cxc_det ON
	cxc.id_cxc = cxc_det.id_cxc
LEFT JOIN ic_fac_tr_pagos pag ON
	cxc_det.id_pago = pag.id_pago
LEFT JOIN ic_cat_tr_serie ser ON
	fac.id_serie = ser.id_serie
LEFT JOIN ic_cat_tr_cliente cli ON
	fac.id_cliente = cli.id_cliente
LEFT JOIN ic_cat_tr_proveedor prov ON
	fac_det.id_proveedor = prov.id_proveedor
LEFT JOIN ic_cat_tc_servicio serv ON
	fac_det.id_servicio =  serv.id_servicio
LEFT JOIN ic_cat_tr_proveedor_aero prov_aer ON
	prov.id_proveedor = prov_aer.id_proveedor
LEFT JOIN ct_glob_tc_aerolinea airline ON
	prov_aer.codigo_bsp = airline.codigo_bsp
LEFT JOIN ic_fac_tr_factura_detalle_imp fac_imp ON
	fac_det.id_factura_detalle = fac_imp.id_factura_detalle
WHERE fac.id_grupo_empresa = 7
AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') >= DATE_FORMAT(NOW(), '%Y-%m')
AND (fac.fecha_factura >= plan_comis.fecha_ini AND fac.fecha_factura <= plan_comis.fecha_fin)
/*AND fac.tipo_cfdi =  'E'*/;

SELECT *
FROM ic_glob_tr_cxc cxc
JOIN ic_glob_tr_cxc_detalle detalle ON
	cxc.id_cxc = detalle.id_cxc;

SELECT 
    SUM((detalle.importe_moneda_base * - 1)/tipo_cambio_usd) importe_cobrado
FROM ic_glob_tr_cxc cxc
JOIN ic_glob_tr_cxc_detalle detalle ON 
	cxc.id_cxc = detalle.id_cxc
WHERE cxc.id_grupo_empresa = 7
AND DATE_FORMAT(detalle.fecha, '%Y-%m') = DATE_FORMAT(NOW(),'%Y-%m')
AND detalle.estatus = 'ACTIVO'
AND cxc.estatus = 'ACTIVO'
AND detalle.id_factura IS NULL
AND cxc.id_sucursal = 98;

/* ACTUAL */
-- CREATE TEMPORARY TABLE tmp_comparativo_actual
SELECT 
	DATE_FORMAT(NOW(), '%Y') anio_actual,
	mes.mes,
	CASE
		WHEN 100 = 100 THEN
			IFNULL(SUM(venta_neta_moneda_base),0)
		WHEN 100 = 149 THEN
			IFNULL(SUM(venta_neta_usd),0)
		WHEN 100 = 49 THEN
			IFNULL(SUM(venta_neta_eur),0)
		ELSE
			0
	END monto
FROM
(SELECT 
	*
FROM ic_rep_tr_acumulado_sucursal suc
WHERE id_grupo_empresa = 7
AND suc.id_sucursal = 98
AND fecha <= DATE_FORMAT(NOW(), '%Y-%m')
AND fecha > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), '%Y-%m')) a
JOIN ct_glob_tc_meses mes ON
	SUBSTRING(fecha,6,2) = mes.num_mes
WHERE mes.id_idioma = 1
GROUP BY mes.num_mes;

/* ACTUAL */
-- CREATE TEMPORARY TABLE tmp_comparativo_actual
SELECT 
	DATE_FORMAT(DATE_SUB(NOW(),INTERVAL 1 YEAR), '%Y') anio_actual,
	mes.mes,
	CASE
		WHEN 100 = 100 THEN
			IFNULL(SUM(venta_neta_moneda_base),0)
		WHEN 100 = 149 THEN
			IFNULL(SUM(venta_neta_usd),0)
		WHEN 100 = 49 THEN
			IFNULL(SUM(venta_neta_eur),0)
		ELSE
			0
	END monto
FROM
(SELECT 
	*
FROM ic_rep_tr_acumulado_sucursal suc
WHERE id_grupo_empresa = 7
AND suc.id_sucursal = 98
AND fecha <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), '%Y-')
AND fecha > CONCAT(DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), '%Y-')),'06')a
RIGHT JOIN ct_glob_tc_meses mes ON
	SUBSTRING(fecha,6,2) = mes.num_mes
WHERE mes.id_idioma = 1
GROUP BY mes.num_mes;

SELECT 
	*
FROM ic_rep_tr_acumulado_sucursal suc
WHERE id_grupo_empresa = 7
AND suc.id_sucursal = 98
AND fecha <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), '%Y-%m')
AND fecha > DATE_FORMAT(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL 6 MONTH), '%Y-%m');

SELECT 
	a.mes,
	a.anio_actual,
	a.monto importe_actual_neto,
	b.anio_anterior,
	b.monto importe_anterior_neto
FROM tmp_neto_ventas_actual a
JOIN tmp_neto_ventas_anterior b ON
	a.mes = b.mes;

SELECT
	SUM(total_moneda_base /tipo_cambio_usd) total_dia
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND fecha_factura = DATE_FORMAT(NOW(), '%Y-%m-%d')
AND tipo_cfdi = 'I';

/* -------------------------------- */

SELECT
	COUNT(*)
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND tipo_cfdi = 'I'
AND DATE_FORMAT(fecha_factura, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

SELECT
	COUNT(*)
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND tipo_cfdi = 'E'
AND DATE_FORMAT(fecha_factura, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

SELECT
	COUNT(*)
FROM ic_cat_tr_cliente
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND estatus = 1
AND DATE_FORMAT(fecha_mod, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

SELECT
	SUM(total_moneda_base)
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND DATE_FORMAT(fecha_factura, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

SELECT
	SUM(total_moneda_base)
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND DATE_FORMAT(fecha_factura, '%Y-%m') = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), '%Y-%m');

/* -------------------------------- */

SELECT
	a.nombre_comercial,
    a.fecha_factura,
    a.total_moneda_base
FROM(
SELECT
	fac.id_cliente,
	cli.nombre_comercial,
	MAX(fecha_factura) fecha_factura,
    total_moneda_base
FROM ic_fac_tr_factura fac
JOIN ic_cat_tr_cliente cli ON
	fac.id_cliente = cli.id_cliente
WHERE fac.id_grupo_empresa = 7
AND fac.id_sucursal = 98
AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), '%Y-%m')
GROUP BY fac.id_cliente) a
LEFT JOIN(
SELECT
	fac.id_cliente,
	cli.nombre_comercial,
	MAX(fecha_factura) fecha_factura,
    total_moneda_base
FROM ic_fac_tr_factura fac
JOIN ic_cat_tr_cliente cli ON
	fac.id_cliente = cli.id_cliente
WHERE fac.id_grupo_empresa = 7
AND fac.id_sucursal = 98
AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') <= DATE_FORMAT(NOW(), '%Y-%m')
AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), '%Y-%m')
GROUP BY fac.id_cliente) b ON
	a.id_cliente = b.id_cliente
WHERE b.id_cliente IS NULL
ORDER BY 2, 3 ASC;

/* -------------------------------- */

CALL suite_mig_demo.sp_dash_ventas_indicadores_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_ventas_graf_x_semestre_c(7, 98, 100, 1, @pr_message);
SELECT @pr_message;

CALL sp_dash_ventas_graf_x_dia_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL suite_mig_demo.sp_dash_ventas_graf_participacion_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL suite_mig_demo.sp_dash_ventas_graf_x_clientes_inactivos_c(7, 98, 100, @pr_message);
SELECT @pr_message;


/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BSP/BOLETOS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT *
FROM ic_cat_tc_servicio;

SELECT *
FROM ic_cat_tc_producto;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT
	SUM(venta_neta_moneda_base)
FROM ic_rep_tr_acumulado_aerolinea
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND fecha = DATE_FORMAT(NOW(),'%Y-%m');

SELECT
	SUM(total_moneda_facturada)
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_gds_tr_vuelos vuelos ON
	det.id_factura_detalle = vuelos.id_factura_detalle
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08'
AND fac.id_grupo_empresa = 7
AND serv.alcance = 1
AND serv.id_producto = 1
AND vuelos.clave_linea_aerea IS NOT NULL;

SELECT
	SUM(total_moneda_facturada)
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_gds_tr_vuelos vuelos ON
	det.id_factura_detalle = vuelos.id_factura_detalle
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08'
AND fac.id_grupo_empresa = 7
AND serv.alcance = 2
AND serv.id_producto = 1
AND vuelos.clave_linea_aerea IS NOT NULL;

SELECT
	COUNT(*)
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_gds_tr_vuelos vuelos ON
	det.id_factura_detalle = vuelos.id_factura_detalle
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08'
AND fac.id_grupo_empresa = 7
AND serv.id_producto = 1
AND vuelos.clave_linea_aerea IS NOT NULL;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

CREATE TEMPORARY TABLE tmp_neto_airlines_actual
SELECT 
	DATE_FORMAT(NOW(), '%Y') anio_actual,
	mes.mes,
	IFNULL(SUM(venta_neta_moneda_base),0) monto
FROM
(SELECT 
	*
FROM ic_rep_tr_acumulado_aerolinea air
WHERE id_grupo_empresa = 7
AND air.id_sucursal = 98
AND fecha <= DATE_FORMAT(NOW(), '%Y-%m')
AND fecha > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), '%Y-%m')) a
JOIN ct_glob_tc_meses mes ON
	SUBSTRING(fecha,6,2) = mes.num_mes
WHERE mes.id_idioma = 1
GROUP BY mes.num_mes;

CREATE TEMPORARY TABLE tmp_neto_airlines_anterior
SELECT 
	DATE_FORMAT(DATE_SUB(NOW(),INTERVAL 1 YEAR), '%Y')  anio_anterior,
	mes.mes,
	IFNULL(SUM(venta_neta_moneda_base),0) monto
FROM
(SELECT 
	*
FROM ic_rep_tr_acumulado_aerolinea air
WHERE id_grupo_empresa = 7
AND air.id_sucursal = 98
AND fecha <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), '%Y-%m')
AND fecha > DATE_FORMAT(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL 6 MONTH), '%Y-%m')) a
RIGHT JOIN ct_glob_tc_meses mes ON
	SUBSTRING(fecha,6,2) = mes.num_mes
WHERE mes.id_idioma = 1
GROUP BY mes.num_mes;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT
	a.id_factura,
    a.fecha_factura,
    IFNULL(a.total, 0.00) total_nacinales,
    IFNULL(b.total, 0.00) total_inter
    
FROM (
	SELECT
		fac.id_factura,
		fecha_factura,
		IFNULL(SUM(total_moneda_base), 0.00) total
	FROM ic_fac_tr_factura fac
	JOIN ic_fac_tr_factura_detalle det ON
		fac.id_factura = det.id_factura
	JOIN ic_gds_tr_vuelos vuelos ON
		det.id_factura_detalle = vuelos.id_factura_detalle
	JOIN ic_cat_tc_servicio serv ON
		det.id_servicio = serv.id_servicio
	WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-07'
	AND fac.id_grupo_empresa = 7
	AND serv.alcance = 1
	AND serv.id_producto = 1
	AND fac.estatus != 2
	AND vuelos.clave_linea_aerea IS NOT NULL
	GROUP BY fac.fecha_factura) a
LEFT JOIN (SELECT
		fac.id_factura,
		fecha_factura,
		IFNULL(SUM(total_moneda_base), 0.00) total
	FROM ic_fac_tr_factura fac
	JOIN ic_fac_tr_factura_detalle det ON
		fac.id_factura = det.id_factura
	JOIN ic_gds_tr_vuelos vuelos ON
		det.id_factura_detalle = vuelos.id_factura_detalle
	JOIN ic_cat_tc_servicio serv ON
		det.id_servicio = serv.id_servicio
	WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-07'
	AND fac.id_grupo_empresa = 7
	AND serv.alcance = 2
	AND serv.id_producto = 1
	AND vuelos.clave_linea_aerea IS NOT NULL
	GROUP BY fac.fecha_factura) b ON
	a.fecha_factura = b.fecha_factura;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT *
FROM ic_cat_tc_tipo_proveedor;
-- 3 Consolidador
-- 2 IATA-BSP
-- 1 Line Aérea

SELECT *
FROM ic_cat_tr_proveedor;

/* TOTAL */
-- CREATE TEMPORARY TABLE tmp_suma
SELECT
	airline.id_aerolinea,
	airline.nombre_aerolinea,
    CASE 
		WHEN id_tipo_proveedor = 2 THEN
			SUM(total_moneda_base)
		ELSE
			0.00
	END total_bsp,
	CASE 
		WHEN id_tipo_proveedor = 1 THEN
			SUM(total_moneda_base)
		ELSE
			0.00
	END total_airline,
	CASE 
		WHEN id_tipo_proveedor = 3 THEN
			SUM(total_moneda_base)
		ELSE
			0.00
	END total_consolidador,
    id_tipo_proveedor
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_gds_tr_vuelos vuelos ON
	det.id_factura_detalle = vuelos.id_factura_detalle
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
JOIN ic_cat_tr_proveedor prov ON
	det.id_proveedor = prov.id_proveedor
JOIN ct_glob_tc_aerolinea airline ON
	vuelos.clave_linea_aerea = airline.clave_aerolinea
WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08'
AND fac.id_grupo_empresa = 7
AND serv.id_producto = 1
AND prov.id_tipo_proveedor IN (1, 2, 3)
AND fac.estatus != 2
AND vuelos.clave_linea_aerea IS NOT NULL
GROUP BY fac.id_factura;

SELECT
	id_aerolinea, 
    nombre_aerolinea, 
    SUM(total_bsp) total_bsp, 
    SUM(total_airline) total_airline,
    SUM(total_consolidador) total_consolidador
FROM tmp_suma
GROUP BY id_aerolinea;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT *
FROM ic_cat_tc_servicio;

/* TOTAL */
CREATE TEMPORARY TABLE tmp_suma_tipo_prov
SELECT
	pro_typ.id_tipo_proveedor,
	pro_typ.desc_tipo_proveedor,
    CASE
		WHEN serv.alcance = 1 THEN
			SUM(total_moneda_base)
		ELSE
			0.00
	END total_nacionales,
    CASE
		WHEN serv.alcance = 2 THEN
			SUM(total_moneda_base)
		ELSE
			0.00
	END total_internacionales
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_gds_tr_vuelos vuelos ON
	det.id_factura_detalle = vuelos.id_factura_detalle
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
JOIN ic_cat_tr_proveedor prov ON
	det.id_proveedor = prov.id_proveedor
JOIN ic_cat_tc_tipo_proveedor pro_typ ON
	prov.id_tipo_proveedor = pro_typ.id_tipo_proveedor
WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08'
AND fac.id_grupo_empresa = 7
AND serv.id_producto = 1
AND prov.id_tipo_proveedor IN (1, 2, 3)
AND fac.estatus != 2
AND vuelos.clave_linea_aerea IS NOT NULL
GROUP BY fac.id_factura;

SELECT
	id_tipo_proveedor, 
    desc_tipo_proveedor, 
    SUM(total_nacionales) total_nacionales, 
    SUM(total_internacionales) total_internacionales,
    (SUM(total_nacionales) + SUM(total_internacionales)) suma_peridod
FROM tmp_suma_tipo_prov
GROUP BY id_tipo_proveedor;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

CALL sp_dash_bsp_indicadores_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_bsp_grafica_x_semestre_c(7, 98, 100, 1, @pr_message);
SELECT @pr_message;

CALL sp_dash_bsp_grafica_comparativa_x_dia_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_bsp_grafica_top_aerolineas_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_bsp_contenido_ventas_x_linea_aer_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_bsp_contenido_ventas_x_tipo_prov_c(7, 98, 100, @pr_message);
SELECT @pr_message;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ SUPER USUARIO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT
	IFNULL(SUM(total_moneda_base), 0) total_venta
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND DATE_FORMAT(fecha_factura, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
AND estatus != 2;

SELECT
	IFNULL(SUM(total_moneda_base), 0) total_dia
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND fecha_factura = DATE_FORMAT(NOW(), '%Y-%m-%d')
AND estatus != 2;

CREATE TEMPORARY TABLE tmp_comisiones
SELECT 
	DATE_FORMAT(NOW(), '%Y') anio_actual,
	mes.mes,
	IFNULL(SUM((comision_agencia) + ROUND((tarifa_moneda_base * porc_comision_agencia)/100,2)), 0) importe_comision
FROM
(SELECT 
	fac.*,
    det.comision_agencia,
    det.tarifa_moneda_base,
    det.porc_comision_agencia,
    det.tipo_cambio_usd,
    det.tipo_cambio_eur
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
WHERE fac.id_grupo_empresa = 7
AND fac.id_sucursal = 98
AND DATE_FORMAT(fecha_factura, '%Y-%m') <= DATE_FORMAT(NOW(), '%Y-%m')
AND DATE_FORMAT(fecha_factura, '%Y-%m') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), '%Y-%m')) a
JOIN ct_glob_tc_meses mes ON
	SUBSTRING(a.fecha_factura,6,2) = mes.num_mes
WHERE mes.id_idioma = 1
GROUP BY mes.num_mes;

CREATE TEMPORARY TABLE tmp_cxs
SELECT 
	DATE_FORMAT(NOW(), '%Y') anio_actual,
	mes.mes,
	IFNULL((SUM(tarifa_moneda_base) + SUM(importe_markup))- SUM(descuento),0) importe_cxs
FROM(
SELECT
	fac.fecha_factura,
	det.*
FROM ic_cat_tc_servicio serv
JOIN ic_fac_tr_factura_detalle det ON
	serv.id_servicio = det.id_servicio
JOIN ic_fac_tr_factura fac ON
	det.id_factura = fac.id_factura
WHERE serv.id_producto = 5
AND fac.id_grupo_empresa = 7
AND fac.id_sucursal = 98
AND fac.estatus != 2
AND serv.estatus = 1
AND DATE_FORMAT(fecha_factura, '%Y-%m') <= DATE_FORMAT(NOW(), '%Y-%m')
AND DATE_FORMAT(fecha_factura, '%Y-%m') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), '%Y-%m')) a
JOIN ct_glob_tc_meses mes ON
	SUBSTRING(a.fecha_factura,6,2) = mes.num_mes
WHERE mes.id_idioma = 1
GROUP BY mes.num_mes;

SELECT
	comisiones.anio_actual, 
    cxs.mes, 
    importe_comision,
    importe_cxs
FROM tmp_comisiones comisiones
JOIN tmp_cxs cxs ON
	comisiones.mes = cxs.mes;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CREATE TEMPORARY TABLE tmp_total_actual
SELECT
	fecha_factura,
	IFNULL(SUM(total_moneda_base), 0) total_venta
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
WHERE fac.id_grupo_empresa = 7
AND fac.id_sucursal = 98
AND fac.estatus != 2
AND DATE_FORMAT(fecha_factura, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
GROUP BY fac.fecha_factura;

CREATE TEMPORARY TABLE tmp_total_anterior
SELECT
	fecha_factura,
	IFNULL(SUM(total_moneda_base), 0) total_venta
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
WHERE fac.id_grupo_empresa = 7
AND fac.id_sucursal = 98
AND fac.estatus != 2
AND DATE_FORMAT(fecha_factura, '%Y-%m') = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), '%Y-%m')
GROUP BY fac.fecha_factura;

SELECT
    CASE
		WHEN actual.fecha_factura  IS NULL THEN
			DATE_ADD(anterior.fecha_factura, INTERVAL 1 YEAR)
		ELSE
			actual.fecha_factura
	END fecha_actual, 
    IFNULL(actual.total_venta, 0.00) total_venta_anio_actual,
    CASE
		WHEN anterior.fecha_factura IS NULL THEN
			DATE_SUB(actual.fecha_factura, INTERVAL 1 YEAR)
		ELSE
			anterior.fecha_factura
	END fecha_anio_anterio,
    IFNULL(anterior.total_venta, 0.00) total_venta_anio_anterior
FROM tmp_total_actual actual
LEFT JOIN tmp_total_anterior anterior ON
	DATE_FORMAT(actual.fecha_factura, '%m-%d') = DATE_FORMAT(anterior.fecha_factura, '%m-%d');

SELECT
	id_servicio,
	descripcion nombre,
	CASE
		WHEN 100 = 100 THEN
			venta_neta_moneda_base
		WHEN 100 = 149 THEN
			venta_neta_usd
		WHEN 100 = 49  THEN
			venta_neta_eur
	END neto_mes,
    fecha
FROM ic_rep_tr_acumulado_servicio
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND fecha = '2019-08'
GROUP BY id_servicio
ORDER BY neto_mes DESC;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CALL sp_dash_superuser_indicadores_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_superuser_graf_x_semestre_c(7, 98, 100, 1, @pr_message);
SELECT @pr_message;

CALL sp_dash_superuser_graf_x_dia_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_superuser_graf_top_servicios_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_superuser_contenido_x_vendedor_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_superuser_contenido_x_provedor_c(7, 98, 100, @pr_message);
SELECT @pr_message;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ADMINISTRADOR ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT
	IFNULL(COUNT(*), 0)
FROM suite_mig_conf.st_adm_tr_usuario
WHERE id_grupo_empresa = 7
AND inicio_sesion = 1
AND estatus_usuario = 1;

SELECT
	MAX(fecha)
FROM ic_fac_tr_folios
WHERE id_grupo_empresa = 7;

SELECT
	SUM(no_folios_disponibles)
FROM ic_fac_tr_folios
WHERE id_grupo_empresa = 7;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT 
	usuario,
    nombre_usuario,
    CONCAT(paterno_usuario,' ', materno_usuario) apellidos_usuario
FROM suite_mig_conf.st_adm_tr_usuario
WHERE id_grupo_empresa = 7
AND inicio_sesion = 1
AND estatus_usuario = 1;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT *
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND estatus != 2
AND DATE_FORMAT(fecha_factura, '%Y-%m') <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), '%Y-%m');

SELECT *
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND estatus != 2
AND DATE_FORMAT(fecha_factura, '%Y-%m') <= DATE_FORMAT(NOW(), '%Y-%m')
AND DATE_FORMAT(fecha_factura, '%Y-%m') >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), '%Y-%m');

SELECT
	COUNT(*)
FROM(
	SELECT
		fac.id_cliente
	FROM ic_fac_tr_factura fac
    JOIN ic_cat_tr_cliente cli ON
		fac.id_cliente = cli.id_cliente
	WHERE fac.id_grupo_empresa = 7
	AND fac.id_sucursal = 98
	AND fac.estatus != 2
	AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), '%Y-%m')
    GROUP BY fac.id_cliente) a
LEFT JOIN(
	SELECT
		fac.id_cliente
	FROM ic_fac_tr_factura fac
    JOIN ic_cat_tr_cliente cli ON
		fac.id_cliente = cli.id_cliente
	WHERE fac.id_grupo_empresa = 7
	AND fac.id_sucursal = 98
	AND fac.estatus != 2
	AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') <= DATE_FORMAT(NOW(), '%Y-%m')
	AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), '%Y-%m')
    GROUP BY fac.id_cliente) b ON
    a.id_cliente = b.id_cliente;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT
	(COUNT(*)/100)
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND estatus = 2
AND DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08';

SELECT
	COUNT(*)
FROM ic_fac_tr_factura
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08';

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

CREATE TEMPORARY TABLE tmp_suma_tipo_prov_ventas
SELECT
	pro_typ.id_tipo_proveedor,
	pro_typ.desc_tipo_proveedor,
	SUM(total_moneda_base) total
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
JOIN ic_cat_tr_proveedor prov ON
	det.id_proveedor = prov.id_proveedor
JOIN ic_cat_tc_tipo_proveedor pro_typ ON
	prov.id_tipo_proveedor = pro_typ.id_tipo_proveedor
WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08'
AND fac.id_grupo_empresa = 7
AND fac.estatus != 2
GROUP BY prov.id_tipo_proveedor;

CREATE TEMPORARY TABLE tmp_suma_tipo_prov_comisiones
SELECT
	pro_typ.id_tipo_proveedor,
    SUM(comision_agencia) total_comision
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
JOIN ic_cat_tr_proveedor prov ON
	det.id_proveedor = prov.id_proveedor
JOIN ic_cat_tc_tipo_proveedor pro_typ ON
	prov.id_tipo_proveedor = pro_typ.id_tipo_proveedor
WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08'
AND fac.id_grupo_empresa = 7
AND fac.estatus != 2
GROUP BY prov.id_tipo_proveedor;


SELECT
	a.id_tipo_proveedor,
    a.desc_tipo_proveedor,
    a.total,
    b.total_comision
FROM tmp_suma_tipo_prov_ventas a
LEFT JOIN tmp_suma_tipo_prov_comisiones b ON
	a.id_tipo_proveedor = b.id_tipo_proveedor;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

CREATE TEMPORARY TABLE tmp_suma_vendedor_ventas
SELECT
	fac.id_vendedor_tit,
	vend.nombre,
	SUM(total_moneda_base) total
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tr_vendedor vend ON
	fac.id_vendedor_tit = vend.id_vendedor
WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08'
AND fac.id_grupo_empresa = 7
AND fac.estatus != 2
GROUP BY fac.id_vendedor_tit;

CREATE TEMPORARY TABLE tmp_suma_vendedor_comisiones
SELECT
	fac.id_vendedor_tit,
    SUM(comision_agencia) total_comision
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tr_vendedor vend ON
	fac.id_vendedor_tit = vend.id_vendedor
WHERE DATE_FORMAT(fecha_factura, '%Y-%m') = '2019-08'
AND fac.id_grupo_empresa = 7
AND fac.estatus != 2
GROUP BY fac.id_vendedor_tit;


SELECT
	a.id_vendedor_tit,
    a.nombre,
    a.total,
    b.total_comision
FROM tmp_suma_vendedor_ventas a
LEFT JOIN tmp_suma_vendedor_comisiones b ON
	a.id_vendedor_tit = b.id_vendedor_tit;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT
	fac.id_cliente,
    cli.nombre_comercial,
    IFNULL((SUM(tarifa_moneda_base) + SUM(importe_markup))- SUM(descuento),0) importe,
    COUNT(det.id_factura) count_servicios
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tr_cliente cli ON
	fac.id_cliente = cli.id_cliente
WHERE fac.id_grupo_empresa = 7
AND fac.estatus != 2
AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') = '2019-08'
GROUP BY fac.id_cliente;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT
	COUNT(*)
FROM (
SELECT fac.*
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
WHERE id_grupo_empresa = 7
AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') = '2019-08'
AND (det.numero_tarjeta != '' OR det.numero_tarjeta IS NOT NULL)
GROUP BY det.id_factura) a;

SELECT
	COUNT(*)
FROM (
SELECT fac.*
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
WHERE id_grupo_empresa = 7
AND DATE_FORMAT(fac.fecha_factura, '%Y-%m') = '2019-08'
AND (det.numero_tarjeta = '' OR det.numero_tarjeta IS NULL)
GROUP BY det.id_factura) a;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT
	cli.razon_social,
    SUM(fac.total_moneda_base) total,
    COUNT(det.id_factura_detalle) no_servicios,
	(SUM(fac.total_moneda_base)/COUNT(det.id_factura_detalle)) promedio
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tr_cliente cli ON
	fac.id_cliente = cli.id_cliente
WHERE fac.id_grupo_empresa = 7
AND fac.id_sucursal = 98
AND fac.estatus != 2
AND DATE_FORMAT(fac.fecha_factura,'%Y-%m') = '2019-08'
GROUP BY cli.id_cliente
ORDER BY 2 DESC;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT
	cli.razon_social,
    SUM(fac.total_moneda_base) total_cxs,
    COUNT(det.id_factura_detalle) no_servicios_cxs,
	(SUM(fac.total_moneda_base)/COUNT(det.id_factura_detalle)) promedio_cxs
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tr_cliente cli ON
	fac.id_cliente = cli.id_cliente
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
WHERE fac.id_grupo_empresa = 7
AND fac.id_sucursal = 98
AND fac.estatus != 2
AND serv.id_producto = 5
AND serv.estatus = 1
AND DATE_FORMAT(fac.fecha_factura,'%Y-%m') = '2019-08'
GROUP BY cli.id_cliente
ORDER BY 2 DESC;


/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

SELECT
	vend.nombre vendedor,
    SUM(fac.total_moneda_base) total_cxs,
    COUNT(det.id_factura_detalle) no_servicios_cxs,
	(SUM(fac.total_moneda_base)/COUNT(det.id_factura_detalle)) promedio_cxs
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tr_vendedor vend ON
	fac.id_vendedor_tit = vend.id_vendedor
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
WHERE fac.id_grupo_empresa = 7
AND fac.id_sucursal = 98
AND fac.estatus != 2
AND serv.id_producto = 5
AND serv.estatus = 1
AND DATE_FORMAT(fac.fecha_factura,'%Y-%m') = '2019-08'
GROUP BY vend.id_vendedor
ORDER BY 2 DESC;

/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */

/* DASH 1 (VISTA OPERACION) "INDICADORES" */
CALL sp_dash_administrador_indicadores_c(@pr_pr_id_grupo_empresa, @pr_message);
SELECT @pr_message;

/* DASH 1 (VISTA OPERACION) "COMPARATIVA VENTAS/COMISIONES POR TIPO PROVEEDOR" */
CALL sp_dash_administrador_graf_comparativa_x_tipo_prov_c(@pr_pr_id_grupo_empresa, @pr_id_sucursal, @pr_moneda_reporte, @pr_message);
SELECT @pr_message;

/* DASH 1 (VISTA OPERACION) "COMPARATIVA VENTAS/COMISIONES POR TIPO VENDEDOR" */
CALL sp_dash_administrador_graf_comparativa_x_vendedor_c(@pr_pr_id_grupo_empresa, @pr_id_sucursal, @pr_moneda_reporte, @pr_message);
SELECT @pr_message;

/* DASH 1 (VISTA OPERACION) GRAFICA COMPARATIVA DE BOLETOS PAGADOS CON TARJETA DE CREDITO */
CALL sp_dash_administrador_graf_boletos_x_tc_c(@pr_pr_id_grupo_empresa, @pr_id_sucursal, @pr_message);
SELECT @pr_message;

/* DASH 1 (VISTA OPERACION) "TABLA DE CONTENIDO DE PROMEDIO DE COMPRAS POR CLIENTE" */
CALL sp_dash_administrador_contenido_promedio_x_cliente_c(@pr_pr_id_grupo_empresa, @pr_id_sucursal, @pr_moneda_reporte, @pr_ini_pag, @pr_fin_pag, @pr_rows_tot_table, @pr_message);
SELECT @pr_rows_tot_table, @pr_message;

/* DASH 1 (VISTA OPERACION) "TABLA DE CONTENIDO DE PROMEDIO DE CARGOS POR SERVICIO POR CLIENTE" */
CALL sp_dash_administrador_contenido_promedio_x_cxs_c(@pr_pr_id_grupo_empresa, @pr_id_sucursal, @pr_moneda_reporte, @pr_ini_pag, @pr_fin_pag, @pr_rows_tot_table, @pr_message);
SELECT @pr_rows_tot_table, @pr_message;

/* DASH 1 (VISTA OPERACION) "TABLA DE CONTENIDO DE PROMEDIO DE COMPRAS POR VENDEDOR" */
CALL sp_dash_administrador_contenido_promedio_x_vededor_c(@pr_pr_id_grupo_empresa, @pr_id_sucursal, @pr_moneda_reporte, @pr_ini_pag, @pr_fin_pag, @pr_rows_tot_table, @pr_message);
SELECT @pr_rows_tot_table, @pr_message;



/* DASH 2 (VISTA SISTEMA) "INDICADORES" */
CALL sp_dash_administrador_indicadores2_c(@pr_pr_id_grupo_empresa, @pr_message);
SELECT @pr_message;

/* DASH 2 (VISTA SISTEMA) "GRAFICA DE ESPACIO UTILIZADO" */
CALL sp_dash_administrador_graf_espacio_utilado_c(@pr_pr_id_grupo_empresa, @pr_message);
SELECT @pr_message;

/* DASH 2 (VISTA SISTEMA) "GRAFICA DE CONSUMO DE ESPACIO POR MES" */
CALL sp_dash_administrador_graf_consumo_espacio_x_mes_c(@pr_pr_id_grupo_empresa, @pr_message);
SELECT @pr_message;

/* DASH 2 (VISTA SISTEMA) "GRAFICA DE FOLIOS UTILIZADOS POR MES" */
CALL sp_dash_administrador_graf_folios_x_mes_c(@pr_pr_id_grupo_empresa, @pr_message);
SELECT @pr_message;

/* DASH 2 (VISTA SISTEMA) "TABLA DE CONTENIDO DE USUARIOS CONECTADOS" */
CALL sp_dash_administrador_contenido_usuarios_conectados_c(@pr_pr_id_grupo_empresa, @pr_ini_pag, @pr_fin_pag, @pr_rows_tot_table, @pr_message);
SELECT @pr_rows_tot_table, @pr_message;

/* DASH 2 (VISTA SISTEMA) "TABLA DE CONTENIDO DE USUARIO CON MAS DE 5 DIAS INACTIVOS" */
CALL sp_dash_administrador_contenido_usuarios_ult_conexion_c(@pr_pr_id_grupo_empresa, @pr_ini_pag, @pr_fin_pag, @pr_rows_tot_table, @pr_message);
SELECT @pr_rows_tot_table, @pr_message;




/* ~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+ */



/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ REPORTES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CALL sp_dash_reportes_indicadores_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_reportes_graf_x_mes_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_reportes_graf_cobranza_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_reportes_graf_comparativa_cxs_ventas_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_reportes_graf_cxs_x_servicio_c(7, 98, 100, @pr_message);
SELECT @pr_message;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ INTERFACE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT *
FROM ic_gds_tr_general
WHERE id_grupo_empresa = 7
AND DATE_FORMAT(fecha_recepcion, '%Y-%m') = '2019-08';

SELECT *
FROM ic_gds_tr_errores;


SELECT
	COUNT(*)
FROM ic_gds_tr_general
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND DATE_FORMAT(fecha_recepcion, '%Y-%m') = '2019-08';

SELECT
	COUNT(*)
FROM ic_gds_tr_general
WHERE id_grupo_empresa = 7
AND id_sucursal = 98
AND DATE_FORMAT(fecha_recepcion, '%Y-%m') = '2019-08'
AND fac_numero IS NOT NULL;

SELECT
	COUNT(*)
FROM(
SELECT *
FROM ic_gds_tr_general a
JOIN ic_gds_tr_errores b ON
	a.id_gds_generall = b.id_gds_general
WHERE a.id_grupo_empresa = 7
AND a.id_sucursal = 98
AND DATE_FORMAT(a.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY b.id_gds_general) a;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

/* OTROS */
SELECT *
FROM ic_gds_tr_general gen
LEFT JOIN ic_gds_tr_vuelos vuelos ON
	gen.id_gds_generall = vuelos.id_gds_general
LEFT JOIN ic_gds_tr_hoteles hoteles ON
	gen.id_gds_generall = hoteles.id_gds_general
LEFT JOIN ic_gds_tr_autos autos ON
	gen.id_gds_generall = autos.id_gds_general
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
AND vuelos.id_gds_general IS NULL
AND hoteles.id_gds_general IS NULL
AND autos.id_gds_general IS NULL;

/* VUELOS */
SELECT *
FROM ic_gds_tr_general gen
JOIN ic_gds_tr_vuelos vuelos ON
	gen.id_gds_generall = vuelos.id_gds_general
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY gen.id_gds_generall;

/* HOTELES */
SELECT *
FROM ic_gds_tr_general gen
JOIN ic_gds_tr_hoteles hoteles ON
	gen.id_gds_generall = hoteles.id_gds_general
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY gen.id_gds_generall;

/* AUTOS */
SELECT *
FROM ic_gds_tr_general gen
JOIN ic_gds_tr_autos autos ON
	gen.id_gds_generall = autos.id_gds_general
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY gen.id_gds_generall;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT
	gds.nombre nombre_gds,
	CASE
		WHEN gen.cve_gds = 'WS' THEN
			COUNT(*)
		WHEN gen.cve_gds = 'AM' THEN
			COUNT(*)
		WHEN gen.cve_gds = 'SA' THEN
			COUNT(*)
	END contador_pnrs
FROM ic_gds_tr_general gen
JOIN ic_cat_tc_gds gds ON
	gen.cve_gds = gds.cve_gds
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY gen.cve_gds;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT
	SUM(total_moneda_base) total
FROM ic_gds_tr_general gen
JOIN ic_fac_tr_factura fac ON
	gen.fac_numero = fac.fac_numero
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND serv.id_producto = 5
AND serv.estatus = 1
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY gen.id_gds_generall;

SELECT
	SUM(total_moneda_base) total_moneda_base
FROM(
SELECT 
	SUM(total_moneda_base) total_moneda_base
FROM ic_gds_tr_general gen
JOIN ic_fac_tr_factura fac ON
	gen.fac_numero = fac.fac_numero
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY gen.id_gds_generall) a;
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT
	nombre
FROM ic_gds_tr_general gen
JOIN ic_cat_tr_vendedor vend ON
	gen.cve_vendedor_tit = vend.clave
WHERE gen.id_grupo_empresa = 7
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08';

/* RECIBIDOS */
CREATE TEMPORARY TABLE tmp_count_recibidos
SELECT
	id_vendedor,
	nombre,
    COUNT(*) contador
FROM ic_gds_tr_general gen
JOIN ic_cat_tr_vendedor vend ON
	gen.cve_vendedor_tit = vend.clave
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY id_vendedor;

/* FACTURADOS */
CREATE TEMPORARY TABLE tmp_count_facturados
SELECT
	id_vendedor,
	nombre,
	COUNT(*) contador
FROM ic_gds_tr_general gen
JOIN ic_cat_tr_vendedor vend ON
	gen.cve_vendedor_tit = vend.clave
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
AND gen.fac_numero IS NOT NULL
GROUP BY id_vendedor;

/* ERROR */
CREATE TEMPORARY TABLE tmp_count_error
SELECT
	id_vendedor,
	nombre,
	COUNT(*) contador
FROM(
SELECT 
	id_vendedor,
	nombre,
	COUNT(*)
FROM ic_gds_tr_general a
JOIN ic_gds_tr_errores b ON
	a.id_gds_generall = b.id_gds_general
JOIN ic_cat_tr_vendedor vend ON
	a.cve_vendedor_tit = vend.clave
WHERE a.id_grupo_empresa = 7
AND a.id_sucursal = 98
AND DATE_FORMAT(a.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY 1, b.id_gds_general)a
GROUP BY 1;

SELECT
	a.nombre nombre_vendedor,
    IFNULL(a.contador, 0) recibidos,
    IFNULL(b.contador, 0) facturados,
    IFNULL(c.contador, 0) error
FROM tmp_count_recibidos a
LEFT JOIN tmp_count_facturados b ON
	a.id_vendedor = b.id_vendedor
LEFT JOIN tmp_count_error c ON
	a.id_vendedor = c.id_vendedor;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT *
FROM ic_gds_tr_general gen
WHERE gen.id_grupo_empresa = 7
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08';

/* PNR's RECIBIDOS */
CREATE TEMPORARY TABLE tmp_cliente_recibidos
SELECT
	cli.id_cliente,
	cli.razon_social,
    COUNT(*) contador
FROM ic_gds_tr_general gen
JOIN ic_cat_tr_cliente cli ON
	gen.cve_cliente = cli.cve_cliente
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
GROUP BY id_cliente;

/* IMPORTE FACTURADO CXS */
CREATE TEMPORARY TABLE tmp_cliente_cxs
SELECT
	cli.id_cliente,
	cli.razon_social,
	SUM(total_moneda_base) total_cxs
FROM ic_gds_tr_general gen
JOIN ic_cat_tr_cliente cli ON
	gen.cve_cliente = cli.cve_cliente
JOIN ic_fac_tr_factura fac ON
	gen.fac_numero = fac.fac_numero
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND serv.id_producto = 5
AND serv.estatus = 1
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
AND gen.fac_numero IS NOT NULL
GROUP BY cli.id_cliente;

/* IMPORTE FACTURADO */
CREATE TEMPORARY TABLE tmp_cliente_facturados
SELECT
	cli.id_cliente,
	cli.razon_social,
	SUM(total_moneda_base) total_facturado
FROM ic_gds_tr_general gen
JOIN ic_cat_tr_cliente cli ON
	gen.cve_cliente = cli.cve_cliente
JOIN ic_fac_tr_factura fac ON
	gen.fac_numero = fac.fac_numero
WHERE gen.id_grupo_empresa = 7
AND gen.id_sucursal = 98
AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
AND gen.fac_numero IS NOT NULL
GROUP BY cli.id_cliente;

SELECT
	a.razon_social,
    IFNULL(a.contador, 0) contador_pnr,
    IFNULL(b.total_facturado, 0) total_facturado,
    IFNULL(c.total_cxs, 0) total_cxs
FROM tmp_cliente_recibidos a
LEFT JOIN tmp_cliente_facturados b ON
	a.id_cliente = b.id_cliente
LEFT JOIN tmp_cliente_cxs c ON
	a.id_cliente = c.id_cliente;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

CALL sp_dash_interface_indicadores_c(7, 98, @pr_message);
SELECT @pr_message;

CALL sp_dash_interface_graf_x_producto_c(7, 98, @pr_message);
SELECT @pr_message;

CALL sp_dash_interface_graf_x_gds_c(7, 98, @pr_message);
SELECT @pr_message;

CALL sp_dash_interface_graf_comparativa_ventas_v_cxs_c(7, 98, 100, @pr_message);
SELECT @pr_message;

CALL sp_dash_interface_contenido_pnr_x_vendedor_c(7, 98, @pr_message);
SELECT @pr_message;

CALL sp_dash_interface_contenido_pnr_x_cliente_c(7, 98, 100, @pr_message);
SELECT @pr_message;
