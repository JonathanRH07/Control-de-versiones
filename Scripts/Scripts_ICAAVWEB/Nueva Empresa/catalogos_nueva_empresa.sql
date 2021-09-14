SELECT *
FROM suite_mig_vader.ic_cat_tc_unidad_negocio
WHERE id_grupo_empresa = 17;

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tr_origen_venta
WHERE id_grupo_empresa = 17;

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tr_plan_comision
WHERE id_grupo_empresa = 17;


SELECT *
FROM suite_mig_vader.ic_cat_tr_plan_comision_fac
WHERE id_plan_comision IN (6,7);

SELECT *
FROM suite_mig_vader.ic_cat_tr_plan_comision_meta
WHERE id_plan_comision IN (6,7);

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tr_vendedor
WHERE id_grupo_empresa = 17;

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tr_meta_venta
WHERE id_grupo_empresa = 17;

SELECT *
FROM suite_mig_vader.ic_cat_tr_meta_venta_tipo
WHERE id_meta_venta = 5;


SELECT *
FROM suite_mig_vader.ic_cat_tr_meta_venta_meses
WHERE id_meta_venta_tipo IN (5, 6);

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tr_corporativo
WHERE id_grupo_empresa = 17;

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tr_cliente
WHERE id_grupo_empresa = 17;

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tc_unidad_medida
WHERE id_grupo_empresa = 17;

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tc_servicio
WHERE id_grupo_empresa = 17;

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tr_proveedor
WHERE id_grupo_empresa = 17;

/**/

SELECT *
FROM suite_mig_vader.ic_cat_tr_serie
WHERE id_grupo_empresa = 17;

/**/

SELECT *
FROM suite_mig_vader.ic_glob_tr_forma_pago
WHERE id_grupo_empresa = 17;

SELECT *
FROM suite_mig_vader.ic_glob_tr_forma_pago_detalle
WHERE id_forma_pago IN (5,6,7,8,9,10,11,12,13,14,15,16);

/**/

SELECT *
FROM suite_mig_vader.ic_fac_tc_grupo_fit
WHERE id_grupo_empresa = 17;

/**/



/* BORRAR EMPRESA */
DELETE FROM `suite_mig_conf`.`st_adm_tr_config_cfdi` WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM `suite_mig_conf`.`st_adm_tr_config_moneda` WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM `suite_mig_conf`.`st_adm_tc_permiso_empresa_sistema` WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM `suite_mig_conf`.`st_adm_tr_config_admin` WHERE `id_empresa` IN  (18, 19);
DELETE FROM `suite_mig_conf`.`st_adm_tr_config_emails` WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_conf.ic_adm_tr_ctrl_cambios WHERE id_usuario IN (1379,1380,1381,1385,1409,1410,1411,1413,1414,1420,1421,1422,1423,1424,1425,1426);
DELETE FROM suite_mig_conf.st_adm_tr_usuario_recuperacion WHERE id_usuario IN (1379, 1380,1381,1385,1409,1410,1411,1413,1414,1420,1421,1422,1423,1424,1425,1426);
DELETE FROM suite_mig_vader.ic_glob_tr_boleto WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_fac_tr_factura_detalle WHERE id_factura IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27);
DELETE FROM suite_mig_vader.ic_fac_tr_factura_cfdi WHERE id_factura IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27);
DELETE FROM suite_mig_vader.ic_fac_tr_factura_detalle_imp WHERE id_factura_detalle IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27);
DELETE FROM ic_glob_tr_cxc_detalle WHERE id_cxc IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25);
DELETE FROM suite_mig_vader.ic_fac_tr_factura_cfdi_relacionados WHERE id_factura IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27);
DELETE FROM suite_mig_vader.ic_fac_tr_factura_forma_pago WHERE id_factura IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27);
DELETE FROM suite_mig_vader.ic_fac_documento_servicio WHERE id_factura IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27);
DELETE FROM suite_mig_vader.ic_fac_tr_debito WHERE id_factura IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27);
DELETE FROM suite_mig_vader.ic_fac_tr_pagos WHERE id_grupo_empresa IN (15, 16);
DELETE FROM suite_mig_vader.ic_fac_tr_pagos_cfdi WHERE id_pago IN (1,2,3,4,5,6,7,8,9);
DELETE FROM suite_mig_vader.ic_fac_tr_pagos_detalle WHERE id_pago IN (1,2,3,4,5,6,7,8,9);
/**/
DELETE FROM ic_glob_tr_cxc WHERE id_grupo_empresa IN (15, 16);
DELETE FROM suite_mig_vader.ic_fac_tr_factura WHERE id_grupo_empresa IN (15, 16);
DELETE FROM suite_mig_vader.ic_cat_tr_cliente WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_cat_tr_plan_comision WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_cat_tr_plan_comision_fac WHERE id_plan_comision IN (2,4,5);
DELETE FROM suite_mig_vader.ic_cat_tr_plan_comision_meta WHERE id_plan_comision IN (2,4,5);
DELETE FROM suite_mig_vader.ic_cat_tr_corporativo WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_glob_tr_ctrl_cambios WHERE id_usuario IN (1379, 1380,1381,1385,1409,1410,1411,1413,1414,1420,1421,1422,1423,1424,1425,1426);
DELETE FROM suite_mig_vader.ic_glob_tr_forma_pago WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_fac_tc_grupo_fit WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_gds_tr_hoteles WHERE id_factura_detalle IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27);
DELETE FROM suite_mig_vader.ic_glob_tr_inventario_boletos WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_cat_tr_origen_venta WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_fac_tr_prove_servicio WHERE id_usuario IN (1379, 1380,1381,1385,1409,1410,1411,1413,1414,1420,1421,1422,1423,1424,1425,1426);
DELETE FROM suite_mig_vader.ic_cat_tr_proveedor_aero WHERE id_usuario IN (1379, 1380,1381,1385,1409,1410,1411,1413,1414,1420,1421,1422,1423,1424,1425,1426);
DELETE FROM suite_mig_vader.ic_cat_tr_proveedor_conf WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_cat_tr_proveedor WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_cat_tr_serie WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_cat_tc_servicio WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_gds_tr_autos WHERE id_usuario IN (1379, 1380,1381,1385,1409,1410,1411,1413,1414,1420,1421,1422,1423,1424,1425,1426);
DELETE FROM suite_mig_vader.ic_cat_tc_unidad_medida WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_cat_tc_unidad_negocio WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_cat_tr_vendedor WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_vader.ic_gds_tr_vuelos WHERE id_usuario IN (1379, 1380,1381,1385,1409,1410,1411,1413,1414,1420,1421,1422,1423,1424,1425,1426);
DELETE FROM suite_mig_conf.st_adm_tc_config_carga_gds WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM `suite_mig_vader`.`ic_fac_tr_folios` WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM `suite_mig_vader`.`ic_fac_tr_folios_historico` WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM `suite_mig_vader`.`ic_fac_tr_folios_historico_uso_mensual` WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM `suite_mig_vader`.`ic_cat_tr_sucursal` WHERE `id_grupo_empresa` IN (15, 16);
/**/
DELETE FROM suite_mig_conf.st_adm_tr_alertas WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_conf.st_adm_tr_alertas_usuarios WHERE id_usuario IN (1379, 1380,1381,1385,1409,1410,1411,1413,1414,1420,1421,1422,1423,1424,1425,1426);
/**/
DELETE FROM suite_mig_conf.st_adm_tr_usuario_sucursal WHERE id_usuario IN (1379, 1380,1381,1385,1409,1410,1411,1413,1414,1420,1421,1422,1423,1424,1425,1426);
DELETE FROM suite_mig_conf.st_adm_tr_usuario_interfase WHERE `id_grupo_empresa` IN (15, 16);
/**/
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM `suite_mig_conf`.`st_adm_tr_usuario` WHERE `id_grupo_empresa` IN (15, 16);
SET FOREIGN_KEY_CHECKS=1;
DELETE FROM `suite_mig_conf`.`st_adm_tr_grupo_empresa` WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM `suite_mig_conf`.`st_adm_tr_grupo` WHERE `id_grupo` IN (10, 11);
DELETE FROM suite_mig_conf.st_adm_tr_estilo_empresa WHERE id_empresa IN (18, 19);
DELETE FROM suite_mig_conf.st_adm_tr_permiso_emp_modulo WHERE id_empresa IN (18, 19);
/**/
DELETE FROM suite_mig_conf.st_adm_tr_empresa_usuario WHERE id_empresa IN (18, 19);
DELETE FROM `suite_mig_conf`.`st_adm_tr_empresa` WHERE id_empresa IN (18, 19);
/**/
DELETE FROM `suite_mig_conf`.`st_adm_tc_direccion` WHERE `id_direccion` IN (12, 13);
DELETE FROM suite_mig_conf.st_adm_tc_role WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_conf.st_adm_tr_config_banco WHERE `id_grupo_empresa` IN (15, 16);
DELETE FROM suite_mig_conf.st_adm_tr_usuario_acceso WHERE id_empresa IN (18, 19);