/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tr_serie
WHERE id_grupo_empresa = 17
-- Date: 2019-10-25 10:08
*/

SELECT *
FROM suite_mig_vader.ic_cat_tr_serie
WHERE id_grupo_empresa = 21;

SELECT *
FROM suite_mig_vader.ic_cat_tr_sucursal
WHERE id_grupo_empresa = 22;

INSERT INTO `ic_cat_tr_serie` 
(
	`id_grupo_empresa`,
    `id_usuario_solicita`,
    `id_sucursal`,
    `id_formato`,
    `id_formato_concentrado`,
    `id_moneda`,
    `id_autorizado_por`,
    `id_revisado_por`,
    `cve_serie`,
    `cve_tipo_serie`,
    `cve_tipo_doc`,
    `folio_serie`,
    `descripcion_serie`,
    `electronica_serie`,
    `automatico_serie`,
    `tipo_requisicion`,
    `factura_xcta_terceros`,
    `copias_serie`,
    `no_max_ren_serie`,
    `tipo_formato`,
    `estatus_serie`,
    `fecha_mod_serie`,
    `id_usuario`
) 
VALUES 
	(22,0,8,1,1,1,0,0,'FAE','FACT','FNC',0,'Factura Electrónica serie A','0',0,'',0,1,0,'A','ACTIVO',NOW(),1495),
	(22,0,8,1,1,1,0,0,'DAE','DOCS','FNC',0,'Documento de Servicio serie A','0',0,'',0,1,0,'A','ACTIVO',NOW(),1495),
	(22,0,8,1,1,1,0,0,'NFA','NC','FNC',0,'Nota de Crédito Electrónica serie A','0',0,'',0,1,0,'CO','ACTIVO',NOW(),1495),
	(22,0,8,1,1,1,0,0,'NDA','DC','FNC',0,'Nota de Documento serie A','0',0,'',0,1,0,'A','ACTIVO',NOW(),1495),
	(22,0,8,1,1,1,0,0,'PAG','PAGF','RECC',0,'Comprobante de Pago serie A','0',0,'',0,1,0,'AN','ACTIVO',NOW(),1495);
