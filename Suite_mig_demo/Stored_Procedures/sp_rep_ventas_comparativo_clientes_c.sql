DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_ventas_comparativo_clientes_c`(
	IN  pr_id_grupo_empresa						INT,
	IN  pr_id_sucursal 							INT,
	IN	pr_id_moneda							INT,
    IN 	pr_id_idioma							INT,
    IN	pr_fecha								VARCHAR(4),
	OUT pr_rows_tot_table 						INT,
	OUT pr_message 	  							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_comparativo_clientes_c
	@fecha:			02/08/2018
	@descripcion:	Sp para consultar el comparativo de las ventas por cliente por mes y año
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/
    DECLARE lo_sucursal							VARCHAR(100) DEFAULT '';
    DECLARE lo_moneda_reporte					TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_comparativo_clientes_c';
	END ;

    /* Desarrollo */
    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    DROP TEMPORARY TABLE IF EXISTS tmp_comparativo_actual;
    DROP TEMPORARY TABLE IF EXISTS tmp_comparativo_anterior;

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

    /* ACTUAL */
	SET @query1 = CONCAT('CREATE TEMPORARY TABLE tmp_comparativo_actual
							SELECT
							CONCAT(''',pr_fecha,''',''-'',
									CASE
										WHEN LENGTH(mes.num_mes) > 1 THEN
											num_mes
										ELSE
											CONCAT(''0'',mes.num_mes)
									END) anio_actual,
							mes.mes,
                            IFNULL(SUM(',lo_moneda_reporte,'), 0) monto
							FROM
							(SELECT
								*
							FROM ic_rep_tr_acumulado_cliente clie
							WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_sucursal,'
							AND SUBSTRING(clie.fecha,1,4) = ''',pr_fecha,''') a
							RIGHT JOIN ct_glob_tc_meses mes ON
								SUBSTRING(fecha,6,2) = mes.num_mes
							WHERE mes.id_idioma = ',pr_id_idioma,'
							GROUP BY mes.num_mes'
						);

    -- SELECT @query1;
    PREPARE stmt FROM @query1;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


    /* ANTERIOR */
    SET @query2 = CONCAT('CREATE TEMPORARY TABLE tmp_comparativo_anterior
							SELECT
								CONCAT(',(pr_fecha - 1),',''-'',
								CASE
									WHEN LENGTH(mes.num_mes) > 1 THEN
										num_mes
									ELSE
										CONCAT(''0'',mes.num_mes)
								END
								) anio_anterior,
								mes.mes,
								IFNULL(SUM(',lo_moneda_reporte,'), 0) monto
							FROM
							(SELECT
								*
							FROM ic_rep_tr_acumulado_cliente clie
							WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_sucursal,'
							AND SUBSTRING(clie.fecha,1,4) = ''',(pr_fecha-1),''') b
							RIGHT JOIN ct_glob_tc_meses mes ON
								SUBSTRING(fecha,6,2) = mes.num_mes
							WHERE mes.id_idioma = ',pr_id_idioma,'
							GROUP BY mes.num_mes');

	-- SELECT @query2;
	PREPARE stmt FROM @query2;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;


	SELECT
		a.mes,
        a.anio_actual,
        a.monto importe_actual_neto,
        b.anio_anterior,
        b.monto importe_anterior_neto
	FROM tmp_comparativo_actual a
	JOIN tmp_comparativo_anterior b ON
		a.mes = b.mes;

	/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	/* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
