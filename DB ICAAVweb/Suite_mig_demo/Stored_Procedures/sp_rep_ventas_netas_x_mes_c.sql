DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_rep_ventas_netas_x_mes_c`(
	IN  pr_id_grupo_empresa	INT,
    IN  pr_id_sucursal 		INT,
	IN	pr_id_moneda		INT,
	IN	pr_idioma			INT,
    IN	pr_fecha			VARCHAR(7),
	OUT pr_rows_tot_table 	INT,
	OUT pr_message 	  		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_netas_x_mes_c
	@fecha:			10/08/2018
	@descripcion:	Sp para consultar las ventas netas por cliente por mes
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_sucursal						VARCHAR(100) DEFAULT '';
    DECLARE lo_anio_ant						VARCHAR(4);
    DECLARE lo_fecha_ant					VARCHAR(7);
    DECLARE lo_anio_ant_ant					VARCHAR(4);
    DECLARE lo_fecha_ant_ant				VARCHAR(7);
    DECLARE lo_mes_ant_ant					VARCHAR(2);
    DECLARE lo_fecha_año_actual  			VARCHAR(30);
    DECLARE lo_total_año_actual  			DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_fecha_actual		 			VARCHAR(20);
	DECLARE lo_fecha_año_anterior  			VARCHAR(30);
    DECLARE lo_total_año_anterior  			DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_fecha_anterior				VARCHAR(20);
	DECLARE lo_fecha_año_actual_mes_ant  	VARCHAR(30);
    DECLARE lo_total_año_actual_mes_ant  	DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_fecha_actual_mes_ant			VARCHAR(20);
	DECLARE lo_mes_def_actual				VARCHAR(30);
    DECLARE lo_mes_def_mes_ant				VARCHAR(30);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_netas_x_mes_c';
	END ;

    /* Desarrollo */

    /* ----------------------------------------------------------------- */

    /* BORRAR LAS TABLAS TEMPORALES */
	DROP TEMPORARY TABLE IF EXISTS tmp_anio_actual;
    DROP TEMPORARY TABLE IF EXISTS tmp_anio_anterior;
    DROP TEMPORARY TABLE IF EXISTS tmp_anio_anterior_anterior;

	/* ----------------------------------------------------------------- */
	/* AÑO ANTERIOR */
	SET lo_anio_ant = (SUBSTRING(pr_fecha,1,4) - 1);

    /* FECHA ANTERIOR */
    SET lo_fecha_ant = CONCAT(lo_anio_ant,'-',SUBSTRING(pr_fecha,6,2));

    /* ----------------------------------------------------------------- */
    /* MES ANTERIOR */
    SET lo_mes_ant_ant = SUBSTRING(pr_fecha,6,2);

    /* VALIDAR MES ANTERIOR */
    IF lo_mes_ant_ant = '01' THEN
		SET lo_fecha_ant_ant = CONCAT(lo_anio_ant,'-','12');
        SET lo_mes_ant_ant = '12';
	ELSE
		IF LENGTH(lo_mes_ant_ant - 1) > 1 THEN
			SET lo_fecha_ant_ant = CONCAT(SUBSTRING(pr_fecha,1,4),'-',(lo_mes_ant_ant - 1));
		ELSE
			SET lo_fecha_ant_ant = CONCAT(SUBSTRING(pr_fecha,1,4),'-0',(lo_mes_ant_ant - 1));
        END IF;
    END IF;

    /* ----------------------------------------------------------------- */

    /* VALIDAR LA SUCURSAL */
    IF pr_id_sucursal > 0 THEN
		SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal);
    END IF;

    /* ----------------------------------------------------------------- */

    /* MES DEFAULT CUANDO NO HAY DATOS */

    /* ACTUAL */
    SELECT
		mes
	INTO
		lo_mes_def_actual
	FROM ct_glob_tc_meses
	WHERE id_idioma = pr_idioma
	AND num_mes = SUBSTRING(pr_fecha,6,2);

	/* MES ANTEIOR AÑO ACTUAL */
    SELECT
		mes
	INTO
		lo_mes_def_mes_ant
	FROM ct_glob_tc_meses
	WHERE id_idioma = pr_idioma
	AND num_mes = (lo_mes_ant_ant - 1);

    /*--------------------------------1------------------------------------------*/

    /* CONSULTA AÑO ACTUAL */
    SET @query = CONCAT('CREATE TEMPORARY TABLE tmp_anio_actual
						SELECT
							CONCAT(mes.mes,'' '', SUBSTRING(fecha,1,4)) fecha1,
							imp.total,
							''',pr_fecha,''' fecha
						FROM (
							SELECT
								CASE
									WHEN ',pr_id_moneda,' = 100 THEN
										SUM(venta_neta_moneda_base)
									WHEN ',pr_id_moneda,' = 149 THEN
										SUM(venta_neta_usd)
									WHEN ',pr_id_moneda,' = 49  THEN
										SUM(venta_neta_eur)
									ELSE
										0
								END total,
								fecha
							FROM ic_rep_tr_acumulado_sucursal
							WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
                            ',lo_sucursal,'
							AND fecha =  ''',pr_fecha,''') imp
						JOIN ct_glob_tc_meses mes ON
							SUBSTRING(imp.fecha,6,2) = mes.num_mes
						WHERE mes.id_idioma = ',pr_idioma);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT
		fecha1,
        total,
        fecha
	INTO
		lo_fecha_año_actual,
        lo_total_año_actual,
        lo_fecha_actual
	FROM tmp_anio_actual;

    /*------------------------------2-------------------------------------------*/

    /* CONSULTA AÑO ANTERIOR */
    SET @query1 = CONCAT('CREATE TEMPORARY TABLE tmp_anio_anterior
						SELECT
							CONCAT(mes.mes,'' '',''',lo_anio_ant,''') fecha1,
							IFNULL(imp.total,0) total,
							''',lo_fecha_ant,''' fecha
                        FROM (
							SELECT
								CASE
									WHEN ',pr_id_moneda,' = 100 THEN
										SUM(venta_neta_moneda_base)
									WHEN ',pr_id_moneda,' = 149 THEN
										SUM(venta_neta_usd)
									WHEN ',pr_id_moneda,' = 49  THEN
										SUM(venta_neta_eur)
									ELSE
										0
								END total,
								fecha
							FROM ic_rep_tr_acumulado_sucursal
							WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
                            ',lo_sucursal,'
							AND fecha = ''',lo_fecha_ant,''') imp
						RIGHT JOIN ct_glob_tc_meses mes ON
							SUBSTRING(imp.fecha,6,2) = mes.num_mes
						WHERE mes.id_idioma = ',pr_idioma,'
						AND num_mes = SUBSTRING(imp.fecha,6,2)
						');

    -- SELECT @query1;
	PREPARE stmt FROM @query1;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT
		fecha1,
        total,
        fecha
	INTO
		lo_fecha_año_anterior,
        lo_total_año_anterior,
        lo_fecha_anterior
	FROM tmp_anio_anterior;

	/*-------------------------------3------------------------------------------*/

    /* CONSULTA MES ANTERIOR AÑO ACTUAL */
    SET @query2 = CONCAT('CREATE TEMPORARY TABLE tmp_anio_anterior_anterior
						SELECT
							CONCAT(mes.mes,'' '',''',SUBSTRING(pr_fecha,1,4),''') fecha1,
							IFNULL(imp.total,0) total,
							''',lo_fecha_ant_ant,''' fecha
						FROM (
							SELECT
								CASE
								WHEN ',pr_id_moneda,' = 100 THEN
									SUM(venta_neta_moneda_base)
								WHEN ',pr_id_moneda,' = 149 THEN
									SUM(venta_neta_usd)
								WHEN ',pr_id_moneda,' = 49  THEN
									SUM(venta_neta_eur)
								ELSE
									0
								END total,
								fecha
							FROM ic_rep_tr_acumulado_sucursal
							WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
                            ',lo_sucursal,'
							AND fecha = ''',lo_fecha_ant_ant,''') imp
							RIGHT JOIN ct_glob_tc_meses mes ON
								SUBSTRING(imp.fecha,6,2) = mes.num_mes
							WHERE mes.id_idioma = ',pr_idioma,'
							AND mes.num_mes = ''',(lo_mes_ant_ant - 1),'''');

	-- SELECT @query2;
	PREPARE stmt FROM @query2;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SELECT
		fecha1,
        total,
        fecha
	INTO
		lo_fecha_año_actual_mes_ant,
        lo_total_año_actual_mes_ant,
        lo_fecha_actual_mes_ant
    FROM tmp_anio_anterior_anterior;

	/*----------------------------------------------------------------------------*/

    IF lo_fecha_año_actual IS NULL THEN
		SET lo_fecha_año_actual = CONCAT(lo_mes_def_actual,' ',SUBSTRING(pr_fecha,1,4));
    END IF;

	IF lo_fecha_año_anterior IS NULL THEN
		SET lo_fecha_año_anterior = CONCAT(lo_mes_def_actual,' ',lo_anio_ant);
    END IF;

	IF lo_fecha_año_actual_mes_ant IS NULL THEN
		SET lo_fecha_año_actual_mes_ant = CONCAT(lo_mes_def_mes_ant,' ',SUBSTRING(pr_fecha,1,4));
    END IF;

    SELECT
		lo_fecha_año_actual,
        lo_total_año_actual,
        pr_fecha,
        lo_fecha_año_anterior,
        lo_total_año_anterior,
        lo_fecha_ant,
        lo_fecha_año_actual_mes_ant,
        lo_total_año_actual_mes_ant,
        lo_fecha_ant_ant
	FROM DUAL;

	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
