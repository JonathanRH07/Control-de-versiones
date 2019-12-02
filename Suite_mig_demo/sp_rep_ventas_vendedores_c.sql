DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_ventas_vendedores_c`(
	IN  pr_id_grupo_empresa		INT,
	IN	pr_id_sucursal			INT,
    IN	pr_año					VARCHAR(4),
    IN	pr_id_moneda			INT,
    IN	pr_mes					VARCHAR(2),
    IN	pr_top					INT,
    -- IN	pr_id_idioma			INT,
	-- OUT pr_rows_tot_table	 	INT,
	OUT pr_message 	  			VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_vendedores_c
	@fecha:			26/11/2018
	@descripcion:	Sp para consultar las ventas por vendedor
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	-- DECLARE lo_sucursal			INT;
    DECLARE lo_fecha 			VARCHAR(7);
	DECLARE lo_count			INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_clientes_c';
	END ;

     DROP TABLE IF EXISTS tmp_vendedor;
     DROP TABLE IF EXISTS tmp_vendedor_resto;
     DROP TABLE IF EXISTS tmp_vendedor_todos;
     DROP TABLE IF EXISTS tmp_vendedor_todos_resto;

    /* Desarrollo */
    IF pr_mes = '' THEN
		SET lo_fecha = DATE_FORMAT(SYSDATE(),'%Y-%m');
	ELSE
		SET lo_fecha = CONCAT(pr_año,'-',pr_mes);
    END IF;

    IF pr_top = 0 THEN
		SET pr_top = 10;
	ELSE
		SET pr_top = pr_top;
    END IF;

	IF pr_id_sucursal > 0 THEN

		SET @vendedorsuc = CONCAT('CREATE TEMPORARY TABLE tmp_vendedor AS
								SELECT
									cli.id_vendedor,
									clave,
									nombre,
									CASE
										WHEN ',pr_id_moneda,' = 100 THEN
											IFNULL(monto_moneda_base,0)
										WHEN ',pr_id_moneda,' = 149 THEN
											IFNULL(monto_usd,0)
										WHEN ',pr_id_moneda,' = 49  THEN
											IFNULL(monto_eur,0)
										ELSE
											0
									END venta_mes,
									CASE
										WHEN ',pr_id_moneda,' = 100 THEN
											IFNULL(egresos_moneda_base,0)
										WHEN ',pr_id_moneda,' = 149 THEN
											IFNULL(egresos_usd,0)
										WHEN ',pr_id_moneda,' = 49  THEN
											IFNULL(egresos_eur,0)
										ELSE
											0
									END devolucion_mes,
									CASE
										WHEN ',pr_id_moneda,' = 100 THEN
											IFNULL(venta_neta_moneda_base,0)
										WHEN ',pr_id_moneda,' = 149 THEN
											IFNULL(venta_neta_usd,0)
										WHEN ',pr_id_moneda,' = 49  THEN
											IFNULL(venta_neta_eur,0)
										ELSE
											0
									END venta_neta_mes,
									CASE
										WHEN ',pr_id_moneda,' = 100 THEN
											IFNULL(acumulado_moneda_base,0)
										WHEN ',pr_id_moneda,' = 149 THEN
											IFNULL(acumulado_usd,0)
										WHEN ',pr_id_moneda,' = 49  THEN
											IFNULL(acumulado_eur,0)
										ELSE
										0
									END acumulado
								FROM ic_rep_tr_acumulado_vendedor cli
								WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND   id_sucursal = ',pr_id_sucursal,'
								AND   fecha = ''',lo_fecha,'''
								GROUP BY cli.id_vendedor
								ORDER BY venta_neta_mes DESC
								LIMIT ',pr_top);

			-- SELECT @vendedorsuc;
			PREPARE stmt FROM @vendedorsuc;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;



			SET @vendedorsuc2 = CONCAT('CREATE TEMPORARY TABLE tmp_vendedor_resto AS
									SELECT
										''id_vendedor'' id_vendedor,
										''Otros'' clave,
										''Otros'' nombre,
										CASE
											WHEN ',pr_id_moneda,' = 100 THEN
												monto_moneda_base
											WHEN ',pr_id_moneda,' = 149 THEN
												monto_usd
											WHEN ',pr_id_moneda,' = 49  THEN
												monto_eur
											ELSE
												0
										END venta_mes,
										CASE
											WHEN ',pr_id_moneda,' = 100 THEN
												egresos_moneda_base
											WHEN ',pr_id_moneda,' = 149 THEN
												egresos_usd
											WHEN ',pr_id_moneda,' = 49  THEN
												egresos_eur
											ELSE
												0
										END devolucion_mes,
										CASE
											WHEN ',pr_id_moneda,' = 100 THEN
												venta_neta_moneda_base
											WHEN ',pr_id_moneda,' = 149 THEN
												venta_neta_usd
											WHEN ',pr_id_moneda,' = 49  THEN
												venta_neta_eur
											ELSE
												0
										END venta_neta_mes,
										CASE
											WHEN ',pr_id_moneda,' = 100 THEN
												IFNULL(acumulado_moneda_base,0)
											WHEN ',pr_id_moneda,' = 149 THEN
												IFNULL(acumulado_usd,0)
											WHEN ',pr_id_moneda,' = 49  THEN
												IFNULL(acumulado_eur,0)
											ELSE
											0
										END acumulado
									FROM ic_rep_tr_acumulado_vendedor cli
									WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND   id_sucursal = ',pr_id_sucursal,'
									AND   fecha = ''',lo_fecha,'''
									GROUP BY cli.id_vendedor
									ORDER BY venta_neta_mes DESC
									LIMIT ',pr_top,',1000');

		-- SELECT @vendedorsuc2;
		PREPARE stmt FROM @vendedorsuc2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SELECT
			COUNT(*)
		INTO
			lo_count
        FROM tmp_vendedor_resto;

		IF lo_count > 0 THEN
			SELECT *
			FROM tmp_vendedor
            UNION
			SELECT id_vendedor, clave, nombre, SUM(venta_mes), SUM(devolucion_mes), SUM(venta_neta_mes), acumulado
			FROM tmp_vendedor_resto;
		ELSE
			SELECT *
			FROM tmp_vendedor;
       END IF;

	ELSE

		SET @vendedorcorp = CONCAT('CREATE TEMPORARY TABLE tmp_vendedor_todos AS
								SELECT
									cli.id_vendedor,
									clave,
									nombre,
									CASE
										WHEN ',pr_id_moneda,' = 100 THEN
											IFNULL(monto_moneda_base,0)
										WHEN ',pr_id_moneda,' = 149 THEN
											IFNULL(monto_usd,0)
										WHEN ',pr_id_moneda,' = 49  THEN
											IFNULL(monto_eur,0)
										ELSE
											0
									END venta_mes,
									CASE
										WHEN ',pr_id_moneda,' = 100 THEN
											IFNULL(egresos_moneda_base,0)
										WHEN ',pr_id_moneda,' = 149 THEN
											IFNULL(egresos_usd,0)
										WHEN ',pr_id_moneda,' = 49  THEN
											IFNULL(egresos_eur,0)
										ELSE
											0
									END devolucion_mes,
									CASE
										WHEN ',pr_id_moneda,' = 100 THEN
											IFNULL(venta_neta_moneda_base,0)
										WHEN ',pr_id_moneda,' = 149 THEN
											IFNULL(venta_neta_usd,0)
										WHEN ',pr_id_moneda,' = 49  THEN
											IFNULL(venta_neta_eur,0)
										ELSE
											0
									END venta_neta_mes,
									CASE
										WHEN ',pr_id_moneda,' = 100 THEN
											IFNULL(acumulado_moneda_base,0)
										WHEN ',pr_id_moneda,' = 149 THEN
											IFNULL(acumulado_usd,0)
										WHEN ',pr_id_moneda,' = 49  THEN
											IFNULL(acumulado_eur,0)
										ELSE
										0
									END acumulado
								FROM ic_rep_tr_acumulado_vendedor cli
								WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND   fecha = ''',lo_fecha,'''
								GROUP BY cli.id_vendedor
								ORDER BY venta_neta_mes DESC
								LIMIT ',pr_top);
		-- SELECT @vendedorcorp;
		PREPARE stmt FROM @vendedorcorp;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET @vendedorcorp2 = CONCAT('CREATE TEMPORARY TABLE tmp_vendedor_todos_resto AS
									SELECT
										''id_vendedor'' id_vendedor,
										''Otros'' clave,
										''Otros'' nombre,
										CASE
											WHEN ',pr_id_moneda,' = 100 THEN
												monto_moneda_base
											WHEN ',pr_id_moneda,' = 149 THEN
												monto_usd
											WHEN ',pr_id_moneda,' = 49  THEN
												monto_eur
											ELSE
												0
										END venta_mes,
										CASE
											WHEN ',pr_id_moneda,' = 100 THEN
												egresos_moneda_base
											WHEN ',pr_id_moneda,' = 149 THEN
												egresos_usd
											WHEN ',pr_id_moneda,' = 49  THEN
												egresos_eur
											ELSE
												0
										END devolucion_mes,
										CASE
											WHEN ',pr_id_moneda,' = 100 THEN
												venta_neta_moneda_base
											WHEN ',pr_id_moneda,' = 149 THEN
												venta_neta_usd
											WHEN ',pr_id_moneda,' = 49  THEN
												venta_neta_eur
											ELSE
												0
										END venta_neta_mes,
										CASE
											WHEN ',pr_id_moneda,' = 100 THEN
												IFNULL(acumulado_moneda_base,0)
											WHEN ',pr_id_moneda,' = 149 THEN
												IFNULL(acumulado_usd,0)
											WHEN ',pr_id_moneda,' = 49  THEN
												IFNULL(acumulado_eur,0)
											ELSE
											0
										END acumulado
									FROM ic_rep_tr_acumulado_vendedor cli
									WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND   fecha = ''',lo_fecha,'''
									GROUP BY cli.id_vendedor
									ORDER BY venta_neta_mes DESC
									LIMIT ',pr_top,',1000');

		-- SELECT @vendedorcorp2;
		PREPARE stmt FROM @vendedorcorp2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

        SELECT
			COUNT(*)
		INTO
			lo_count
        FROM tmp_vendedor_todos_resto;

		IF lo_count > 0 THEN
			SELECT *
			FROM tmp_vendedor_todos
			UNION
			SELECT id_vendedor, clave, nombre, SUM(venta_mes), SUM(devolucion_mes), SUM(venta_neta_mes), acumulado
			FROM tmp_vendedor_todos_resto;
		ELSE
			SELECT *
			FROM tmp_vendedor_todos;
        END IF;
    END IF;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
