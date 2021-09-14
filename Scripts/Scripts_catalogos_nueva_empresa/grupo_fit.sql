/*
-- Query: SELECT *
FROM suite_mig_vader.ic_fac_tc_grupo_fit
WHERE id_grupo_empresa = 17
-- Date: 2019-10-25 10:10
*/

SELECT *
FROM suite_mig_vader.ic_fac_tc_grupo_fit
WHERE id_grupo_empresa = 21;

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
	22,
    'GPO001',
    'Grupo Excelencia en el servicio',
    '2020-01-10',
    '2020-05-21',
    'ACTIVO',
    NOW(),
    1495
);
