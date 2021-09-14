DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_plan_comision_meta_c`(
	IN  pr_id_plan_comision    	   	INT,
    OUT pr_message 				    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_plan_comision_meta_c
	@fecha:			13/01/2017
	@descripcion:	Sp para consutla de la tabla cat_plan_comision_meta
	@autor: 		Griselda Medina Medina
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_plan_comision_meta_c';
	END ;

	SELECT
		plan_com_meta.id_plan_comision_meta,
		plan_com_meta.id_plan_comision,
        IFNULL(plan_com_meta.id_tipo_proveedor,'') id_tipo_proveedor,
        prov.cve_proveedor,
		tip_prov.desc_tipo_proveedor,
        IFNULL(plan_com_meta.id_proveedor,'') id_proveedor,
		prov.nombre_comercial,
        IFNULL(plan_com_meta.id_serivicio,'') id_servicio,
		serv.cve_servicio,
        serv.descripcion,
		plan_com_meta.prioridad,
		plan_com_meta.minima,
		plan_com_meta.tope,
		plan_com_meta.porc_monto,
		plan_com_meta.valor,
		plan_com_meta.forma,
		plan_com_meta.periodo,
		plan_com_meta.fecha_ini,
		plan_com_meta.fecha_fin,
		plan_com_meta.estatus
	FROM ic_cat_tr_plan_comision_meta plan_com_meta
	LEFT JOIN ic_cat_tr_plan_comision plan_com
		ON plan_com.id_plan_comision= plan_com_meta.id_plan_comision
	LEFT JOIN ic_cat_tc_tipo_proveedor tip_prov
		ON tip_prov.id_tipo_proveedor = plan_com_meta.id_tipo_proveedor
	LEFT JOIN ic_cat_tr_proveedor prov
		ON prov.id_proveedor= plan_com_meta.id_proveedor
	LEFT JOIN ic_cat_tc_servicio serv
		ON serv.id_servicio= plan_com_meta.id_serivicio
	WHERE plan_com_meta.id_plan_comision = pr_id_plan_comision
		AND plan_com_meta.estatus = 'ACTIVO'
	ORDER BY plan_com_meta.prioridad;


	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
