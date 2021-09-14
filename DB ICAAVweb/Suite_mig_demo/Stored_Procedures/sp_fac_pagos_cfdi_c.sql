DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_pagos_cfdi_c`(
	IN  pr_id_pago 			INT,
    OUT pr_message 			VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_fac_pagos_cfdi_c
	@fecha: 		23/11/2018
	@descripcion: 	SP para buscar un registro especifico
	@autor:  		Yazbek Kido
	@cambios:
*/


    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_fac_pagos_cfdi_c';
	END ;

    SET @query = CONCAT('SELECT
		*
		FROM ic_fac_tr_pagos_cfdi WHERE
		id_pago = ?');

	PREPARE stmt FROM @query;

    SET @id_pago = pr_id_pago;

	EXECUTE stmt USING  @id_pago;
	DEALLOCATE PREPARE stmt;

	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
