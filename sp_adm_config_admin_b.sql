DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_admin_b`(
	IN  pr_id_grupo_empresa 	INT(11),
	OUT pr_message 				VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_adm_config_admin_b
	@fecha: 		03/08/2017
	@descripcion: 	SP para buscar registros en la tabla config_admin
	@autor: 		Griselda Medina Medina
	@cambios:

*/

	DECLARE lo_base_datos 		VARCHAR(55);
    DECLARE lo_id_empresa 		INT;
    -- DECLARE lo_count_base INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_config_admin_b';
	END ;

	SELECT
		DISTINCT(dba.nombre)
	INTO
		lo_base_datos
	FROM suite_mig_conf.st_adm_tr_grupo_empresa grup_empr
	JOIN suite_mig_conf.st_adm_tr_empresa emp ON
		grup_empr.id_empresa = emp.id_empresa
	JOIN suite_mig_conf.st_adm_tc_base_datos dba ON
		emp.id_base_datos = dba.id_base_datos
	WHERE grup_empr.id_grupo_empresa = pr_id_grupo_empresa;

    SELECT
		emp.id_empresa
	INTO
		lo_id_empresa
	FROM suite_mig_conf.st_adm_tr_grupo_empresa grup_empr
	JOIN suite_mig_conf.st_adm_tr_empresa emp ON
		grup_empr.id_empresa = emp.id_empresa
	WHERE grup_empr.id_grupo_empresa = pr_id_grupo_empresa;

	IF lo_base_datos IS NULL THEN
		SET pr_message = 'La empresa no esta asigna a una base';
    ELSE
		SET @query = CONCAT('
			SELECT
				em.id_empresa,
				em.id_direccion,
				em.rfc_sucursal,
				em.nom_empresa,
				em.telefono_empresa,
				em.email_empresa,
				em.comercial_empresa,
				em.usuarios,
				em.sucursales,
				em.outsoursing,
				dir.calle_direccion,
				pa.id_pais,
                pa.pais,
				dir.codigo_postal_direccion,
				dir.ciudad_direccion,
				dir.estado_direccion,
				dir.num_exterior_direccion,
				dir.num_interior_direccion,
				dir.colonia_direccion,
				dir.municipio_direccion,
				cnf.id_config_admin,
				cnf.id_empresa,
				cnf.inventario_bol_linea,
				cnf.notas_factura,
				cnf.inventario_bol_linea,
				cnf.notas_factura,
				cnf.unidad_negocio_obli,
				cnf.origen_venta_obli,
				cnf.cambios_clie_fijo,
				cnf.cambios_doc_serv,
				cnf.cambios_factura,
				cnf.desglose_impuesto,
				cnf.tipo_descu,
				cnf.limite_credito,
				cnf.ant_cl,
				cnf.multi_formato_imp,
				cnf.nc_fac_no_exist,
				cnf.nc_cambios,
				cnf.nc_valida_fac,
				cnf.unidad_negocio_obli,
				cnf.origen_venta_obli,
				cnf.cambios_clie_fijo,
				cnf.cambios_doc_serv,
                cnf.aviso_no_folios,
                cnf.forma_pago_folios,
				cnf.cambios_factura,
				cnf.desglose_impuesto,
				cnf.tipo_descu,
				cnf.limite_credito,
				cnf.ant_cl,
				cnf.multi_formato_imp,
				cnf.nc_fac_no_exist,
				cnf.nc_cambios,
				cnf.nc_valida_fac,
				cnf.cxcdven1,
				cnf.cxcdven2,
				cnf.cxcdven3,
				cnf.cxcdven4,
				cnf.cxcdven5,
				cnf.cxcdven6,
				cnf.cxpdven1,
				cnf.cxpdven2,
				cnf.cxpdven3,
				cnf.cxpdven4,
				cnf.cxpdven5,
				cnf.cxpdven6,
				cnf.enviar_bol_elect,
				cnf.incluir_bol,
				cnf.Incluir_pax,
				cnf.Incluir_pnr,
				cnf.Incluir_fecha_viaje,
				cnf.calculo_markup,
				cnf.logo_empresa,
				cnf.fecha_mod fecha_mod,
				concat(usuario.nombre_usuario," ",
				usuario.paterno_usuario) usuario_mod
			FROM st_adm_tr_empresa AS em
			JOIN st_adm_tc_direccion AS dir
				ON em.id_direccion = dir.id_direccion
			JOIN ',lo_base_datos,'.ct_glob_tc_pais AS pa
				ON dir.cve_pais = pa.cve_pais
			LEFT JOIN st_adm_tr_config_admin AS cnf
				ON em.id_empresa = cnf.id_empresa
			LEFT JOIN st_adm_tr_usuario usuario
				ON usuario.id_usuario = cnf.id_usuario
			WHERE em.id_empresa = ',lo_id_empresa,'
		');

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET pr_message     = 'SUCCESS';
    END IF;
END$$
DELIMITER ;
