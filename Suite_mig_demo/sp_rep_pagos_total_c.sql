DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_pagos_total_c`(
	IN	pr_id_grupo_empresa			INT,
    IN	pr_id_sucursal				INT,
	-- IN	pr_id_moneda				INT,
    IN	pr_id_cliente				INT,
    IN	pr_fecha_ini				VARCHAR(10),
    IN	pr_fecha_fin				VARCHAR(10),
	OUT pr_message 	  		 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_pagos_total_c
	@fecha:			21/08/2018
	@descripcion:	Sp para consultar el total de las ventas por sucursal y cliente
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_sucursal				VARCHAR(100) DEFAULT '';
    DECLARE lo_cliente				VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_pagos_total_c';
	END ;

	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal);
    END IF;

	IF pr_id_cliente > 0 THEN
		SET lo_cliente = CONCAT('AND id_cliente = ',pr_id_cliente);
    END IF;

	/* Desarrollo */

    SET @query = CONCAT('
						SELECT
							SUM(monto_moneda_base) total
						FROM ic_rep_tr_acumulado_pagos
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						',lo_cliente,'
						AND fecha >= ''',pr_fecha_ini,'''
						AND fecha <= ''',pr_fecha_fin,''''
						);

    -- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
