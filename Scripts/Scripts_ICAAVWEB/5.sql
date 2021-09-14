USE suite_mig_conf;

SELECT *
FROM st_adm_tc_role;

SELECT * 
FROM st_adm_tc_role_trans;

SELECT *
FROM st_adm_tr_permiso_role;

SELECT
	per_rol.id_permiso_role,
    per_rol.id_role,
    rol.nombre_role,
    per_rol.id_tipo_permiso,
    perm_type.nom_tipo_permiso,
    per_rol.id_submodulo,
    submod.nombre_submodulo
FROM st_adm_tr_permiso_role per_rol
JOIN st_adm_tc_role_copy rol ON
	per_rol.id_role = rol.id_role
JOIN st_adm_tc_tipo_permiso perm_type ON
	per_rol.id_tipo_permiso = perm_type.id_tipo_permiso
JOIN st_adm_tr_submodulo submod ON
	per_rol.id_submodulo = submod.id_submodulo
WHERE per_rol.id_role = 1;


SELECT
	CONCAT(db,'.',name),
	name,
    CONVERT(body USING utf8)
FROM mysql.proc
WHERE db = 'suite_mig_conf'
AND body LIKE '%st_adm_tr_permiso_role%';