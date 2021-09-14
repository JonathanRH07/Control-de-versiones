SELECT
	DISTINCT(id_comision)
FROM ic_cat_tr_vendedor
WHERE id_grupo_empresa = 1;

SELECT *
FROM ic_cat_tr_vendedor
WHERE id_grupo_empresa = 1
AND id_comision = 68;

SELECT *
FROM ic_cat_tr_plan_comision_fac
WHERE id_plan_comision IN (68);

SELECT *
FROM ic_cat_tr_proveedor
WHERE id_tipo_proveedor = 6;