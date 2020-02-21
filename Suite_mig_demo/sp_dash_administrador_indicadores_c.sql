DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_indicadores_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    -- IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_indicadores2_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_clientes_sn_actividad		INT;
    DECLARE lo_porc_cancelaciones			DECIMAL(16.2);
    DECLARE lo_numero_folios				INT;
    DECLARE lo_efectividad_pnr				DECIMAL(5,2);
	DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';
    DECLARE lo_sucursal2						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_ventas_indicadores_c';
	END;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal,'');
        SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_clientes_1;
    DROP TABLE IF EXISTS tmp_clientes_2;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND fac.id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_1 = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_clientes_1
				SELECT
					fac.id_factura,
					fac.id_cliente
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tr_cliente cli ON
					fac.id_cliente = cli.id_cliente
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
                AND fac.hora_factura IS NOT NULL
                AND fac.estatus != 2
                AND cli.estatus = 1
                AND fac.tipo_cfdi = ''I''
				AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), ''%Y-%m-%d'')
                AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 12 MONTH), ''%Y-%m-%d'')
                ORDER BY fac.fecha_factura DESC');

	-- SELECT @query_1;
	PREPARE stmt FROM @query_1;
	EXECUTE stmt;

    SET @query_2 = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_clientes_2
                SELECT
					fac.id_factura,
					fac.id_cliente
				FROM ic_fac_tr_factura fac
				JOIN ic_fac_tr_factura_detalle det ON
					fac.id_factura = det.id_factura
				JOIN ic_cat_tr_cliente cli ON
					fac.id_cliente = cli.id_cliente
				WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
                AND fac.hora_factura IS NOT NULL
                AND fac.estatus != 2
                AND cli.estatus = 1
                AND fac.tipo_cfdi = ''E''
                AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), ''%Y-%m-%d'')
				AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') <= DATE_FORMAT(NOW(), ''%Y-%m-%d'')
                ORDER BY fac.fecha_factura DESC');

	-- SELECT @query_2;
	PREPARE stmt FROM @query_2;
	EXECUTE stmt;

    SELECT
		IFNULL(COUNT(*), 0)
	INTO
		lo_clientes_sn_actividad
	FROM (
    SELECT
		a.*
	FROM tmp_clientes_1 a
	LEFT JOIN tmp_clientes_2 b ON
		a.id_cliente = b.id_cliente
	GROUP BY a.id_cliente) a;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* PORCENTAJE DE CANCELACION */
    SET @queryporc_can = CONCAT(
						'
						SELECT
							IFNULL(COUNT(*), 0)
						INTO
							@lo_porc_cancelaciones
						FROM ic_fac_tr_factura
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal2,'
						AND estatus = 2
						AND DATE_FORMAT(fecha_cancelacion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @queryporc_can;
	PREPARE stmt FROM @queryporc_can;
	EXECUTE stmt;

    SET @queryporc_fac = CONCAT(
						'
                        SELECT
							IFNULL(COUNT(*), 0)
						INTO
							@lo_porc_facturas
						FROM ic_fac_tr_factura
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal2,'
						AND estatus != 2
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @queryporc_fac;
	PREPARE stmt FROM @queryporc_fac;
	EXECUTE stmt;

    SET lo_porc_cancelaciones = IFNULL(((IFNULL(@lo_porc_cancelaciones, 0.00)*100)/ IFNULL(@lo_porc_facturas, 0.00)), 0);

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @lo_numero_folios = 0;
    SET @querycount_folios = CONCAT(
					'
					SELECT
						IFNULL(COUNT(*), 0)
					INTO
						@lo_numero_folios
					FROM ic_fac_tr_factura
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal2,'
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @querycount_folios;
	PREPARE stmt FROM @querycount_folios;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_numero_folios = IFNULL((IFNULL(@lo_numero_folios, 0) / DATE_FORMAT(NOW(),'%d')), 0);

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_efectividad = CONCAT(
					'
					SELECT
						COUNT(*)
					INTO
						@lo_efectividad_pnr
					FROM ic_gds_tr_general
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal2,'
					AND DATE_FORMAT(fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND fac_numero IS NOT NULL');

	-- SELECT @query_efectividad;
	PREPARE stmt FROM @query_efectividad;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SELECT
		COUNT(*)
	INTO
		@lo_no_pnr_recibidos
	FROM ic_gds_tr_general
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND DATE_FORMAT(fecha_recepcion, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

    SET lo_efectividad_pnr = IFNULL((IFNULL(@lo_efectividad_pnr, 0)*100)/IFNULL(@lo_no_pnr_recibidos, 0), 0);

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		lo_clientes_sn_actividad,
        lo_efectividad_pnr,
		lo_porc_cancelaciones,
        lo_numero_folios;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
