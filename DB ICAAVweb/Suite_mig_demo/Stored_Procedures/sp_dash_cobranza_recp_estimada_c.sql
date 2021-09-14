DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_cobranza_recp_estimada_c`(
	IN  pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN	pr_moneda_reporte					INT,
	IN  pr_ini_pag							INT,
    IN  pr_fin_pag							INT,
    OUT pr_rows_tot_table					INT,
    OUT pr_message 							TEXT
)
BEGIN
/*
	@nombre:		sp_dash_cobranza_recp_estimada_c
	@fecha: 		2019/08/29
	@descripción: 	Sp para obtenber grafica de cobros por semestre
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE lo_recuperacion					TEXT;
    DECLARE lo_porc_recup					TEXT;
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_dash_cobranza_recp_estimada_c';
	END ;

    /* DESARROLLO */
    /* VALIDAMOS LA MONEDA DEL REPORTE */
    SET lo_porc_recup = 'TRUNCATE((SUM(saldo_facturado) * 100) / SUM(saldo_facturado),2)';

    IF pr_moneda_reporte = 149 THEN
		SET lo_recuperacion = '(SUM(saldo_facturado) / tipo_cambio_usd)';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_recuperacion = '(SUM(saldo_facturado) / tipo_cambio_eur)';
	ELSE
		SET lo_recuperacion = 'SUM(saldo_facturado)';
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

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_recuperacion;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET @queryac = CONCAT('
					CREATE TEMPORARY TABLE tmp_recuperacion
					SELECT
						cve_cliente,
						razon_social cliente, ','
						',lo_recuperacion,' recuperacion
					FROM antiguedad_saldos
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND estatus = ''ACTIVO''
					AND saldo_facturado <> 0
					AND DATE_FORMAT(fecha_vencimiento, ''%Y-%m-%d'') >= DATE_FORMAT(NOW(), ''%Y-%m-%d'')
					AND DATE_FORMAT(fecha_vencimiento, ''%Y-%m-%d'') <= DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 MONTH), ''%Y-%m-%d'')
					GROUP BY cve_cliente
					ORDER BY recuperacion DESC'
    );

	-- SELECT @queryac;
    PREPARE stmt FROM @queryac;
	EXECUTE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		SUM(recuperacion)
	INTO
		@lo_suma
	FROM tmp_recuperacion;

    SELECT
		cve_cliente,
		cliente,
		recuperacion,
		(recuperacion / @lo_suma) * 100 porc_recup
	FROM tmp_recuperacion
    WHERE recuperacion != 0
    ORDER BY recuperacion DESC
    LIMIT pr_ini_pag, pr_fin_pag;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		COUNT(*)
    INTO
		pr_rows_tot_table
    FROM tmp_recuperacion;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
