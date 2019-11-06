DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_gds_config`(
	IN  pr_id_grupo_empresa INT,
    OUT pr_message 		 	VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_cat_centro_costo_nivel_c
	@fecha: 		10/04/2017
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_gds_config';
	END ;

	SELECT
		adm.inventario_bol_linea,
        adm.notas_factura,
        adm.unidad_negocio_obli,
        adm.origen_venta_obli,
        adm.desglose_impuesto,
        adm.tipo_descu,
        adm.limite_credito,
        adm.ant_cl,
        adm.multi_formato_imp,
        adm.nc_fac_no_exist,
        adm.nc_cambios,
        adm.nc_valida_fac,
        adm.enviar_bol_elect,
        adm.incluir_bol,
        adm.incluir_pax,
        adm.incluir_pnr,
        adm.incluir_fecha_viaje,
        adm.calculo_markup,
        adm.aviso_no_folios,
        cfdi.*,
        emp.id_empresa,
        emp.nom_empresa,
        emp.rfc_sucursal,
        emp.razon_social,
        zon.zona_horaria,
        emp.matriz_empresa,
        dir.cve_pais
	FROM st_adm_tr_config_admin adm
    JOIN st_adm_tr_grupo_empresa grp ON
		 adm.id_empresa = grp.id_empresa
	JOIN st_adm_tr_config_cfdi cfdi ON
		grp.id_grupo_empresa = cfdi.id_grupo_empresa
	JOIN st_adm_tr_empresa emp ON
		 emp.id_empresa = adm.id_empresa
	JOIN st_adm_tc_direccion dir ON
		 emp.id_direccion = dir.id_direccion
	JOIN st_adm_tc_zona_horaria zon ON
		 emp.id_zona_horaria = zon.id_zona_horaria
	WHERE grp.id_grupo_empresa = pr_id_grupo_empresa;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
