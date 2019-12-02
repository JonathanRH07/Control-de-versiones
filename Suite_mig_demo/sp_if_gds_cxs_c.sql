DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_cxs_c`(
    IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_referencia			VARCHAR(10),
    IN  pr_cve_producto			VARCHAR(2),
    IN  pr_alcance				ENUM('NACIONAL','INTERNACIONAL'),
    IN  pr_forma_pago_gds 		CHAR(2),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_gds_cxs_c
	@fecha: 		24/01/2018
	@descripción: 	Procedimiento que permite seleccionar informacion de la tabla ic_gds_tr_cxs
	@autor : 		Griselda Medina Medina.
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_cxs_c';
	END ;

	IF pr_cve_producto != '' AND pr_id_grupo_empresa > 0 AND pr_alcance != '' AND pr_forma_pago_gds != '' THEN
		SELECT
			cxs.id_proveedor,
            cxs.id_servicio,
            cxs.id_serie,
            cxs.id_forma_pago,
            cxs.referencia,
            cxs.incluye_impuesto,
            cxs.automatico,
            cxs.forma_pago_gds,
            cxs.en_otra_serie,
            cxs.importe,
            ser.descripcion,
            pag.cve_forma_pago,
            pag.id_tipo_forma_pago
		FROM
			ic_gds_tr_cxs cxs
		JOIN ic_cat_tc_servicio ser ON
			ser.id_servicio = cxs.id_servicio
		JOIN ic_glob_tr_forma_pago pag ON
			pag.id_forma_pago = cxs.id_forma_pago
		JOIN ic_cat_tc_producto pro ON
			pro.id_producto = cxs.id_producto
		WHERE cxs.id_grupo_empresa = pr_id_grupo_empresa
        AND cxs.automatico='S'
		AND pro.cve_producto=pr_cve_producto
        AND cxs.forma_pago_gds=pr_forma_pago_gds
        AND cxs.alcance=pr_alcance;

	ELSEIF  pr_id_grupo_empresa > 0  AND pr_referencia != '' THEN
		SELECT
			cxs.id_proveedor,
            cxs.id_servicio,
            cxs.id_serie,
            cxs.id_forma_pago,
            cxs.referencia,
            cxs.incluye_impuesto,
            cxs.automatico,
            cxs.forma_pago_gds,
            cxs.en_otra_serie,
            cxs.importe,
            ser.descripcion,
            pag.cve_forma_pago,
            pag.id_tipo_forma_pago
		FROM
			ic_gds_tr_cxs cxs
		JOIN ic_cat_tc_servicio ser ON
			ser.id_servicio = cxs.id_servicio
		JOIN ic_glob_tr_forma_pago pag ON
			pag.id_forma_pago = cxs.id_forma_pago
		WHERE cxs.id_grupo_empresa = pr_id_grupo_empresa
		AND cxs.referencia=pr_referencia;
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
