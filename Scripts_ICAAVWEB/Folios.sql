SELECT *
FROM ic_fac_tr_folios;

SELECT *
FROM ic_fac_tr_folios_historico;

SELECT *
FROM ic_fac_tr_folios_historico_uso_mensual;

CALL suite_mig_demo.sp_rep_folios_detalle_c(7, @pr_message);
SELECT @pr_message;

CALL suite_mig_demo.sp_rep_folios_desgloce_c(7, @pr_message);
SELECT @pr_message;

CALL suite_mig_demo.sp_rep_folios_historico_c(7, @pr_message);
SELECT @pr_message;

CALL suite_mig_demo.sp_rep_folios_consumo_mensual_c(7, '2019', 1, @pr_message);
SELECT @pr_message;


SELECT *
FROM ic_fac_tr_folios
WHERE id_grupo_empresa = 10;

SELECT *
FROM ic_fac_tr_folios_historico
WHERE id_grupo_empresa = 10;

SELECT *
FROM ic_fac_tr_folios_historico_uso_mensual
WHERE id_grupo_empresa = 7;

SELECT *
FROM ic_fac_tr_factura
ORDER BY fecha_factura DESC;

SELECT *
FROM ic_fac_tr_factura_detalle
ORDER BY fecha_mod DESC;

SELECT
    fecha
INTO
	lo_fecha_hist_mens
FROM ic_fac_tr_folios_historico_uso_mensual
WHERE id_grupo_empresa = NEW.id_grupo_empresa;


SELECT
	no_folios_facturas,
	no_folios_nc,
	no_folios_documentos,
	no_folios_documentos_credito,
	no_folios_comprobantes_cc,
	no_folios_comprobantes_sc,
    fecha
FROM ic_fac_tr_folios_historico_uso_mensual
WHERE id_grupo_empresa = 7
AND DATE_FORMAT(fecha, '%Y-%m') = '2019-08';
