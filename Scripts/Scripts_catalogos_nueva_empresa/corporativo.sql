/*
-- Query: SELECT *
FROM suite_mig_vader.ic_cat_tr_corporativo
WHERE id_grupo_empresa = 21
-- Date: 2019-10-25 10:04
*/

SELECT *
FROM suite_mig_vader.ic_cat_tr_corporativo
WHERE id_grupo_empresa = 19;

INSERT INTO suite_mig_vader.ic_cat_tr_corporativo
(
	id_grupo_empresa,
    cve_corporativo,
    nom_corporativo,
    limite_credito_corporativo,
    saldo,
    estatus_corporativo,
    fecha_mod_corporativo,
    id_usuario
) 
VALUES 
(
	22,
    'CORP01',
    'Corporativo empresas 01',
    200000,
    NULL,
    'ACTIVO',
	NOW(),
    1495
);

SELECT last_insert_id();