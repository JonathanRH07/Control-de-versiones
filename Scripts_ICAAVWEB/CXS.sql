USE suite_mig_demo;

SELECT *
FROM ic_cat_tc_producto;

SELECT *
FROM ic_cat_tc_servicio
WHERE id_producto = 5;

SELECT *
FROM ic_cat_tc_servicio serv
LEFT JOIN ic_fac_tr_factura_detalle det ON
	serv.id_servicio = det.id_servicio
LEFT JOIN ic_fac_tr_factura fac ON
	det.id_factura = fac.id_factura
WHERE serv.id_producto = 5
AND serv.id_grupo_empresa = 7
AND serv.estatus = 1;

SELECT
	serv.id_servicio,
	COUNT(serv.id_servicio)
FROM ic_cat_tc_servicio serv
JOIN ic_fac_tr_factura_detalle det ON
	serv.id_servicio = det.id_servicio
JOIN ic_fac_tr_factura fac ON
	det.id_factura = fac.id_factura
WHERE serv.id_producto = 5
AND serv.id_grupo_empresa = 7
AND serv.estatus = 1
GROUP BY serv.id_servicio;

SELECT
	a.descripcion,
    b.contador,
    SUM(a.total_moneda_base) total_moneda_base
FROM (
		SELECT
			serv.id_servicio,
			serv.descripcion,
			SUM(fac.total_moneda_base) total_moneda_base
		FROM ic_cat_tc_servicio serv
		JOIN ic_fac_tr_factura_detalle det ON
			serv.id_servicio = det.id_servicio
		JOIN ic_fac_tr_factura fac ON
			det.id_factura = fac.id_factura
		WHERE serv.id_producto = 5
		AND serv.id_grupo_empresa = 7 
		AND serv.estatus = 1
        AND fac.fecha_factura >= '2019-05-01'
        AND fac.fecha_factura <= '2019-05-31'
		GROUP BY det.id_factura) a
JOIN (
	SELECT
			serv.id_servicio,
			COUNT(serv.id_servicio) contador
		FROM ic_cat_tc_servicio serv
		JOIN ic_fac_tr_factura_detalle det ON
			serv.id_servicio = det.id_servicio
		JOIN ic_fac_tr_factura fac ON
			det.id_factura = fac.id_factura
		WHERE serv.id_producto = 5
		AND serv.id_grupo_empresa = 7
		AND serv.estatus = 1
		AND fac.fecha_factura >= '2019-05-01'
        AND fac.fecha_factura <= '2019-05-31'
		GROUP BY serv.id_servicio) b ON
	a.id_servicio = b.id_servicio
GROUP BY a.id_servicio;

/* ---------------------- */



/* ---------------------- */

SELECT
	serv.descripcion,
	COUNT(*) no_cargos,
	((SUM(tarifa_moneda_base) + SUM(importe_markup))- SUM(descuento)) total
FROM ic_cat_tc_servicio serv
JOIN ic_fac_tr_factura_detalle det ON
	serv.id_servicio = det.id_servicio
JOIN ic_fac_tr_factura fac ON
	det.id_factura = fac.id_factura
WHERE serv.id_producto = 5
AND serv.id_grupo_empresa = 7
AND serv.estatus = 1
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31'
GROUP BY serv.descripcion;

/* ---------------------- */

SELECT 
    ((SUM(tarifa_moneda_base) + SUM(importe_markup))- SUM(descuento)) total_ventas
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
WHERE id_grupo_empresa = 7
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31';

SELECT
	((SUM(tarifa_moneda_base) + SUM(importe_markup))- SUM(descuento)) total_cargos
FROM ic_cat_tc_servicio serv
JOIN ic_fac_tr_factura_detalle det ON
	serv.id_servicio = det.id_servicio
JOIN ic_fac_tr_factura fac ON
	det.id_factura = fac.id_factura
WHERE serv.id_producto = 5
AND serv.id_grupo_empresa = 7
AND serv.estatus = 1
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31';

/* ---------------------- */

/* ---------------------- */

SELECT 
    SUM(det.comision_agencia)
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
WHERE id_grupo_empresa = 7
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31';


SELECT
	((SUM(tarifa_moneda_base) + SUM(importe_markup)) - SUM(descuento)) total_cargos
FROM ic_cat_tc_servicio serv
JOIN ic_fac_tr_factura_detalle det ON
	serv.id_servicio = det.id_servicio
JOIN ic_fac_tr_factura fac ON
	det.id_factura = fac.id_factura
WHERE serv.id_producto = 5
AND serv.id_grupo_empresa = 7
AND serv.estatus = 1
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31';
/* ---------------------- */

SELECT 
    SUM(det.comision_agencia) comision_agencia
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
WHERE fac.id_grupo_empresa = 7
AND serv.id_producto = 5
AND serv.estatus = 1
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31';

SELECT 
    SUM(det.comision_titular + det.comision_auxiliar) comision_vendedor
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
WHERE fac.id_grupo_empresa = 7
AND serv.id_producto = 5
AND serv.estatus = 1
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31';

/* ---------------------- */

CREATE TEMPORARY TABLE tmp_ventas
SELECT
	fac.id_factura,
    fac.id_cliente,
    cli.cve_cliente,
    cli.nombre_comercial nombre,
	SUM((tarifa_moneda_base + importe_markup - descuento)) tarifa_facturada,
    COUNT(det.id_servicio) no_servicios,
    SUM((tarifa_moneda_base + importe_markup - descuento)) / COUNT(det.id_servicio) promedio_servicios
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
JOIN ic_cat_tr_cliente cli ON
	fac.id_cliente = cli.id_cliente
WHERE fac.id_grupo_empresa = 7
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31'
GROUP BY fac.id_cliente
ORDER BY cli.cve_cliente;

CREATE TEMPORARY TABLE tmp_cxs
SELECT
	fac.id_factura,
    fac.id_cliente,
    SUM((tarifa_moneda_base + importe_markup - descuento)) importe_cxs,
    COUNT(det.id_servicio) numero_cxs,
    SUM((tarifa_moneda_base + importe_markup - descuento)) / COUNT(det.id_servicio) promedio_cxs
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
JOIN ic_cat_tr_cliente cli ON
	fac.id_cliente = cli.id_cliente
WHERE fac.id_grupo_empresa = 7
AND serv.id_producto = 5
AND serv.estatus = 1
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31'
GROUP BY fac.id_cliente
ORDER BY cli.cve_cliente;

SELECT *
FROM tmp_ventas;

SELECT *
FROM tmp_cxs;

SELECT
	vent.id_factura, 
    vent.id_cliente, 
    vent.cve_cliente, 
    vent.nombre, 
    vent.tarifa_facturada, 
    vent.no_servicios, 
    vent.promedio_servicios, 
    cxs.importe_cxs, 
    cxs.numero_cxs, 
    cxs.promedio_cxs,
    ((promedio_cxs*100) / promedio_servicios) porcentaje_cxs_venta
FROM tmp_ventas vent
JOIN tmp_cxs cxs ON
	vent.id_cliente = cxs.id_cliente
GROUP BY vent.id_factura;

/* ---------------------- */

SELECT
	fac.fecha_factura,
    CONCAT(serie.cve_serie, '-',fac.fac_numero) factura,
    cli.cve_cliente,
    vend.clave cve_vendedor,
    det.nombre_pasajero,
    prov.cve_proveedor,
    serv.cve_servicio,
    (tarifa_moneda_base + importe_markup - descuento) importe_cxs,
    det.numero_boleto referencia,
    serv.descripcion concepto_serv
FROM ic_fac_tr_factura fac
JOIN ic_fac_tr_factura_detalle det ON
	fac.id_factura = det.id_factura
JOIN ic_cat_tc_servicio serv ON
	det.id_servicio = serv.id_servicio
JOIN ic_cat_tr_cliente cli ON
	fac.id_cliente = cli.id_cliente
JOIN ic_cat_tr_serie serie ON
	fac.id_serie = serie.id_serie
JOIN ic_cat_tr_vendedor vend ON
	fac.id_vendedor_tit = vend.id_vendedor
JOIN ic_cat_tr_proveedor prov ON
	det.id_proveedor = prov.id_proveedor
WHERE fac.id_grupo_empresa = 7
AND fac.id_cliente = 14984
AND serv.id_producto = 5
AND serv.estatus = 1
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31'
GROUP BY det.id_factura_detalle;

/* ---------------------- */

SELECT
	IFNULL(((SUM(tarifa_moneda_base) + SUM(importe_markup))- SUM(descuento)), 0) total_importe,
	IFNULL(COUNT(*), 0) no_cargos,
    IFNULL((((SUM(tarifa_moneda_base) + SUM(importe_markup))- SUM(descuento)) / COUNT(*)), 0) costo_promedio,
    IFNULL(((SUM(tarifa_moneda_base) + SUM(importe_markup))- SUM(descuento)), 0) total_ingresos,
    IFNULL(SUM((((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_titular))/100) +
	(comision_agencia * (porc_comision_titular/100)) +
	((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_auxiliar))/100) +
	(comision_agencia * (porc_comision_auxiliar/100))) + ((comision_titular) + (comision_auxiliar))), 0) comision_neta,
    (IFNULL(((SUM(tarifa_moneda_base) + SUM(importe_markup))- SUM(descuento)), 0) - IFNULL(SUM((((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_titular))/100) +
	(comision_agencia * (porc_comision_titular/100)) +
	((((tarifa_moneda_base * porc_comision_agencia)/100) * (porc_comision_auxiliar))/100) +
	(comision_agencia * (porc_comision_auxiliar/100))) + ((comision_titular) + (comision_auxiliar))), 0)) ingresos_netos_x_cargos
FROM ic_cat_tc_servicio serv
JOIN ic_fac_tr_factura_detalle det ON
	serv.id_servicio = det.id_servicio
JOIN ic_fac_tr_factura fac ON
	det.id_factura = fac.id_factura
WHERE serv.id_producto = 5
AND serv.id_grupo_empresa = 7
AND serv.estatus = 1
AND fac.fecha_factura >=  '2019-05-01'
AND fac.fecha_factura <= '2019-05-31'
GROUP BY serv.descripcion;

/* ---------------------- */


CALL sp_rep_cxs_cargos_x_tipo_c(7,  0, 100, '2019-05-01', '2019-05-31', @pr_message);
SELECT @pr_message;

CALL sp_rep_cxs_comparativa_vent_vs_cxs_c(7,  0, 100, '2019-05-01', '2019-05-31', @pr_message);
SELECT @pr_message;

CALL sp_rep_cxs_comparativa_ing_vs_cxs_c(7,  0, 100, '2019-05-01', '2019-05-31', @pr_message);
SELECT @pr_message;

CALL sp_rep_cxs_comparativa_comisiones_c(7,  0, 100, '2019-05-01', '2019-05-31', @pr_message);
SELECT @pr_message;

CALL sp_rep_cxs_cargos_x_cliente_c(7, 98, 100, '2019-05-01', '2019-05-31', @pr_message);
SELECT @pr_message;

CALL sp_rep_cxs_cargos_x_vendedor_c(7, 98, 100, '2019-05-01', '2019-05-31', @pr_message);
SELECT @pr_message;

/* CLIENTE */
CALL sp_rep_cxs_cargos_x_detalle_c(7, 98, 1, 14984, 100, '2019-05-01', '2019-05-31', @pr_message);
SELECT @pr_message;

/* VENDEDOR */
CALL sp_rep_cxs_cargos_x_detalle_c(7, 98, 1, 14984, 100, '2019-05-01', '2019-05-31', @pr_message);
SELECT @pr_message;

/* SERVICIO */
CALL sp_rep_cxs_cargos_x_detalle_c(7, 98, 3, 0, 100, '2019-05-01', '2019-05-31', @pr_message);
SELECT @pr_message;

