/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tr_vendedor
WHERE id_grupo_empresa = 21
-- Date: 2019-10-25 10:02
*/

SELECT *
FROM suite_mig_vader.ic_cat_tr_vendedor
WHERE id_grupo_empresa = 20;

SELECT *
FROM suite_mig_vader.ic_cat_tr_plan_comision
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
	(22,8,12,12,'001','Vendedor 001','mrgetw_tester1@yopmail.com',NULL,NULL,NULL,NULL,0,'ACTIVO',NOW(),1495),
	(22,8,12,12,'ML','MARIA LOPEZ','mrgetw_tester1@yopmail.com',NULL,NULL,NULL,NULL,0,'ACTIVO',NOW(),1495);
