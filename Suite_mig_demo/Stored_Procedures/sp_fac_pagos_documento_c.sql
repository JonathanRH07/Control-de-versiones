DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_documento_c`(
	IN  pr_id_grupo_empresa	INT,
    IN  pr_id_pago			INT,
    OUT pr_message 			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_pagos_documento_c
	@fecha: 		2018/04/19
	@descripción: 	Sp para obtenber todos los registros de las tablas cxc
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_pagos_documento_c';
	END ;
    /*
		importe_facturado
		pagos_facturado
		saldo_facturado
    */
	SELECT
		suc.cve_sucursal,
		cxc.cve_serie,
		cxc.cve_tipo_serie as cveTipoSerie,
		cxc.fac_numero,
		cxc.fecha_emision,
		mon.clave_moneda,
		cxc.c_MetodoPago,
		cxc.uuid,
		det.no_parcialidad,
		det.id_pago,
		det.saldo_act saldo_moneda_base,
		det.saldo_ant saldo_anterior,
		det.importe_moneda_base pagos_facturado,
		cxc.importe_moneda_base importe_moneda_base,
        cxc.tipo_cambio,
        det.tipo_cambio_dr
	FROM ic_glob_tr_cxc cxc
	JOIN  ic_fac_tr_pagos_detalle det ON
			cxc.id_cxc = det.id_cxc
	JOIN ic_cat_tr_sucursal suc ON
			cxc.id_sucursal = suc.id_sucursal
	JOIN ct_glob_tc_moneda mon ON
			cxc.id_moneda = mon.id_moneda
	WHERE cxc.id_grupo_empresa = pr_id_grupo_empresa
	AND	det.id_pago = pr_id_pago;

	# Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
