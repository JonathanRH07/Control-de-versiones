DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_ventas_clientes_x_mes_c`(
	IN  pr_id_grupo_empresa		INT,
	IN  pr_id_sucursal 			INT,
	IN	pr_id_moneda			INT,
    IN	pr_fecha				VARCHAR(7),
	OUT pr_rows_tot_table 		INT,
	OUT pr_message 	  			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_clientes_x_mes_c
	@fecha:			02/08/2018
	@descripcion:	Sp para consultar las ventas por cliente por mes
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/
    DECLARE lo_sucursal		  	VARCHAR(20) DEFAULT '';
    DECLARE lo_sum_total		DECIMAL;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_clientes_x_mes_c';
	END ;

    /* Desarrollo */

    IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal);
    END IF;

	SET @total_neto = 0;
	SET @lo_sum_tot = CONCAT('SELECT
								SUM(venta_neta_moneda_base) total
							INTO
								@total_neto
							FROM ic_rep_tr_acumulado_cliente
							WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
                            ',lo_sucursal,'
							AND fecha = ''',pr_fecha,'''');

	-- SELECT @lo_sum_tot;
    PREPARE stmt FROM @lo_sum_tot;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_sum_total = @total_neto;

    SET @query = CONCAT('
						SELECT
							acu.id_cliente,
							acu.clave,
							acu.nombre nombre_cliente,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									SUM(acu.venta_neta_usd)
								WHEN ',pr_id_moneda,' = 49  THEN
									SUM(acu.venta_neta_eur)
								ELSE
									SUM(acu.venta_neta_moneda_base)
							END ventas_x_mes,
							cont.contador no_servicios,
							FORMAT(((SUM(acu.venta_neta_moneda_base)*100)/',lo_sum_total,'),2) porcentaje_mes,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									SUM(acu.acumulado_usd)
								WHEN ',pr_id_moneda,' = 49  THEN
									SUM(acu.acumulado_eur)
								ELSE
									SUM(acu.acumulado_moneda_base)
							END acumulado_x_mes
						FROM ic_rep_tr_acumulado_cliente acu
						LEFT JOIN (
								SELECT
									a.id_cliente,
									(IFNULL(a.contador_ingreso,0) - IFNULL(b.contador_egreso,0)) contador
								FROM
									(SELECT
										fac.id_cliente,
										COUNT(*) contador_ingreso
									FROM ic_fac_tr_factura fac
									LEFT JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									',lo_sucursal,'
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = ''',pr_fecha,'''
									AND fac.estatus != ''CANCELADA''
									AND fac.tipo_cfdi = ''I''
									GROUP BY fac.id_cliente) a
								LEFT JOIN (
									SELECT
										fac.id_cliente,
										COUNT(*) contador_egreso
									FROM ic_fac_tr_factura fac
									LEFT JOIN ic_fac_tr_factura_detalle det ON
										fac.id_factura = det.id_factura
									WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
									',lo_sucursal,'
									AND DATE_FORMAT(fac.fecha_factura,''%Y-%m'') = ''',pr_fecha,'''
									AND fac.estatus != ''CANCELADA''
									AND fac.tipo_cfdi = ''E''
									GROUP BY fac.id_cliente) b ON
										a.id_cliente = b.id_cliente) cont ON
							acu.id_cliente = cont.id_cliente
						WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND fecha = ''',pr_fecha,'''
						GROUP BY acu.id_cliente
						ORDER BY 4 DESC');

	-- SELECT @query;
    PREPARE stmt FROM @query;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
