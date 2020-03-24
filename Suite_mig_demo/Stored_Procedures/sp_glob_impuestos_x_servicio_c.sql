DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_impuestos_x_servicio_c`(
	IN  pr_id_servicio			INT,
    IN  pr_id_grupo_empresa		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN

/*
	@nombre:		sp_glob_impuestos_x_servicio_c
	@fecha: 		2017/03/08
	@descripción: 	Sp para obtenber los impuestos por servicio.
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_glob_impuestos_x_servicio_c';
	END ;

	SELECT
		serv_imp.id_servicio_impuesto,
		serv_imp.id_servicio,
        imp.desc_impuesto descripcion,
		serv_imp.id_impuesto,
        imp.cve_impuesto,
        imp.tipo_valor_impuesto,
        imp.valor_impuesto,
        imp.por_pagar_impuesto,
		serv_imp.estatus
	FROM
		ic_fac_tr_servicio_impuesto serv_imp
	INNER JOIN ic_cat_tr_impuesto imp
		ON imp.id_impuesto = serv_imp.id_impuesto
	INNER JOIN ic_cat_tc_servicio serv
		ON serv.id_servicio= serv_imp.id_servicio
	WHERE
		serv_imp.estatus = 1
        AND serv_imp.id_servicio= pr_id_servicio;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
