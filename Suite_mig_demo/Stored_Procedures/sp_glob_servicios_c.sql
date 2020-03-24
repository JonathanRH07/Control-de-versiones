DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_servicios_c`(
	IN  pr_id_grupo_empresa 	INT,
    IN  pr_id_prove				VARCHAR(5),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_servicios_c
	@fecha: 		20/01/2017
	@descripción: 	Sp para obtener registros de servicios.
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_servicios_c';
	END ;

	IF pr_id_prove = '' THEN
		SELECT
			serv.*,
            unidad.cve_unidad_medida,
            unidad.c_ClaveUnidad,
            prov_serv.id_prove_servicio,
			prov_serv.id_proveedor,
            prov_serv.id_aerolinea,
            prov_serv.comision,
            prov_serv.id_impuesto,
            imp.valor_impuesto,
            imp.tipo_valor_impuesto,
			prov_serv.tipo_valor_comision,
			prov_serv.margen,
			prov_serv.tipo_valor_margen,
            prod.cve_producto,
            airline.nombre_aerolinea,
            airline.clave_aerolinea
		FROM ic_fac_tr_prove_servicio prov_serv
		INNER JOIN ic_cat_tc_servicio serv ON
			serv.id_servicio = prov_serv.id_servicio
		LEFT JOIN ic_cat_tc_unidad_medida unidad ON
			serv.id_unidad_medida = unidad.id_unidad_medida
		LEFT JOIN ic_cat_tc_producto prod ON
			serv.id_producto = prod.id_producto
		LEFT JOIN ic_cat_tr_impuesto imp ON
			prov_serv.id_impuesto = imp.id_impuesto
		LEFT JOIN ct_glob_tc_aerolinea airline ON
			prov_serv.id_aerolinea = airline.id_aerolinea
		WHERE serv.id_grupo_empresa = pr_id_grupo_empresa
		AND serv.estatus = 1;
	ELSE
		SELECT
			serv.*,
            unidad.cve_unidad_medida,
            unidad.c_ClaveUnidad,
            prov_serv.id_prove_servicio,
			prov_serv.id_proveedor,
            prov_serv.id_aerolinea,
            prov_serv.comision,
            prov_serv.id_impuesto,
            imp.valor_impuesto,
            imp.tipo_valor_impuesto,
			prov_serv.tipo_valor_comision,
			prov_serv.margen,
			prov_serv.tipo_valor_margen,
            prod.cve_producto,
            airline.nombre_aerolinea,
            airline.clave_aerolinea
		FROM
			ic_cat_tc_servicio serv
		INNER JOIN  ic_fac_tr_prove_servicio prov_serv ON
			prov_serv.id_servicio= serv.id_servicio
		LEFT JOIN ic_cat_tc_unidad_medida unidad ON
			serv.id_unidad_medida = unidad.id_unidad_medida
		LEFT JOIN ic_cat_tc_producto prod ON
			serv.id_producto = prod.id_producto
		LEFT JOIN ic_cat_tr_impuesto imp ON
			prov_serv.id_impuesto = imp.id_impuesto
		LEFT JOIN ct_glob_tc_aerolinea airline ON
			prov_serv.id_aerolinea = airline.id_aerolinea
		WHERE serv.id_grupo_empresa  = pr_id_grupo_empresa
        AND prov_serv.id_proveedor = pr_id_prove
		AND serv.estatus = 1;
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
