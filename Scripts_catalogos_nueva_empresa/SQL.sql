
SET @lo_id_grupo_empresa = 30;

/* -------------------------------------------------------------------- */

#PROVEEDORES
INSERT INTO ct_glob_tc_direccion
(
    cve_pais, 
    calle, 
    num_exterior, 
    num_interior, 
    colonia, 
    municipio, 
    ciudad, 
    estado, 
    codigo_postal, 
    estatus
) 
VALUES
('MX', 'Paseo de la Reforma', '243', '', 'Cuauhtémoc', 'Cuauhtémoc', 'Ciudad de México', 'CIUDAD DE MEXICO', '06500', 'ACTIVO'),
('MX', 'Río Nilo', '7456', '56', 'Cuauhtémoc', 'Cuauhtémoc', 'Ciudad de México', 'CIUDAD DE MEXICO', '06500', 'ACTIVO'),
('MX', '1ro. de Mayo', '2563', '56', 'Las Américas', 'Naucalpan de Juárez', 'Naucalpan de Juárez', 'MÉXICO', '53040', 'ACTIVO'),
('MX', 'Arquimides', '253', 'P.B.', 'Guaymas Centro', 'Guaymas', 'Heroica Guaymas', 'SONORA', '85400', 'ACTIVO'),
('MX', 'Calle 36', '1456', '21', 'Concordia de Aquiles Serdán', 'Los Reyes de Juárez', '', 'PUEBLA', '75400', 'ACTIVO'),
('MX', 'Tláloc', '5869', '10', 'Popotla', 'Miguel Hidalgo', 'Ciudad de México', 'CIUDAD DE MEXICO', '11400', 'ACTIVO'),
('MX', 'Prado Sur', '15552', '123', 'Lomas Hermosa', 'Miguel Hidalgo', 'Ciudad de México', 'CIUDAD DE MEXICO', '11200', 'ACTIVO'),
('MX', 'Querétaro', '3653', '14', 'Roma Norte', 'Cuauhtémoc', 'Ciudad de México', 'CIUDAD DE MEXICO', '06700', 'ACTIVO'),
('MX', 'Ganges', '45', 'PB', 'Cuauhtémoc', 'Cuauhtémoc', 'Ciudad de México', 'CIUDAD DE MEXICO', '06500', 'ACTIVO');

SELECT *
FROM ct_glob_tc_direccion
WHERE DATE_FORMAT(fecha_mod, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d');

SELECT 
	id_sucursal
INTO
	@lo_id_sucursal
FROM ic_cat_tr_sucursal
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

SELECT 
	id_usuario
INTO
	@lo_id_usuario
FROM suite_mig_conf.st_adm_tr_usuario
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

INSERT INTO `ic_cat_tr_proveedor` 
(
    `id_grupo_empresa`,
    `cve_proveedor`,
    `id_tipo_proveedor`,
    `id_direccion`,
    `id_sucursal`,
    `id_sat_tipo_tercero`,
    `id_sat_tipo_operacion`,
    `tipo_proveedor_operacion`,
    `tipo_persona`,
    `rfc`,
    `razon_social`,
    `nombre_comercial`,
    `telefono`,
    `email`,
    `concepto_pago`,
    `porcentaje_prorrateo`,
    `estatus`,
    `fecha_mod`,
    `id_usuario`
)
VALUES
(@lo_id_grupo_empresa,'AM'	,1 ,29653,@lo_id_sucursal,NULL,NULL,'INGRESO','M','AME880912I89','Aerovías de México, S.A. de C.V.','Aeroméxico','53274000','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario),
(@lo_id_grupo_empresa,'H00001',5 ,29654,@lo_id_sucursal,NULL,NULL,'INGRESO','M','HTR020506EF8','Hoteles de México, S.A. de C.V.','Hoteles de México','44-44-44-44','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario),
(@lo_id_grupo_empresa,'S00001',12,29655,@lo_id_sucursal,NULL,NULL,'INGRESO','M','ASV061005KL2','Asistencia en Viajes, S.A. de C.V.','Asistencia en Viajes','66-66-66-66','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario),
(@lo_id_grupo_empresa,'O00001',11,29656,@lo_id_sucursal,NULL,NULL,'INGRESO','M','OPK170301WYZ','Operadora Kanguro, S.A. de C.V.','Operadora Kanguro','55-55-55-55','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario),
(@lo_id_grupo_empresa,'A00001',6 ,29657,@lo_id_sucursal,NULL,NULL,'INGRESO','M','AUT160814LK5','Hodge Arrendadora de Autos, S.A. de C.V.','Hodge Arrendadora','22-22-22-22','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario),
(@lo_id_grupo_empresa,'C00001',7 ,29658,@lo_id_sucursal,NULL,NULL,'INGRESO','M','ETN861001FD5','Enlaces Terrestres Nacionales, S.A. de C.V.','ETN','66-66-66-66','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario),
(@lo_id_grupo_empresa,'R00001',8 ,29659,@lo_id_sucursal,NULL,NULL,'INGRESO','M','CRU96011815E','Cruceros Espectaculares, S.A. de C.V.','Cruceros Espectaculares','77-77-77-77','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario),
(@lo_id_grupo_empresa,'N00001',3 ,29660,@lo_id_sucursal,NULL,NULL,'INGRESO','M','CVI050520896','Consolidadora de Viajes, S.A. de C.V.','Consolidadora de Viajes','88-88-88-88','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario),
(@lo_id_grupo_empresa,'X00001',12,29661,@lo_id_sucursal,NULL,NULL,'INGRESO','F','XAXX010101000','Cargos por Servicio','Cargos por Servicio','66-66-66-66','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario),
(@lo_id_grupo_empresa,'F00001',10,29662,@lo_id_sucursal,NULL,NULL,'INGRESO','M','FNO080615GE2','Ferrocarriles del Noreste, S.A. de C.V.','Ferrocarriles del Noreste','22-22-22-22','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),@lo_id_usuario);

INSERT INTO ic_cat_tr_proveedor_conf
 (
	id_proveedor,
	id_grupo_empresa,
	inventario,
	num_dias_credito,
	ctrl_comisiones,
	no_contab_comision,
	id_usuario
 )
 SELECT 
	id_proveedor,
	id_grupo_empresa,
	0,
	0,
	0,
	0,
	id_usuario
 FROM ic_cat_tr_proveedor
 WHERE id_grupo_empresa = @lo_id_grupo_empresa;

SELECT
	id_proveedor,
    cve_proveedor
INTO
	@lo_id_proveedor_la,
    @lo_cve_proveedor
FROM ic_cat_tr_proveedor
WHERE id_grupo_empresa = @lo_id_grupo_empresa
AND id_tipo_proveedor = 1;

SELECT
	id_servicio
INTO
	@lo_id_servicio_la
FROM ic_cat_tc_servicio
WHERE id_grupo_empresa = @lo_id_grupo_empresa
AND cve_servicio = '001';

SELECT
	codigo_bsp
INTO
	@lo_codigo_bsp
FROM ct_glob_tc_aerolinea
WHERE clave_aerolinea = @lo_cve_proveedor;


INSERT INTO ic_fac_tr_prove_servicio
(
    id_proveedor,
    id_servicio,
    id_impuesto,
    id_aerolinea,
    comision,
    tipo_valor_comision,
    margen,
    tipo_valor_margen,
    id_usuario
)
VALUES
(
	@lo_id_proveedor_la,
    @lo_id_servicio_la,
    2,
    @lo_codigo_bsp,
    1.00,
    'P',
    1.00,
    'P',
    @lo_id_usuario
);

SET @lo_id_prove_servicio = LAST_INSERT_ID();

INSERT INTO ic_fac_tr_prove_imp_serv
(
    id_prove_servicio,
    id_impuesto,
    tipo_valor_cantidad,
    cantidad,
    por_pagar,
    base_valor,
    id_usuario
)
VALUES
	(@lo_id_prove_servicio, 2, 'T', 0.160000, 'NO', 100.00, @lo_id_usuario),
    (@lo_id_prove_servicio, 5, 'C', 800.000000, 'NO', 100.00, @lo_id_usuario);


INSERT INTO ic_cat_tr_proveedor_aero
(
	id_proveedor,
    id_pac,
    codigo_bsp,
    tipo_boleto,
    bajo_costo,
    envia_factura,
    id_usuario
)
VALUES
(
	@lo_id_proveedor_la,
    1,
    @lo_codigo_bsp,
    3,
    2,
    2,
    @lo_id_usuario
);

/* -------------------------------------------------------------------- */

#PLAN DE COMISION
INSERT INTO `ic_cat_tr_plan_comision` 
(
    `id_grupo_empresa`,
    `cve_plan_comision`,
    `descripcion`,
    `cuota_minima`,
    `cuota_minima_monto`,
    `comisiones_por`,
    `fecha_ini`,
    `fecha_fin`,
    `estatus`,
    `fecha_mod`,
    `id_usuario`
) VALUES 
(
    @lo_id_grupo_empresa,
    'VENDEDORES2020',
    'Plan de comisiones para vendedores 2020',
    '0',
    0.00,
    'F',
    '2020-01-01',
    '2020-12-31',
    'ACTIVO',
    NOW(),
    @lo_id_usuario);

/* -------------------------------------------------------------------- */

#PLAN DE COMISION FACTURA
SELECT
	id_plan_comision
INTO
	@lo_id_plan_comision
FROM ic_cat_tr_plan_comision
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

INSERT INTO `ic_cat_tr_plan_comision_fac` 
(
    `id_plan_comision`,
    `id_tipo_proveedor`,
    `id_proveedor`,
    `id_serivicio`,
    `prioridad`,
    `tipo`,
    `porc_monto`,
    `valor`,
    `fecha_ini`,
    `fecha_fin`,
    `estatus`,
    `fecha_mod`,
    `id_usuario`
) 
VALUES 
(
    @lo_id_plan_comision,
    NULL,
    NULL,
    NULL,
    1,
    'V',
    'P',
    1.00,
    '2020-01-01',
    '2020-12-31',
    'ACTIVO',
    NOW(),
    @lo_id_usuario
);

/* -------------------------------------------------------------------- */

#ORIGEN DE VENTA
INSERT INTO `ic_cat_tr_origen_venta` (`id_grupo_empresa`,`cve`,`descripcion`,`estatus`,`fecha_mod`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'PAGINAWEB','Página WEB','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_cat_tr_origen_venta` (`id_grupo_empresa`,`cve`,`descripcion`,`estatus`,`fecha_mod`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'PERIODICO','Periódico','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_cat_tr_origen_venta` (`id_grupo_empresa`,`cve`,`descripcion`,`estatus`,`fecha_mod`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'RADIO','Radio','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_cat_tr_origen_venta` (`id_grupo_empresa`,`cve`,`descripcion`,`estatus`,`fecha_mod`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'REDSOCIAL','Red Social','ACTIVO',NOW(),@lo_id_usuario);

/* -------------------------------------------------------------------- */

#UNIDAD DE NEGOCIO
INSERT INTO `ic_cat_tc_unidad_negocio` 
(
    `id_grupo_empresa`,
    `cve_unidad_negocio`,
    `desc_unidad_negocio`,
    `estatus_unidad_negocio`,
    `fecha_mod_unidad_negocio`,
    `id_usuario`
) 
VALUES 
    (@lo_id_grupo_empresa,'CORPORATIV','Viajes Corporativos','ACTIVO',NOW(),@lo_id_usuario),
    (@lo_id_grupo_empresa,'LEISURE','Viajes de Placer','ACTIVO',NOW(),@lo_id_usuario),
    (@lo_id_grupo_empresa,'MICE','Congresos, Eventos y Convenciones','ACTIVO',NOW(),@lo_id_usuario),
    (@lo_id_grupo_empresa,'RECEPTIVO','Turismo Receptivo','ACTIVO',NOW(),@lo_id_usuario);

/* -------------------------------------------------------------------- */

#UNIDAD DE MEDIDA
INSERT INTO `ic_cat_tc_unidad_medida` 
(
    `id_grupo_empresa`,
    `cve_unidad_medida`,
    `descripcion`,
    `c_ClaveUnidad`,
    `estatus`,
    `fecha_mod`,
    `id_usuario`
) 
VALUES 
    (@lo_id_grupo_empresa,'ACTIVIDAD','ACTIVIDAD','E48','ACTIVO',NOW(),@lo_id_usuario),
    (@lo_id_grupo_empresa,'SERVICIO','SERVICIO','E48','ACTIVO',NOW(),@lo_id_usuario);

/* -------------------------------------------------------------------- */

#GRUPOS FIT
INSERT INTO `ic_fac_tc_grupo_fit` 
(
    `id_grupo_empresa`,
    `cve_codigo_grupo`,
    `desc_grupo_fit`,
    `fecha_ini_grupo_fit`,
    `fecha_fin_grupo_fit`,
    `estatus_grupo_fit`,
    `fecha_mod_grupo_fit`,
    `id_usuario`
) 
VALUES 
(
    @lo_id_grupo_empresa,
    'GPO001',
    'Grupo Excelencia en el servicio',
    '2020-01-10',
    '2020-05-21',
    'ACTIVO',
    NOW(),
    @lo_id_usuario
);

/* -------------------------------------------------------------------- */

#UNIDAD DE NEGOCIO
SELECT
	id_sucursal
INTO
	@lo_id_sucursal
FROM ic_cat_tr_sucursal
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

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
    (@lo_id_grupo_empresa,0,@lo_id_sucursal,1,1,1,0,0,'FAE','FACT','FNC',0,'Factura Electrónica serie A','0',0,'',0,1,0,'A','ACTIVO',NOW(),@lo_id_usuario),
    (@lo_id_grupo_empresa,0,@lo_id_sucursal,1,1,1,0,0,'DAE','DOCS','FNC',0,'Documento de Servicio serie A','0',0,'',0,1,0,'A','ACTIVO',NOW(),@lo_id_usuario),
    (@lo_id_grupo_empresa,0,@lo_id_sucursal,1,1,1,0,0,'NFA','NC','FNC',0,'Nota de Crédito Electrónica serie A','0',0,'',0,1,0,'CO','ACTIVO',NOW(),@lo_id_usuario),
    (@lo_id_grupo_empresa,0,@lo_id_sucursal,1,1,1,0,0,'NDA','DC','FNC',0,'Nota de Documento serie A','0',0,'',0,1,0,'A','ACTIVO',NOW(),@lo_id_usuario),
    (@lo_id_grupo_empresa,0,@lo_id_sucursal,1,1,1,0,0,'PAG','PAGF','RECC',0,'Comprobante de Pago serie A','0',0,'',0,1,0,'AN','ACTIVO',NOW(),@lo_id_usuario);

/* -------------------------------------------------------------------- */

#CORPORATIVO
INSERT INTO ic_cat_tr_corporativo
(
    id_grupo_empresa,
    cve_corporativo,
    nom_corporativo,
    limite_credito_corporativo,
    saldo,
    estatus_corporativo,
    fecha_mod_corporativo,
    id_usuario
) 
VALUES 
(
    @lo_id_grupo_empresa,
    'CORP01',
    'Corporativo empresas 01',
    200000,
    NULL,
    'ACTIVO',
    NOW(),
    @lo_id_usuario
);

/* -------------------------------------------------------------------- */

#FORMA DE PAGO
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'04','CCAX','American Express Tarjeta de Crédito','2','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'02','CHEQUE','Cheques','1','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'01','EFECTIVO','Efectivo contado','1','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'04','CCMC','Master Card Tarjeta de Crédito','2','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'04','CCVI','Visa Tarjeta de Crédito','2','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'04','CCTP','UATP Tarjeta de Crédito','2','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'03','TRANS','Transferencia Electrónica','1','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'30','ANTICIPOS','Aplicación de Anticipos','1','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'99','CREDITO','Crédito Agencia','1','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'28','DCVI','Visa Tarjeta de Debito','2','ACTIVO',NOW(),@lo_id_usuario);
INSERT INTO `ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (@lo_id_grupo_empresa,'28','DCMC','Master Card Tarjeta de Débito','2','ACTIVO',NOW(),@lo_id_usuario);

/* -------------------------------------------------------------------- */

#FORMA DE PAGO DETALLE
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,1,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,1,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,1,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,2,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,2,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,2,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,3,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,3,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,3,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,4,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,4,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,4,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,5,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,5,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,5,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,6,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,6,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,6,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,7,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,7,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,7,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,8,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,8,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,8,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,9,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,9,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,9,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,10,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,10,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,10,NULL,49,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,11,NULL,100,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,11,NULL,149,'ACTIVO');
INSERT INTO `ic_glob_tr_forma_pago_detalle` (`id_usuario`,`id_forma_pago`,`id_cuenta_contable`,`id_moneda`,`estatus_forma_pago_detalle`) VALUES (@lo_id_usuario,11,NULL,49,'ACTIVO');

/* -------------------------------------------------------------------- */

#SERVICIO
SELECT
	MAX(id_unidad_medida)
INTO
	@lo_id_unidad_medida
FROM ic_cat_tc_unidad_medida
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,1,@lo_id_unidad_medida,'90121502','001','NACIONAL','Boletos Aéreos Nacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,1,@lo_id_unidad_medida,'90121502','002','INTERNACIONAL','Boletos Aéreos Internacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,1,@lo_id_unidad_medida,'90121502','003','NACIONAL','Boletos Aéreos Nacionales Bajo Costo','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,1,@lo_id_unidad_medida,'90121502','004','INTERNACIONAL','Boletos Aéreos Internacionales Bajo Costo','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,2,@lo_id_unidad_medida,'90121502','005','NACIONAL','Hoteles Nacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,2,@lo_id_unidad_medida,'90121502','006','INTERNACIONAL','Hoteles Internacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,8,@lo_id_unidad_medida,'90121502','007','NACIONAL','Paquetes Nacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,8,@lo_id_unidad_medida,'90121502','008','INTERNACIONAL','Paquetes Internacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,5,@lo_id_unidad_medida,'90121502','009','NACIONAL','Cargo por emisión boletos aéreos','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,5,@lo_id_unidad_medida,'90121502','010','NACIONAL','Cargo por reservaciones de viaje','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,4,@lo_id_unidad_medida,'90121502','011','NACIONAL','Traslados Nacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,4,@lo_id_unidad_medida,'90121502','012','INTERNACIONAL','Traslados Internacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,4,@lo_id_unidad_medida,'90121502','013','INTERNACIONAL','Visas','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,10,@lo_id_unidad_medida,'90121502','014','INTERNACIONAL','Seguros de Viaje','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,4,@lo_id_unidad_medida,'90121502','015','NACIONAL','Boletos de Autobus','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,3,@lo_id_unidad_medida,'90121502','016','NACIONAL','Renta de Autos Nacioanales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,3,@lo_id_unidad_medida,'90121502','017','INTERNACIONAL','Renta de Autos Internacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,7,@lo_id_unidad_medida,'90121502','018','NACIONAL','Trenes Nacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,7,@lo_id_unidad_medida,'90121502','019','INTERNACIONAL','Trenes Internacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,9,@lo_id_unidad_medida,'90121502','020','INTERNACIONAL','Cruceros','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,6,@lo_id_unidad_medida,'90121502','021','NACIONAL','Comisiones Nacionales','NO','ACTIVO',@lo_id_usuario);
INSERT INTO `ic_cat_tc_servicio` (`id_grupo_empresa`,`id_producto`,`id_unidad_medida`,`c_ClaveProdServ`,`cve_servicio`,`alcance`,`descripcion`,`valida_adicis`,`estatus`,`id_usuario`) VALUES (@lo_id_grupo_empresa,6,@lo_id_unidad_medida,'90121502','022','INTERNACIONAL','Comisiones Internacionales','NO','ACTIVO',@lo_id_usuario);

/* -------------------------------------------------------------------- */

#VENDEDOR
SELECT *
FROM ic_cat_tr_plan_comision
WHERE id_grupo_empresa = 22;

INSERT INTO `ic_cat_tr_vendedor` 
(
    `id_grupo_empresa`,
    `id_sucursal`,
    `id_comision`,
    `id_comision_aux`,
    `clave`,
    `nombre`,
    `email`,
    `cve_gds_sa`,
    `cve_gds_am`,
    `cve_gds_ws`,
    `cve_gds_ap`,
    `id_usuario_vendedor`,
    `estatus`,
    `fecha_mod`,
    `id_usuario`
) 
VALUES 
    (@lo_id_grupo_empresa,@lo_id_sucursal,@lo_id_plan_comision,@lo_id_plan_comision,'001','Vendedor 001','mrgetw_tester1@yopmail.com',NULL,NULL,NULL,NULL,0,'ACTIVO',NOW(),@lo_id_usuario),
    (@lo_id_grupo_empresa,@lo_id_sucursal,@lo_id_plan_comision,@lo_id_plan_comision,'ML','MARIA LOPEZ','mrgetw_tester1@yopmail.com',NULL,NULL,NULL,NULL,0,'ACTIVO',NOW(),@lo_id_usuario);

/* -------------------------------------------------------------------- */

#META VENTA
INSERT INTO ic_cat_tr_meta_venta 
(
    `id_grupo_empresa`,
    `clave`,
    `descripcion`,
    `id_tipo_meta`,
    `total`,
    `fecha_inicio`,
    `fecha_fin`,
    `id_usuario`,
    `fecha_mod`
) 
VALUES 
(
    @lo_id_grupo_empresa,
    '01',
    'Meta de Ventas 4o. trimestre 2019',
    NULL,
    3200000.00,
    '2020-01-01',
    '2020-04-21',
    @lo_id_usuario,
    NOW()
);

/* -------------------------------------------------------------------- */

#META VENTA TIPO
SELECT
	id_meta_venta
INTO
	@lo_id_meta_venta
FROM ic_cat_tr_meta_venta
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

SELECT
	MIN(id_vendedor)
INTO
	@lo_id_vendedor
FROM ic_cat_tr_vendedor
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

INSERT INTO `ic_cat_tr_meta_venta_tipo` 
(
    `id_meta_venta`,
    `id_vendedor`,
    `id_sucursal`,
    `id_empresa`,
    `total`,
    `id_usuario`,
    `fecha_mod`
) 
VALUES 
    (@lo_id_meta_venta,@lo_id_vendedor,@lo_id_sucursal,NULL,650000.00,@lo_id_usuario,NOW()),
    (@lo_id_meta_venta,(@lo_id_vendedor+1),@lo_id_sucursal,NULL,2550000.00,@lo_id_usuario,NOW());

/* -------------------------------------------------------------------- */

#CLIENTE
INSERT INTO ct_glob_tc_direccion
(
	cve_pais,
    calle,
    num_exterior,
    num_interior,
    colonia,
    municipio,
    ciudad,
    estado,
    codigo_postal,
    estatus
) 
VALUES
('MX', 'ooooo', 'wtwrt', '', 'Roma Norte', 'Cuauhtémoc', 'Ciudad de México', 'CIUDAD DE MEXICO', '06700', 'ACTIVO'),
('MX', 'Paseo de la Reforma', '243', '', 'Cuauhtémoc', 'Cuauhtémoc', 'Ciudad de México', 'CIUDAD DE MEXICO', '06500', 'ACTIVO'),
('MX', 'Ganges', '45', 'PB', 'Cuauhtémoc', 'Cuauhtémoc', 'Ciudad de México', 'CIUDAD DE MEXICO', '06500', 'ACTIVO');

SELECT *
FROM ct_glob_tc_direccion
WHERE DATE_FORMAT(fecha_mod, '%Y-%m-%d') = DATE_FORMAT(NOW(), '%Y-%m-%d');

SELECT
	id_corporativo
INTO
	@lo_id_corporativo
FROM ic_cat_tr_corporativo
WHERE id_grupo_empresa = @lo_id_grupo_empresa;

INSERT INTO `ic_cat_tr_cliente` 
(
	`id_grupo_empresa`,
    `id_sucursal`,
    `id_corporativo`,
    `id_vendedor`,
    `id_direccion`,
    `id_cuenta_contable`,
    `rfc`,
    `cve_cliente`,
    `razon_social`,
    `tipo_persona`,
    `nombre_comercial`,
    `tipo_cliente`,
    `telefono`,
    `email`,
    `cve_gds`,
    `datos_adicionales`,
    `cuenta_pagos_fe`,
    `enviar_mail_boleto`,
    `facturar_boleto`,
    `facturar_boleto_automatico`,
    `observaciones`,
    `notas_factura`,
    `envio_cfdi_portal`,
    `dias_credito`,
    `limite_credito`,
    `saldo`,
    `complemento_ine`,
    `fp_credito_agencia`,
    `fp_contado`,
    `fp_tc_cliente`,
    `gr_credito_agencia`,
    `gr_contado`,
    `gr_tc_agencia`,
    `gr_tc_cliente`,
    `fecha_creacion`,
    `estatus`,
    `fecha_mod`,
    `id_usuario`
) 
VALUES 
	(@lo_id_grupo_empresa,@lo_id_sucursal,@lo_id_corporativo,@lo_id_vendedor,29665,NULL,'ABCD010203AB','001','Periódicos y revistas de México, S.A, de C.V.','M','Periódicos y revistas de México','FIJO','55-55-55-55','mrgetw_tester1@yopmail.com','',0,'','0','0','0','','','0',8,NULL,180288.60,'N','N','N','N','N','N','1','0',NOW(),'ACTIVO',NOW(),@lo_id_usuario),
	(@lo_id_grupo_empresa,@lo_id_sucursal,@lo_id_corporativo,@lo_id_vendedor,29666,NULL,'DEFG02030425','HILGAT','Hilos el Gato, S.A. de C.V.','M','Hilos el Gato, S.A. de C.V.','FIJO','66-66-66-66','mrgetw_tester1@yopmail.com','',0,'','0','0','0','','','0',15,NULL,437010.00,'N','N','N','N','N','N','1','0',NOW(),'ACTIVO',NOW(),@lo_id_usuario),
	(@lo_id_grupo_empresa,@lo_id_sucursal,@lo_id_corporativo,(@lo_id_vendedor+1),29667,NULL,'IHG8611053F3','IHG8611053','Industrias de Hule González, S.A. de C.V.','M','Industrias de Hule González,','FIJO','55-55-55-55','mrgetw_tester1@yopmail.com','',0,'','0','0','0','','','0',3,NULL,14280.00,'N','N','N','N','N','N','N','0',NOW(),'ACTIVO',NOW(),@lo_id_usuario);
