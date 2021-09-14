SELECT *
FROM suite_mig_conf.st_adm_tr_usuario
WHERE id_usuario = 1292;

SELECT *
FROM suite_mig_conf.st_adm_tr_usuario_acceso;

TRUNCATE suite_mig_conf.st_adm_tr_usuario_acceso;

CALL suite_mig_conf.sp_adm_usuario_acceso_i(1292, '192.168.20.95', '1', 488, @pr_affect_rows, @pr_message);
SELECT @pr_affect_rows, @pr_message;

CALL suite_mig_conf.sp_adm_usuario_acceso_u(3, '', '2', 488, @pr_affect_rows, @pr_message);
SELECT @pr_affect_rows, @pr_message;

CALL suite_mig_conf.sp_adm_usuario_acceso_c(1292, @pr_message);
SELECT @pr_message;


/* SP DE INSERCCION DE IP's */
CALL suite_mig_conf.sp_adm_usuario_acceso_i(@id_usuario, @pr_acceso_por, @pr_estatus_acceso, @pr_id_usuario_mod, @pr_affect_rows, @pr_message);
SELECT @pr_affect_rows, @pr_message;

/* SP DE ACTUALIZACION DE IP's */
CALL suite_mig_conf.sp_adm_usuario_acceso_u(@id_usuario_acceso, @pr_acceso_por, @pr_estatus_acceso, @pr_id_usuario_mod, @pr_affect_rows, @pr_message);
SELECT @pr_affect_rows, @pr_message;

/* SP DE CONSULTA DE IP's POR USUARIO */
CALL suite_mig_conf.sp_adm_usuario_acceso_c(@id_usuario, @pr_message);
SELECT @pr_message;

SELECT
	id_usuario_acceso,
    id_usuario,
    id_empresa, 
    acceso_por
FROM st_adm_tr_usuario_acceso
WHERE id_usuario = 1292
AND estatus_acceso = 1
LIMIT 1;