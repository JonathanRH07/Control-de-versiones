DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_admin_i`(
	IN  pr_id_empresa 				INT(11),
	IN  pr_inventario_bol_linea 	CHAR(1) ,
	IN  pr_notas_factura 			VARCHAR(255),
	IN  pr_unidad_negocio_obli 		CHAR(1),
	IN  pr_origen_venta_obli 		CHAR(1),
	IN  pr_cambios_clie_fijo 		CHAR(1),
	IN  pr_cambios_doc_serv 		CHAR(1),
	IN  pr_cambios_factura 			CHAR(1),
	IN  pr_desglose_impuesto 		CHAR(1),
	IN  pr_tipo_descu 				CHAR(1),
	IN  pr_limite_credito 			CHAR(1),
	IN  pr_ant_cl 					CHAR(1),
	IN  pr_multi_formato_imp 		CHAR(1),
	IN  pr_nc_fac_no_exist 			CHAR(1),
	IN  pr_nc_cambios 				CHAR(1),
	IN  pr_nc_valida_fac 			CHAR(1),
	IN  pr_cxcdven1 				TINYINT(4),
	IN  pr_cxcdven2 				TINYINT(4),
	IN  pr_cxcdven3 				TINYINT(4),
	IN  pr_cxcdven4 				TINYINT(4),
	IN  pr_cxcdven5 				TINYINT(4),
	IN  pr_cxcdven6 				TINYINT(4),
	IN  pr_cxpdven1 				TINYINT(4),
	IN  pr_cxpdven2 				TINYINT(4),
	IN  pr_cxpdven3 				TINYINT(4),
	IN  pr_cxpdven4 				TINYINT(4),
	IN  pr_cxpdven5 				TINYINT(4),
	IN  pr_cxpdven6 				TINYINT(4),
	IN  pr_enviar_bol_elect 		CHAR(1),
	IN  pr_incluir_bol 				CHAR(1),
	IN  pr_incluir_pax 				CHAR(1),
	IN  pr_incluir_pnr 				CHAR(1),
	IN  pr_incluir_fecha_viaje 		CHAR(1),
	IN  pr_calculo_markup 			CHAR(1),
    IN  pr_id_usuario 				INT(11),
    IN  pr_logo_empresa				VARCHAR(500),
    IN  pr_aviso_no_folios			INT,
    IN 	pr_centro_costos_obli		CHAR(1),
    -- IN  pr_forma_pago_folios		ENUM('CREDITO','PREPAGO'),
    OUT pr_inserted_id				INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_config_admin_i
	@fecha: 		03/08/2017
	@descripcion: 	SP para insertar registros en la tabla config_admin
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_adm_config_admin_i';
        SET pr_affect_rows = 0;
	END;


	INSERT INTO  suite_mig_conf.st_adm_tr_config_admin(
		id_empresa,
		inventario_bol_linea,
		notas_factura,
		unidad_negocio_obli,
		origen_venta_obli,
		cambios_clie_fijo,
		cambios_doc_serv,
		cambios_factura,
		desglose_impuesto,
		tipo_descu,
		limite_credito,
		ant_cl,
		multi_formato_imp,
		nc_fac_no_exist,
		nc_cambios,
		nc_valida_fac,
		cxcdven1,
		cxcdven2,
		cxcdven3,
		cxcdven4,
		cxcdven5,
		cxcdven6,
		cxpdven1,
		cxpdven2,
		cxpdven3,
		cxpdven4,
		cxpdven5,
		cxpdven6,
		enviar_bol_elect,
		incluir_bol,
		incluir_pax ,
		incluir_pnr,
		incluir_fecha_viaje,
		calculo_markup,
        id_usuario,
        logo_empresa,
        aviso_no_folios,
		centro_costos_obli
		-- forma_pago_folios
		)
	VALUE
		(
		pr_id_empresa,
		pr_inventario_bol_linea,
		pr_notas_factura,
		pr_unidad_negocio_obli,
		pr_origen_venta_obli,
		pr_cambios_clie_fijo,
		pr_cambios_doc_serv,
		pr_cambios_factura,
		pr_desglose_impuesto,
		pr_tipo_descu,
		pr_limite_credito,
		pr_ant_cl,
		pr_multi_formato_imp,
		pr_nc_fac_no_exist,
		pr_nc_cambios,
		pr_nc_valida_fac,
		pr_cxcdven1,
		pr_cxcdven2,
		pr_cxcdven3,
		pr_cxcdven4,
		pr_cxcdven5,
		pr_cxcdven6,
		pr_cxpdven1,
		pr_cxpdven2,
		pr_cxpdven3,
		pr_cxpdven4,
		pr_cxpdven5,
		pr_cxpdven6,
		pr_enviar_bol_elect,
		pr_incluir_bol,
		pr_incluir_pax ,
		pr_incluir_pnr,
		pr_incluir_fecha_viaje,
		pr_calculo_markup,
        pr_id_usuario,
        pr_logo_empresa,
		pr_aviso_no_folios,
        pr_centro_costos_obli
		-- pr_forma_pago_folios
		);


	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';
END$$
DELIMITER ;
