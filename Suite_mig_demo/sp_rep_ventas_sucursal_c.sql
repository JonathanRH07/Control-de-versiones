DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_ventas_sucursal_c`(
	IN	pr_id_grupo_empresa	INT,
    IN	pr_id_sucursal		INT,
    IN  pr_año				VARCHAR(4),
    IN	pr_id_moneda		INT,
    IN  pr_mes				VARCHAR(2),
    IN  pr_top				INT,
    -- IN  pr_id_idioma		INT,
	-- OUT pr_rows_tot_table 	INT,
    OUT pr_message 	  		VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_sucursal_c
	@fecha:			10/08/2018
	@descripcion:	Sp para consultar las ventas por sucursal
	@autor: 		David Roldan Solares
	@cambios:
*/

	-- DECLARE lo_sucursal			INT;
    DECLARE lo_fecha 			VARCHAR(7);
    DECLARE lo_venta_todos 		DECIMAL(16,2);
    DECLARE lo_sucursal_todos	VARCHAR(25);
    DECLARE lo_venta_sucur		DECIMAL(16,2);
    DECLARE lo_sucursal_nom		VARCHAR(25);
    DECLARE lo_venta_top		DECIMAL(16,2);
    DECLARE lo_venta_top_res	DECIMAL(16,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_rep_ventas_sucursal_c';
	END;

    DROP TABLE IF EXISTS tmp_sucursal;
	DROP TABLE IF EXISTS tmp_sucursal_resto;
    DROP TABLE IF EXISTS tmp_top;
    DROP TABLE IF EXISTS tmp_top_res;

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
        SET @querysucselc = CONCAT('CREATE TEMPORARY TABLE tmp_sucursal AS
									SELECT
										suc.cve_sucursal,
										CASE
											WHEN ',pr_id_moneda,' != 149 AND ',pr_id_moneda,' = 100 THEN
												IFNULL(SUM(venta_neta_moneda_base),0)
											WHEN ',pr_id_moneda,' = 149 THEN
												IFNULL(SUM(venta_neta_usd),0)
											WHEN ',pr_id_moneda,' = 49 THEN
												IFNULL(SUM(venta_neta_eur),0)
											ELSE
												0
										END venta_neta
									FROM ic_rep_tr_acumulado_sucursal acu
									JOIN ic_cat_tr_sucursal suc ON
										acu.id_sucursal = suc.id_sucursal
									WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND   acu.fecha  = ''',lo_fecha,'''
									AND   acu.id_sucursal = ',pr_id_sucursal);

		-- SELECT @querysucselc;
		PREPARE stmt FROM @querysucselc;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;


        /*Suma todas las sucursales si se selecciona una sucursal*/
        SET @querysucselc2 = CONCAT('CREATE TEMPORARY TABLE tmp_sucursal_resto AS
									SELECT
										''Otros'' cve_sucursal,
										CASE
											WHEN ',pr_id_moneda,' != 149 AND ',pr_id_moneda,' = 100 THEN
												IFNULL(SUM(venta_neta_moneda_base),0)
											WHEN ',pr_id_moneda,' = 149 THEN
												IFNULL(SUM(venta_neta_usd),0)
											WHEN ',pr_id_moneda,' = 49 THEN
												IFNULL(SUM(venta_neta_eur),0)
											ELSE
												0
										END venta_neta
									FROM ic_rep_tr_acumulado_sucursal acu
									WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND   acu.fecha  = ''',lo_fecha,'''
									AND   id_sucursal <> ',pr_id_sucursal);

		-- SELECT @querysucselc2;
        PREPARE stmt FROM @querysucselc2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;


        SELECT
			*
		FROM tmp_sucursal
		UNION ALL
		SELECT
			*
		FROM tmp_sucursal_resto;


    ELSE

		/*Suma todas las sucursales si es corporativo*/
        SET @querycorp = CONCAT('CREATE TEMPORARY TABLE tmp_top AS
								SELECT
									cve_sucursal,
									CASE
										WHEN ',pr_id_moneda,' != 149 AND ',pr_id_moneda,' != 49 THEN
											IFNULL(SUM(venta_neta_moneda_base),0)
										WHEN ',pr_id_moneda,' = 149 THEN
											IFNULL(SUM(venta_neta_usd),0)
										WHEN ',pr_id_moneda,' = 49 THEN
											IFNULL(SUM(venta_neta_eur),0)
										ELSE
											0
									END venta_neta
								FROM ic_rep_tr_acumulado_sucursal acu
								JOIN ic_cat_tr_sucursal suc ON
									acu.id_sucursal = suc.id_sucursal
								WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND   acu.fecha  = ''',lo_fecha,'''
								GROUP BY acu.id_sucursal
								LIMIT ',pr_top);

        -- SELECT @querycorp;
        PREPARE stmt FROM @querycorp;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;


		/*Suma todas las sucursales si es corporativo*/
        SET @querycorp2 = CONCAT('CREATE TEMPORARY TABLE tmp_top_res AS
								SELECT
									''OTROS'' cve_sucursal,
									CASE
										WHEN ',pr_id_moneda,' != 149 AND ',pr_id_moneda,' = 100 THEN
											venta_neta_moneda_base
										WHEN ',pr_id_moneda,' = 149 THEN
											venta_neta_usd
										WHEN ',pr_id_moneda,' = 49 THEN
											venta_neta_eur
										ELSE
											0
									END venta_neta
								FROM ic_rep_tr_acumulado_sucursal acu
								WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND   acu.fecha  = ''',lo_fecha,'''
								LIMIT ',pr_top,',1000');

		-- SELECT @querycorp2;
		PREPARE stmt FROM @querycorp2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;


        SELECT
			cve_sucursal,
            venta_neta
		FROM tmp_top
        UNION ALL
        SELECT
			cve_sucursal,
			SUM(venta_neta)
		FROM tmp_top_res;

	END IF;

    /* Mensaje de ejecución */
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
