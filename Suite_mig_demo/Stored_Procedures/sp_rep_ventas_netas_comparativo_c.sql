DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_ventas_netas_comparativo_c`(
	IN  pr_id_grupo_empresa						INT,
	IN  pr_id_sucursal 							INT,
    IN	pr_año									VARCHAR(4),
    IN	pr_id_moneda							INT,
	IN 	pr_id_idioma							INT,
	OUT pr_message 	  							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_netas_comparativo_c
	@fecha:			26/11/2018
	@descripcion:	Sp para consultar el comparativo de las ventas por cliente por mes y año |REPORTE DE VENTAS TOTALES|
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/
	/*VARIABLES*/
    DECLARE lo_sucursal 						TEXT DEFAULT '';
    DECLARE lo_moneda_reporte					TEXT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_netas_comparativo_c';
	END ;


    /* Desarrollo */
    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_totales_actual;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_totales_anterior;
    DROP TEMPORARY TABLE IF EXISTS tmp_ventas_totales_ante_anterior;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    /* VALIDAR MONEDA DEL REPORTE */
    IF pr_id_moneda = 149 THEN
        SET lo_moneda_reporte = 'venta_neta_usd';
	ELSEIF pr_id_moneda = 49 THEN
        SET lo_moneda_reporte = 'venta_neta_eur';
	ELSE
        SET lo_moneda_reporte = 'venta_neta_moneda_base';
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    /* VALIDAR SUCURSAL EN CASO DE SER CORPORATIVO */
	SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF pr_id_sucursal > 0 THEN
		IF @lo_es_matriz = 0 THEN
			SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal,'');
		END IF;
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    /* AÑO ACTUAL */
    SET @queryactual = CONCAT('CREATE TEMPORARY TABLE tmp_ventas_totales_actual
							SELECT
								CASE
									WHEN LENGTH(num_mes) = 1 THEN
										CONCAT(''',pr_año,''',''-'',''0'',mes.num_mes)
									WHEN LENGTH(num_mes) > 1 THEN
										CONCAT(''',pr_año,''',''-'',mes.num_mes)
								END anio_actual,
								mes.mes mes_actual,
								IFNULL(SUM(',lo_moneda_reporte,') ,0) monto_actual
							FROM
							(SELECT *
							FROM ic_rep_tr_acumulado_sucursal suc
							WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_sucursal,'
							AND suc.fecha LIKE ''',pr_año,'%'') b
							RIGHT JOIN ct_glob_tc_meses mes ON
								SUBSTRING(b.fecha,6,2) = mes.num_mes
							WHERE mes.id_idioma = ',pr_id_idioma,'
							GROUP BY mes.num_mes;');

    -- SELECT @queryactual;
    PREPARE stmt FROM @queryactual;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* AÑO ANTERIOR  */
    SET @queryanterior = CONCAT('CREATE TEMPORARY TABLE tmp_ventas_totales_anterior
								SELECT
									CASE
										WHEN LENGTH(num_mes) = 1 THEN
											CONCAT((',(pr_año - 1),'),''-'',''0'',mes.num_mes)
										WHEN LENGTH(num_mes) > 1 THEN
											CONCAT((',(pr_año - 1),'),''-'',mes.num_mes)
									END anio_anterior,
									mes.mes mes_anterior,
									IFNULL(SUM(',lo_moneda_reporte,') ,0) monto_anterior
								FROM
								(SELECT *
								FROM ic_rep_tr_acumulado_sucursal suc
								WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
                                ',lo_sucursal,'
								AND suc.fecha LIKE ''',(pr_año - 1),'%'' ) b
								RIGHT JOIN ct_glob_tc_meses mes ON
									SUBSTRING(b.fecha,6,2) = mes.num_mes
								WHERE mes.id_idioma = ',pr_id_idioma,'
								GROUP BY mes.num_mes');

    -- SELECT @queryanterior;
    PREPARE stmt FROM @queryanterior;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /*  AÑO ANTERIOR ANTERIOR  */
    SET @queryanteanterior = CONCAT('CREATE TEMPORARY TABLE tmp_ventas_totales_ante_anterior
									SELECT
										CASE
											WHEN LENGTH(num_mes) = 1 THEN
												CONCAT((',(pr_año - 2),'),''-'',''0'',mes.num_mes)
											WHEN LENGTH(num_mes) > 1 THEN
												CONCAT((',(pr_año - 2),'),''-'',mes.num_mes)
										END anio_ante_anterior,
										mes.mes mes_ante_anterior,
										IFNULL(SUM(',lo_moneda_reporte,') ,0) monto_ante_anterior
									FROM
									(SELECT *
									FROM ic_rep_tr_acumulado_sucursal suc
									WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
									',lo_sucursal,'
									AND suc.fecha LIKE ''',(pr_año - 2),'%'') b
									RIGHT JOIN ct_glob_tc_meses mes ON
										SUBSTRING(b.fecha,6,2) = mes.num_mes
									WHERE mes.id_idioma = ',pr_id_idioma,'
									GROUP BY mes.num_mes');

	-- SELECT @queryanteanterior;
    PREPARE stmt FROM @queryanteanterior;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    SELECT
		actual.*,
		' ||| ',
		anterior.*,
        ' ||| ',
        ante_anterior.*
    FROM tmp_ventas_totales_actual actual
    JOIN tmp_ventas_totales_anterior anterior ON
		actual.mes_actual = anterior.mes_anterior
	JOIN tmp_ventas_totales_ante_anterior ante_anterior ON
		actual.mes_actual = ante_anterior.mes_ante_anterior;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
