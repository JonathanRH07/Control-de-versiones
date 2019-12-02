DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_ventas_top_aerolinea_c`(
	IN  pr_id_grupo_empresa	INT,
    IN	pr_id_moneda		INT,
    IN	pr_id_sucursal		INT,
    IN	pr_fecha			VARCHAR(7),
	OUT pr_rows_tot_table 	INT,
	OUT pr_message 	  		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_top_aerolinea_c
	@fecha:			2019/06/20
	@descripcion:	Sp para consultar el top 10  de ventas por clientes por mes
	@autor: 		Jonathan Ramirez Hernandez
	@
*/

	DECLARE lo_sucursal				VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_top_aerolinea_c';
	END ;

    /* Desarrollo */

	DROP TEMPORARY TABLE IF EXISTS tmp_top_aerolinea;

	/* VALIDAR LA SUCURSAL */
	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal);
	END IF;

    SET @query = CONCAT('
						CREATE TEMPORARY TABLE tmp_top_aerolinea
						SELECT
							airline.clave_aerolinea clave,
							airline.nombre_aerolinea nombre,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									monto_usd
								WHEN ',pr_id_moneda,' = 49  THEN
									monto_eur
								ELSE
									monto_moneda_base
							END venta_mes,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									egresos_usd
								WHEN ',pr_id_moneda,' = 49  THEN
									egresos_eur
								ELSE
									egresos_moneda_base
							END devoluciones_mes,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									venta_neta_usd
								WHEN ',pr_id_moneda,' = 49  THEN
									venta_neta_eur
								ELSE
									venta_neta_moneda_base
							END neto_mes,
							CASE
								WHEN ',pr_id_moneda,' = 149 THEN
									acumulado_usd
								WHEN ',pr_id_moneda,' = 49  THEN
									acumulado_eur
								ELSE
									acumulado_moneda_base
							END neto_acumulado
						FROM ic_rep_tr_acumulado_aerolinea acu
						JOIN ct_glob_tc_aerolinea airline ON
							acu.clave_linea_aerea = airline.clave_aerolinea
						WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND acu.fecha =  ''',pr_fecha,'''
						GROUP BY acu.clave_linea_aerea
						ORDER BY neto_mes DESC
						LIMIT 10'
						);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    SELECT *
    FROM tmp_top_aerolinea;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
