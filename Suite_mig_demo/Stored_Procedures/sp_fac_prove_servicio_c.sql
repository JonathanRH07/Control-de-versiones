DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_prove_servicio_c`(
	IN  pr_id_proveedor 	INT(11),
	OUT pr_affect_rows		INT,
	OUT pr_message			VARCHAR(5000))
BEGIN
	/*
		@nombre:		sp_fac_prove_servicio_c
		@fecha:			09/01/2017
		@descripcion:	SP para consultar registros en prove_servicio
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_prove_servicio_c';
	END ;

	SELECT
		prov_serv.id_prove_servicio,
		prov_serv.id_proveedor,
		prov.nombre_comercial,
		prov_serv.id_servicio,
		serv.descripcion,
        serv.cve_servicio,
        serv.id_unidad_medida,
        unidades.c_ClaveUnidad,
        serv.c_ClaveProdServ,
        prov_serv.id_impuesto,
        prov_serv.id_aerolinea,
        prov_serv.comision,
        prov_serv.tipo_valor_comision,
        prov_serv.margen,
        prov_serv.tipo_valor_margen,
        sat.descripcion descripcion_sat,
        unidades.cve_unidad_medida,
        prod.cve_producto,
        airline.nombre_aerolinea
	FROM ic_fac_tr_prove_servicio prov_serv
	INNER JOIN ic_cat_tc_servicio serv ON
		serv.id_servicio = prov_serv.id_servicio
	INNER JOIN ic_cat_tr_proveedor prov ON
		prov.id_proveedor = prov_serv.id_proveedor
	AND prov_serv.id_proveedor = pr_id_proveedor
    INNER JOIN sat_productos_servicios sat ON
		serv.c_ClaveProdServ = sat.c_ClaveProdServ
	LEFT JOIN ic_cat_tc_unidad_medida unidades ON
		serv.id_unidad_medida = unidades.id_unidad_medida
	LEFT JOIN ic_cat_tc_producto prod ON
		serv.id_producto = prod.id_producto
	LEFT JOIN ct_glob_tc_aerolinea airline ON
		prov_serv.id_aerolinea = airline.id_aerolinea
    WHERE serv.estatus = 'ACTIVO';

	SET @pr_rows_tot_table=(SELECT
								COUNT(*)
							FROM ic_fac_tr_prove_servicio prov_serv
							INNER JOIN ic_cat_tc_servicio serv ON
								serv.id_servicio = prov_serv.id_servicio
							INNER JOIN ic_cat_tr_proveedor prov ON
								prov.id_proveedor = prov_serv.id_proveedor
							AND prov_serv.id_proveedor=pr_id_proveedor
                            INNER JOIN sat_productos_servicios sat ON
								serv.c_ClaveProdServ = sat.c_ClaveProdServ
                            LEFT JOIN ic_cat_tc_unidad_medida unidades ON
								serv.id_unidad_medida = unidades.id_unidad_medida
                            LEFT JOIN ic_cat_tc_producto prod ON
								serv.id_producto = prod.id_producto
                            WHERE serv.estatus = 'ACTIVO'
	);

	SET pr_affect_rows = @pr_rows_tot_table;
	SET pr_message	= 'SUCCESS';
END$$
DELIMITER ;
