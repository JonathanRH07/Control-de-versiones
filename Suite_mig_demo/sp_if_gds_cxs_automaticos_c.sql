DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_cxs_automaticos_c`(
	IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_referencia			VARCHAR(10),
    IN  pr_cve_producto			VARCHAR(2),
    IN  pr_alcance				ENUM('NACIONAL','INTERNACIONAL'),
    IN  pr_forma_pago_gds 		CHAR(2),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_gds_cxs_automaticos_c
	@fecha: 		31/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_cxs_automaticos_c';
	END ;


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
		LEFT JOIN  ic_cat_tc_producto pro ON
			pro.id_producto = cxs.id_producto
		WHERE cxs.id_grupo_empresa = pr_id_grupo_empresa
        AND cxs.automatico='S'
        AND (pro.cve_producto=pr_cve_producto OR cxs.id_producto IS NULL)
        AND (cxs.forma_pago_gds=pr_forma_pago_gds OR cxs.forma_pago_gds = 'BO')
        AND (cxs.alcance=pr_alcance OR cxs.alcance = 'TODOS');

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
