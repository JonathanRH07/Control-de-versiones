/* BORRAR REGISTROS DEL MES */
DELETE FROM ic_rep_tr_acumulado_sucursal WHERE fecha >= '2020-01';
DELETE FROM ic_rep_tr_acumulado_cliente WHERE fecha >= '2020-01';
DELETE FROM ic_rep_tr_acumulado_vendedor WHERE fecha >= '2020-01';
DELETE FROM ic_rep_tr_acumulado_proveedor WHERE fecha >= '2020-01';
DELETE FROM ic_rep_tr_acumulado_servicio WHERE fecha >= '2020-01';
DELETE FROM ic_rep_tr_acumulado_tipo_proveedor WHERE fecha >= '2020-01';
DELETE FROM ic_rep_tr_acumulado_aerolinea WHERE fecha >= '2020-01';
COMMIT;

/* CARGAR REGISTROS DEL MES */
CALL sp_acumulados_sucursal_mes_u('2020-01', @pr_message);
CALL sp_acumulados_cliente_mes_u('2020-01', @pr_message);
CALL sp_acumulados_vendedor_mes_u('2020-01', @pr_message);
CALL sp_acumulados_proveedor_mes_u('2020-01', @pr_message);
CALL sp_acumulados_servicio_mes_u('2020-01', @pr_message);
CALL sp_acumulados_tipo_proveedor_mes_u('2020-01', @pr_message);
CALL sp_acumulados_pagos_mes_u('2020-01', @pr_message);
CALL sp_acumulados_pagos_detalle_mes_u('2020-01', @pr_message);
CALL sp_acumulados_aerolinea_mes_u('2020-01', @pr_message);

/* CARGAR REGISTROS ACUMULADOS DEL MES */
CALL sp_rep_acumulados_sucursal_mes_u('2020-01', @pr_message);
CALL sp_rep_acumulados_cliente_mes_u('2020-01', @pr_message);
CALL sp_rep_acumulados_vendedor_mes_u('2020-01', @pr_message);
CALL sp_rep_acumulados_proveedor_mes_u('2020-01', @pr_message);
CALL sp_rep_acumulados_servicio_mes_u('2020-01', @pr_message);
CALL sp_rep_acumulados_tipo_proveedor_mes_u('2020-01', @pr_message);
CALL sp_rep_acumulados_aerolineas_mes_u('2020-01', @pr_message);

/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~ */

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_sucursal
WHERE fecha >= '2020-01';
COMMIT;

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_sucursal
WHERE monto_tarifa_base = 0
AND	egresos_moneda_base = 0
AND venta_neta_moneda_base = 0
AND acumulado_moneda_base = 0;

/* --------------------------------- */

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_cliente
WHERE fecha >= '2019-11';
COMMIT;

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_cliente
WHERE monto_moneda_base = 0
AND	egresos_moneda_base = 0
AND venta_neta_moneda_base = 0
AND acumulado_moneda_base = 0;

/* -------------------------------- */

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_vendedor
WHERE fecha >= '2019-11';
COMMIT;

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_vendedor
WHERE monto_moneda_base = 0
AND	egresos_moneda_base = 0
AND venta_neta_moneda_base = 0
AND acumulado_moneda_base = 0;

/* -------------------------------- */

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_proveedor
WHERE fecha >= '2019-11';
COMMIT;

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_proveedor
WHERE monto_moneda_base = 0
AND	egresos_moneda_base = 0
AND venta_neta_moneda_base = 0
AND acumulado_moneda_base = 0;

/* -------------------------------- */

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_servicio
WHERE fecha >= '2019-11';
COMMIT;

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_servicio
WHERE monto_moneda_base = 0
AND	egresos_moneda_base = 0
AND venta_neta_moneda_base = 0
AND acumulado_moneda_base = 0;

/* -------------------------------- */

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_tipo_proveedor
WHERE fecha >= '2019-11';
COMMIT;

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_tipo_proveedor
WHERE monto_moneda_base = 0
AND	egresos_moneda_base = 0
AND venta_neta_moneda_base = 0
AND acumulado_moneda_base = 0;

/* -------------------------------- */

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_pagos
WHERE DATE_FORMAT(fecha, '%Y-%m') >= '2020-01';
COMMIT;


/* -------------------------------- */

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_pagos_detalle
WHERE DATE_FORMAT(fecha, '%Y-%m') >= '2020-01';
COMMIT;


/* -------------------------------- */

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_aerolinea
WHERE fecha >= '2019-11';
COMMIT;

SELECT * -- DELETE
FROM ic_rep_tr_acumulado_servicio
WHERE monto_moneda_base = 0
AND	egresos_moneda_base = 0
AND venta_neta_moneda_base = 0
AND acumulado_moneda_base = 0;