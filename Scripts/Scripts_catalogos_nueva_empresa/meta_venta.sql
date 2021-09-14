/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tr_meta_venta
WHERE id_grupo_empresa = 17
-- Date: 2019-10-25 10:02
*/

SELECT *
FROM suite_mig_vader.ic_cat_tr_meta_venta
WHERE id_grupo_empresa = 19;

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
	22,
    '01',
    'Meta de Ventas 4o. trimestre 2019',
    1,
    3200000.00,
    '2020-01-01',
    '2020-04-21',
    1495,
    NOW()
);
