/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tr_plan_comision_fac
WHERE id_plan_comision IN (11)
-- Date: 2019-10-25 10:01
*/

SELECT *
FROM suite_mig_vader.ic_cat_tr_plan_comision_fac;

SELECT *
FROM suite_mig_vader.ic_cat_tr_plan_comision
WHERE id_grupo_empresa = 22;

SELECT *
FROM suite_mig_vader.ic_cat_tr_proveedor
WHERE id_grupo_empresa = 21;

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
	12,
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
    1495
);
