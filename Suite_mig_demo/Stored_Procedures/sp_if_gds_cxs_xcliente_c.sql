DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_gds_cxs_xcliente_c`(IN  pr_id_cliente 			INT(11),
	IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_referencia 			VARCHAR(10),
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_if_gds_cxs_xcliente_c
	@fecha: 		31/01/2018
	@descripción:
	@autor : 		Griselda Medina Medina.
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_gds_cxs_xcliente_c';
	END ;

    IF pr_id_cliente > 0 AND pr_id_grupo_empresa > 0 AND pr_referencia != '' THEN
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
            cli.importe,
            ser.descripcion,
            pag.cve_forma_pago,
            pag.id_tipo_forma_pago
		FROM
			ic_gds_tr_cxs_xcliente cli
		INNER JOIN ic_gds_tr_cxs cxs ON
			cxs.id_gds_cxs = cli.id_gds_cxs
		JOIN ic_cat_tc_servicio ser ON
			ser.id_servicio = cxs.id_servicio
		JOIN ic_glob_tr_forma_pago pag ON
			pag.id_forma_pago = cxs.id_forma_pago
		WHERE cxs.id_grupo_empresa=pr_id_grupo_empresa
		AND cli.id_cliente=pr_id_cliente
        AND cxs.referencia=pr_referencia;
	ELSEIF pr_id_cliente > 0  AND pr_id_grupo_empresa > 0 THEN
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
            cli.importe,
            ser.descripcion,
            pag.cve_forma_pago,
            pag.id_tipo_forma_pago
		FROM
			ic_gds_tr_cxs_xcliente cli
		INNER JOIN ic_gds_tr_cxs cxs ON
			cxs.id_gds_cxs = cli.id_gds_cxs
		JOIN ic_cat_tc_servicio ser ON
			ser.id_servicio = cxs.id_servicio
		JOIN ic_glob_tr_forma_pago pag ON
			pag.id_forma_pago = cxs.id_forma_pago
		WHERE cxs.id_grupo_empresa=pr_id_grupo_empresa
		AND cli.id_cliente=pr_id_cliente;
	END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
