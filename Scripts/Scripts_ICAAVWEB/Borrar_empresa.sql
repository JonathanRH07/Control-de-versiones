SELECT *
FROM suite_mig_conf.st_adm_tr_empresa;

SELECT
	empresa.nom_empresa,
	empresa.id_empresa,
    empresa.id_direccion,
    grupo_empresa.id_grupo,
    grupo_empresa.id_grupo_empresa,
    permiso_sistema.id_permiso_empresa_sistema,
    config_admin.id_config_admin
INTO
	@lo_nom_empresa,
    @lo_id_empresa,
    @lo_id_direccion,
    @lo_id_grupo,
    @lo_id_grupo_empresa,
    @lo_id_permiso_empresa_sistema,
    @lo_id_config_admin
FROM suite_mig_conf.st_adm_tr_empresa empresa
JOIN suite_mig_conf.st_adm_tr_grupo_empresa grupo_empresa ON
	empresa.id_empresa = grupo_empresa.id_empresa
JOIN suite_mig_conf.st_adm_tc_permiso_empresa_sistema permiso_sistema ON
	grupo_empresa.id_grupo_empresa = permiso_sistema.id_grupo_empresa
JOIN suite_mig_conf.st_adm_tr_config_admin config_admin ON
	empresa.id_empresa = config_admin.id_empresa
WHERE empresa.id_empresa = 76;

SELECT
	@lo_nom_empresa,
    @lo_id_empresa,
    @lo_id_direccion,
    @lo_id_grupo,
    @lo_id_grupo_empresa,
    @lo_id_permiso_empresa_sistema,
    @lo_id_config_admin;
	

/* BORRAR LA EMPRESA */
/*
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM `suite_mig_conf`.`st_adm_tr_grupo_empresa` WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM `suite_mig_conf`.`st_adm_tr_empresa` WHERE id_empresa = @lo_id_empresa;
DELETE FROM `suite_mig_conf`.`st_adm_tc_direccion` WHERE id_direccion = @lo_id_direccion;
DELETE FROM `suite_mig_conf`.`st_adm_tr_grupo` WHERE id_grupo = @lo_id_grupo;
DELETE FROM `suite_mig_conf`.`st_adm_tr_permiso_emp_modulo` WHERE id_empresa = @lo_id_empresa;
DELETE FROM `suite_mig_conf`.`st_adm_tr_config_admin` WHERE id_config_admin = @lo_id_config_admin;
DELETE FROM `suite_mig_conf`.`st_adm_tr_config_moneda` WHERE id_grupo_empresa = @lo_id_grupo_empresa;
*/
/*
DELETE FROM `suite_mig_conf`.`st_adm_tr_usuario` WHERE (`id_usuario` = '1498');
DELETE FROM `suite_mig_conf`.`st_adm_tr_empresa_usuario` WHERE (`id_empresa_usuario` = '355');
DELETE FROM `suite_mig_conf`.`st_adm_tr_usuario_sucursal` WHERE (`id_usuario_sucursal` = '973');
DELETE FROM `suite_mig_conf`.`st_adm_tr_estilo_empresa` WHERE (`id_estilo_empresa` = '209');
DELETE FROM `suite_mig_conf`.`st_adm_tr_estilo_empresa` WHERE (`id_estilo_empresa` = '210');
DELETE FROM `suite_mig_conf`.`st_adm_tr_estilo_empresa` WHERE (`id_estilo_empresa` = '211');
DELETE FROM `suite_mig_conf`.`st_adm_tr_estilo_empresa` WHERE (`id_estilo_empresa` = '212');
DELETE FROM `suite_mig_conf`.`st_adm_tr_estilo_empresa` WHERE (`id_estilo_empresa` = '213');
DELETE FROM `suite_mig_conf`.`st_adm_tr_estilo_empresa` WHERE (`id_estilo_empresa` = '214');
DELETE FROM `suite_mig_conf`.`st_adm_tc_permiso_empresa_sistema` WHERE id_permiso_empresa_sistema = 73;
*/
-- SET FOREIGN_KEY_CHECKS=1;

/*
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM `suite_mig_conf`.`st_adm_tr_config_moneda` WHERE (`id_moneda_empresa` = '275');
DELETE FROM `suite_mig_conf`.`st_adm_tr_config_moneda` WHERE (`id_moneda_empresa` = '276');
DELETE FROM `suite_mig_conf`.`st_adm_tr_config_moneda` WHERE (`id_moneda_empresa` = '277');
SET FOREIGN_KEY_CHECKS=1;
*/

/* BORRAR DATOS DE LA NUEVA EMPRESA */
SELECT
	nombre
FROM suite_mig_conf.st_adm_tr_empresa empresa
JOIN suite_mig_conf.st_adm_tc_base_datos db ON
	empresa.id_base_datos = db.id_base_datos
JOIN suite_mig_conf.st_adm_tr_grupo_empresa grupo ON
	empresa.id_empresa = grupo.id_empresa
WHERE grupo.id_grupo_empresa = @lo_id_grupo_empresa;

/* CONFIGURACION */
DELETE a.* FROM suite_mig_conf.ic_adm_tr_ctrl_cambios a JOIN suite_mig_conf.st_adm_tr_usuario b ON a.id_usuario = b.id_usuario WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM suite_mig_conf.st_adm_tc_role WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM suite_mig_conf.st_adm_tr_alertas WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM suite_mig_conf.st_adm_tr_alertas_usuarios a JOIN suite_mig_conf.st_adm_tr_alertas b ON a.id_alerta = b.id_alertas WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM suite_mig_conf.st_adm_tr_usuario_recuperacion a JOIN suite_mig_conf.st_adm_tr_usuario b ON a.id_usuario = b.id_usuario WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM suite_mig_conf.st_adm_tr_notificaciones WHERE id_grupo_empresa = @lo_id_grupo_empresa;
COMMIT;

/* BASE DE DATOS */
DELETE a.* FROM ic_fac_tr_factura_cfdi a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_tr_factura_cfdi_relacionados a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_glob_tr_cxc_detalle a JOIN ic_glob_tr_cxc b ON a.id_cxc = b.id_cxc WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_glob_tr_cxc WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_documento_servicio a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_fac_tr_debito WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_tr_factura_detalle_imp a JOIN ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_tr_factura_detalle a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_tr_factura_forma_pago a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_fac_tr_folios WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_fac_tr_folios_historico WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_fac_tr_folios_historico_uso_mensual WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_fac_tr_pagos WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_tr_pagos_cfdi a JOIN ic_fac_tr_pagos b ON a.id_pago = b.id_pago WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_tr_pagos_detalle a JOIN ic_fac_tr_pagos b ON a.id_pago = b.id_pago WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_gds_tr_autos a JOIN ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_gds_tr_hoteles a JOIN ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_gds_tr_vuelos a JOIN ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_glob_tr_boleto WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_glob_tr_ctrl_cambios a JOIN suite_mig_conf.st_adm_tr_usuario b ON a.id_usuario = b.id_usuario WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_glob_tr_inventario_boletos WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_fac_tr_anticipos WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_tr_anticipos_aplicacion a JOIN ic_fac_tr_anticipos b ON a.id_anticipos = b.id_anticipos WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_fac_tr_compras_x_servicio WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_tr_factura_analisis a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_fac_tr_factura_ine_complemento a JOIN ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_fac_tr_factura WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_fac_tc_grupo_fit WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_gds_tr_general WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_gds_tr_analisis a JOIN ic_gds_tr_general b ON a.id_gds_general = b.id_gds_generall WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_gds_tr_cupon a JOIN ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_gds_tr_errores a JOIN ic_gds_tr_general b ON a.id_gds_general = b.id_gds_generall WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_gds_tr_vuelos_citypair a JOIN ic_gds_tr_vuelos b ON a.id_gds_vuelos = b.id_gds_vuelos JOIN ic_fac_tr_factura_detalle c ON b.id_factura_detalle = c.id_factura_detalle JOIN ic_fac_tr_factura d ON c.id_factura = d.id_factura WHERE d.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_gds_tr_vuelos_segmento a JOIN ic_gds_tr_vuelos b ON a.id_gds_vuelos = b.id_gds_vuelos JOIN ic_fac_tr_factura_detalle c ON b.id_factura_detalle = c.id_factura_detalle JOIN ic_fac_tr_factura d ON c.id_factura = d.id_factura WHERE d.id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_rep_tr_acumulado_pagos WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_rep_tr_acumulado_pagos_detalle WHERE id_grupo_empresa = @lo_id_grupo_empresa;

UPDATE ic_cat_tr_cliente 
SET saldo = 0
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

UPDATE ic_cat_tr_serie 
SET folio_serie = 0
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

/* BORRAR USUARIO (OPCIONAL) */
SELECT *
FROM suite_mig_conf.st_adm_tr_usuario;

/*
SET FOREIGN_KEY_CHECKS=0;
DELETE FROM ic_cat_tr_cliente WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_cat_tr_sucursal WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_cat_tc_servicio WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_cat_tr_proveedor WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_cat_tr_corporativo WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE FROM ic_glob_tr_forma_pago WHERE id_grupo_empresa = @lo_id_grupo_empresa;
DELETE a.* FROM ic_glob_tr_forma_pago_detalle a JOIN ic_glob_tr_forma_pago b WHERE b.id_grupo_empresa = @lo_id_grupo_empresa;
SET FOREIGN_KEY_CHECKS=1;
*/
COMMIT;