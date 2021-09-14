SELECT
	id_grupo_empresa,
    id_sucursal,
    id_cliente,
    id_vendedor_tit,
    tipo_cfdi,
    tipo_cambio_usd,
    tipo_cambio_eur,
    id_unidad_negocio
FROM ic_fac_tr_factura
WHERE id_factura = 1;

SELECT *
FROM ic_fac_tr_factura;

SELECT *
FROM ic_fac_tr_factura_detalle;

SELECT *
FROM ic_cat_tr_cliente
WHERE id_grupo_empresa = 7;

SELECT
	id_tipo_proveedor
INTO
	@lo_id_tipo_proveedor
FROM ic_cat_tr_proveedor
WHERE id_proveedor = pr_id_proveedor;

SELECT
	clave_linea_aerea
FROM ic_gds_tr_vuelos
WHERE id_factura_detalle = 5246;

SELECT
	clave_linea_aerea
INTO
	@lo_clave_linea_aerea
FROM ic_gds_tr_vuelos
WHERE id_factura_detalle = NEW.id_factura_detalle;

SELECT
	cve_unidad_negocio,
    desc_unidad_negocio
INTO
	@lo_cve_unidad_negocio,
    @lo_desc_unidad_negocio
FROM ic_cat_tc_unidad_negocio
WHERE id_unidad_negocio = @lo_id_unidad_negocio;

/* -------------------------------------------------------------------------------------- */

/* CLIENTE */
SELECT -- ic_fac_tr_factura
	*
	/*
	id_sucursal,
    id_cliente,
    monto_moneda_base,
    egresos_moneda_base,
    venta_neta_moneda_base,
    acumulado_moneda_base
INTO
	@lo_clie_id_sucursal,
    @lo_clie_id_cliente,
    @lo_clie_monto_moneda_base,
    @lo_clie_egresos_moneda_base,
    @lo_clie_venta_neta_moneda_base,
    @lo_clie_acumulado_moneda_base
    */
FROM ic_rep_tr_acumulado_cliente
WHERE id_grupo_empresa = 17
AND id_cliente = 0
AND id_sucursal = 0
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

/* SUCURSAL */
SELECT *-- ic_fac_tr_factura
	/*
    id_sucursal,
    monto_tarifa_base,
    egresos_moneda_base,
    venta_neta_moneda_base,
    acumulado_moneda_base
INTO
	@lo_suc_id_sucursal,
    @lo_suc_monto_tarifa_base,
    @lo_suc_egresos_moneda_base,
    @lo_suc_venta_neta_moneda_base,
    @lo_suc_acumulado_moneda_base
    */
FROM ic_rep_tr_acumulado_sucursal
WHERE id_grupo_empresa = 17
AND id_sucursal = 0
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

/* VENDEDOR */
SELECT  *-- ic_fac_tr_factura
/*
	id_sucursal,
    id_vendedor,
    monto_moneda_base,
    egresos_moneda_base,
    venta_neta_moneda_base,
    acumulado_moneda_base
INTO
	@lo_vend_id_sucursal,
    @lo_vend_id_vendedor,
    @lo_vend_monto_moneda_base,
    @lo_vend_egresos_moneda_base,
    @lo_vend_venta_neta_moneda_base,
    @lo_vend_acumulado_moneda_base
    */
FROM ic_rep_tr_acumulado_vendedor
WHERE id_grupo_empresa = 17
AND id_vendedor = 0
AND id_sucursal = 0
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

/* -------------------------------------------------------------------------------------- */

/* PROVEEDOR */
SELECT * -- ic_fac_tr_factura_detalle
	/*
    id_sucursal,
    id_proveedor,
    monto_moneda_base,
    egresos_moneda_base,
    venta_neta_moneda_base,
    acumulado_moneda_base
    */
FROM ic_rep_tr_acumulado_proveedor
WHERE id_grupo_empresa = 17
AND id_proveedor = 0
AND id_sucursal = 0
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

/* SERVICIO */
SELECT *-- ic_fac_tr_factura_detalle
/*
	id_sucursal,
    id_servicio,
	monto_moneda_base,
    egresos_moneda_base,
    venta_neta_moneda_base,
    acumulado_moneda_base
    */
FROM ic_rep_tr_acumulado_servicio
WHERE id_grupo_empresa = 17
AND id_servicio = 0
AND id_sucursal = 0
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

/* TIPO PROVEEDOR */
SELECT	*-- ic_fac_tr_factura_detalle
/*
	id_tipo_proveedor,
    id_sucursal,
    monto_moneda_base,
    egresos_moneda_base,
    venta_neta_moneda_base,
    acumulado_moneda_base
*/
FROM ic_rep_tr_acumulado_tipo_proveedor
WHERE id_grupo_empresa = 17
AND id_tipo_proveedor = 0
AND id_sucursal = 0
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

/* AEROLINEA */
SELECT * -- ic_gds_tr_vuelos
/*
	clave_linea_aerea,
	monto_moneda_base,
    egresos_moneda_base,
    venta_neta_moneda_base,
    acumulado_moneda_base
*/
FROM ic_rep_tr_acumulado_aerolinea
WHERE id_grupo_empresa = 17
AND clave_linea_aerea = ''
AND id_sucursal = 0
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

/* UNIDAD DE NEGOCIO */
SELECT * --  ic_fac_tr_factura
    /*
    id_grupo_empresa,
    id_sucursal,
    cve_unidad_negocio,
    desc_unidad_negocio,
    monto_moneda_base,
    egresos_moneda_base,
    venta_neta_moneda_base,
    acumulado_moneda_base
    */
FROM ic_rep_tr_acumulado_unidad_negocio
WHERE id_grupo_empresa = 17
AND id_sucursal = 0
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

/* -------------------------------------------------------------------------------------- */
SELECT *
FROM ic_fac_tr_factura;

SELECT *
FROM ic_fac_tr_factura_detalle;

SELECT
	id_proveedor,
    id_servicio,
    IFNULL(((tarifa_moneda_base) + (importe_markup) - (descuento)),0)
INTO
	lo_id_proveedor,
    lo_id_servicio,
    lo_total
FROM ic_fac_tr_factura_detalle
WHERE id_factura = 5450;

-- CLIENTE
UPDATE ic_rep_tr_acumulado_cliente
SET monto_moneda_base = (monto_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
monto_usd = (monto_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
monto_eur = (monto_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
venta_neta_moneda_base = (venta_neta_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
venta_neta_usd =(venta_neta_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
venta_neta_eur =(venta_neta_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
acumulado_moneda_base =(acumulado_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
acumulado_usd =(acumulado_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
acumulado_eur =(acumulado_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0))
WHERE id_grupo_empresa = @lo_id_grupo_empresa
AND id_cliente = @lo_id_cliente
AND id_sucursal = @lo_id_sucursal
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

-- SUCURSAL
UPDATE ic_rep_tr_acumulado_sucursal
SET monto_tarifa_base = (monto_tarifa_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
monto_usd = (monto_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
monto_eur = (monto_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
venta_neta_moneda_base = (venta_neta_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
venta_neta_usd =(venta_neta_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
venta_neta_eur =(venta_neta_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
acumulado_moneda_base =(acumulado_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
acumulado_usd =(acumulado_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
acumulado_eur =(acumulado_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0))
WHERE id_grupo_empresa = @lo_id_grupo_empresa
AND id_sucursal = @lo_id_sucursal
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

-- VENDEDOR
UPDATE ic_rep_tr_acumulado_vendedor
SET monto_moneda_base = (monto_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
monto_usd = (monto_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
monto_eur = (monto_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
venta_neta_moneda_base = (venta_neta_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
venta_neta_usd =(venta_neta_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
venta_neta_eur =(venta_neta_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
acumulado_moneda_base =(acumulado_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
acumulado_usd =(acumulado_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
acumulado_eur =(acumulado_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0))
WHERE id_grupo_empresa = @lo_id_grupo_empresa
AND id_vendedor = @lo_id_vendedor_tit
AND id_sucursal = @lo_id_sucursal
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

-- PROVEEDOR
UPDATE ic_rep_tr_acumulado_proveedor
SET monto_moneda_base = (monto_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
monto_usd = (monto_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
monto_eur = (monto_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
venta_neta_moneda_base = (venta_neta_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
venta_neta_usd =(venta_neta_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
venta_neta_eur =(venta_neta_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
acumulado_moneda_base =(acumulado_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
acumulado_usd =(acumulado_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
acumulado_eur =(acumulado_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0))
WHERE id_grupo_empresa = @lo_id_grupo_empresa
AND id_proveedor = NEW.id_proveedor
AND id_sucursal = @lo_id_sucursal
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');  

-- SERVICIO
UPDATE ic_rep_tr_acumulado_servicio
SET monto_moneda_base = (monto_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
monto_usd = (monto_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
monto_eur = (monto_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
venta_neta_moneda_base = (venta_neta_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
venta_neta_usd =(venta_neta_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
venta_neta_eur =(venta_neta_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
acumulado_moneda_base =(acumulado_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
acumulado_usd =(acumulado_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
acumulado_eur =(acumulado_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0))
WHERE id_grupo_empresa = @lo_id_grupo_empresa
AND id_servicio = NEW.id_servicio
AND id_sucursal = @lo_id_sucursal
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

-- TIPO PROVEEDOR
UPDATE ic_rep_tr_acumulado_tipo_proveedor
SET monto_moneda_base = (monto_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
monto_usd = (monto_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
monto_eur = (monto_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
venta_neta_moneda_base = (venta_neta_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
venta_neta_usd = (venta_neta_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
venta_neta_eur = (venta_neta_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
acumulado_moneda_base = (acumulado_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
acumulado_usd = (acumulado_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
acumulado_eur = (acumulado_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0))
WHERE id_grupo_empresa = @lo_id_grupo_empresa
AND id_tipo_proveedor = @lo_id_tipo_proveedor
AND id_sucursal = @lo_id_sucursal
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');

-- AEROLINEA
IF @lo_clave_linea_aerea IS NOT NULL OR @lo_clave_linea_aerea != '' THEN
	UPDATE ic_rep_tr_acumulado_aerolinea
	SET monto_moneda_base = (monto_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
	monto_usd = (monto_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
	monto_eur = (monto_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
	venta_neta_moneda_base = (venta_neta_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
	venta_neta_usd = (venta_neta_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
	venta_neta_eur = (venta_neta_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
	acumulado_moneda_base = (acumulado_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
	acumulado_usd = (acumulado_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
	acumulado_eur = (acumulado_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0))
	WHERE id_grupo_empresa = @lo_id_grupo_empresa
	AND clave_linea_aerea = @lo_clave_linea_aerea
	AND id_sucursal = @lo_id_sucursal
	AND fecha = DATE_FORMAT(NOW(), '%Y-%m');
END IF;

-- UNIDAD DE NEGOCIO
UPDATE ic_rep_tr_acumulado_unidad_negocio
SET monto_moneda_base = (monto_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
monto_usd = (monto_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
monto_eur = (monto_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
venta_neta_moneda_base = (venta_neta_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
venta_neta_usd = (venta_neta_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
venta_neta_eur = (venta_neta_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0)),
acumulado_moneda_base = (acumulado_moneda_base - IFNULL(((NEW.tarifa_moneda_base) + (NEW.importe_markup) - (NEW.descuento)),0)),
acumulado_usd = (acumulado_usd - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_usd) + (NEW.importe_markup/@lo_tipo_cambio_usd) - (NEW.descuento/@lo_tipo_cambio_usd)),0)),
acumulado_eur = (acumulado_eur - IFNULL(((NEW.tarifa_moneda_base/@lo_tipo_cambio_eur) + (NEW.importe_markup/@lo_tipo_cambio_eur) - (NEW.descuento/@lo_tipo_cambio_eur)),0))
WHERE id_grupo_empresa = @lo_id_grupo_empresa
AND cve_unidad_negocio = @lo_cve_unidad_negocio
AND id_sucursal = @lo_id_sucursal
AND fecha = DATE_FORMAT(NOW(), '%Y-%m');    