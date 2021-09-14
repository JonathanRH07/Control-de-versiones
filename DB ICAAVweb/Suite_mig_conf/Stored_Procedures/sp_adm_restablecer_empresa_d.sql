DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_restablecer_empresa_d`(
	IN  pr_id_grupo_empresa 	INT(11),
    OUT pr_message 	        	VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_restablecer_empresa_d
	@fecha: 		21/02/2020
	@descripcion: 	SP para eliminar registros de una empresa y dejarlas desde 0
    @author: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_restablecer_empresa_d';
        ROLLBACK;
	END;*/

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	SELECT
		CONCAT(nombre,'.')
	INTO
		@lo_base_datos
	FROM suite_mig_conf.st_adm_tr_empresa empresa
	JOIN suite_mig_conf.st_adm_tc_base_datos db ON
		empresa.id_base_datos = db.id_base_datos
	JOIN suite_mig_conf.st_adm_tr_grupo_empresa grupo ON
		empresa.id_empresa = grupo.id_empresa
	WHERE grupo.id_grupo_empresa = pr_id_grupo_empresa;


	/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    START TRANSACTION;

    /* CONFIGURACION */

    SET @query = CONCAT(
			'
			DELETE a.* FROM ic_adm_tr_ctrl_cambios a JOIN st_adm_tr_usuario b ON a.id_usuario = b.id_usuario WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';','
			DELETE FROM st_adm_tc_role WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';','
			DELETE FROM st_adm_tr_alertas WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';','
			DELETE a.* FROM st_adm_tr_alertas_usuarios a JOIN st_adm_tr_alertas b ON a.id_alerta = b.id_alertas WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';','
			DELETE a.* FROM st_adm_tr_usuario_recuperacion a JOIN st_adm_tr_usuario b ON a.id_usuario = b.id_usuario WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';','
			DELETE FROM st_adm_tr_notificaciones WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';');

    SELECT @query;
    PREPARE stmt FROM @query;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


    /* TRANSACCIONAL */
    SET @query2 = CONCAT(
			'
            DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_factura_cfdi a JOIN ',@lo_base_datos,'ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_factura_cfdi_relacionados a JOIN ',@lo_base_datos,'ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_glob_tr_cxc_detalle a JOIN ',@lo_base_datos,'ic_glob_tr_cxc b ON a.id_cxc = b.id_cxc WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_glob_tr_cxc WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_documento_servicio a JOIN ',@lo_base_datos,'ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_fac_tc_grupo_fit WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_fac_tr_debito WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_factura_detalle_imp a JOIN ',@lo_base_datos,'ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ',@lo_base_datos,'ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_factura_detalle a JOIN ',@lo_base_datos,'ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_factura_forma_pago a JOIN ',@lo_base_datos,'ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_fac_tr_factura WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_fac_tr_folios WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_fac_tr_folios_historico WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_fac_tr_folios_historico_uso_mensual WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_pagos_cfdi a JOIN ',@lo_base_datos,'ic_fac_tr_pagos b ON a.id_pago = b.id_pago WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_pagos_detalle a JOIN ',@lo_base_datos,'ic_fac_tr_pagos b ON a.id_pago = b.id_pago WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';
            DELETE FROM ',@lo_base_datos,'ic_fac_tr_pagos WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_gds_tr_autos a JOIN ',@lo_base_datos,'ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ',@lo_base_datos,'ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_gds_tr_hoteles a JOIN ',@lo_base_datos,'ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ',@lo_base_datos,'ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_gds_tr_vuelos a JOIN ',@lo_base_datos,'ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ',@lo_base_datos,'ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_glob_tr_boleto WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_glob_tr_ctrl_cambios a JOIN suite_mig_conf.st_adm_tr_usuario b ON a.id_usuario = b.id_usuario WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_glob_tr_inventario_boletos WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_fac_tr_anticipos WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_anticipos_aplicacion a JOIN ',@lo_base_datos,'ic_fac_tr_anticipos b ON a.id_anticipos = b.id_anticipos WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_fac_tr_compras_x_servicio WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_factura_analisis a JOIN ',@lo_base_datos,'ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_fac_tr_factura_ine_complemento a JOIN ',@lo_base_datos,'ic_fac_tr_factura b ON a.id_factura = b.id_factura WHERE b.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_gds_tr_general WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_gds_tr_analisis a JOIN ',@lo_base_datos,'ic_gds_tr_general b ON a.id_gds_general = b.id_gds_generall WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_gds_tr_cupon a JOIN ',@lo_base_datos,'ic_fac_tr_factura_detalle b  ON a.id_factura_detalle = b.id_factura_detalle JOIN ',@lo_base_datos,'ic_fac_tr_factura c ON b.id_factura = c.id_factura WHERE c.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_gds_tr_errores a JOIN ',@lo_base_datos,'ic_gds_tr_general b ON a.id_gds_general = b.id_gds_generall WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_gds_tr_vuelos_citypair a JOIN ',@lo_base_datos,'ic_gds_tr_vuelos b ON a.id_gds_vuelos = b.id_gds_vuelos JOIN ',@lo_base_datos,'ic_fac_tr_factura_detalle c ON b.id_factura_detalle = c.id_factura_detalle JOIN ',@lo_base_datos,'ic_fac_tr_factura d ON c.id_factura = d.id_factura WHERE d.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE a.* FROM ',@lo_base_datos,'ic_gds_tr_vuelos_segmento a JOIN ',@lo_base_datos,'ic_gds_tr_vuelos b ON a.id_gds_vuelos = b.id_gds_vuelos JOIN ',@lo_base_datos,'ic_fac_tr_factura_detalle c ON b.id_factura_detalle = c.id_factura_detalle JOIN ',@lo_base_datos,'ic_fac_tr_factura d ON c.id_factura = d.id_factura WHERE d.id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_rep_tr_acumulado_aerolinea WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_rep_tr_acumulado_cliente WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_rep_tr_acumulado_pagos WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_rep_tr_acumulado_pagos_detalle WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_rep_tr_acumulado_proveedor WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_rep_tr_acumulado_servicio WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_rep_tr_acumulado_sucursal WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_rep_tr_acumulado_tipo_proveedor WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';
			DELETE FROM ',@lo_base_datos,'ic_rep_tr_acumulado_vendedor WHERE id_grupo_empresa = ',pr_id_grupo_empresa,';');

	SELECT @query2;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */



	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
    COMMIT;
END$$
DELIMITER ;
