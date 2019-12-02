DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_pagos_con_tc_u`(
	IN  pr_id_cxc							INT,
    IN	pr_id_factura						INT,
    IN  pr_importe_x_aplicar				DECIMAL(18,2),
	OUT pr_rows_tot_table 	 				INT,
    OUT pr_message 	  		 				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_pagos_con_tc_c
	@fecha:			10/08/2018
	@descripcion:	Sp para consultar los pagos recibidos y pagados con tarjeta de credito
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
		SET pr_message = 'ERROR store sp_rep_pagos_con_tc_c';
	END;

    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

    START TRANSACTION;

    UPDATE ic_fac_tr_compras_x_servicio
	SET importe_tc = 0
	WHERE id_factura = pr_id_factura;

	UPDATE ic_glob_tr_cxc
	SET saldo_moneda_base = (saldo_moneda_base + pr_importe_x_aplicar)
	WHERE id_cxc = pr_id_cxc;

	UPDATE ic_glob_tr_cxc_detalle
	SET estatus = 2
	WHERE id_cxc = pr_id_cxc;


	/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

	/* Mensaje de ejecución */
    COMMIT;
	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
