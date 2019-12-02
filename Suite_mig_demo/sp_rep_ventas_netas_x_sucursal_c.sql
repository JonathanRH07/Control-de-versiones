DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_ventas_netas_x_sucursal_c`(
	IN	pr_id_grupo_empresa	 INT,
    IN	pr_id_moneda		 INT,
    IN	pr_id_sucursal		 INT,
    IN	pr_fecha		     VARCHAR(7),
	OUT pr_rows_tot_table 	 INT,
    OUT pr_message 	  		 VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_netas_x_sucursal_c
	@fecha:			10/08/2018
	@descripcion:	Sp para consultar las ventas por sucursal
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_sucursal				VARCHAR(100) DEFAULT '';
	DECLARE lo_sucursal_2			VARCHAR(100) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_ventas_netas_x_sucursal_c';
	END ;
	/* Desarrollo */

    DROP TEMPORARY TABLE IF EXISTS tmp_reporte_ventas_suc;

	/* VALIDAR LA SUCURSAL */
	IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND acu.id_sucursal = ',pr_id_sucursal);
		SET lo_sucursal_2 = CONCAT('AND suc.id_sucursal = ',pr_id_sucursal);
	END IF;

	/* CONSULTA SUCURSALES */
	SET @query = CONCAT('CREATE TEMPORARY TABLE tmp_reporte_ventas_suc
						SELECT
							suc.id_sucursal,
							suc.nombre,
							suc.cve_sucursal,
							IFNULL(acumulados.total,0) total,
							CASE
								WHEN acumulados.fecha_1 IS NULL THEN
									''',pr_fecha,'''
								ELSE
									acumulados.fecha_1
							END fecha,
							CASE
								WHEN suc.matriz = 1 THEN
									''MATRIZ''
								WHEN suc.matriz = 0 THEN
									''CORPORATIVO''
							END tipo
						FROM(
						SELECT
							*,
							CASE
								WHEN ',pr_id_moneda,' = 100 THEN
									SUM(acu.venta_neta_moneda_base)
								WHEN ',pr_id_moneda,' = 149 THEN
									SUM(acu.venta_neta_usd)
								WHEN ',pr_id_moneda,' = 49  THEN
									SUM(acu.venta_neta_eur)
							END total,
							fecha fecha_1
						FROM ic_rep_tr_acumulado_sucursal acu
						WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND fecha = ''',pr_fecha,'''
						GROUP BY acu.id_sucursal) acumulados
						RIGHT JOIN ic_cat_tr_sucursal suc ON
							acumulados.id_sucursal = suc.id_sucursal
						WHERE suc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal_2,'
						AND estatus = ''ACTIVO'''
						);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT *
	FROM tmp_reporte_ventas_suc;

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
