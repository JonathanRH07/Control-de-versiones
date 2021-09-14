SELECT
	sum(data_length + index_length)/1024/1024/1024 "size in GB" 
FROM information_schema.TABLES 
WHERE table_schema = 'suite_mig_demo'
AND TABLE_NAME LIKE 'ic_%';

SELECT
	tabla
FROM consulta_espacio
WHERE tipo_tabla = 1;

SELECT
	CONCAT(tabla, ' WHERE id_grupo_empresa = 7;')
FROM consulta_espacio;

SELECT
	REPLACE(tabla,'a.*','COUNT(*)')
FROM consulta_espacio;

UPDATE consulta_espacio
SET tabla = REPLACE(tabla,'COUNT(COUNT(*)) ','COUNT(*)')
WHERE tipo_tabla != 1;

SELECT
	espacio_almacenamiento
FROM suite_mig_conf.st_adm_tc_tipo_paquete;

/*
DELETE FROM consulta_espacio 
WHERE tipo_tabla = 1;

INSERT INTO consulta_espacio (tipo_tabla, tabla)
VALUES
(1,'SELECT COUNT(*) FROM ic_cat_tc_cuenta_contable a '),
(1,'SELECT COUNT(*) FROM ic_cat_tc_formato a '),
(1,'SELECT COUNT(*) FROM ic_cat_tc_servicio a '),
(1,'SELECT COUNT(*) FROM ic_cat_tc_unidad_medida a '),
(1,'SELECT COUNT(*) FROM ic_cat_tc_unidad_negocio a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_cliente a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_cliente_banco a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_config_banco a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_corporativo a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_meta_venta a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_origen_venta a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_plan_comision a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_proveedor a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_proveedor_conf a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_serie a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_sucursal a '),
(1,'SELECT COUNT(*) FROM ic_cat_tr_vendedor a '),
(1,'SELECT COUNT(*) FROM ic_fac_tc_grupo_fit a '),
(1,'SELECT COUNT(*) FROM ic_fac_tr_anticipos a '),
(1,'SELECT COUNT(*) FROM ic_fac_tr_compras_x_servicio a '),
(1,'SELECT COUNT(*) FROM ic_fac_tr_debito a '),
(1,'SELECT COUNT(*) FROM ic_fac_tr_factura a '),
(1,'SELECT COUNT(*) FROM ic_fac_tr_folios a '),
(1,'SELECT COUNT(*) FROM ic_fac_tr_folios_historico a '),
(1,'SELECT COUNT(*) FROM ic_fac_tr_folios_historico_uso_mensual a '),
(1,'SELECT COUNT(*) FROM ic_fac_tr_pagos a '),
(1,'SELECT COUNT(*) FROM ic_gds_tc_corporativa a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_arrendadoras a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_bpc a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_cadenas a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_cxs a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_cxs_automaticos a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_configuracion a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_forma_pago_emp a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_general a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_impuestos a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_justificacion_tarifas a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_mailing_list a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_remarks_cliente a '),
(1,'SELECT COUNT(*) FROM ic_gds_tr_remarks_grupo_emp a '),
(1,'SELECT COUNT(*) FROM ic_glob_tr_boleto a '),
(1,'SELECT COUNT(*) FROM ic_glob_tr_cxc a '),
(1,'SELECT COUNT(*) FROM ic_glob_tr_forma_pago a '),
(1,'SELECT COUNT(*) FROM ic_glob_tr_info_sys a '),
(1,'SELECT COUNT(*) FROM ic_glob_tr_inventario_boletos a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_aerolinea a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_cliente a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_origen_venta a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_pagos a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_pagos_detalle a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_proveedor a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_servicio a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_sucursal a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_tipo_proveedor a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_unidad_negocio a '),
(1,'SELECT COUNT(*) FROM ic_rep_tr_acumulado_vendedor a ')
;
--  TIPO 1 - SIMPLE
SELECT * FROM ic_cat_tc_cuenta_contable;
SELECT * FROM ic_cat_tc_formato;
SELECT * FROM ic_cat_tc_servicio;
SELECT * FROM ic_cat_tc_unidad_medida;
SELECT * FROM ic_cat_tc_unidad_negocio;
SELECT * FROM ic_cat_tr_cliente;
SELECT * FROM ic_cat_tr_cliente_banco;
SELECT * FROM ic_cat_tr_config_banco;
SELECT * FROM ic_cat_tr_corporativo;
SELECT * FROM ic_cat_tr_meta_venta;
SELECT * FROM ic_cat_tr_origen_venta;
SELECT * FROM ic_cat_tr_plan_comision;
SELECT * FROM ic_cat_tr_proveedor;
SELECT * FROM ic_cat_tr_proveedor_conf;
SELECT * FROM ic_cat_tr_serie;
SELECT * FROM ic_cat_tr_sucursal;
SELECT * FROM ic_cat_tr_vendedor;
SELECT * FROM ic_fac_tc_grupo_fit;
SELECT * FROM ic_fac_tr_anticipos;
SELECT * FROM ic_fac_tr_compras_x_servicio;
SELECT * FROM ic_fac_tr_debito;
SELECT * FROM ic_fac_tr_factura;
SELECT * FROM ic_fac_tr_folios;
SELECT * FROM ic_fac_tr_folios_historico;
SELECT * FROM ic_fac_tr_folios_historico_uso_mensual;
SELECT * FROM ic_fac_tr_pagos;
SELECT * FROM ic_gds_tc_corporativa;
SELECT * FROM ic_gds_tr_arrendadoras;
SELECT * FROM ic_gds_tr_bpc;
SELECT * FROM ic_gds_tr_cadenas;
SELECT * FROM ic_gds_tr_cxs;
SELECT * FROM ic_gds_tr_cxs_automaticos;
SELECT * FROM ic_gds_tr_configuracion;
SELECT * FROM ic_gds_tr_forma_pago_emp;
SELECT * FROM ic_gds_tr_general;
SELECT * FROM ic_gds_tr_impuestos;
SELECT * FROM ic_gds_tr_justificacion_tarifas;
SELECT * FROM ic_gds_tr_mailing_list;
SELECT * FROM ic_gds_tr_remarks_cliente;
SELECT * FROM ic_gds_tr_remarks_grupo_emp;
SELECT * FROM ic_glob_tr_boleto;
SELECT * FROM ic_glob_tr_cxc;
SELECT * FROM ic_glob_tr_forma_pago;
SELECT * FROM ic_glob_tr_info_sys;
SELECT * FROM ic_glob_tr_inventario_boletos;
SELECT * FROM ic_rep_tr_acumulado_aerolinea;
SELECT * FROM ic_rep_tr_acumulado_cliente;
SELECT * FROM ic_rep_tr_acumulado_origen_venta;
SELECT * FROM ic_rep_tr_acumulado_pagos;
SELECT * FROM ic_rep_tr_acumulado_pagos_detalle;
SELECT * FROM ic_rep_tr_acumulado_proveedor;
SELECT * FROM ic_rep_tr_acumulado_servicio;
SELECT * FROM ic_rep_tr_acumulado_sucursal;
SELECT * FROM ic_rep_tr_acumulado_tipo_proveedor;
SELECT * FROM ic_rep_tr_acumulado_unidad_negocio;
SELECT * FROM ic_rep_tr_acumulado_vendedor;

-- TIPO 2 - UN JOIN 
SELECT a.* FROM ic_glob_tr_cxc_detalle a JOIN ic_glob_tr_cxc b ON a.id_cxc = b.id_cxc; 
SELECT a.* FROM ic_fac_tr_pagos_cfdi a JOIN ic_fac_tr_pagos b ON a.id_pago = b.id_pago;
SELECT a.* FROM ic_fac_tr_pagos_detalle a JOIN ic_fac_tr_pagos b ON a.id_pago = b.id_pago;
SELECT a.* FROM ic_fac_tr_addenda a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_fac_tr_factura_cfdi a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura;
SELECT a.* FROM ic_cat_tr_centro_costo a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_gds_tr_cxs_xcliente a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_fac_tr_revision_pago a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_fac_documento_servicio a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura;
SELECT a.* FROM ic_fac_tr_vendedor_aux a JOIN ic_cat_tr_vendedor b ON a.id_vendedor = b.id_vendedor;
SELECT a.* FROM ic_fac_tr_factura_detalle a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura;
SELECT a.* FROM ic_fac_tr_addenda_cliente a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_gds_tr_errores a JOIN ic_gds_tr_general b ON a.id_gds_general = b.id_gds_generall;
SELECT a.* FROM ic_fac_tr_factura_analisis a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura;
SELECT a.* FROM ic_gds_tr_cliente_contable a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_cat_tr_cliente_contacto a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_gds_tr_analisis a JOIN ic_gds_tr_general b ON a.id_gds_general = b.id_gds_generall;
SELECT a.* FROM ic_cat_tr_cliente_descuento a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_cat_tr_cliente_envio_fac a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_cat_tr_cliente_adicional a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_fac_tr_factura_forma_pago a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura;
SELECT a.* FROM ic_cat_tr_centro_costo_nivel a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_gds_tr_provee_contable a JOIN ic_cat_tr_sucursal b ON a.id_sucursal = b.id_sucursal;
SELECT a.* FROM ic_fac_tr_prove_servicio a JOIN ic_cat_tr_proveedor b ON a.id_proveedor = b.id_proveedor;
SELECT a.* FROM ic_fac_tr_servicio_impuesto a JOIN ic_cat_tc_servicio b ON a.id_servicio = b.id_servicio;
SELECT a.* FROM ic_cat_tr_proveedor_aero a JOIN ic_cat_tr_proveedor b ON a.id_proveedor = b.id_proveedor;
SELECT a.* FROM ic_cat_tr_impuesto_contable a JOIN ic_cat_tr_sucursal b ON a.id_sucursal = b.id_sucursal;
SELECT a.* FROM ic_cat_tr_cliente_revision_pago a JOIN ic_cat_tr_cliente b ON a.id_cliente = b.id_cliente;
SELECT a.* FROM ic_fac_tr_prove_cta_egreso a JOIN ic_cat_tr_proveedor b ON a.id_proveedor = b.id_proveedor;
SELECT a.* FROM ic_fac_tr_factura_ine_complemento a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura;
SELECT a.* FROM ic_cat_tr_proveedor_contacto a JOIN ic_cat_tr_proveedor b ON a.id_proveedor = b.id_proveedor;
SELECT a.* FROM ic_fac_tr_prove_cta_bancaria a JOIN ic_cat_tr_proveedor b ON a.id_proveedor = b.id_proveedor;
SELECT a.* FROM ic_cat_tr_meta_venta_tipo a JOIN ic_cat_tr_meta_venta b ON a.id_meta_venta = b.id_meta_venta;
SELECT a.* FROM ic_fac_tr_factura_cfdi_relacionados a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura;
SELECT a.* FROM ic_fac_tr_anticipos_aplicacion a JOIN ic_fac_tr_anticipos b ON a.id_anticipos = b.id_anticipos;
SELECT a.* FROM ic_glob_tr_forma_pago_detalle a JOIN suite_mig_conf.st_adm_tr_usuario b ON a.id_usuario = b.id_usuario;
SELECT a.* FROM ic_cat_tr_plan_comision_fac a JOIN ic_cat_tr_plan_comision b ON a.id_plan_comision = b.id_plan_comision;
SELECT a.* FROM ic_cat_tr_plan_comision_meta a JOIN ic_cat_tr_plan_comision b ON a.id_plan_comision = b.id_plan_comision;


-- TIPO 3 - DE 2 A 3 JOIN's
SELECT a.* FROM ic_gds_tr_cupon a JOIN ic_fac_tr_factura_detalle b ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura;
SELECT a.* FROM ic_gds_tr_autos a JOIN ic_fac_tr_factura_detalle b ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura;
SELECT a.* FROM ic_gds_tr_vuelos a JOIN ic_fac_tr_factura_detalle b ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura;
SELECT a.* FROM ic_gds_tr_hoteles a JOIN ic_fac_tr_factura_detalle b ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura;
SELECT a.* FROM ic_fac_tr_prove_imp_serv a JOIN ic_fac_tr_prove_servicio b ON a.id_prove_servicio = b.id_prove_servicio JOIN ic_cat_tr_proveedor c ON b.id_proveedor = c.id_proveedor;
SELECT a.* FROM ic_fac_tr_factura_detalle_imp a JOIN ic_fac_tr_factura_detalle b ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura;
SELECT a.* FROM ic_fac_tr_prove_cta_ingreso a JOIN ic_fac_tr_prove_servicio b ON a.id_prove_servicio = b.id_prove_servicio JOIN ic_cat_tr_proveedor c ON b.id_proveedor = c.id_proveedor;
SELECT a.* FROM ic_cat_tr_meta_venta_meses a JOIN ic_cat_tr_meta_venta_tipo b ON a.id_meta_venta_tipo = b.id_meta_venta_tipo JOIN ic_cat_tr_meta_venta c ON b.id_meta_venta = c.id_meta_venta;
SELECT a.* FROM ic_gds_tr_vuelos_citypair a JOIN ic_gds_tr_vuelos b ON a.id_gds_vuelos = b.id_gds_vuelos JOIN ic_fac_tr_factura_detalle c ON b.id_factura_detalle = c.id_factura_detalle JOIN ic_fac_tr_factura d ON c.id_factura = d.id_factura;
SELECT a.* FROM ic_gds_tr_vuelos_segmento a JOIN ic_gds_tr_vuelos b ON a.id_gds_vuelos = b.id_gds_vuelos JOIN ic_fac_tr_factura_detalle c ON b.id_factura_detalle = c.id_factura_detalle JOIN ic_fac_tr_factura d ON c.id_factura = d.id_factura;
*/

/* ------------------------------------------------------------------------- */

SELECT
    table_schema "database",
    TABLE_NAME,
	sum(data_length + index_length)/1024/1024/1024 "size in GB" 
FROM information_schema.TABLES 
WHERE table_schema = 'suite_mig_demo'
AND TABLE_NAME LIKE 'ic_%'
GROUP BY TABLE_NAME;

SELECT
    TABLE_NAME
FROM information_schema.TABLES 
WHERE table_schema = 'suite_mig_demo'
AND TABLE_NAME LIKE 'ic_%'
GROUP BY TABLE_NAME;

SHOW FULL TABLES FROM suite_mig_demo
WHERE Table_type = 'BASE TABLE'
AND Tables_in_suite_mig_demo LIKE 'ic_%';

/*
SELECT * FROM ic_cat_tc_cuenta_contable WHERE id_grupo_empresa = 7; -- 2
SELECT * FROM ic_cat_tc_formato WHERE id_grupo_empresa = 7; -- 0
-- SELECT * FROM ic_cat_tc_gds WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tc_impuesto_categoria WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tc_ine_ambito WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tc_ine_ent_fed WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tc_ine_tipo_comite WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tc_ine_tipo_proceso WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tc_producto WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tc_servicio WHERE id_grupo_empresa = 7; -- 53
-- SELECT * FROM ic_cat_tc_tipo_meta WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tc_tipo_meta_trans WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tc_tipo_proveedor WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tc_tipo_serie WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tc_unidad_medida WHERE id_grupo_empresa = 7; -- 3
SELECT * FROM ic_cat_tc_unidad_negocio WHERE id_grupo_empresa = 7; -- 11
-- SELECT * FROM ic_cat_tr_centro_costo WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tr_centro_costo_nivel WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tr_cliente WHERE id_grupo_empresa = 7; -- 4935
-- SELECT * FROM ic_cat_tr_cliente_adicional WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tr_cliente_banco WHERE id_grupo_empresa = 7; -- 102
-- SELECT * FROM ic_cat_tr_cliente_contacto WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tr_cliente_descuento WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tr_cliente_envio_fac WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tr_cliente_revision_pago WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tr_config_banco WHERE id_grupo_empresa = 7; -- 0
SELECT * FROM ic_cat_tr_corporativo WHERE id_grupo_empresa = 7; -- 6
-- SELECT * FROM ic_cat_tr_departamento WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tr_impuesto WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tr_impuesto_contable WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tr_impuesto_provee_unidad WHERE id_grupo_empresa = 7; -- 3
SELECT * FROM ic_cat_tr_meta_venta WHERE id_grupo_empresa = 7; -- 0
-- SELECT * FROM ic_cat_tr_meta_venta_meses WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tr_meta_venta_tipo WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tr_origen_venta WHERE id_grupo_empresa = 7; -- 7
SELECT * FROM ic_cat_tr_plan_comision WHERE id_grupo_empresa = 7; -- 5
-- SELECT * FROM ic_cat_tr_plan_comision_fac WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_cat_tr_plan_comision_meta WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tr_proveedor WHERE id_grupo_empresa = 7; -- 887
-- SELECT * FROM ic_cat_tr_proveedor_aero WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tr_proveedor_conf WHERE id_grupo_empresa = 7; -- 56
-- SELECT * FROM ic_cat_tr_proveedor_contacto WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tr_serie WHERE id_grupo_empresa = 7; -- 12
SELECT * FROM ic_cat_tr_sucursal WHERE id_grupo_empresa = 7; -- 3
-- SELECT * FROM ic_cat_tr_tipo_doc WHERE id_grupo_empresa = 7; 
-- SELECT * FROM ic_cat_tr_unidad_sucursal WHERE id_grupo_empresa = 7;
SELECT * FROM ic_cat_tr_vendedor WHERE id_grupo_empresa = 7; -- 85
-- SELECT * FROM ic_fac_documento_servicio WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_fac_tc_estatus_boleto WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_fac_tc_etiqueta_addenda WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_fac_tc_factura_estatus_cancelacion WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tc_grupo_fit WHERE id_grupo_empresa = 7; -- 4
-- SELECT * FROM ic_fac_tc_razon_cancelacion WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_fac_tc_tipo_consulta_boleto WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_fac_tr_addenda WHERE id_grupo_empresa = 7;
-- SELECT * FROM ic_fac_tr_addenda_cliente WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_anticipos WHERE id_grupo_empresa = 7; -- 44
-- SELECT * FROM ic_fac_tr_anticipos_aplicacion WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_compras_x_servicio WHERE id_grupo_empresa = 7; -- 150
SELECT * FROM ic_fac_tr_debito WHERE id_grupo_empresa = 7; -- 8
SELECT * FROM ic_fac_tr_factura WHERE id_grupo_empresa = 7; -- 1794
SELECT * FROM ic_fac_tr_factura_analisis WHERE id_factura IN (SELECT id_factura FROM ic_fac_tr_factura WHERE id_grupo_empresa = 7); - 
SELECT * FROM ic_fac_tr_factura_cfdi WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_factura_cfdi_relacionados WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_factura_detalle WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_factura_detalle_imp WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_factura_forma_pago WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_factura_ine_complemento WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_folios WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_folios_historico WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_folios_historico_uso_mensual WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_imp_ser_prov WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_pagos WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_pagos_cfdi WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_pagos_detalle WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_prove_cta_bancaria WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_prove_cta_egreso WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_prove_cta_ingreso WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_prove_imp_serv WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_prove_servicio WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_razon_cancelacion_factura WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_razon_cancelacion_factura_trans WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_revision_pago WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_servicio_impuesto WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_vendedor_aux WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_xml_cancelacion WHERE id_grupo_empresa = 7;
SELECT * FROM ic_fac_tr_xml_error WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tc_corporativa WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tc_forma_pago WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_analisis WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_arrendadoras WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_autos WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_bpc WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_cadenas WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_cliente_contable WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_configuracion WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_cupon WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_cxs WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_cxs_automaticos WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_cxs_xcliente WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_errores WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_forma_pago WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_forma_pago_emp WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_general WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_hoteles WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_impuestos WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_justificacion_tarifas WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_mailing_list WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_provee_contable WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_remarks WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_remarks_cliente WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_remarks_grupo_emp WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_vuelos WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_vuelos_citypair WHERE id_grupo_empresa = 7;
SELECT * FROM ic_gds_tr_vuelos_segmento WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tc_catalogo WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tc_cxc_monedas WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tc_tipo_cambio WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tc_tipo_ope_sat WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tc_tipo_tercero_sat WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tr_addenda_default WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tr_boleto WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tr_ctrl_cambios WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tr_cxc WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tr_cxc_detalle WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tr_forma_pago WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tr_forma_pago_detalle WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tr_info_sys WHERE id_grupo_empresa = 7;
SELECT * FROM ic_glob_tr_inventario_boletos WHERE id_grupo_empresa = 7;
SELECT * FROM ic_rep_tr_acumulado_aerolinea WHERE id_grupo_empresa = 7;
SELECT * FROM ic_rep_tr_acumulado_cliente WHERE id_grupo_empresa = 7;
SELECT * FROM ic_rep_tr_acumulado_pagos WHERE id_grupo_empresa = 7;
SELECT * FROM ic_rep_tr_acumulado_pagos_detalle WHERE id_grupo_empresa = 7;
SELECT * FROM ic_rep_tr_acumulado_proveedor WHERE id_grupo_empresa = 7;
SELECT * FROM ic_rep_tr_acumulado_servicio WHERE id_grupo_empresa = 7;
SELECT * FROM ic_rep_tr_acumulado_sucursal WHERE id_grupo_empresa = 7;
SELECT * FROM ic_rep_tr_acumulado_tipo_proveedor WHERE id_grupo_empresa = 7;
SELECT * FROM ic_rep_tr_acumulado_vendedor WHERE id_grupo_empresa = 7;
*/

/*
SELECT COUNT(*) FROM ic_cat_tc_cuenta_contable WHERE id_grupo_empresa = 7; -- 2
SELECT COUNT(*) FROM ic_cat_tc_formato WHERE id_grupo_empresa = 7; -- 0
-- SELECT COUNT(*) FROM ic_cat_tc_gds WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_impuesto_categoria WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_ine_ambito WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_ine_ent_fed WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_ine_tipo_comite WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_ine_tipo_proceso WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_producto WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tc_servicio WHERE id_grupo_empresa = 7; -- 53
-- SELECT COUNT(*) FROM ic_cat_tc_tipo_meta WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_tipo_meta_trans WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_tipo_proveedor WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_tipo_serie WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tc_unidad_medida WHERE id_grupo_empresa = 7; -- 3
SELECT COUNT(*) FROM ic_cat_tc_unidad_negocio WHERE id_grupo_empresa = 7; -- 11
-- SELECT COUNT(*) FROM ic_cat_tr_centro_costo WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_centro_costo_nivel WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_cliente WHERE id_grupo_empresa = 7; -- 4935
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_adicional WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_cliente_banco WHERE id_grupo_empresa = 7; -- 102
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_contacto WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_descuento WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_envio_fac WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_revision_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_config_banco WHERE id_grupo_empresa = 7; -- 0
SELECT COUNT(*) FROM ic_cat_tr_corporativo WHERE id_grupo_empresa = 7; -- 6
-- SELECT COUNT(*) FROM ic_cat_tr_departamento WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_impuesto WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_impuesto_contable WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_impuesto_provee_unidad WHERE id_grupo_empresa = 7; -- 3
SELECT COUNT(*) FROM ic_cat_tr_meta_venta WHERE id_grupo_empresa = 7; -- 0
-- SELECT COUNT(*) FROM ic_cat_tr_meta_venta_meses WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_meta_venta_tipo WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_origen_venta WHERE id_grupo_empresa = 7; -- 7
SELECT COUNT(*) FROM ic_cat_tr_plan_comision WHERE id_grupo_empresa = 7; -- 5
-- SELECT COUNT(*) FROM ic_cat_tr_plan_comision_fac WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_plan_comision_meta WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_proveedor WHERE id_grupo_empresa = 7; -- 887
-- SELECT COUNT(*) FROM ic_cat_tr_proveedor_aero WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_proveedor_conf WHERE id_grupo_empresa = 7; -- 56
-- SELECT COUNT(*) FROM ic_cat_tr_proveedor_contacto WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_serie WHERE id_grupo_empresa = 7; -- 12
SELECT COUNT(*) FROM ic_cat_tr_sucursal WHERE id_grupo_empresa = 7; -- 3
-- SELECT COUNT(*) FROM ic_cat_tr_tipo_doc WHERE id_grupo_empresa = 7; 
-- SELECT COUNT(*) FROM ic_cat_tr_unidad_sucursal WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_vendedor WHERE id_grupo_empresa = 7; -- 85
-- SELECT COUNT(*) FROM ic_fac_documento_servicio WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tc_estatus_boleto WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tc_etiqueta_addenda WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tc_factura_estatus_cancelacion WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tc_grupo_fit WHERE id_grupo_empresa = 7; -- 4
-- SELECT COUNT(*) FROM ic_fac_tc_razon_cancelacion WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tc_tipo_consulta_boleto WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tr_addenda WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tr_addenda_cliente WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_anticipos WHERE id_grupo_empresa = 7; -- 44
-- SELECT COUNT(*) FROM ic_fac_tr_anticipos_aplicacion WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_compras_x_servicio WHERE id_grupo_empresa = 7; -- 150
SELECT COUNT(*) FROM ic_fac_tr_debito WHERE id_grupo_empresa = 7; -- 8
SELECT COUNT(*) FROM ic_fac_tr_factura WHERE id_grupo_empresa = 7; -- 1794
SELECT COUNT(*) FROM ic_fac_tr_factura_analisis WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_cfdi WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_cfdi_relacionados WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_detalle_imp WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_forma_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_ine_complemento WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_folios WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_folios_historico WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_folios_historico_uso_mensual WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_imp_ser_prov WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_pagos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_pagos_cfdi WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_pagos_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_cta_bancaria WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_cta_egreso WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_cta_ingreso WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_imp_serv WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_servicio WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_razon_cancelacion_factura WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_razon_cancelacion_factura_trans WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_revision_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_servicio_impuesto WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_vendedor_aux WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_xml_cancelacion WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_xml_error WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tc_corporativa WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tc_forma_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_analisis WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_arrendadoras WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_autos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_bpc WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cadenas WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cliente_contable WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_configuracion WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cupon WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cxs WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cxs_automaticos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cxs_xcliente WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_errores WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_forma_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_forma_pago_emp WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_general WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_hoteles WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_impuestos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_justificacion_tarifas WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_mailing_list WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_provee_contable WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_remarks WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_remarks_cliente WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_remarks_grupo_emp WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_vuelos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_vuelos_citypair WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_vuelos_segmento WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_catalogo WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_cxc_monedas WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_tipo_cambio WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_tipo_ope_sat WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_tipo_tercero_sat WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_addenda_default WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_boleto WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_ctrl_cambios WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_cxc WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_cxc_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_forma_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_forma_pago_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_info_sys WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_inventario_boletos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_aerolinea WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_cliente WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_pagos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_pagos_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_proveedor WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_servicio WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_sucursal WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_tipo_proveedor WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_vendedor WHERE id_grupo_empresa = 7;

*/

/*
SELECT COUNT(*) FROM ic_cat_tc_cuenta_contable WHERE id_grupo_empresa = 7; -- 2
SELECT COUNT(*) FROM ic_cat_tc_formato WHERE id_grupo_empresa = 7; -- 0
-- SELECT COUNT(*) FROM ic_cat_tc_gds WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_impuesto_categoria WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_ine_ambito WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_ine_ent_fed WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_ine_tipo_comite WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_ine_tipo_proceso WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_producto WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tc_servicio WHERE id_grupo_empresa = 7; -- 53
-- SELECT COUNT(*) FROM ic_cat_tc_tipo_meta WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_tipo_meta_trans WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_tipo_proveedor WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tc_tipo_serie WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tc_unidad_medida WHERE id_grupo_empresa = 7; -- 3
SELECT COUNT(*) FROM ic_cat_tc_unidad_negocio WHERE id_grupo_empresa = 7; -- 11
-- SELECT COUNT(*) FROM ic_cat_tr_centro_costo WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_centro_costo_nivel WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_cliente WHERE id_grupo_empresa = 7; -- 4935
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_adicional WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_cliente_banco WHERE id_grupo_empresa = 7; -- 102
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_contacto WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_descuento WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_envio_fac WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_cliente_revision_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_config_banco WHERE id_grupo_empresa = 7; -- 0
SELECT COUNT(*) FROM ic_cat_tr_corporativo WHERE id_grupo_empresa = 7; -- 6
-- SELECT COUNT(*) FROM ic_cat_tr_departamento WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_impuesto WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_impuesto_contable WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_impuesto_provee_unidad WHERE id_grupo_empresa = 7; -- 3
SELECT COUNT(*) FROM ic_cat_tr_meta_venta WHERE id_grupo_empresa = 7; -- 0
-- SELECT COUNT(*) FROM ic_cat_tr_meta_venta_meses WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_meta_venta_tipo WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_origen_venta WHERE id_grupo_empresa = 7; -- 7
SELECT COUNT(*) FROM ic_cat_tr_plan_comision WHERE id_grupo_empresa = 7; -- 5
-- SELECT COUNT(*) FROM ic_cat_tr_plan_comision_fac WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_cat_tr_plan_comision_meta WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_proveedor WHERE id_grupo_empresa = 7; -- 887
-- SELECT COUNT(*) FROM ic_cat_tr_proveedor_aero WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_proveedor_conf WHERE id_grupo_empresa = 7; -- 56
-- SELECT COUNT(*) FROM ic_cat_tr_proveedor_contacto WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_serie WHERE id_grupo_empresa = 7; -- 12
SELECT COUNT(*) FROM ic_cat_tr_sucursal WHERE id_grupo_empresa = 7; -- 3
-- SELECT COUNT(*) FROM ic_cat_tr_tipo_doc WHERE id_grupo_empresa = 7; 
-- SELECT COUNT(*) FROM ic_cat_tr_unidad_sucursal WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_cat_tr_vendedor WHERE id_grupo_empresa = 7; -- 85
-- SELECT COUNT(*) FROM ic_fac_documento_servicio WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tc_estatus_boleto WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tc_etiqueta_addenda WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tc_factura_estatus_cancelacion WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tc_grupo_fit WHERE id_grupo_empresa = 7; -- 4
-- SELECT COUNT(*) FROM ic_fac_tc_razon_cancelacion WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tc_tipo_consulta_boleto WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tr_addenda WHERE id_grupo_empresa = 7;
-- SELECT COUNT(*) FROM ic_fac_tr_addenda_cliente WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_anticipos WHERE id_grupo_empresa = 7; -- 44
-- SELECT COUNT(*) FROM ic_fac_tr_anticipos_aplicacion WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_compras_x_servicio WHERE id_grupo_empresa = 7; -- 150
SELECT COUNT(*) FROM ic_fac_tr_debito WHERE id_grupo_empresa = 7; -- 8
SELECT COUNT(*) FROM ic_fac_tr_factura WHERE id_grupo_empresa = 7; -- 1794
SELECT COUNT(*) FROM ic_fac_tr_factura_analisis WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_cfdi WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_cfdi_relacionados WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_detalle_imp WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_forma_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_factura_ine_complemento WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_folios WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_folios_historico WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_folios_historico_uso_mensual WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_imp_ser_prov WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_pagos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_pagos_cfdi WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_pagos_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_cta_bancaria WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_cta_egreso WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_cta_ingreso WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_imp_serv WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_prove_servicio WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_razon_cancelacion_factura WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_razon_cancelacion_factura_trans WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_revision_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_servicio_impuesto WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_vendedor_aux WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_xml_cancelacion WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_fac_tr_xml_error WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tc_corporativa WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tc_forma_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_analisis WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_arrendadoras WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_autos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_bpc WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cadenas WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cliente_contable WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_configuracion WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cupon WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cxs WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cxs_automaticos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_cxs_xcliente WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_errores WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_forma_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_forma_pago_emp WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_general WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_hoteles WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_impuestos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_justificacion_tarifas WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_mailing_list WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_provee_contable WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_remarks WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_remarks_cliente WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_remarks_grupo_emp WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_vuelos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_vuelos_citypair WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_gds_tr_vuelos_segmento WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_catalogo WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_cxc_monedas WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_tipo_cambio WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_tipo_ope_sat WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tc_tipo_tercero_sat WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_addenda_default WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_boleto WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_ctrl_cambios WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_cxc WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_cxc_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_forma_pago WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_forma_pago_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_info_sys WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_glob_tr_inventario_boletos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_aerolinea WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_cliente WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_pagos WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_pagos_detalle WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_proveedor WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_servicio WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_sucursal WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_tipo_proveedor WHERE id_grupo_empresa = 7;
SELECT COUNT(*) FROM ic_rep_tr_acumulado_vendedor WHERE id_grupo_empresa = 7;
*/