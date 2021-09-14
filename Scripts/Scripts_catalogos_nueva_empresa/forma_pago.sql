/*
-- Query: SELECT *
FROM suite_mig_vader.ic_glob_tr_forma_pago
WHERE id_grupo_empresa = 17
-- Date: 2019-10-25 10:09
*/

SELECT *
FROM suite_mig_vader.ic_glob_tr_forma_pago
WHERE id_grupo_empresa = 21;

INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'04','CCAX','American Express Tarjeta de Crédito','2','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'02','CHEQUE','Cheques','1','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'01','EFECTIVO','Efectivo contado','1','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'04','CCMC','Master Card Tarjeta de Crédito','2','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'04','CCVI','Visa Tarjeta de Crédito','2','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'04','CCTP','UATP Tarjeta de Crédito','2','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'03','TRANS','Transferencia Electrónica','1','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'30','ANTICIPOS','Aplicación de Anticipos','1','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'99','CREDITO','Crédito Agencia','1','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'28','DCVI','Visa Tarjeta de Debito','2','ACTIVO',NOW(),1495);
INSERT INTO suite_mig_vader.`ic_glob_tr_forma_pago` (`id_grupo_empresa`,`id_forma_pago_sat`,`cve_forma_pago`,`desc_forma_pago`,`id_tipo_forma_pago`,`estatus_forma_pago`,`fecha_mod_forma_pago`,`id_usuario`) VALUES (22,'28','DCMC','Master Card Tarjeta de Débito','2','ACTIVO',NOW(),1495);
