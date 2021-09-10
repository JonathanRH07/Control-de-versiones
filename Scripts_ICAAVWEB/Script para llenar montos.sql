SELECT * FROM ic_rep_tr_acumulado_sucursal;

SELECT * FROM ic_rep_tr_acumulado_cliente;-- ESTA

SELECT * FROM ic_rep_tr_acumulado_proveedor;-- ESTA

SELECT * FROM ic_rep_tr_acumulado_servicio;-- ESTA

SELECT * FROM ic_rep_tr_acumulado_vendedor;

/* SUCURSAL */
SELECT *
FROM ic_rep_tr_acumulado_sucursal;
/*1*/
SELECT 
	FLOOR(1 + (RAND() * monto_tarifa_base)) egresos
FROM ic_rep_tr_acumulado_sucursal
WHERE egresos_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_sucursal
SET egresos_moneda_base = FLOOR(1 + (RAND() * monto_tarifa_base))
WHERE egresos_moneda_base IS NULL;

/*2*/
SELECT
	monto_tarifa_base,
    egresos_moneda_base,
    (monto_tarifa_base - egresos_moneda_base) venta_neta
FROM ic_rep_tr_acumulado_sucursal
WHERE venta_neta_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_sucursal
SET venta_neta_moneda_base = (monto_tarifa_base - egresos_moneda_base)
WHERE venta_neta_moneda_base IS NULL;

/*3*/
SELECT 
	monto_tarifa_base,
    venta_neta_moneda_base,
    (venta_neta_moneda_base + egresos_moneda_base)
FROM ic_rep_tr_acumulado_sucursal
WHERE venta_neta_moneda_base IS NULL;

/*5*/
SELECT 
	(egresos_moneda_base*20),
    egresos_eur
FROM ic_rep_tr_acumulado_sucursal
WHERE egresos_eur IS NULL;

SELECT 
	(venta_neta_moneda_base*18),
    venta_neta_usd
FROM ic_rep_tr_acumulado_sucursal
WHERE venta_neta_usd IS NULL;

SELECT 
	(venta_neta_moneda_base*20),
    venta_neta_eur
FROM ic_rep_tr_acumulado_sucursal
WHERE venta_neta_eur IS NULL;

UPDATE ic_rep_tr_acumulado_sucursal
SET egresos_usd = (egresos_moneda_base*18),
	egresos_eur = (egresos_moneda_base*20),
    venta_neta_usd = (venta_neta_moneda_base*18),
    venta_neta_eur = (venta_neta_moneda_base*20)
WHERE venta_neta_eur IS NULL
AND egresos_eur IS NULL
AND venta_neta_usd IS NULL
AND egresos_usd IS NULL;

/* CLIENTE */
SELECT *
FROM ic_rep_tr_acumulado_cliente;
/*1*/
SELECT 
	FLOOR(1 + (RAND() * monto_moneda_base)) egresos
FROM ic_rep_tr_acumulado_cliente
WHERE egresos_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_cliente
SET egresos_moneda_base = FLOOR(1 + (RAND() * monto_moneda_base))
WHERE egresos_moneda_base IS NULL;

/*2*/
SELECT
	monto_moneda_base,
    egresos_moneda_base,
    (monto_moneda_base - egresos_moneda_base) venta_neta
FROM ic_rep_tr_acumulado_cliente
WHERE venta_neta_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_cliente
SET venta_neta_moneda_base = (monto_moneda_base - egresos_moneda_base)
WHERE venta_neta_moneda_base IS NULL;

/*3*/
SELECT 
	monto_moneda_base,
    venta_neta_moneda_base,
    (venta_neta_moneda_base + egresos_moneda_base)
FROM ic_rep_tr_acumulado_cliente
WHERE venta_neta_moneda_base IS NULL;

/*4*/
SELECT 
	(egresos_moneda_base*18),
    egresos_usd
FROM ic_rep_tr_acumulado_cliente
WHERE egresos_usd IS NULL;


/*5*/
SELECT 
	(egresos_moneda_base*20),
    egresos_eur
FROM ic_rep_tr_acumulado_cliente
WHERE egresos_eur IS NULL;


SELECT 
	(venta_neta_moneda_base*18),
    venta_neta_usd
FROM ic_rep_tr_acumulado_cliente
WHERE venta_neta_usd IS NULL;


/*6*/
SELECT 
	(venta_neta_moneda_base*20),
    venta_neta_eur
FROM ic_rep_tr_acumulado_cliente
WHERE venta_neta_eur IS NULL;



UPDATE ic_rep_tr_acumulado_cliente
SET egresos_usd = (egresos_moneda_base*18),
	egresos_eur = (egresos_moneda_base*20),
    venta_neta_usd = (venta_neta_moneda_base*18),
    venta_neta_eur = (venta_neta_moneda_base*20)
WHERE venta_neta_eur IS NULL
AND egresos_eur IS NULL
AND venta_neta_usd IS NULL
AND egresos_usd IS NULL;

/* VENDEDOR */
SELECT *
FROM ic_rep_tr_acumulado_vendedor;
/*1*/
SELECT 
	FLOOR(1 + (RAND() * monto_moneda_base)) egresos
FROM ic_rep_tr_acumulado_vendedor
WHERE egresos_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_vendedor
SET egresos_moneda_base = FLOOR(1 + (RAND() * monto_moneda_base))
WHERE egresos_moneda_base IS NULL;

/*2*/
SELECT
	monto_moneda_base,
    egresos_moneda_base,
    (monto_moneda_base - egresos_moneda_base) venta_neta
FROM ic_rep_tr_acumulado_vendedor
WHERE venta_neta_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_vendedor
SET venta_neta_moneda_base = (monto_moneda_base - egresos_moneda_base)
WHERE venta_neta_moneda_base IS NULL;

/*3*/
SELECT 
	monto_moneda_base,
    venta_neta_moneda_base,
    (venta_neta_moneda_base + egresos_moneda_base)
FROM ic_rep_tr_acumulado_vendedor
WHERE venta_neta_moneda_base IS NULL;

/*4*/
SELECT 
	(egresos_moneda_base*18),
    egresos_usd
FROM ic_rep_tr_acumulado_vendedor
WHERE egresos_usd IS NULL;


/*5*/
SELECT 
	(egresos_moneda_base*20),
    egresos_eur
FROM ic_rep_tr_acumulado_vendedor
WHERE egresos_eur IS NULL;


SELECT 
	(venta_neta_moneda_base*18),
    venta_neta_usd
FROM ic_rep_tr_acumulado_vendedor
WHERE venta_neta_usd IS NULL;


/*6*/
SELECT 
	(venta_neta_moneda_base*20),
    venta_neta_eur
FROM ic_rep_tr_acumulado_vendedor
WHERE venta_neta_eur IS NULL;



UPDATE ic_rep_tr_acumulado_vendedor
SET egresos_usd = (egresos_moneda_base*18),
	egresos_eur = (egresos_moneda_base*20),
    venta_neta_usd = (venta_neta_moneda_base*18),
    venta_neta_eur = (venta_neta_moneda_base*20)
WHERE venta_neta_eur IS NULL
AND egresos_eur IS NULL
AND venta_neta_usd IS NULL
AND egresos_usd IS NULL;

/* PROVEEDOR */
SELECT *
FROM ic_rep_tr_acumulado_proveedor;
/*1*/
SELECT 
	FLOOR(1 + (RAND() * monto_moneda_base)) egresos
FROM ic_rep_tr_acumulado_proveedor
WHERE egresos_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_proveedor
SET egresos_moneda_base = FLOOR(1 + (RAND() * monto_moneda_base))
WHERE egresos_moneda_base IS NULL;

/*2*/
SELECT
	monto_moneda_base,
    egresos_moneda_base,
    (monto_moneda_base - egresos_moneda_base) venta_neta
FROM ic_rep_tr_acumulado_proveedor
WHERE venta_neta_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_proveedor
SET venta_neta_moneda_base = (monto_moneda_base - egresos_moneda_base)
WHERE venta_neta_moneda_base IS NULL;

/*3*/
SELECT 
	monto_moneda_base,
    venta_neta_moneda_base,
    (venta_neta_moneda_base + egresos_moneda_base)
FROM ic_rep_tr_acumulado_proveedor
WHERE venta_neta_moneda_base IS NULL;

/*4*/
SELECT 
	(egresos_moneda_base*18),
    egresos_usd
FROM ic_rep_tr_acumulado_proveedor
WHERE egresos_usd IS NULL;


/*5*/
SELECT 
	(egresos_moneda_base*20),
    egresos_eur
FROM ic_rep_tr_acumulado_proveedor
WHERE egresos_eur IS NULL;


SELECT 
	(venta_neta_moneda_base*18),
    venta_neta_usd
FROM ic_rep_tr_acumulado_proveedor
WHERE venta_neta_usd IS NULL;


/*6*/
SELECT 
	(venta_neta_moneda_base*20),
    venta_neta_eur
FROM ic_rep_tr_acumulado_proveedor
WHERE venta_neta_eur IS NULL;



UPDATE ic_rep_tr_acumulado_proveedor
SET egresos_usd = (egresos_moneda_base*18),
	egresos_eur = (egresos_moneda_base*20),
    venta_neta_usd = (venta_neta_moneda_base*18),
    venta_neta_eur = (venta_neta_moneda_base*20)
WHERE venta_neta_eur IS NULL
AND egresos_eur IS NULL
AND venta_neta_usd IS NULL
AND egresos_usd IS NULL;

/* SERVICIO */
SELECT *
FROM ic_rep_tr_acumulado_servicio;

/*1*/
SELECT 
	FLOOR(1 + (RAND() * monto_moneda_base)) egresos
FROM ic_rep_tr_acumulado_servicio
WHERE egresos_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_servicio
SET egresos_moneda_base = FLOOR(1 + (RAND() * monto_moneda_base))
WHERE egresos_moneda_base IS NULL;

/*2*/
SELECT
	monto_moneda_base,
    egresos_moneda_base,
    (monto_moneda_base - egresos_moneda_base) venta_neta
FROM ic_rep_tr_acumulado_servicio
WHERE venta_neta_moneda_base IS NULL;

UPDATE ic_rep_tr_acumulado_servicio
SET venta_neta_moneda_base = (monto_moneda_base - egresos_moneda_base)
WHERE venta_neta_moneda_base IS NULL;

/*3*/
SELECT 
	monto_moneda_base,
    venta_neta_moneda_base,
    (venta_neta_moneda_base + egresos_moneda_base)
FROM ic_rep_tr_acumulado_servicio
WHERE venta_neta_moneda_base IS NULL;

/*4*/
SELECT 
	(egresos_moneda_base*18),
    egresos_usd
FROM ic_rep_tr_acumulado_servicio
WHERE egresos_usd IS NULL;


/*5*/
SELECT 
	(egresos_moneda_base*20),
    egresos_eur
FROM ic_rep_tr_acumulado_servicio
WHERE egresos_eur IS NULL;


SELECT 
	(venta_neta_moneda_base*18),
    venta_neta_usd
FROM ic_rep_tr_acumulado_servicio
WHERE venta_neta_usd IS NULL;


/*6*/
SELECT 
	(venta_neta_moneda_base*20),
    venta_neta_eur
FROM ic_rep_tr_acumulado_servicio
WHERE venta_neta_eur IS NULL;



UPDATE ic_rep_tr_acumulado_servicio
SET egresos_usd = (egresos_moneda_base*18),
	egresos_eur = (egresos_moneda_base*20),
    venta_neta_usd = (venta_neta_moneda_base*18),
    venta_neta_eur = (venta_neta_moneda_base*20)
WHERE venta_neta_eur IS NULL
AND egresos_eur IS NULL
AND venta_neta_usd IS NULL
AND egresos_usd IS NULL;