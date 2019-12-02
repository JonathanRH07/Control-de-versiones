DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_anticipos_cfdi_anticipos_pendientes_c`(
	IN  pr_id_grupo_empresa			INT,
    IN	pr_estatus					INT, /* 1=PENDIENTES DE APLICAR | 2=APLICADOS | 3=TODOS */
    IN  pr_fecha_ini				DATE,
    IN  pr_fecha_fin				DATE,
    IN	pr_id_moneda				INT,
    IN  pr_id_sucursal				INT,
    IN  pr_id_cliente				INT,
    OUT pr_message 	  		 		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_anticipos_cfdi_anticipos_pendientes_c
	@fecha:			03/05/2019
	@descripcion:	Sp para consultar el reporte de los anticipos en facturacion
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_sucursal				VARCHAR(150) DEFAULT '';
    DECLARE lo_cliente				VARCHAR(150) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_anticipos_cfdi_anticipos_pendientes_c';
	END ;

        /* VALIDAR SUCURSAL */
	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

    /* VALIDAR CLIENTE */
	IF pr_id_cliente > 0 THEN
		SET lo_cliente = CONCAT('AND fac.id_cliente =',pr_id_cliente);
    END IF;

	IF pr_estatus != 2 THEN
		/* ANTICIPOS PENDIENTE DE APLICAR */
		SET @query = CONCAT('
							SELECT
								IFNULL(COUNT(*),0) contador_ant
							FROM ic_fac_tr_anticipos ant
							LEFT JOIN ic_fac_tr_anticipos_aplicacion ant_apli ON
								ant.id_anticipos = ant_apli.id_anticipos
							JOIN ic_fac_tr_factura fac ON
								ant.id_factura = fac.id_factura
							WHERE ant.importe_aplicado_moneda_facturada >= 0
                            AND ant.importe_aplicado_moneda_facturada < anticipo_moneda_facturada
							AND ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND ant.fecha >= ''',pr_fecha_ini,'''
							AND ant.fecha <= ''',pr_fecha_fin,'''
							',lo_sucursal,'
							',lo_cliente
                            );

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;

    ELSE
		SELECT
		0 contador_ant;
    END  IF;

	/* Mensaje de ejecución */
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
