DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_fac_pagos_g`(
	IN  pr_id_grupo_empresa INT,
	IN  pr_id_pago 			INT,
    OUT pr_message 			VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_fac_pagos_g
	@fecha: 		30/10/2018
	@descripcion: 	SP para buscar un registro especifico
	@autor:  		Yazbek Kido
	@cambios: 		@mario se actualizo para mostrar documentos relacionados
*/


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_pagos_g';
	END ;

    SET @query = CONCAT('SELECT
		pagos.id_pago,
		pagos.id_grupo_empresa,
		pagos.id_serie,
		serie.cve_serie,
		pagos.numero,
		moneda.clave_moneda,
        moneda.decripcion as descripcion_moneda,
		pagos.id_cliente,
		cliente.cve_cliente,
		pagos.mail_cliente,
		cliente.razon_social,
		cliente.id_sucursal,
        cliente.id_direccion,
        cliente.rfc,
		sucursal.cve_sucursal,
        pagos.fecha as fecha_uuid,
		pagos.fecha_captura_recibo,
		pagos.total_pago,
		pagos.total_pago_moneda_base,
		pagos.no_operacion,
		pagos.confirmacion_pac,
		pagos.tpo_cambio,
        cfdi.id_cfdi,
		cfdi.uuid as sealing_uuid,
        cfdi.factura_xml,
		pagos.id_usuario,
		usuario.usuario,
        usuario.nombre_usuario,
        pagos.id_forma_pago,
		concat(pagosat.descripcion," - ",fpago.id_forma_pago_sat) as forma_pago_sat,
        pagosat.descripcion as desc_forma_pago_sat,
        fpago.id_forma_pago_sat as id_forma_pago_sat,
		concat(usuario.usuario) AS user_alias,
		pagos.id_pago_sustituido_por,
		pagos.estatus,
		pagos.nombancoemisor,
		pagos.rfcemisorctaord,
		pagos.nombancoordext,
		pagos.nombancoemisor,
		pagos.ctaordenante,
		pagos.rfcemisorctaben,
		pagos.ctabeneficiario,
		pagos.tipocadpago,
		pagos.certpago,
		pagos.cadpago,
        pagos.concepto_p,
		pagos.concepto_c,
		pagos.recibimos_de,
        pagos.c_UsoCFDI_sat,
        pagos.id_razon_cancelacion,
        pagos.fecha_mod,
        pagos.c_UsoCFDI_descripcion_sat,
        pagos.sello_spei as xmlspei,
        pagos.factura_pdf,
		bancoord.clave_sat as cve_banco_ord_sat,
        bancoemi.clave_sat as cve_banco_emi_sat,
        suc_sust.cve_sucursal AS sust_cve_sucursal,
        suc_sust.nombre AS sust_nombre_sucursal,
		ser_sust.cve_serie AS sust_cve_serie,
		pagos_sust.numero AS sust_numero,
		cfdi_sust.uuid AS sust_sealing_uuid,
        IF(cfdi_sust.uuid IS NOT NULL, "S", "N") sustituido,
        IF(cfdi_sust.uuid IS NOT NULL, "SI", "NO") nombre_sustituido
		FROM ic_fac_tr_pagos AS pagos
		LEFT JOIN ct_glob_tc_moneda AS moneda
		ON moneda.id_moneda = pagos.id_moneda
		LEFT JOIN ic_cat_tr_serie AS serie
		ON serie.id_serie=pagos.id_serie
		LEFT JOIN ic_cat_tr_cliente AS cliente
		 ON cliente.id_cliente=pagos.id_cliente
		LEFT JOIN suite_mig_conf.st_adm_tr_usuario AS usuario
		 ON usuario.id_usuario=pagos.id_usuario
		LEFT JOIN ic_cat_tr_sucursal AS sucursal
		 ON sucursal.id_sucursal=pagos.id_sucursal
		LEFT JOIN ic_glob_tr_forma_pago AS fpago
		 ON fpago.id_forma_pago=pagos.id_forma_pago
		LEFT JOIN ic_fac_tr_pagos_cfdi AS cfdi
		 ON cfdi.id_pago=pagos.id_pago
		LEFT JOIN ic_fac_tr_pagos pagos_sust
         ON pagos.id_pago_sustituye_a = pagos_sust.id_pago
        LEFT JOIN ic_cat_tr_sucursal suc_sust
		 ON pagos_sust.id_sucursal = suc_sust.id_sucursal
		LEFT JOIN ic_cat_tr_serie ser_sust
		 ON pagos_sust.id_serie = ser_sust.id_serie
		LEFT JOIN ic_fac_tr_pagos_cfdi cfdi_sust
		 ON cfdi_sust.id_pago = pagos_sust.id_pago
		LEFT JOIN sat_formas_pago AS pagosat
	     ON pagosat.c_FormaPago=fpago.id_forma_pago_sat
		LEFT JOIN sat_bancos AS bancoord
	     ON bancoord.razon_social=pagos.nombancoordext
		LEFT JOIN sat_bancos AS bancoemi
	     ON bancoemi.razon_social=pagos.nombancoemisor
		WHERE pagos.id_grupo_empresa= ? AND pagos.id_pago = ?');

	PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @id_pago = pr_id_pago;

	EXECUTE stmt USING @id_grupo_empresa, @id_pago;
	DEALLOCATE PREPARE stmt;

	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
