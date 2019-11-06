DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_admin_u`(
	IN  pr_id_config_admin 			INT(11),
	IN  pr_id_empresa				INT(11),
	IN  pr_inventario_bol_linea		CHAR(1),
	IN  pr_notas_factura			VARCHAR(255),
	IN  pr_unidad_negocio_obli		CHAR(1),
	IN  pr_origen_venta_obli		CHAR(1),
	IN  pr_cambios_clie_fijo		CHAR(1),
	IN  pr_cambios_doc_serv			CHAR(1),
	IN  pr_cambios_factura			CHAR(1),
	IN  pr_desglose_impuesto		CHAR(1),
	IN  pr_tipo_descu				CHAR(1),
	IN  pr_limite_credito			CHAR(1),
	IN  pr_ant_cl					CHAR(1),
	IN  pr_multi_formato_imp		CHAR(1),
	IN  pr_nc_fac_no_exist			CHAR(1),
	IN  pr_nc_cambios				CHAR(1),
	IN  pr_nc_valida_fac			CHAR(1),
	IN  pr_cxcdven1					TINYINT(4),
	IN  pr_cxcdven2					TINYINT(4),
	IN  pr_cxcdven3					TINYINT(4),
	IN  pr_cxcdven4					TINYINT(4),
	IN  pr_cxcdven5					TINYINT(4),
	IN  pr_cxcdven6					TINYINT(4),
	IN  pr_cxpdven1					TINYINT(4),
	IN  pr_cxpdven2					TINYINT(4),
	IN  pr_cxpdven3					TINYINT(4),
	IN  pr_cxpdven4					TINYINT(4),
	IN  pr_cxpdven5					TINYINT(4),
	IN  pr_cxpdven6					TINYINT(4),
	IN  pr_enviar_bol_elect 		CHAR(1),
	IN  pr_incluir_bol				CHAR(1),
	IN  pr_Incluir_pax				CHAR(1),
	IN  pr_Incluir_pnr				CHAR(1),
	IN  pr_Incluir_fecha_viaje		CHAR(1),
	IN  pr_estatus					ENUM('ACTIVO','INACTIVO'),
    IN  pr_calculo_markup			CHAR(1),
	IN  pr_id_usuario				INT(11),
    IN  pr_logo_empresa				VARCHAR(500),
	IN	pr_aviso_no_folios			VARCHAR(20),
    -- IN  pr_forma_pago_folios		ENUM('CREDITO','PREPAGO'),
    OUT pr_affect_rows				INT,
	OUT pr_message					VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_adm_config_admin_u
		@fecha:			21/03/2017
		@descripcion:   SP para actualizar registro en la tabla st_adm_tr_config_admin.
		@autor:			Griselda Medina Medina
		@cambios:
	*/
    DECLARE  lo_id_config_admin         VARCHAR(1000) DEFAULT '';
	DECLARE  lo_id_empresa				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_inventario_bol_linea	VARCHAR(1000) DEFAULT '';
	DECLARE  lo_notas_factura			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_unidad_negocio_obli		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_origen_venta_obli		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cambios_clie_fijo		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cambios_doc_serv		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cambios_factura			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_desglose_impuesto		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_tipo_descu				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_limite_credito			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_ant_cl					VARCHAR(1000) DEFAULT '';
	DECLARE  lo_multi_formato_imp		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nc_fac_no_exist			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nc_cambios				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nc_valida_fac			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxcdven1				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxcdven2				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxcdven3				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxcdven4				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxcdven5				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxcdven6				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxpdven1				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxpdven2				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxpdven3				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxpdven4				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxpdven5				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_cxpdven6				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_enviar_bol_elect		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_incluir_bol				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_Incluir_pax				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_Incluir_pnr				VARCHAR(1000) DEFAULT '';
	DECLARE  lo_Incluir_fecha_viaje		VARCHAR(1000) DEFAULT '';
	DECLARE  lo_estatus					VARCHAR(1000) DEFAULT '';
    DECLARE  lo_calculo_markup          VARCHAR(1000) DEFAULT '';
	DECLARE  lo_id_usuario				VARCHAR(1000) DEFAULT '';
    DECLARE  lo_logo_empresa			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_aviso_no_folios			VARCHAR(1000) DEFAULT '';
    -- DECLARE  lo_forma_pago_folios		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_adm_config_admin_u';
		SET pr_affect_rows = 0;
	END;

	IF pr_id_config_admin > 0  THEN
		SET lo_id_config_admin = CONCAT(' id_empresa= "', pr_id_config_admin, '",');
	END IF;

	IF pr_id_empresa > 0  THEN
		SET lo_id_empresa = CONCAT(' id_empresa= "', pr_id_empresa, '",');
	END IF;

	IF pr_inventario_bol_linea  > ''  THEN
		SET lo_inventario_bol_linea = CONCAT(' inventario_bol_linea= "', pr_inventario_bol_linea, '",');
	END IF;

	IF pr_notas_factura > ''  THEN
		SET lo_notas_factura = CONCAT(' notas_factura= "', pr_notas_factura, '",');
	END IF;

	IF pr_unidad_negocio_obli > ''  THEN
		SET lo_unidad_negocio_obli = CONCAT(' unidad_negocio_obli= "', pr_unidad_negocio_obli, '",');
	END IF;

	IF pr_origen_venta_obli > ''  THEN
		SET lo_origen_venta_obli = CONCAT(' origen_venta_obli= "', pr_origen_venta_obli, '",');
	END IF;

	IF pr_cambios_clie_fijo > ''  THEN
		SET lo_cambios_clie_fijo = CONCAT(' cambios_clie_fijo= "', pr_cambios_clie_fijo, '",');
	END IF;

	IF pr_cambios_doc_serv > ''  THEN
		SET lo_cambios_doc_serv = CONCAT(' cambios_doc_serv= "', pr_cambios_doc_serv, '",');
	END IF;

	IF pr_cambios_factura > ''  THEN
		SET lo_cambios_factura = CONCAT(' cambios_factura= "', pr_cambios_factura, '",');
	END IF;

	IF pr_desglose_impuesto > ''  THEN
		SET lo_desglose_impuesto = CONCAT(' desglose_impuesto= "', pr_desglose_impuesto, '",');
	END IF;

	IF pr_tipo_descu > 0  THEN
		SET lo_tipo_descu = CONCAT(' tipo_descu= "', pr_tipo_descu, '",');
	END IF;

	IF pr_limite_credito > 0  THEN
		SET lo_limite_credito = CONCAT(' limite_credito= "', pr_limite_credito, '",');
	END IF;

	IF pr_ant_cl > 0 THEN
		SET lo_ant_cl = CONCAT(' ant_cl= "', pr_ant_cl, '",');
	END IF;

	IF pr_multi_formato_imp > '' THEN
		SET lo_multi_formato_imp = CONCAT(' multi_formato_imp= "', pr_multi_formato_imp, '",');
	END IF;

	IF pr_nc_fac_no_exist > '' THEN
		SET lo_nc_fac_no_exist = CONCAT(' nc_fac_no_exist= "', pr_nc_fac_no_exist, '",');
	END IF;

	IF pr_nc_cambios > '' THEN
		SET lo_nc_cambios = CONCAT(' nc_cambios= "', pr_nc_cambios, '",');
	END IF;

	IF pr_nc_valida_fac > '' THEN
		SET lo_nc_valida_fac = CONCAT(' nc_valida_fac= "', pr_nc_valida_fac, '",');
	END IF;

	IF pr_cxcdven1 = '' THEN
		SET lo_cxcdven1 = CONCAT(' cxcdven1= 7,');
	ELSE
		SET lo_cxcdven1 = CONCAT(' cxcdven1= "', pr_cxcdven1, '",');
	END IF;

	IF pr_cxcdven2 = '' THEN
		SET lo_cxcdven2 = CONCAT(' cxcdven2= 14,');
	ELSE
		SET lo_cxcdven2 = CONCAT(' cxcdven2= "', pr_cxcdven2, '",');
	END IF;

	IF pr_cxcdven3 = '' THEN
		SET lo_cxcdven3 = CONCAT(' cxcdven3= 21,');
	ELSE
		SET lo_cxcdven3 = CONCAT(' cxcdven3= "', pr_cxcdven3, '",');
	END IF;

	IF pr_cxcdven4 = '' THEN
		SET lo_cxcdven4 = CONCAT(' cxcdven4= 28,');
	ELSE
		SET lo_cxcdven4 = CONCAT(' cxcdven4= "', pr_cxcdven4, '",');
	END IF;

	IF pr_cxcdven5 > 0 THEN
		SET lo_cxcdven5 = CONCAT(' cxcdven5= "', pr_cxcdven5, '",');
	END IF;

	IF pr_cxcdven6 > 0 THEN
		SET lo_cxcdven6 = CONCAT(' cxcdven6= "', pr_cxcdven6, '",');
	END IF;

	IF pr_cxpdven1 > 0 THEN
		SET lo_cxpdven1 = CONCAT(' cxpdven1= "', pr_cxpdven1, '",');
	END IF;

	IF pr_cxpdven2 > 0 THEN
		SET lo_cxpdven2 = CONCAT(' cxpdven2= "', pr_cxpdven2, '",');
	END IF;

	IF pr_cxpdven3 > 0 THEN
		SET lo_cxpdven3 = CONCAT(' cxpdven3= "', pr_cxpdven3, '",');
	END IF;

	IF pr_cxpdven4 > 0 THEN
		SET lo_cxpdven4 = CONCAT(' cxpdven4= "', pr_cxpdven4, '",');
	END IF;

	IF pr_cxpdven5 > 0 THEN
		SET lo_cxpdven5 = CONCAT(' cxpdven5= "', pr_cxpdven5, '",');
	END IF;

	IF pr_cxpdven6 > 0 THEN
		SET lo_cxpdven6 = CONCAT(' cxpdven6= "', pr_cxpdven6, '",');
	END IF;

	IF pr_enviar_bol_elect != '' THEN
		SET lo_enviar_bol_elect = CONCAT(' enviar_bol_elect= "', pr_enviar_bol_elect, '",');
	END IF;

	IF pr_incluir_bol  !=''  THEN
		SET lo_incluir_bol = CONCAT(' incluir_bol= "', pr_incluir_bol, '",');
	END IF;

	IF pr_Incluir_pax != '' THEN
		SET lo_Incluir_pax = CONCAT(' Incluir_pax= "', pr_Incluir_pax, '",');
	END IF;

	IF pr_Incluir_pnr != '' THEN
		SET lo_Incluir_pnr = CONCAT(' Incluir_pnr= "', pr_Incluir_pnr, '",');
	END IF;

	IF pr_Incluir_fecha_viaje != '' THEN
		SET lo_Incluir_fecha_viaje = CONCAT(' Incluir_fecha_viaje= "', pr_Incluir_fecha_viaje, '",');
	END IF;

	IF pr_estatus > 0 THEN
		SET lo_estatus = CONCAT(' estatus= "', pr_estatus, '",');
	END IF;

    IF pr_calculo_markup != '' THEN
		SET lo_calculo_markup = CONCAT(' calculo_markup= "', pr_calculo_markup, '",');
	END IF;

    IF pr_logo_empresa != '' THEN
		SET lo_logo_empresa = CONCAT(' logo_empresa= "', pr_logo_empresa, '",');
	END IF;

    IF pr_aviso_no_folios != '' THEN
		SET lo_aviso_no_folios = CONCAT(' aviso_no_folios = ',pr_aviso_no_folios, ',');
    END IF;

    /*
    IF pr_forma_pago_folios != '' THEN
		SET lo_forma_pago_folios = CONCAT(' forma_pago_folios = ',pr_forma_pago_folios);
    END IF;
	*/

	SET @query = CONCAT('UPDATE suite_mig_conf.st_adm_tr_config_admin
							SET ',
                            lo_id_config_admin,
							lo_id_empresa,
							lo_inventario_bol_linea,
							lo_notas_factura,
							lo_unidad_negocio_obli,
							lo_origen_venta_obli,
							lo_cambios_clie_fijo,
							lo_cambios_doc_serv,
							lo_cambios_factura,
							lo_desglose_impuesto ,
							lo_tipo_descu,
							lo_limite_credito,
							lo_ant_cl,
							lo_multi_formato_imp ,
							lo_nc_fac_no_exist ,
							lo_nc_cambios,
							lo_nc_valida_fac ,
							lo_cxcdven1,
							lo_cxcdven2,
							lo_cxcdven3,
							lo_cxcdven4 ,
							lo_cxcdven5,
							lo_cxcdven6,
							lo_cxpdven1,
							lo_cxpdven2 ,
							lo_cxpdven3 ,
							lo_cxpdven4,
							lo_cxpdven5,
							lo_cxpdven6,
							lo_enviar_bol_elect,
							lo_incluir_bol,
							lo_Incluir_pax,
							lo_Incluir_pnr ,
							lo_Incluir_fecha_viaje,
							lo_estatus,
                            lo_calculo_markup,
                            lo_logo_empresa,
                            lo_aviso_no_folios,
                            -- lo_forma_pago_folios
							' id_usuario=',pr_id_usuario,
							' , fecha_mod  = sysdate()
							WHERE id_config_admin = ?');

	PREPARE stmt FROM @query;

	SET @id_config_admin= pr_id_config_admin;
	EXECUTE stmt USING @id_config_admin;

	#Devuelve el numero de registros insertados
	SELECT
	ROW_COUNT()
	INTO
	pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
