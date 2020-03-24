DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_cobranza_graf_cobros_c`(
	IN  pr_id_grupo_empresa	INT,
    IN	pr_id_sucursal		INT,
    IN	pr_moneda_reporte	INT,
    IN  pr_id_idioma		INT,
    OUT pr_message 			TEXT
)
BEGIN
/*
	@nombre:		sp_dash_cobranza_graf_cobros_c
	@fecha: 		2019/08/16
	@descripción: 	Sp para obtenber grafica de cobros por semestre
	@autor : 		David Roldan Solares
	@cambios:
*/

    DECLARE lo_moneda_reporte 	TEXT;
    DECLARE lo_fecha_ini 		DATE;
    DECLARE lo_fecha_fin 		DATE;
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_dash_cobranza_graf_cobros';
	END ;

    /* DESARROLLO */
    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '(det.importe_usd * -1)';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '(det.importe_eur * -1)';
	ELSE
		SET lo_moneda_reporte = '(det.importe_moneda_base * -1)';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /*Rango de fechas*/
    IF DATE_FORMAT(SYSDATE(),'%m') BETWEEN '01' AND '06' THEN
		SET lo_fecha_ini = CONCAT(DATE_FORMAT(SYSDATE(),'%Y'),'-01-01 00:00:00');
        SET lo_fecha_fin = CONCAT(DATE_FORMAT(SYSDATE(),'%Y'),'-06-30 23:59:59');
	ELSE
		SET lo_fecha_ini = CONCAT(DATE_FORMAT(SYSDATE(),'%Y'),'-01-01 00:00:00');
        SET lo_fecha_fin = CONCAT(DATE_FORMAT(SYSDATE(),'%Y'),'-06-30 23:59:59');
        #SET lo_fecha_ini = CONCAT(DATE_FORMAT(SYSDATE(),'%Y'),'-07-01 00:00:00');
        #SET lo_fecha_fin = CONCAT(DATE_FORMAT(SYSDATE(),'%Y'),'-12-31 23:59:59');
	END IF;

     /* BORRAMOS LAS TABLAS TEMPORALES */
    DROP TABLE IF EXISTS tmp_sem_cobranza_actual;
    DROP TABLE IF EXISTS tmp_sem_cobranza_anterior;

    /* AÑO ACTUAL */
    SET @queryac = CONCAT('
						CREATE TEMPORARY TABLE tmp_sem_cobranza_actual
						SELECT
							DATE_FORMAT(NOW(), ''%Y'') anio_actual,
							mes.mes mes_actual,
							IFNULL(a.total_cobrado, 0.00) total_cobrado,
                            mes.num_mes
						FROM(
                        SELECT
							SUM(',lo_moneda_reporte,') total_cobrado,
							fecha
						FROM ic_glob_tr_cxc cxc
						JOIN ic_glob_tr_cxc_detalle det ON
							cxc.id_cxc = det.id_cxc
						WHERE cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND det.estatus = ''ACTIVO''
						AND det.id_factura IS NULL
						AND cxc.estatus = ''ACTIVO''
						AND DATE_FORMAT(det.fecha, ''%Y-%m'') <= DATE_FORMAT(NOW(), ''%Y-%m'')
						AND DATE_FORMAT(det.fecha, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH), ''%Y-%m'')
						GROUP BY DATE_FORMAT(det.fecha,''%Y-%m'')) a
						JOIN ct_glob_tc_meses mes ON
							SUBSTRING(a.fecha,6,2) = mes.num_mes
						WHERE mes.id_idioma = ',pr_id_idioma,'
						GROUP BY mes.num_mes');

	-- SELECT @queryac;
    PREPARE stmt FROM @queryac;
	EXECUTE stmt;

    /* AÑO ANTERIOR */
    SET @queryant = CONCAT('
						CREATE TEMPORARY TABLE tmp_sem_cobranza_anterior
						SELECT
							DATE_FORMAT(NOW(), ''%Y'') anio_anterior,
							mes.mes mes_anterior,
							IFNULL(a.total_cobrado, 0.00) total_cobrado,
                            mes.num_mes
						FROM(
						SELECT
							IFNULL(SUM(',lo_moneda_reporte,'), 0.00) total_cobrado,
							det.fecha
						FROM ic_glob_tr_cxc cxc
						JOIN ic_glob_tr_cxc_detalle det ON
							cxc.id_cxc = det.id_cxc
						WHERE cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND det.estatus = ''ACTIVO''
						AND det.id_factura IS NULL
						AND cxc.estatus = ''ACTIVO''
						AND DATE_FORMAT(det.fecha, ''%Y-%m'') <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), ''%Y-%m'')
						AND DATE_FORMAT(det.fecha, ''%Y-%m'') > DATE_FORMAT(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL 6 MONTH), ''%Y-%m'')
						GROUP BY DATE_FORMAT(det.fecha, ''%Y-%m'')) a
						JOIN ct_glob_tc_meses mes ON
							SUBSTRING(a.fecha,6,2) = mes.num_mes
						WHERE mes.id_idioma = ',pr_id_idioma,'
						GROUP BY mes.num_mes');

    -- SELECT @queryant;
    PREPARE stmt FROM @queryant;
	EXECUTE stmt;

    /* Datos para grafica */
    SELECT
		act.mes_actual,
        IFNULL(act.anio_actual, DATE_FORMAT(NOW(), '%Y')) anio_actual,
        IFNULL(act.total_cobrado, 0.00) total_cobrado,
        IFNULL(ant.anio_anterior, DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 YEAR), '%Y')) anio_anterior,
        IFNULL(ant.total_cobrado, 0.00) total_cobrado_anterior
    FROM tmp_sem_cobranza_actual act
    LEFT JOIN tmp_sem_cobranza_anterior ant ON
		 act.mes_actual = ant.mes_anterior
	ORDER BY act.num_mes ASC;

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
