/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tc_unidad_medida
WHERE id_grupo_empresa = 17
-- Date: 2019-10-25 10:06
*/

SELECT *
FROM suite_mig_vader.ic_cat_tc_unidad_medida
WHERE id_grupo_empresa = 22;

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
	(22,'ACTIVIDAD','ACTIVIDAD','E48','ACTIVO',NOW(),1495),
	(22,'SERVICIO','SERVICIO','E48','ACTIVO',NOW(),1495);
