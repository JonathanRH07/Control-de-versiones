DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_plan_comision_fac_c`(
	IN  pr_id_plan_comision    	   	INT,
    OUT pr_message 				    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_plan_comision_fac_c
	@fecha:			13/01/2017
	@descripcion:	Sp para consutla de la tabla cat_plan_comision_fac
	@autor: 		Griselda Medina Medina
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_plan_comision_fac_c';
	END ;

	SELECT
		id_plan_comision_fac,
		plan_com_fac.id_plan_comision,
        #(select case when plan_com_fac.id_tipo_proveedor=NULL THEN '' ELSE plan_com_fac.id_tipo_proveedor END)id_tipo_proveedor,
        IFNULL(plan_com_fac.id_tipo_proveedor,'') id_tipo_proveedor,
		tip_prov.desc_tipo_proveedor,
        IFNULL(plan_com_fac.id_proveedor,'') id_proveedor,
		prov.nombre_comercial,
        prov.cve_proveedor,
        IFNULL(plan_com_fac.id_serivicio,'') id_servicio,
		IFNULL(serv.descripcion,'')descripcion,
        serv.cve_servicio,
		plan_com_fac.prioridad,
		plan_com_fac.tipo,
		plan_com_fac.porc_monto,
		plan_com_fac.valor,
		plan_com_fac.fecha_ini,
		plan_com_fac.fecha_fin,
		plan_com_fac.estatus
	FROM ic_cat_tr_plan_comision_fac plan_com_fac
	INNER JOIN ic_cat_tr_plan_comision plan_com
		ON plan_com.id_plan_comision= plan_com_fac.id_plan_comision
	LEFT JOIN ic_cat_tc_tipo_proveedor tip_prov
		ON tip_prov.id_tipo_proveedor = plan_com_fac.id_tipo_proveedor
	LEFT JOIN ic_cat_tr_proveedor prov
		ON prov.id_proveedor= plan_com_fac.id_proveedor
	LEFT JOIN ic_cat_tc_servicio serv
		ON serv.id_servicio= plan_com_fac.id_serivicio
	WHERE plan_com_fac.id_plan_comision = pr_id_plan_comision
		AND plan_com_fac.estatus = 'ACTIVO'
	ORDER BY plan_com_fac.prioridad;


	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
