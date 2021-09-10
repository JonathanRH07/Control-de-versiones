/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tr_meta_venta_tipo
WHERE id_meta_venta = 5
-- Date: 2019-10-25 10:03
*/

SELECT *
FROM ic_cat_tr_meta_venta;

SELECT *
FROM ic_cat_tr_vendedor
WHERE id_grupo_empresa = 22;

INSERT INTO `ic_cat_tr_meta_venta_tipo` 
(
	`id_meta_venta`,
    `id_vendedor`,
    `id_sucursal`,
    `id_empresa`,
    `total`,
    `id_usuario`,
    `fecha_mod`
) 
VALUES 
	(18,40,8,NULL,650000.00,'1495',NOW()),
	(18,41,8,NULL,2550000.00,'1495',NOW());
