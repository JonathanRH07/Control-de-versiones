SELECT *
FROM suite_mig_conf.st_adm_tr_usuario;

SELECT *
FROM st_adm_tc_role;

SELECT *
FROM st_adm_tc_role_copy; -- 

SELECT *
FROM st_adm_tc_tipo_permiso;

SELECT *
FROM st_adm_tc_accion_permiso;

SELECT *
FROM st_adm_tr_permiso_role;

SELECT *
FROM st_adm_tc_modulo;

SELECT *
FROM st_adm_tr_submodulo;

SELECT *
FROM st_adm_tr_submodulo_permiso;

SELECT *
FROM st_adm_tr_permiso_emp_modulo;

SELECT *
FROM st_adm_tr_grupo;

SELECT *
FROM st_adm_tr_empresa;

SELECT *
FROM st_adm_tr_grupo_empresa;

/* ----------------------------------------------------------------------------- */

CALL suite_mig_conf.sp_adm_usuario_cierra_c(488, @pr_message);
SELECT @pr_message;
