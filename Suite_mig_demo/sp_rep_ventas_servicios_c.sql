DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_ventas_servicios_c`(
	IN  pr_id_grupo_empresa						INT,
	IN	pr_id_sucursal							INT,
    IN	pr_año									VARCHAR(4),
    IN	pr_id_moneda							INT,
    IN	pr_mes									VARCHAR(2),
    IN	pr_top									INT,
	OUT pr_message 	  							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_servicios_c
	@fecha:			2018/11/27
	@descripcion:	Sp para consultar las ventas por servicio por mes |REPOORTE VENTAS TOTALES|
	@autor: 		David Roldan Solares
	@
*/
	DECLARE lo_sucursal							TEXT DEFAULT '';
    DECLARE lo_fecha 							VARCHAR(7);
    DECLARE lo_count							INT;
	DECLARE lo_moneda_reporte_ing				TEXT;
    DECLARE lo_moneda_reporte_egr				TEXT;
    DECLARE lo_moneda_reporte_neto				TEXT;
    DECLARE lo_moneda_reporte_acu				TEXT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_servicios_c';
	END ;

    /* Desarrollo */
    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    DROP TABLE IF EXISTS tmp_servicio;
    DROP TABLE IF EXISTS tmp_servicio_resto;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    /* VALIDAR AÑO */
    IF pr_mes = '' THEN
		SET lo_fecha = DATE_FORMAT(SYSDATE(),'%Y-%m');
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
		SET lo_moneda_reporte_ing = 'monto_usd';
        SET lo_moneda_reporte_egr = 'egresos_usd';
        SET lo_moneda_reporte_neto = 'venta_neta_usd';
        SET lo_moneda_reporte_acu = 'acumulado_usd';
	ELSEIF pr_id_moneda = 49 THEN
		SET lo_moneda_reporte_ing = 'monto_eur';
        SET lo_moneda_reporte_egr = 'egresos_eur';
        SET lo_moneda_reporte_neto = 'venta_neta_eur';
        SET lo_moneda_reporte_acu = 'acumulado_eur';
	ELSE
		SET lo_moneda_reporte_ing = 'monto_moneda_base';
		SET lo_moneda_reporte_egr = 'egresos_moneda_base';
        SET lo_moneda_reporte_neto = 'venta_neta_moneda_base';
        SET lo_moneda_reporte_acu = 'acumulado_moneda_base';
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

	SET @serviciosucur = CONCAT('
						CREATE TEMPORARY TABLE tmp_servicio AS
						SELECT
							cli.id_servicio,
							cve_servicio clave,
							descripcion nombre,
							IFNULL(',lo_moneda_reporte_ing,' ,0) venta_mes,
							IFNULL(',lo_moneda_reporte_egr,' ,0) devolucion_mes,
							IFNULL(',lo_moneda_reporte_neto,' ,0) venta_neta_mes,
							IFNULL(',lo_moneda_reporte_acu,' ,0) acumulado
						FROM ic_rep_tr_acumulado_servicio cli
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND fecha = ''',lo_fecha,'''
						GROUP BY cli.id_servicio
						ORDER BY venta_neta_mes DESC
						LIMIT ',pr_top);

	-- SELECT @serviciosucur;
	PREPARE stmt FROM @serviciosucur;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;


	SET @serviciosucur2 = CONCAT('
						CREATE TEMPORARY TABLE tmp_servicio_resto AS
						SELECT
							''id_servicio'' id_servicio,
							''Otros'' clave,
							''Otros'' nombre,
							IFNULL(',lo_moneda_reporte_ing,' ,0) venta_mes,
							IFNULL(',lo_moneda_reporte_egr,' ,0) devolucion_mes,
							IFNULL(',lo_moneda_reporte_neto,' ,0) venta_neta_mes,
							IFNULL(',lo_moneda_reporte_acu,' ,0) acumulado
						FROM ic_rep_tr_acumulado_servicio cli
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND fecha = ''',lo_fecha,'''
						GROUP BY cli.id_servicio
						ORDER BY venta_neta_mes DESC
						LIMIT ',pr_top,',1000');

	-- SELECT @serviciosucur2;
	PREPARE stmt FROM @serviciosucur2;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT
		COUNT(*)
	INTO
		lo_count
	FROM tmp_servicio_resto;

	IF lo_count > 0 THEN
		SELECT *
		FROM tmp_servicio
		UNION
		SELECT id_servicio, clave, nombre, SUM(venta_mes), SUM(devolucion_mes), SUM(venta_neta_mes), acumulado
		FROM tmp_servicio_resto;
	ELSE
		SELECT *
		FROM tmp_servicio;
	END IF;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
