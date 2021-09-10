/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tr_cliente
WHERE id_grupo_empresa = 21
-- Date: 2019-10-25 10:05
*/

SELECT *
FROM suite_mig_vader.ic_cat_tr_vendedor
WHERE id_grupo_empresa = 20;

SELECT *
FROM suite_mig_vader.ic_cat_tr_cliente
WHERE id_grupo_empresa = 19;

SELECT *
FROM ct_glob_tc_direccion
WHERE id_direccion IN (29357,29358,29359);

SELECT *
FROM ic_cat_tr_corporativo;

SELECT *
FROM ic_cat_tr_sucursal;

SELECT *
FROM suite_mig_conf.st_adm_tr_grupo_empresa;
SELECT *
FROM suite_mig_conf.st_adm_tr_usuario;

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
	(22,8,9,40,NULL,NULL,'ABCD010203AB','001','Periódicos y revistas de México, S.A, de C.V.','M','Periódicos y revistas de México','FIJO','55-55-55-55','mrgetw_tester1@yopmail.com','',0,'','0','0','0','','','0',8,NULL,180288.60,'N','N','N','N','N','N','1','0',NOW(),'ACTIVO',NOW(),1495),
	(22,8,9,40,NULL,NULL,'DEFG02030425','HILGAT','Hilos el Gato, S.A. de C.V.','M','Hilos el Gato, S.A. de C.V.','FIJO','66-66-66-66','mrgetw_tester1@yopmail.com','',0,'','0','0','0','','','0',15,NULL,437010.00,'N','N','N','N','N','N','1','0',NOW(),'ACTIVO',NOW(),1495),
	(22,8,9,41,NULL,NULL,'IHG8611053F3','IHG8611053','Industrias de Hule González, S.A. de C.V.','M','Industrias de Hule González,','FIJO','55-55-55-55','mrgetw_tester1@yopmail.com','',0,'','0','0','0','','','0',3,NULL,14280.00,'N','N','N','N','N','N','N','0',NOW(),'ACTIVO',NOW(),1495);
