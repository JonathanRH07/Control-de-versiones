/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tr_plan_comision
WHERE id_grupo_empresa = 17
-- Date: 2019-10-25 10:01
*/

SELECT *
FROM suite_mig_vader.ic_cat_tr_plan_comision
WHERE id_grupo_empresa = 19;

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
    22,
    'VENDEDORES2019',
    'Plan de comisiones para vendedores 2019',
    '0',
    0.00,
    'F',
    '2020-01-01',
    '2020-12-31',
    'ACTIVO',
    NOW(),
    1495);
