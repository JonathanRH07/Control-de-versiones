DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_pagos_x_cliente_detalle_c`(
	IN	pr_id_grupo_empresa			INT,
    IN	pr_id_sucursal				INT,
	-- IN	pr_id_moneda				INT,
    IN	pr_id_cliente				INT,
    IN	pr_id_pago					INT,
    IN	pr_fecha_ini				VARCHAR(10),
    IN	pr_fecha_fin				VARCHAR(10),
	OUT pr_message 	  		 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_pagos_x_cliente_detalle_c
	@fecha:			21/08/2018
	@descripcion:	Sp para consultar el detalle de los pagos por cliente
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_sucursal				VARCHAR(100) DEFAULT '';
    DECLARE lo_cliente				VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_pagos_x_cliente_detalle_c';
	END ;

	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND acu.id_sucursal = ',pr_id_sucursal);
    END IF;

	IF pr_id_cliente > 0 THEN
		SET lo_cliente = CONCAT('AND acu.id_cliente = ',pr_id_cliente);
    END IF;

    /* Desarrollo */

    SET @query = CONCAT('
						SELECT
							acu.id_pago,
							CASE
								WHEN suc.matriz = 1 THEN
									''MATRIZ''
								WHEN suc.matriz = 0 THEN
									''CORPORATIVO''
							END sucursal,
							acu_det.fecha,
							cxc.cve_serie serie,
							cxc.fac_numero numero,
							CONCAT(ser.cve_serie,'' - '',acu.numero) referencia,
							acu_det.importe importe_mxn
						FROM ic_rep_tr_acumulado_pagos_detalle acu_det
						JOIN ic_rep_tr_acumulado_pagos acu ON
							acu_det.id_pago = acu.id_pago
						JOIN ic_cat_tr_sucursal suc ON
							acu_det.id_sucursal = suc.id_sucursal
						JOIN ic_glob_tr_cxc cxc ON
							acu_det.id_cxc = cxc.id_cxc
						JOIN ic_cat_tr_serie ser ON
							acu.id_serie = ser.id_serie
						WHERE acu_det.id_grupo_empresa = ',pr_id_grupo_empresa,'
                        AND acu.id_pago = ',pr_id_pago,'
						',lo_sucursal,'
						',lo_cliente,'
						AND acu_det.fecha >= ''',pr_fecha_ini,'''
						AND acu_det.fecha <= ''',pr_fecha_fin,'''');

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
