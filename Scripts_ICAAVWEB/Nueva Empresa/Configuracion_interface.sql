SELECT *
FROM suite_mig_conf.st_adm_tr_empresa; -- 20

SELECT *
FROM suite_mig_conf.st_adm_tr_grupo_empresa; -- 17

SELECT *
FROM suite_mig_conf.st_adm_tr_usuario
WHERE id_grupo_empresa = 17; -- 1440

SELECT 
    id_grupo_empresa,
    CONVERT(UNCOMPRESS(host_bd) USING utf8) host_bd,
    CONVERT(UNCOMPRESS(usuario_bd) USING utf8) usuario_bd,
    CONVERT(UNCOMPRESS(password_bd) USING utf8) password_bd,
    CONVERT(UNCOMPRESS(base_bd) USING utf8) base_bd,
    CONVERT(UNCOMPRESS(puerto_bd) USING utf8) puerto_bd,
    carpeta
FROM suite_mig_conf.st_adm_tc_config_carga_gds
WHERE id_grupo_empresa = 17;

UPDATE suite_mig_conf.st_adm_tc_config_carga_gds
SET base_bd = COMPRESS('suite_mig_demo')
WHERE id_grupo_empresa = 19;

SELECT *
FROM suite_mig_conf.st_adm_tr_config_admin
WHERE id_empresa = 20;

SELECT *
FROM suite_mig_r2d2.ic_gds_tr_configuracion
WHERE id_grupo_empresa = 72;

SELECT *
FROM suite_mig_vader.ic_glob_tr_info_sys
WHERE id_grupo_empresa = 17;

SELECT *
FROM suite_mig_conf.st_adm_tr_usuario_interfase
WHERE id_grupo_empresa = 72;