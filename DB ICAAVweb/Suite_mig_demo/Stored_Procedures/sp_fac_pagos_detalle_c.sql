DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_detalle_c`(
	OUT pr_message 		VARCHAR(500))
BEGIN

/*
	@nombre:		sp_fac_pagos_detalle_c
	@fecha: 		2018/02/19
	@descripción: 	Sp para obtenber registros de las tablas ic_fac_tr_pagos_detalle
	@autor : 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_pagos_detalle_c';
	END ;

	SELECT
		*
	FROM
		ic_fac_tr_pagos_detalle;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
