/**/

SELECT *
FROM ic_glob_tr_cxc;

SELECT *
FROM ic_glob_tr_cxc_detalle;

SELECT *
FROM ic_fac_tr_pagos;

SELECT *
FROM ic_fac_tr_pagos_detalle;
    
SELECT *
FROM ic_glob_tr_cxc cxc
JOIN ic_fac_tr_pagos_detalle pagos_det ON
	cxc.id_cxc = pagos_det.id_cxc
/*SET cxc.pagos_facturado = pagos_det.importe_pago,
	cxc.pagos_moneda_base = pagos_det.importe_moneda_base
*/
WHERE cxc.pagos_facturado > cxc.importe_facturado
OR cxc.saldo_facturado > cxc.importe_facturado
GROUP BY cxc.id_cxc;
    
UPDATE ic_glob_tr_cxc cxc
JOIN ic_fac_tr_pagos_detalle pagos_det ON
	cxc.id_cxc = pagos_det.id_cxc
SET cxc.pagos_facturado = pagos_det.importe_pago,
	cxc.pagos_moneda_base = pagos_det.importe_moneda_base
WHERE cxc.pagos_facturado > cxc.importe_facturado
AND cxc.saldo_facturado > cxc.importe_facturado;
    
UPDATE ic_glob_tr_cxc cxc
JOIN ic_fac_tr_pagos_detalle pagos_det ON
	cxc.id_cxc = pagos_det.id_cxc
SET cxc.saldo_facturado = (pagos_det.importe_pago - cxc.pagos_facturado),
	cxc.saldo_moneda_base = (pagos_det.importe_moneda_base - cxc.pagos_moneda_base)
AND cxc.estatus = 'INACTIVO';
    
    
    
SELECT *
FROM ic_glob_tr_cxc cxc
LEFT JOIN ic_fac_tr_pagos_detalle pagos_det ON
	cxc.id_cxc = pagos_det.id_cxc
WHERE pagos_det.id_pago_detalle IS NULL;


UPDATE ic_glob_tr_cxc cxc
LEFT JOIN ic_fac_tr_pagos_detalle pagos_det ON
	cxc.id_cxc = pagos_det.id_cxc
SET /*pagos_facturado = 0,
	pagos_moneda_base=0*/cxc.saldo_facturado = (cxc.importe_facturado),
	cxc.saldo_moneda_base = ( cxc.importe_facturado)
WHERE pagos_det.id_pago_detalle IS NULL
AND cxc.estatus = 'INACTIVO';

/* --------------------------------------- */

SELECT *
FROM ic_glob_tr_cxc cxc
JOIN ic_glob_tr_cxc_detalle cxc_detalle ON
	cxc.id_cxc = cxc_detalle.id_cxc
WHERE cxc_detalle.id_pago = 0
AND cxc_detalle.estatus = 'INACTIVO';

UPDATE ic_glob_tr_cxc cxc
JOIN ic_glob_tr_cxc_detalle cxc_detalle ON
	cxc.id_cxc = cxc_detalle.id_cxc
SET saldo_moneda_base = cxc.importe_moneda_base,
	pagos_moneda_base = cxc.importe_moneda_base
WHERE cxc_detalle.id_pago = 0
 AND cxc_detalle.estatus = 'INACTIVO';

SELECT *
FROM ic_glob_tr_cxc; -- 971618 971627


SELECT *
FROM ic_glob_tr_cxc_detalle
WHERE id_cxc IN (971618, 971627);

/* ******************************************************* */

SELECT *
	/*
    pagos_facturado <-- importe_pago
    pagos_moneda_base <-- importe_moneda_base    
    */
FROM ic_glob_tr_cxc;

SELECT *
FROM ic_fac_tr_pagos;

SELECT *
FROM ic_fac_tr_pagos_detalle;

SELECT *
FROM ic_glob_tr_cxc cxc
JOIN ic_fac_tr_pagos_detalle pagos_det ON
	cxc.id_cxc = pagos_det.id_cxc
JOIN ic_fac_tr_pagos pagos ON
	pagos_det.id_pago = pagos.id_pago;
    
    
UPDATE ic_glob_tr_cxc cxc
JOIN ic_fac_tr_pagos_detalle pagos_det ON
	cxc.id_cxc = pagos_det.id_cxc
SET cxc.saldo_facturado = (pagos_det.importe_pago - cxc.pagos_facturado),
	cxc.saldo_moneda_base = (pagos_det.importe_moneda_base - cxc.pagos_moneda_base)