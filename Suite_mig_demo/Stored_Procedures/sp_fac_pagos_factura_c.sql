DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_factura_c`(
	IN  pr_id_grupo_empresa	INT,
    IN  pr_id_cliente		INT,
    OUT pr_message 			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_fac_pagos_factura_c
	@fecha: 		02/05/2018
	@descripción: 	Sp para obtenber registros de las cuentas por cobrar por cliente
	@autor : 		David Roldan Solares
	@cambios:
*/

	SELECT
		suc.cve_sucursal,
		cxc.cve_serie,
         cxc.cve_tipo_serie as cveTipoSerie,
		cxc.fac_numero,
		cxc.fecha_emision,
		mon.clave_moneda,
		cxc.importe_facturado,
		cxc.saldo_facturado,
		uuid
	FROM ic_glob_tr_cxc cxc
	JOIN  ic_cat_tr_sucursal suc ON
		  cxc.id_sucursal = suc.id_sucursal
	JOIN  ct_glob_tc_moneda mon ON
		  cxc.id_moneda = mon.id_moneda
	WHERE cxc.id_cliente 	   = pr_id_cliente
    AND   cxc.id_grupo_empresa = pr_id_grupo_empresa;

END$$
DELIMITER ;
