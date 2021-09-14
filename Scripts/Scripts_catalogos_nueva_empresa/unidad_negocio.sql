/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tc_unidad_negocio
WHERE id_grupo_empresa = 21
-- Date: 2019-10-25 10:00
*/
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
	(22,'CORPORATIV','Viajes Corporativos','ACTIVO',NOW(),1495),
	(22,'LEISURE','Viajes de Placer','ACTIVO',NOW(),1495),
	(22,'MICE','Congresos, Eventos y Convenciones','ACTIVO',NOW(),1495),
	(22,'RECEPTIVO','Turismo Receptivo','ACTIVO',NOW(),1495);
