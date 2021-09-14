SELECT *
FROM ic_rep_tr_acumulado_sucursal;

CALL sp_acumulados_sucursal_mes_u('2019-11', @pr_message);
SELECT @pr_message;

CALL sp_rep_acumulados_sucursal_mes_u('2019-11', @pr_message);
SELECT @pr_message;

/* ---------------------------------- */

SELECT *
FROM ic_rep_tr_acumulado_cliente;

CALL sp_acumulados_cliente_mes_u('2019-11', @pr_message);
SELECT @pr_message;

CALL sp_rep_acumulados_cliente_mes_u('2019-11', @pr_message);
SELECT @pr_message;

/* ---------------------------------- */

SELECT *
FROM ic_rep_tr_acumulado_vendedor;

CALL sp_acumulados_vendedor_mes_u('2019-11', @pr_message);
SELECT @pr_message;

CALL sp_rep_acumulados_vendedor_mes_u('2019-11', @pr_message);
SELECT @pr_message;

/* ---------------------------------- */

SELECT *
FROM ic_rep_tr_acumulado_proveedor;

CALL sp_acumulados_proveedor_mes_u('2019-11', @pr_message);
SELECT @pr_message;

CALL sp_rep_acumulados_proveedor_mes_u('2019-11', @pr_message);
SELECT @pr_message;

/* ---------------------------------- */

SELECT *
FROM ic_rep_tr_acumulado_servicio;

CALL sp_acumulados_servicio_mes_u('2019-11', @pr_message);
SELECT @pr_message;

CALL sp_rep_acumulados_servicio_mes_u('2019-11', @pr_message);
SELECT @pr_message;

/* ---------------------------------- */

SELECT *
FROM ic_rep_tr_acumulado_tipo_proveedor;

CALL sp_acumulados_tipo_proveedor_mes_u('2019-11', @pr_message);
SELECT @pr_message;

CALL sp_rep_acumulados_tipo_proveedor_mes_u('2019-11', @pr_message);
SELECT @pr_message;

/* ---------------------------------- */

SELECT *
FROM ic_rep_tr_acumulado_pagos;

CALL sp_acumulados_pagos_mes_u('2019-11', @pr_message);
SELECT @pr_message;

/* ---------------------------------- */

SELECT *
FROM ic_rep_tr_acumulado_pagos_detalle;

CALL sp_acumulados_pagos_detalle_mes_u('2019-11', @pr_message);
SELECT @pr_message;

/* ---------------------------------- */

SELECT *
FROM ic_rep_tr_acumulado_aerolinea;

CALL sp_acumulados_aerolinea_mes_u('2019-11', @pr_message);
SELECT @pr_message;

CALL sp_rep_acumulados_aerolineas_mes_u('2019-11', @pr_message);
SELECT @pr_message;
/* ---------------------------------- */