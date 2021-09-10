set @pr_message = '0';
call suite_mig_yoda.sp_correccion_folios_historico_mensual_u(47, @pr_message);
select @pr_message;

SELECT *
FROM ic_fac_tr_folios
WHERE id_grupo_empresa = 47;

SELECT *
FROM ic_fac_tr_folios_historico
WHERE id_grupo_empresa = 47;

SELECT *
FROM ic_fac_tr_folios_historico_uso_mensual
WHERE id_grupo_empresa = 47;

UPDATE ic_fac_tr_folios_historico_uso_mensual
SET no_folios_facturas = 0,
	no_folios_nc = 0,
    no_folios_documentos = 0,
    no_folios_documentos_credito = 0,
    no_folios_comprobantes_cc = 0,
    no_folios_comprobantes_sc = 0
WHERE id_grupo_empresa = 47;