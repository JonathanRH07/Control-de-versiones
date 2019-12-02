DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_imp_serv_b`(
	IN  pr_id_grupo_empresa 		INT,
	IN  pr_in_id_prove_servicio		VARCHAR(100),
	OUT pr_message					VARCHAR(5000)
    )
BEGIN
	/*
		@nombre:		sp_fac_prove_servicio_c
		@fecha:			09/03/2017
		@descripcion:	Consulta registros se prov_imp_sev
		@autor:			Griselda Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_imp_serv_b';
	END ;

	SET @query = CONCAT('
			SELECT
				T2.id_servicio,
				T2.id_proveedor,
				T1.*,
				IMP.desc_impuesto descripcion,
				IMP.cve_impuesto,
				IMP.cve_impuesto_cat,
				sat_impuestos.c_Impuesto,
				imp_prov_uni.c_ClaveProdServ,
				-- IMP.c_ClaveProdServ,
				sat_unidad.c_ClaveUnidad,
				sat_unidad.nombre sat_unidad_nombre,
				IMP.clase,
				IMP.tipo
			FROM ic_fac_tr_prove_imp_serv T1
			INNER JOIN ic_fac_tr_prove_servicio T2 ON
				T2.id_prove_servicio = T1.id_prove_servicio
			INNER JOIN ic_cat_tr_impuesto IMP ON
				IMP.id_impuesto= T1.id_impuesto
			LEFT JOIN sat_impuestos ON
				sat_impuestos.descripcion = IMP.cve_impuesto_cat
			LEFT JOIN ic_cat_tr_impuesto_provee_unidad imp_prov_uni ON
				IMP.id_impuesto = imp_prov_uni.id_impuesto AND
				imp_prov_uni.id_grupo_empresa = ',pr_id_grupo_empresa,'
			LEFT JOIN sat_unidades_medida sat_unidad ON
				sat_unidad.id_unidad = imp_prov_uni.id_unidad
			WHERE T1.id_prove_servicio IN (',pr_in_id_prove_servicio,')
	');

    #SELECT @query;

    PREPARE stmt FROM @query;
	EXECUTE stmt;

	SET pr_message	= 'SUCCESS';
END$$
DELIMITER ;
