/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tr_proveedor
WHERE id_grupo_empresa = 21
-- Date: 2019-10-25 10:07
*/

SELECT *
FROM ct_glob_tc_direccion
WHERE id_direccion IN (29249,29250,29251,29252,29253,29254,29255,29256,29257,29258);

SELECT *
FROM suite_mig_vader.ic_cat_tr_proveedor
WHERE id_direccion IN (29249,29250,29251,29252,29253,29254,29255,29256,29257,29258);

SELECT *
FROM suite_mig_vader.ic_cat_tr_proveedor
WHERE id_grupo_empresa = 21;

/*
29360
29361
29362
29363
29364
29365
29366
29367
29368
29369
*/

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
(22,'AM',1,NULL,8,NULL,NULL,'INGRESO','M','AME880912I89','Aerovías de México, S.A. de C.V.','Aeroméxico','53274000','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495),
(22,'H00001',5,NULL,8,NULL,NULL,'INGRESO','M','HTR020506EF8','Hoteles de México, S.A. de C.V.','Hoteles de México','44-44-44-44','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495),
(22,'S00001',12,NULL,8,NULL,NULL,'INGRESO','M','ASV061005KL2','Asistencia en Viajes, S.A. de C.V.','Asistencia en Viajes','66-66-66-66','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495),
(22,'O00001',11,NULL,8,NULL,NULL,'INGRESO','M','OPK170301WYZ','Operadora Kanguro, S.A. de C.V.','Operadora Kanguro','55-55-55-55','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495),
(22,'A00001',6,NULL,8,NULL,NULL,'INGRESO','M','AUT160814LK5','Hodge Arrendadora de Autos, S.A. de C.V.','Hodge Arrendadora','22-22-22-22','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495),
(22,'C00001',7,NULL,8,NULL,NULL,'INGRESO','M','ETN861001FD5','Enlaces Terrestres Nacionales, S.A. de C.V.','ETN','66-66-66-66','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495),
(22,'R00001',8,NULL,8,NULL,NULL,'INGRESO','M','CRU96011815E','Cruceros Espectaculares, S.A. de C.V.','Cruceros Espectaculares','77-77-77-77','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495),
(22,'N00001',3,NULL,8,NULL,NULL,'INGRESO','M','CVI050520896','Consolidadora de Viajes, S.A. de C.V.','Consolidadora de Viajes','88-88-88-88','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495),
(22,'X00001',12,NULL,8,NULL,NULL,'INGRESO','F','XAXX010101000','Cargos por Servicio','Cargos por Servicio','66-66-66-66','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495),
(22,'F00001',10,NULL,8,NULL,NULL,'INGRESO','M','FNO080615GE2','Ferrocarriles del Noreste, S.A. de C.V.','Ferrocarriles del Noreste','22-22-22-22','mrgetw_tester1@yopmail.com',NULL,NULL,'ACTIVO',NOW(),1495)
