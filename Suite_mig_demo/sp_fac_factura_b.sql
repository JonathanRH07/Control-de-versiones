DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_b`(
	IN  pr_id_grupo_empresa	INT(11),
    IN  pr_id_sucursal		INT(11),
    IN  pr_consulta_gral	CHAR(30),
	IN  pr_ini_pag			INT(11),
	IN  pr_fin_pag			INT(11),
	IN  pr_order_by			VARCHAR(100),
    IN  pr_id_idioma		INT,
    IN  pr_estatus			ENUM('ACTIVO', 'CANCELADO','TODOS'),
    OUT pr_rows_tot_table	INT,
	OUT pr_message			VARCHAR(5000))
BEGIN
--
/*
	@nombre:		sp_fac_pagos_c
	@fecha: 		2018/04/19
	@descripción: 	Sp para obtenber registros de las tablas ic_fac_tr_pagos
	@autor : 		Griselda Medina Medina
	@cambios: 	    se agrego el uuid relacionado @mario
*/
	DECLARE lo_matriz			INT;
    DECLARE lo_matriz_campo		VARCHAR(200)  DEFAULT '';
    DECLARE lo_consulta_gral	VARCHAR(1000) DEFAULT '';
	DECLARE lo_order_by 		VARCHAR(200)  DEFAULT '';
    DECLARE lo_first_select		VARCHAR(200)  DEFAULT '';
	DECLARE lo_estatus			VARCHAR(200)  DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = RETURNED_SQLSTATE;
	END ;

    IF (pr_estatus != '' AND pr_estatus != 'TODOS' AND pr_consulta_gral = '') THEN
			SET lo_estatus = CONCAT(' AND pagos.estatus = ''', pr_estatus, ''' ');
	END IF;

	SELECT
		matriz
	INTO
		lo_matriz
    FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF lo_matriz = 0 THEN
		SET lo_matriz_campo = CONCAT(' AND pagos.id_sucursal = ',pr_id_sucursal);
    END IF;

    IF (pr_consulta_gral !='')THEN
     SET lo_consulta_gral = CONCAT('
     AND (serie.cve_serie LIKE "%', pr_consulta_gral,'%"
     OR pagos.numero LIKE "%', pr_consulta_gral,'%"
     OR total_pago LIKE "%', pr_consulta_gral,'%"
     OR pagos.id_pago_sustituido_por LIKE "%', pr_consulta_gral,'%"
     OR usuario.usuario LIKE "%', pr_consulta_gral,'%"
     OR cliente.cve_cliente LIKE "%', pr_consulta_gral,'%"
     OR sucursal.cve_sucursal LIKE "%', pr_consulta_gral,'%"
     OR cliente.razon_social LIKE "%', pr_consulta_gral,'%"
     OR pagos.fecha LIKE "%', pr_consulta_gral,'%"
     OR moneda.clave_moneda LIKE "%', pr_consulta_gral,'%"
     OR fpago.cve_forma_pago LIKE "%', pr_consulta_gral,'%"
     OR pagos.tpo_cambio LIKE "%', pr_consulta_gral,'%")');

    ELSE
		IF (pr_estatus != '' AND pr_estatus != 'TODOS' ) THEN
			SET lo_estatus = CONCAT(' AND pagos.estatus = ''', pr_estatus, ''' ');
		ELSEIF pr_estatus = 'TODOS' THEN
			SET lo_estatus = '';
		ELSE
			SET lo_first_select = ' AND pagos.estatus = ''ACTIVO''';
		END IF;
	END IF;

    # Busqueda por ORDER BY
	IF pr_order_by <> '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

	 SET @query = CONCAT('SELECT
							pagos.id_pago,
							pagos.id_grupo_empresa,
							pagos.id_serie,
							concat(serie.cve_serie,"-",serie.descripcion_serie) as cve_serie_d,
							serie.cve_serie,
							pagos.numero,
							pagos.id_pago_sustituye_a,
							concat(moneda.clave_moneda,"-",mon_transl.descripcion_moneda) as clave_moneda_d,
							moneda.clave_moneda,
							descripcion_moneda,
							mon_transl.plural,
							pagos.id_cliente,
							cliente.cve_cliente,
							pagos.mail_cliente as email,
							cliente.razon_social,
							cliente.id_sucursal,
							cliente.rfc,
							sucursal.cve_sucursal,
							pagos.fecha as fecha_uuid,
							pagos.fecha_captura_recibo,
							FORMAT(pagos.total_pago,2) as total_pago,
							FORMAT(pagos.total_pago_moneda_base,2) as total_pago_moneda_base,
							pagos.no_operacion,
							pagos.confirmacion_pac,
							pagos.tpo_cambio,
							cfdi.uuid as sealing_uuid,
							cfdi.factura_xml,
							TO_BASE64(pagos.factura_pdf) as factura_pdf,
							pagos.id_usuario,
							usuario.usuario,
							concat(usuario.nombre_usuario," ",paterno_usuario) as usuario_mod,
							pagos.id_forma_pago,
							concat(fpago.id_forma_pago_sat,"-",fpago.cve_forma_pago) as cve_forma_pago,
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
							cancel.descripcion,
							pagos.fecha_mod,
							pagos.c_UsoCFDI_descripcion_sat,
							pagos.sello_spei as xmlspei,
							(SELECT
								CONCAT(cve_sucursal,"-",cve_serie,"-" , numero,"-",uuid)
							FROM ic_fac_tr_pagos pagos_sust
							JOIN ic_cat_tr_sucursal suc ON
									pagos_sust.id_sucursal = suc.id_sucursal
							JOIN ic_cat_tr_serie ser ON
								pagos_sust.id_serie = ser.id_serie
							WHERE  pagos.id_pago_sustituye_a = pagos_sust.id_pago) AS pagos_sust,

							(SELECT
								cve_serie
							FROM ic_fac_tr_pagos pagos_sust
							JOIN ic_cat_tr_sucursal suc ON
									pagos_sust.id_sucursal = suc.id_sucursal
							JOIN ic_cat_tr_serie ser ON
								pagos_sust.id_serie = ser.id_serie
							WHERE  pagos.id_pago_sustituye_a = pagos_sust.id_pago) AS sust_cve_serie,

							(SELECT
								numero
							FROM ic_fac_tr_pagos pagos_sust
							JOIN ic_cat_tr_sucursal suc ON
									pagos_sust.id_sucursal = suc.id_sucursal
							JOIN ic_cat_tr_serie ser ON
								pagos_sust.id_serie = ser.id_serie
							WHERE  pagos.id_pago_sustituye_a = pagos_sust.id_pago) AS sust_numero,

							(SELECT
								uuid
							FROM ic_fac_tr_pagos pagos_sust
							JOIN ic_cat_tr_sucursal suc ON
									pagos_sust.id_sucursal = suc.id_sucursal
							JOIN ic_cat_tr_serie ser ON
								pagos_sust.id_serie = ser.id_serie
							WHERE  pagos.id_pago_sustituye_a = pagos_sust.id_pago) AS sust_sealing_uuid

							FROM ic_fac_tr_pagos AS pagos
							LEFT JOIN ct_glob_tc_moneda AS moneda
								ON moneda.id_moneda = pagos.id_moneda
							LEFT JOIN ct_glob_tc_moneda_trans as mon_transl
								ON moneda.id_moneda = mon_transl.id_moneda
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
							LEFT JOIN ic_fac_tc_razon_cancelacion cancel
								ON pagos.id_razon_cancelacion = cancel.id_razon_cancelacion
							WHERE pagos.id_grupo_empresa=?
							AND   mon_transl.id_idioma = ', pr_id_idioma
								,lo_matriz_campo
								,lo_first_select
								,lo_consulta_gral
								,lo_estatus
								,lo_order_by
								,' LIMIT ?,?'
						);

    -- SELECT @query;

    PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;
	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;
	DEALLOCATE PREPARE stmt;

    # START count rows query
	SET pr_rows_tot_table = (SELECT FOUND_ROWS());

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
