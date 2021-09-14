SELECT * 
FROM suite_mig_vader.ic_cat_tr_cliente
WHERE /*id_grupo_empresa = 7
AND */ id_direccion IS NULL;

SELECT *
FROM suite_mig_vader.ct_glob_tc_direccion;

SELECT
	id_direccion,
    COUNT(*) cont
FROM suite_mig_demo.ic_cat_tr_cliente
GROUP BY id_direccion
HAVING 2 > 1;

SELECT *
FROM suite_mig_demo.ic_cat_tr_cliente
WHERE id_direccion = 11;