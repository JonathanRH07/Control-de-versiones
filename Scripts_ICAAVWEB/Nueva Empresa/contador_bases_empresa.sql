SELECT *
FROM suite_mig_conf.st_adm_tr_empresa;

SELECT *
FROM suite_mig_conf.st_adm_tr_grupo_empresa;

SELECT 
	id_base_datos,
    COUNT(*)
FROM suite_mig_conf.st_adm_tr_empresa
GROUP BY id_base_datos;

SELECT *
FROM suite_mig_conf.st_adm_tc_base_datos;

SELECT
	id_grupo_empresa,
    metodo_pago
FROM suite_mig_demo.ic_fac_tr_folios;

SELECT *
FROM suite_mig_conf.st_adm_tc_zona_horaria;

SELECT 
	base.nombre,
    COUNT(*)
FROM suite_mig_conf.st_adm_tr_empresa empresa
JOIN suite_mig_conf.st_adm_tc_base_datos base ON
	empresa.id_base_datos = base.id_base_datos
GROUP BY empresa.id_base_datos;

SELECT 
	base.nombre,
    COUNT(*)
FROM suite_mig_conf.st_adm_tr_empresa empresa
JOIN suite_mig_conf.st_adm_tc_base_datos base ON
	empresa.id_base_datos = base.id_base_datos
WHERE estatus_empresa = 1
GROUP BY empresa.id_base_datos;

SELECT
	id_grupo_empresa,
    base.nombre,
	empresa.nom_empresa
FROM suite_mig_conf.st_adm_tr_empresa empresa
JOIN suite_mig_conf.st_adm_tc_base_datos base ON
	empresa.id_base_datos = base.id_base_datos
JOIN suite_mig_conf.st_adm_tr_grupo_empresa grupo_emp ON
	empresa.id_empresa = grupo_emp.id_empresa
WHERE estatus_empresa = 1;

SELECT
	id_grupo_empresa,
    base.nombre,
	empresa.nom_empresa
FROM suite_mig_conf.st_adm_tr_empresa empresa
JOIN suite_mig_conf.st_adm_tc_base_datos base ON
	empresa.id_base_datos = base.id_base_datos
JOIN suite_mig_conf.st_adm_tr_grupo_empresa grupo_emp ON
	empresa.id_empresa = grupo_emp.id_empresa
WHERE estatus_empresa != 1;