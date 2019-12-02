DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_cobranza_detalle`(
	IN pr_id_grupo_empresa						INT,
	IN  pr_fecha								DATE,
	IN  pr_id_sucursal							INT,
    IN  pr_tipo_reporte							VARCHAR(100),
	IN  pr_id									INT,
    OUT pr_message 								TEXT)
BEGIN
/*
	@nombre:		sp_rep_cobranza_detalle
	@fecha: 		18/07/2018
	@descripción: 	Sp para obtenber el detalle de las facturas pagadas para el reporte de Cobranza
	@autor : 		Rafael Quezada
	@cambios:
*/

    DECLARE ls_sucursal CHAR(50) DEFAULT '';
	DECLARE ls_select CHAR(50) DEFAULT '';
	DECLARE ls_parte CHAR(200) DEFAULT '';

	CASE pr_tipo_reporte
		WHEN 'Cliente' THEN
			IF  pr_id  > 0  THEN
			SET ls_select = CONCAT(' AND cxc.id_cliente = ', pr_id, ' ');
			END IF;

		WHEN 'Vendedor'  THEN
			IF  pr_id  > 0  THEN
			SET ls_select = CONCAT(' AND cxc.id_vendedor = ', pr_id, ' ');
			END IF;

		WHEN 'Corporativo'  THEN
			IF  pr_id  > 0  THEN
			SET ls_select = CONCAT(' AND cliente.id_corporativo = ', pr_id, ' ' );
			SET ls_parte = 'join ic_cat_tr_cliente as cliente on
				cxc.id_cliente = cliente.id_cliente
				join ic_cat_tr_corporativo as corporativo on
				cliente.id_corporativo = corporativo.id_corporativo';
			END IF;
	END CASE;

	IF  pr_id_sucursal > 0  THEN
		SET ls_sucursal = CONCAT(' AND cxc.id_sucursal = ', pr_id_sucursal, ' ');
	END IF;

	SET @query = CONCAT('SELECT cxc.fecha_emision  fecha,
	cve_serie serie,
	fac_numero  numero,
	detalle.referencia_origen referencia,
	to_days(detalle.fecha) - to_days(fecha_vencimiento) vencimiento,
	clave_moneda moneda,
	pagos.tpo_cambio tipo_cambio,
	(  detalle.importe_moneda_base /pagos.tpo_cambio) * - 1  importe,
	detalle.importe_moneda_base  * -1 importe_mn
	FROM  ic_glob_tr_cxc  as cxc join ic_glob_tr_cxc_detalle  as detalle on
	cxc.id_cxc  = detalle.id_cxc  and cxc.estatus = "ACTIVO"  and detalle.id_factura is  null
	join ic_fac_tr_pagos as pagos on
	detalle.id_pago = pagos.id_pago
	left outer join ct_glob_tc_moneda as moneda on pagos.id_moneda = moneda.id_moneda ',ls_parte,'
	Where cxc.id_grupo_empresa = ', pr_id_grupo_empresa,' and detalle.fecha  = "',pr_fecha,'"  and detalle.estatus = "ACTIVO" ' ,ls_sucursal,ls_select);

	PREPARE stmt FROM @query;
	EXECUTE stmt;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
