DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_ventas_clientes_c`(
	IN  pr_id_grupo_empresa	INT,
	IN	pr_id_sucursal		INT,
    IN	pr_año				VARCHAR(4),
    IN	pr_id_moneda		INT,
    IN	pr_mes				VARCHAR(2),
    IN	pr_top				INT,
    -- IN	pr_id_idioma		INT,
	-- OUT pr_rows_tot_table 	INT,
	OUT pr_message 	  		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_clientes_c
	@fecha:			2018/11/27
	@descripcion:	Sp para consultar las ventas por clientes por mes
	@autor: 		David Roldan Solares
	@
*/

	-- DECLARE lo_sucursal		INT;
    DECLARE lo_fecha 		VARCHAR(7);
    DECLARE lo_count		INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_clientes_c';
	END ;

    DROP TABLE IF EXISTS tmp_cliente;
    DROP TABLE IF EXISTS tmp_cliente_resto;
    DROP TABLE IF EXISTS tmp_cliente_todos;
    DROP TABLE IF EXISTS tmp_cliente_todos_resto;

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

        /*Suma solo la sucursal seleccionada*/
		SET @clientesuc = CONCAT('CREATE TEMPORARY TABLE tmp_cliente AS
									SELECT
										cli.id_cliente,
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
									FROM ic_rep_tr_acumulado_cliente cli
									WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND   id_sucursal = ',pr_id_sucursal,'
									AND   fecha = ''',lo_fecha,'''
									GROUP BY cli.id_cliente
									ORDER BY venta_neta_mes DESC
									LIMIT ',pr_top);


        -- SELECT @clientesuc;
		PREPARE stmt FROM @clientesuc;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		/*Suma todas las sucursales si se selecciona una sucursal*/
		SET @clientesuc2 = CONCAT('CREATE TEMPORARY TABLE tmp_cliente_resto AS
									SELECT
										cli.id_cliente,
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
												IFNULL(monto_moneda_base - egresos_moneda_base,0)
											WHEN ',pr_id_moneda,' = 149 THEN
												IFNULL(monto_usd - egresos_usd,0)
											WHEN ',pr_id_moneda,' = 49  THEN
												IFNULL(monto_eur - egresos_eur,0)
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
									FROM ic_rep_tr_acumulado_cliente cli
									WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND   id_sucursal = ',pr_id_sucursal,'
									AND   fecha = ''',lo_fecha,'''
									GROUP BY cli.id_cliente
									ORDER BY venta_neta_mes DESC
									LIMIT ',pr_top,',1000');

		-- SELECT @clientesuc2;
		PREPARE stmt FROM @clientesuc2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SELECT
			COUNT(*)
		INTO
			lo_count
        FROM tmp_cliente_resto;

        IF lo_count > 0 THEN
			SELECT *
			FROM tmp_cliente
			UNION
			SELECT 'id_cliente' id_cliente, 'Otros' clave, 'Otros' nombre, SUM(venta_mes), SUM(devolucion_mes), SUM(venta_neta_mes), SUM(acumulado)
			FROM tmp_cliente_resto;
		ELSE
			SELECT *
			FROM tmp_cliente;
        END IF;

	ELSE

		/*Suma todas las sucursales si es corporativo*/
		SET @clientescorp = CONCAT('CREATE TEMPORARY TABLE tmp_cliente_todos AS
									SELECT
										cli.id_cliente,
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
												IFNULL(monto_moneda_base - egresos_moneda_base,0)
											WHEN ',pr_id_moneda,' = 149 THEN
												IFNULL(monto_usd - egresos_usd,0)
											WHEN ',pr_id_moneda,' = 49  THEN
												IFNULL(monto_eur - egresos_eur,0)
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
									FROM ic_rep_tr_acumulado_cliente cli
									WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND   fecha = ''',lo_fecha,'''
									GROUP BY cli.id_cliente
									ORDER BY venta_neta_mes DESC
									LIMIT ',pr_top);
		-- SELECT @clientescorp;
        PREPARE stmt FROM @clientescorp;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

        /*Suma todas las sucursales si es corporativo*/
		SET @clientescorp2 = CONCAT('CREATE TEMPORARY TABLE tmp_cliente_todos_resto AS
									SELECT
										cli.id_cliente,
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
												IFNULL(monto_moneda_base - egresos_moneda_base,0)
											WHEN ',pr_id_moneda,' = 149 THEN
												IFNULL(monto_usd - egresos_usd,0)
											WHEN ',pr_id_moneda,' = 49  THEN
												IFNULL(monto_eur - egresos_eur,0)
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
									FROM ic_rep_tr_acumulado_cliente cli
									WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND   fecha = ''',lo_fecha,'''
									GROUP BY cli.id_cliente
									ORDER BY venta_neta_mes DESC
									LIMIT ',pr_top,',1000');

		-- SELECT @clientescorp2;
        PREPARE stmt FROM @clientescorp2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

        SELECT
			COUNT(*)
		INTO
			lo_count
        FROM tmp_cliente_todos_resto;

         IF lo_count > 0 THEN

            SELECT *
			FROM tmp_cliente_todos
			UNION
			SELECT 'id_cliente' id_cliente, 'Otros' clave, 'Otros' nombre, SUM(venta_mes), SUM(devolucion_mes), SUM(venta_neta_mes), SUM(acumulado)
			FROM tmp_cliente_todos_resto;
		ELSE
			SELECT *
			FROM tmp_cliente_todos;
        END IF;

    END IF;
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
