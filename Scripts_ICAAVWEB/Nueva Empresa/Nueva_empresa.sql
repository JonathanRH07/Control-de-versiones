SELECT *
FROM suite_mig_conf.st_adm_tr_grupo; -- 28
/*
ALTER TABLE `suite_mig_conf`.`st_adm_tr_grupo` 
AUTO_INCREMENT = 62 ;
*/

SELECT *
FROM suite_mig_conf.st_adm_tc_direccion;-- 19
/*
ALTER TABLE `suite_mig_conf`.`st_adm_tc_direccion` 
AUTO_INCREMENT = 70 ;
*/

SELECT *
FROM suite_mig_conf.st_adm_tr_empresa; -- 26
/*
ALTER TABLE `suite_mig_conf`.`st_adm_tr_empresa` 
AUTO_INCREMENT = 70 ;
*/

/*
SELECT *
FROM suite_mig_conf.st_adm_tc_base_datos;
*/

SELECT *
FROM suite_mig_conf.st_adm_tr_grupo_empresa; -- 23
/*
ALTER TABLE `suite_mig_conf`.`st_adm_tr_grupo_empresa` 
AUTO_INCREMENT = 67 ;
*/

SELECT *
FROM suite_mig_conf.st_adm_tc_role;

SELECT *
FROM suite_mig_conf.st_adm_tr_permiso_role;

SELECT
	id_permiso_empresa_sistema,
    id_grupo_empresa,
    id_sistema,
    CONVERT(UNCOMPRESS(host_empresa_sistema) USING utf8) host_empresa_sistema,
    CONVERT(UNCOMPRESS(db_empresa_sistema) USING utf8) db_empresa_sistema,
    CONVERT(UNCOMPRESS(usuario_empresa_sistema) USING utf8) usuario_empresa_sistema,
    CONVERT(UNCOMPRESS(password_empresa_sistema) USING utf8) password_empresa_sistema,
    CONVERT(UNCOMPRESS(puerto_empresa_sistema) USING utf8) puerto_empresa_sistema
FROM suite_mig_conf.st_adm_tc_permiso_empresa_sistema; -- 21

SELECT *
FROM suite_mig_conf.st_adm_tr_permiso_emp_modulo; -- |33|34|35|36|37|38|

SELECT *
FROM suite_mig_conf.st_adm_tr_config_admin; -- 49

SELECT *
FROM suite_mig_conf.st_adm_tr_config_moneda; -- 49

SELECT *
FROM suite_mig_conf.st_adm_tr_usuario
ORDER BY id_usuario DESC; -- 1495
/*
ALTER TABLE `suite_mig_conf`.`st_adm_tr_usuario` 
AUTO_INCREMENT = 1582 ;
*/

SELECT *
FROM suite_mig_conf.st_adm_tr_empresa_usuario
WHERE id_empresa = 58; -- 255

SELECT *
FROM suite_mig_conf.st_adm_tr_usuario_sucursal
WHERE id_usuario = 1577; -- |827|828|829|830|831|832|833|834|835|836|837|838|839|840|

SELECT *
FROM suite_mig_conf.st_adm_tr_estilo_empresa
WHERE id_empresa = 55;

SELECT *
FROM suite_mig_conf.st_adm_tc_zona_horaria;

SELECT *
FROM suite_mig_conf.st_adm_tr_usuario_interfase;

SELECT 
    id_grupo_empresa,
    CONVERT(UNCOMPRESS(host_bd) USING utf8) host_bd,
    CONVERT(UNCOMPRESS(usuario_bd) USING utf8) usuario_bd,
    CONVERT(UNCOMPRESS(password_bd) USING utf8) password_bd,
	CONVERT(UNCOMPRESS(base_bd) USING utf8) base_bd,
    CONVERT(UNCOMPRESS(puerto_bd) USING utf8) puerto_bd
FROM suite_mig_conf.st_adm_tc_config_carga_gds;

SELECT *
FROM ic_gds_tr_configuracion;

SELECT *
FROM suite_mig_conf.st_adm_tr_config_emails;

SELECT *
FROM ic_glob_tr_info_sys;

SELECT *
FROM ct_glob_tc_direccion;

SELECT *
FROM ic_cat_tr_sucursal
WHERE id_grupo_empresa = 67;

SELECT *
FROM ic_cat_tr_vendedor
WHERE id_grupo_empresa = 67;

SELECT *
FROM ic_cat_tc_servicio
WHERE id_grupo_empresa = 67;

SELECT *
FROM ic_cat_tr_proveedor
WHERE id_grupo_empresa = 67;

SELECT *
FROM ic_cat_tr_cliente
WHERE id_grupo_empresa = 67;

SELECT *
FROM ic_cat_tr_cliente a
JOIN ic_cat_tr_cliente_revision_pago b ON
	a.id_cliente = b.id_cliente
WHERE a.id_grupo_empresa = 15
GROUP BY a.id_cliente;

/* ---------------------------------------------------- */

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_cuenta_contable`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_formato`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_gds`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_impuesto_categoria`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_ine_ambito`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_ine_ent_fed`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_ine_tipo_comite`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_ine_tipo_proceso`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_producto`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_servicio`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_tipo_meta`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_tipo_meta_trans`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_tipo_proveedor`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_tipo_serie`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_unidad_medida`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tc_unidad_negocio`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_centro_costo`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_centro_costo_nivel`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_cliente`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_cliente_adicional`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_cliente_banco`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_cliente_contacto`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_cliente_descuento`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_cliente_envio_fac`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_cliente_revision_pago`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_config_banco`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_corporativo`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_departamento`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_impuesto`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_impuesto_contable`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_impuesto_provee_unidad`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_meta_venta`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_meta_venta_meses`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_meta_venta_tipo`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_origen_venta`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_plan_comision`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_plan_comision_fac`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_plan_comision_meta`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_proveedor`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_proveedor_aero`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_proveedor_conf`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_proveedor_contacto`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_serie`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_sucursal`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_tipo_doc`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_unidad_sucursal`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_cat_tr_vendedor`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_documento_servicio`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tc_estatus_boleto`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tc_etiqueta_addenda`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tc_factura_estatus_cancelacion`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tc_grupo_fit`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tc_razon_cancelacion`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tc_tipo_consulta_boleto`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_addenda`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_addenda_cliente`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_anticipos`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_anticipos_aplicacion`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_compras_x_servicio`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_debito`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_factura`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_factura_analisis`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_factura_cfdi`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_factura_cfdi_relacionados`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_factura_detalle`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_factura_detalle_imp`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_factura_forma_pago`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_factura_ine_complemento`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_folios`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_folios_historico`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_folios_historico_uso_mensual`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_imp_ser_prov`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_pagos`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_pagos_cfdi`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_pagos_detalle`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_prove_cta_bancaria`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_prove_cta_egreso`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_prove_cta_ingreso`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_prove_imp_serv`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_prove_servicio`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_razon_cancelacion_factura`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_razon_cancelacion_factura_trans`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_revision_pago`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_servicio_impuesto`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_vendedor_aux`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_xml_cancelacion`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_fac_tr_xml_error`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tc_corporativa`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tc_forma_pago`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_analisis`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_arrendadoras`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_autos`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_bpc`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_cadenas`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_cliente_contable`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_configuracion`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_cupon`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_cxs`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_cxs_automaticos`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_cxs_xcliente`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_errores`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_forma_pago`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_forma_pago_emp`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_general`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_hoteles`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_impuestos`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_justificacion_tarifas`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_mailing_list`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_provee_contable`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_remarks`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_remarks_cliente`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_remarks_grupo_emp`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_vuelos`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_vuelos_citypair`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_gds_tr_vuelos_segmento`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tc_catalogo`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tc_cxc_monedas`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tc_tipo_cambio`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tc_tipo_ope_sat`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tc_tipo_tercero_sat`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tr_addenda_default`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tr_boleto`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tr_ctrl_cambios`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tr_cxc`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tr_cxc_detalle`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tr_forma_pago`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tr_forma_pago_detalle`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tr_info_sys`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_glob_tr_inventario_boletos`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_rep_tr_acumulado_aerolinea`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_rep_tr_acumulado_cliente`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_rep_tr_acumulado_pagos`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_rep_tr_acumulado_pagos_detalle`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_rep_tr_acumulado_proveedor`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_rep_tr_acumulado_servicio`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_rep_tr_acumulado_sucursal`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_rep_tr_acumulado_tipo_proveedor`
;

TRUNCATE TABLE`suite_mig_vader`.`ic_rep_tr_acumulado_vendedor`
;

SET FOREIGN_KEY_CHECKS = 1;

/* *-----------------------------------* */

/* BORRAR EMPRESA */
DELETE FROM suite_mig_conf.st_adm_tr_config_cfdi WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_config_moneda WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tc_permiso_empresa_sistema WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_config_admin WHERE id_empresa = 19;
DELETE FROM suite_mig_conf.st_adm_tr_config_emails WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.ic_adm_tr_ctrl_cambios WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_conf.st_adm_tr_usuario_recuperacion WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_glob_tr_boleto WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_factura_detalle WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_tr_factura_cfdi WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_tr_factura_detalle_imp WHERE id_factura_detalle IN (5180,5181,5182,5183,5184,5185,5186,5187,5188,5189,5190);
DELETE FROM suite_mig_demo.ic_glob_tr_cxc_detalle WHERE id_cxc IN (971066,971067,971068,971069,971070,971071,971072,971073);
DELETE FROM suite_mig_demo.ic_fac_tr_factura_cfdi_relacionados WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_glob_tr_cxc WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_factura_forma_pago WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_documento_servicio WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_tr_debito WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_tr_factura WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_pagos_cfdi WHERE id_pago = 3809;
DELETE FROM suite_mig_demo.ic_fac_tr_pagos_detalle WHERE id_pago = 3809;
DELETE FROM suite_mig_demo.ic_fac_tr_pagos WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_cliente WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_plan_comision_fac WHERE id_plan_comision = 77;
DELETE FROM suite_mig_demo.ic_cat_tr_plan_comision_meta WHERE id_plan_comision = 77;
DELETE FROM suite_mig_demo.ic_cat_tr_plan_comision WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_corporativo WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_glob_tr_ctrl_cambios WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_glob_tr_forma_pago WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tc_grupo_fit WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_gds_tr_hoteles WHERE id_factura_detalle IN (5180,5181,5182,5183,5184,5185,5186,5187,5188,5189,5190);
DELETE FROM suite_mig_demo.ic_glob_tr_inventario_boletos WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_origen_venta WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_prove_servicio WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_cat_tr_proveedor_aero WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_cat_tr_proveedor_conf WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_proveedor WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_serie WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tc_servicio WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_gds_tr_autos WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_cat_tc_unidad_medida WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tc_unidad_negocio WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_vendedor WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_gds_tr_vuelos WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_conf.st_adm_tr_usuario WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tc_config_carga_gds WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_folios WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_folios_historico WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_folios_historico_uso_mensual WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_sucursal WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_grupo_empresa WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_grupo WHERE id_grupo = 10;
DELETE FROM suite_mig_conf.st_adm_tr_estilo_empresa WHERE id_empresa = 19;
DELETE FROM suite_mig_conf.st_adm_tr_permiso_emp_modulo WHERE id_empresa = 19;
DELETE FROM suite_mig_conf.st_adm_tr_empresa WHERE id_empresa = 19;
DELETE FROM suite_mig_conf.st_adm_tc_direccion WHERE id_direccion = 12;
DELETE FROM suite_mig_conf.st_adm_tc_role WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_alertas WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_alertas_usuarios WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_conf.st_adm_tr_config_banco WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_empresa_usuario WHERE id_empresa = 19;
DELETE FROM suite_mig_conf.st_adm_tr_usuario_acceso WHERE id_empresa = 19;
DELETE FROM suite_mig_conf.st_adm_tr_usuario_interfase WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_usuario_sucursal WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
/* ------------------------ */

/* BORRAR DATOS DE LA EMPRESA  */
DELETE FROM suite_mig_conf.st_adm_tr_config_cfdi WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_config_moneda WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tc_permiso_empresa_sistema WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_config_admin WHERE id_empresa = 19;
DELETE FROM suite_mig_conf.st_adm_tr_config_emails WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.ic_adm_tr_ctrl_cambios WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_conf.st_adm_tr_usuario_recuperacion WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_glob_tr_boleto WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_factura_detalle WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_tr_factura_cfdi WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_tr_factura_detalle_imp WHERE id_factura_detalle IN (5180,5181,5182,5183,5184,5185,5186,5187,5188,5189,5190);
DELETE FROM suite_mig_demo.ic_glob_tr_cxc_detalle WHERE id_cxc IN (971066,971067,971068,971069,971070,971071,971072,971073);
DELETE FROM suite_mig_demo.ic_fac_tr_factura_cfdi_relacionados WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_glob_tr_cxc WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_factura_forma_pago WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_documento_servicio WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_tr_debito WHERE id_factura IN (5377,5378,5379,5386,5387,5388,5389,5390,5391,5392,5393);
DELETE FROM suite_mig_demo.ic_fac_tr_factura WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_pagos_cfdi WHERE id_pago = 3809;
DELETE FROM suite_mig_demo.ic_fac_tr_pagos_detalle WHERE id_pago = 3809;
DELETE FROM suite_mig_demo.ic_fac_tr_pagos WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_cliente WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_plan_comision_fac WHERE id_plan_comision = 77;
DELETE FROM suite_mig_demo.ic_cat_tr_plan_comision_meta WHERE id_plan_comision = 77;
DELETE FROM suite_mig_demo.ic_cat_tr_plan_comision WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_corporativo WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_glob_tr_ctrl_cambios WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_glob_tr_forma_pago WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tc_grupo_fit WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_gds_tr_hoteles WHERE id_factura_detalle IN (5180,5181,5182,5183,5184,5185,5186,5187,5188,5189,5190);
DELETE FROM suite_mig_demo.ic_glob_tr_inventario_boletos WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_origen_venta WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_prove_servicio WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_cat_tr_proveedor_aero WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_cat_tr_proveedor_conf WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_proveedor WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_serie WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tc_servicio WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_gds_tr_autos WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_demo.ic_cat_tc_unidad_medida WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tc_unidad_negocio WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_vendedor WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_gds_tr_vuelos WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_conf.st_adm_tr_usuario WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_folios WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_folios_historico WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_fac_tr_folios_historico_uso_mensual WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_demo.ic_cat_tr_sucursal WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tc_role WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_alertas WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_alertas_usuarios WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
DELETE FROM suite_mig_conf.st_adm_tr_config_banco WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_usuario_acceso WHERE id_empresa = 19;
DELETE FROM suite_mig_conf.st_adm_tr_usuario_interfase WHERE id_grupo_empresa = 15;
DELETE FROM suite_mig_conf.st_adm_tr_usuario_sucursal WHERE id_usuario IN (1366,1367,1368,1370,1371,1372,1374,1375,1377,1378);
/* ------------------------ */

ALTER TABLE `suite_mig_conf`.`st_adm_tr_grupo_empresa` 
AUTO_INCREMENT = 15 ;