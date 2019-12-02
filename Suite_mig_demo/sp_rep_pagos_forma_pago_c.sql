DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_pagos_forma_pago_c`(
	IN	pr_id_grupo_empresa			INT,
    IN	pr_id_sucursal				INT,
	-- IN	pr_id_moneda				INT,
    IN	pr_id_cliente				INT,
    IN	pr_fecha_ini				VARCHAR(10),
    IN	pr_fecha_fin				VARCHAR(10),
	OUT pr_message 	  				VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_pagos_forma_pago_c
	@fecha:			21/08/2018
	@descripcion:	Sp para consultar las ventas por formas de pago de las ventas por sucursal y cliente
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_sucursal				VARCHAR(100) DEFAULT '';
    DECLARE lo_cliente				VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_pagos_forma_pago_c';
	END ;

    IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal);
    END IF;

	IF pr_id_cliente > 0 THEN
		SET lo_cliente = CONCAT('AND id_cliente = ',pr_id_cliente);
    END IF;

	/* Desarrollo */
    SET @lo_total = 0;
	SET @query_total = CONCAT('
								SELECT
									IFNULL(SUM(monto_moneda_base),0)
								INTO
									@lo_total
								FROM ic_rep_tr_acumulado_pagos
								WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
								',lo_sucursal,'
								',lo_cliente,'
								AND fecha >= ''',pr_fecha_ini,'''
								AND fecha <= ''',pr_fecha_fin,''''
							);

	-- SELECT @query_total;
	PREPARE stmt FROM @query_total;
	EXECUTE stmt;

    SET @query = CONCAT('

						SELECT
							payform.desc_forma_pago forma_pago,
							SUM(monto_moneda_base) importe_mxn,
							FORMAT((SUM(monto_moneda_base)*100)/',@lo_total,',2) porcentaje
						FROM ic_rep_tr_acumulado_pagos acu
						JOIN ic_glob_tr_forma_pago payform ON
							acu.id_forma_pago = payform.id_forma_pago
						WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
                        ',lo_cliente,'
						AND acu.fecha >= ''',pr_fecha_ini,'''
						AND acu.fecha <= ''',pr_fecha_fin,'''
						GROUP BY 1
                        ORDER BY 3 DESC'
                        );

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
