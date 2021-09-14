DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_u_pdf`(
	IN 	pr_id_pago		INT,
    IN  pr_factura_pdf  MEDIUMBLOB,
	OUT lo_factura_pdf  TEXT,
    OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_adm_permiso_role_u
	@fecha: 		2017/09/06
	@descripci贸n: 	Sp para crear pdf con cfdi y sin complementos
	@autor : 		provisionally mario
	@cambios: 		add update pdf an return
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	SET pr_message = 'ERROR store sp_fac_pagos_u_pdf';

	UPDATE ic_fac_tr_pagos
	SET factura_pdf = pr_factura_pdf
    WHERE id_pago = pr_id_pago;

	SET lo_factura_pdf = TO_BASE64(pr_factura_pdf);
    SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
