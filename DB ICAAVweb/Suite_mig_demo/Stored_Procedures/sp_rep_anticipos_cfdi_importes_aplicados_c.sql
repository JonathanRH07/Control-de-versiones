DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_anticipos_cfdi_importes_aplicados_c`(
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
	@nombre:		sp_rep_anticipos_cfdi_importes_aplicados_c
	@fecha:			03/05/2019
	@descripcion:	Sp para consultar el reporte de los anticipos en facturacion
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_sucursal				VARCHAR(150) DEFAULT '';
    DECLARE lo_cliente				VARCHAR(150) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_anticipos_cfdi_importes_aplicados_c';
	END ;

        /* VALIDAR SUCURSAL */
	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal);
    END IF;

    /* VALIDAR CLIENTE */
	IF pr_id_cliente > 0 THEN
		SET lo_cliente = CONCAT('AND fac.id_cliente =',pr_id_cliente);
    END IF;

	IF pr_estatus = 1 THEN
		/* ANTICIPOS PENDIENTE DE APLICAR */
		SELECT
		0 importe_ant_aplicados;

    ELSEIF pr_estatus = 2 THEN

        /* ANTICIPOS APLICADOS */
		SET @query = CONCAT('
							SELECT
								CASE
									WHEN ',pr_id_moneda,' = 149 THEN
										SUM(ant.importe_aplicado_usd)
									WHEN ',pr_id_moneda,' = 49 THEN
										SUM(ant.importe_aplicado_eur)
									ELSE
										SUM(ant.importe_aplicado_base)
								END importe_ant_aplicados
							FROM ic_fac_tr_anticipos ant
							LEFT JOIN ic_fac_tr_anticipos_aplicacion ant_apli ON
								ant.id_anticipos = ant_apli.id_anticipos
							JOIN ic_fac_tr_factura fac ON
								ant.id_factura = fac.id_factura
							WHERE id_anticipos_aplicacion IS NOT NULL
							AND ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND ant_apli.fecha >= ''',pr_fecha_ini,'''
							AND ant_apli.fecha <= ''',pr_fecha_fin,'''
							AND ant.fecha >= ''',pr_fecha_ini,'''
							AND ant.fecha <= ''',pr_fecha_fin,'''
							',lo_sucursal,'
							',lo_cliente
                            );

        -- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;

    ELSEIF pr_estatus = 3 THEN

        /* TODOS */
        SET @query = CONCAT('
							SELECT
								CASE
									WHEN ',pr_id_moneda,' = 149 THEN
										SUM(ant.importe_aplicado_usd)
									WHEN ',pr_id_moneda,' = 49 THEN
										SUM(ant.importe_aplicado_eur)
									ELSE
										SUM(ant.importe_aplicado_base)
								END importe_ant_aplicados
							FROM ic_fac_tr_anticipos ant
							LEFT JOIN ic_fac_tr_anticipos_aplicacion ant_apli ON
								ant.id_anticipos = ant_apli.id_anticipos
							JOIN ic_fac_tr_factura fac ON
								ant.id_factura = fac.id_factura
							WHERE id_anticipos_aplicacion IS NOT NULL
                            AND ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND ant_apli.fecha >= ''',pr_fecha_ini,'''
							AND ant_apli.fecha<= ''',pr_fecha_fin,'''
							AND ant.fecha >= ''',pr_fecha_ini,'''
							AND ant.fecha <= ''',pr_fecha_fin,'''
							',lo_sucursal,'
							',lo_cliente
							);

		-- SELECT @query;
		PREPARE stmt FROM @query;
		EXECUTE stmt;

    END IF;

	/* Mensaje de ejecución */
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
