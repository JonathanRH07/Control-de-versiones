DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_pagos_x_cliente_c`(
	IN	pr_id_grupo_empresa			INT,
    IN	pr_id_sucursal				INT,
	-- IN	pr_id_moneda				INT,
    IN	pr_id_cliente				INT,
    IN	pr_fecha_ini				VARCHAR(10),
    IN	pr_fecha_fin				VARCHAR(10),
	OUT pr_message 	  		 VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_pagos_x_cliente
	@fecha:			21/08/2018
	@descripcion:	Sp para consultar el desgloce de los pagos por cliente
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_sucursal				VARCHAR(100) DEFAULT '';
    DECLARE lo_cliente				VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_pagos_x_cliente';
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
							ser.cve_serie,
							acu.numero,
							fecha,
							cli.nombre_comercial,
							mon.clave_moneda,
							acu.tpo_cambio,
							acu.total_pago monto_moneda_base,
							acu.monto_moneda_base monto_convertido,
							payform.desc_forma_pago descripcion
						FROM ic_rep_tr_acumulado_pagos acu
						JOIN ic_cat_tr_serie ser ON
							acu.id_serie = ser.id_serie
						JOIN ic_cat_tr_cliente cli ON
							acu.id_cliente = cli.id_cliente
						JOIN ct_glob_tc_moneda mon ON
							acu.id_moneda = mon.id_moneda
						JOIN ic_glob_tr_forma_pago payform ON
							acu.id_forma_pago = payform.id_forma_pago
						WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						',lo_cliente,'
						AND acu.fecha >= ''',pr_fecha_ini,'''
						AND acu.fecha <= ''',pr_fecha_fin,''''
                        );

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
