DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_cfdi_c`(
	IN 	pr_id_empresa			INT,
    IN 	pr_id_grupo_empresa		INT,
    IN 	pr_id_sucursal			INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_cfdi_c
	@fecha: 		07/07/2017
	@descripción: 	Sp para consultar los datos para facturar
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_cfdi_c';
	END ;

	SELECT
        empresa.id_empresa,
		suite_mig_conf.empresa.comercial_empresa,
		suite_mig_conf.empresa.rfc_sucursal,
		suite_mig_conf.empresa.telefono_empresa, #
		suite_mig_conf.cfdi.metodo_pago,
		suite_mig_conf.cfdi.uso_cfdi,
		suite_mig_conf.cfdi.regimen_fiscal_sat, #
		sat.descripcion desc_regimen_fiscal, #
		suite_mig_conf.cfdi.certificado,
		suite_mig_conf.cfdi.no_certificado,
		suite_mig_conf.cfdi.portal_timbrado_usuario,
		suite_mig_conf.cfdi.portal_timbrado_pwd,
		suite_mig_conf.cfdi.archivo_llave,
		suite_mig_conf.cfdi.archivo_certificado,
		suite_mig_conf.cfdi.contrasena,
        suite_mig_conf.cfdi.ambiente_timbrado,
		suite_mig_conf.pac.cve_pac,
		IF(suite_mig_conf.cfdi.ambiente_timbrado = 2, suite_mig_conf.pac.url_timbrado_produccion, suite_mig_conf.pac.url_timbrado) url_timbrado,
		dir.cve_pais,
		dir.calle,
		dir.num_exterior,
		dir.num_interior,
		dir.colonia,
		dir.municipio,
		dir.ciudad,
		dir.estado,
		dir.codigo_postal,
		suite_mig_conf.pac.nombre nombre_pac,
		suite_mig_conf.cfdi.usuario_cancelacion,
		suite_mig_conf.cfdi.password_cancelacion,
		suite_mig_conf.conf_admin.logo_empresa,
        suite_mig_conf.conf_admin.aviso_no_folios
	FROM suite_mig_conf.st_adm_tr_config_cfdi cfdi
	JOIN suite_mig_conf.st_adm_tr_grupo_empresa grupo_empresa
		ON grupo_empresa.id_grupo_empresa = cfdi.id_grupo_empresa
	JOIN suite_mig_conf.st_adm_tr_empresa empresa
		ON empresa.id_empresa = grupo_empresa.id_empresa
	LEFT JOIN suite_mig_conf.st_adm_tc_pac pac
		ON pac.id_pac = cfdi.id_pac
	LEFT JOIN ic_cat_tr_sucursal suc
		ON suc.id_grupo_empresa = grupo_empresa.id_grupo_empresa
	LEFT JOIN ct_glob_tc_direccion dir
		ON dir.id_direccion = suc.id_direccion
	LEFT JOIN suite_mig_conf.st_adm_tr_config_admin conf_admin
		ON conf_admin.id_empresa = empresa.id_empresa
	LEFT JOIN sat_regimen_fiscal sat
	ON cfdi.regimen_fiscal_sat = sat.c_RegimenFiscal
	WHERE empresa.id_empresa = pr_id_empresa
	AND grupo_empresa.id_grupo_empresa = pr_id_grupo_empresa
	AND suc.id_sucursal = pr_id_sucursal;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
