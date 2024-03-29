SELECT *
FROM suite_mig_conf.st_adm_tr_usuario
WHERE usuario LIKE 'jhernandez%';

/* ---------------------------------------------------------- */

USE suite_mig_conf;

CALL suite_mig_conf.sp_adm_usuario_inicio_c('jhernandezesp', '9e79c08924cf3db0c48cf83b285593abe74442b6', '192.168.20.95', @pr_message); -- 
SELECT @pr_message;

CALL suite_mig_conf.sp_adm_usuario_cierra_c(1480, @pr_message);
SELECT @pr_message;

SELECT *
FROM suite_mig_conf.st_adm_tr_usuario
WHERE id_usuario = 1570;

SELECT *
FROM suite_mig_conf.st_adm_tr_usuario
WHERE tipo_usuario = 2;

SELECT *
FROM st_adm_tr_usuario_acceso;

SELECT *
FROM suite_mig_conf.st_adm_tc_role;

/*
'1', 'Súper usuario'
'2', 'Administrator'
'3', 'Configuración'
'4', 'Ventas'
'5', 'Cobranza'
'6', 'Boletos-BSP'
'7', 'Reportes'
'8', 'Interface',
'9', 'Pagos'

*/

SELECT *
FROM suite_mig_conf.st_adm_tc_role_trans
WHERE id_role = 4;

SELECT *
FROM suite_mig_conf.st_adm_tr_usuario_sucursal
WHERE id_usuario = 1494;

SELECT *
FROM suite_mig_conf.st_adm_tr_empresa_usuario
WHERE id_usuario = 1506;

SELECT *
FROM suite_mig_vader.ic_cat_tr_sucursal;