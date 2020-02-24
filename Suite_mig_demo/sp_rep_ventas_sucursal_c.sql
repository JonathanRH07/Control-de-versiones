DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_ventas_sucursal_c`(
	IN	pr_id_grupo_empresa						INT,
    IN	pr_id_sucursal							INT,
    IN  pr_año									VARCHAR(4),
    IN	pr_id_moneda							INT,
    IN  pr_mes									VARCHAR(2),
    IN  pr_top									INT,
    OUT pr_message 	  							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_sucursal_c
	@fecha:			10/08/2018
	@descripcion:	Sp para consultar las ventas por sucursal |REPOORTE VENTAS TOTALES|
	@autor: 		David Roldan Solares
	@cambios:
*/

	DECLARE lo_sucursal							TEXT DEFAULT '';
    DECLARE lo_fecha 							VARCHAR(7);
    DECLARE lo_moneda_reporte_neto				TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_ventas_sucursal_c';
	END;

    /* Desarrollo */
    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	DROP TABLE IF EXISTS tmp_sucursal;
	DROP TABLE IF EXISTS tmp_sucursal_resto;

	/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	/* VALIDAR AÑO */
    IF pr_mes = '' THEN
		SET lo_fecha = DATE_FORMAT(NOW(),'%Y-%m');
	ELSE
		SET lo_fecha = CONCAT(pr_año,'-',pr_mes);
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	/* VALIDAR EL TOP */
    IF pr_top = 0 THEN
		SET pr_top = 10;
	ELSE
		SET pr_top = pr_top;
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    /* VALIDAR MONEDA DEL REPORTE */
    IF pr_id_moneda = 149 THEN
        SET lo_moneda_reporte_neto = 'venta_neta_usd';
	ELSEIF pr_id_moneda = 49 THEN
        SET lo_moneda_reporte_neto = 'venta_neta_eur';
	ELSE
        SET lo_moneda_reporte_neto = 'venta_neta_moneda_base';
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
			SET lo_sucursal = CONCAT('AND acu.id_sucursal = ',pr_id_sucursal,'');
		END IF;
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	/*Suma solo la sucursal seleccionada*/
	SET @querysucselc = CONCAT('
							CREATE TEMPORARY TABLE tmp_sucursal
							SELECT
								suc.cve_sucursal,
								IFNULL(SUM(',lo_moneda_reporte_neto,') ,0) venta_neta
							FROM ic_rep_tr_acumulado_sucursal acu
							JOIN ic_cat_tr_sucursal suc ON
								acu.id_sucursal = suc.id_sucursal
							WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_sucursal,'
							AND acu.fecha  = ''',lo_fecha,'''
                            LIMIT ',pr_top);

	-- SELECT @querysucselc;
	PREPARE stmt FROM @querysucselc;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;


	/*Suma todas las sucursales*/
	SET @querysucselc2 = CONCAT('
							CREATE TEMPORARY TABLE tmp_sucursal_resto
							SELECT
								''Otros'' cve_sucursal,
								IFNULL(SUM(',lo_moneda_reporte_neto,') ,0) venta_neta
							FROM ic_rep_tr_acumulado_sucursal acu
							WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND acu.fecha  = ''',lo_fecha,'''
                            LIMIT ',pr_top,',1000');

	-- SELECT @querysucselc2;
	PREPARE stmt FROM @querysucselc2;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT
		COUNT(*)
	INTO
		@lo_count
	FROM tmp_sucursal_resto;

    IF @lo_es_matriz = 0 THEN
		IF @lo_count = 0 THEN
			SELECT *
			FROM tmp_sucursal;
		ELSE
			SELECT *
			FROM tmp_sucursal
			UNION ALL
			SELECT *
			FROM tmp_sucursal_resto;
		END IF;
	ELSE
		SELECT *
		FROM tmp_sucursal;
	END IF;

	/* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    /* Mensaje de ejecución */
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
