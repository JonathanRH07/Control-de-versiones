DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_detalle_men_c`(
	IN  pr_id_pago 		  INT,
    OUT pr_rows_tot_table INT,
	OUT pr_message		  VARCHAR(5000)
)
BEGIN
/*
	@nombre: 		sp_fac_pagos_detalle_men_c
	@fecha: 		11/06/2018
	@descripcion: 	SP para buscar
	@autor:  		Griselda Medina Medina
	@cambios:
*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_pagos_detalle_men_c';
	END ;

	SELECT
		no_mensualidad
	FROM ic_fac_tr_pagos_detalle
    WHERE id_pago = pr_id_pago;

    SELECT
		COUNT(no_mensualidad)
	INTO
		pr_rows_tot_table
	FROM ic_fac_tr_pagos_detalle
    WHERE id_pago = pr_id_pago;

	SET pr_message 	   = 'SUCCESS';

END$$
DELIMITER ;
