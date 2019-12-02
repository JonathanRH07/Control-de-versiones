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
    DECLARE lo_efectividad_pnr				DECIMAL(16.2) DEFAULT 0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_ventas_indicadores_c';
	END;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_clientes_1;
    DROP TABLE IF EXISTS tmp_clientes_2;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

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
				AND fac.id_sucursal = ',pr_id_sucursal,'
                AND fac.hora_factura IS NOT NULL
                AND fac.estatus != 2
                AND cli.estatus = 1
				AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') <= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), ''%Y-%m-%d'')
                AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 12 MONTH), ''%Y-%m-%d'')
				-- GROUP BY fac.id_cliente
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
				AND fac.id_sucursal = ',pr_id_sucursal,'
                AND fac.hora_factura IS NOT NULL
                AND fac.estatus != 2
                AND cli.estatus = 1
                AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') > DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), ''%Y-%m-%d'')
				AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m-%d'') <= DATE_FORMAT(NOW(), ''%Y-%m-%d'')
				-- GROUP BY fac.id_cliente
                ORDER BY fac.fecha_factura DESC');

	-- SELECT @query_2;
	PREPARE stmt FROM @query_2;
	EXECUTE stmt;

    SELECT
		*
	INTO
		lo_clientes_sn_actividad
	FROM (
	SELECT
		COUNT(*)
	FROM tmp_clientes_1 a
	LEFT JOIN tmp_clientes_2 b ON
		a.id_cliente = b.id_cliente
	WHERE b.id_cliente IS NULL
	ORDER BY a.id_factura DESC) a;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @lo_porc_cancelaciones = 0.00;
    SET @querycount_cancelaciones = CONCAT(
					'
					SELECT
						IFNULL(COUNT(*), 0)
					INTO
						@lo_porc_cancelaciones
					FROM ic_fac_tr_factura
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					AND id_sucursal = ',pr_id_sucursal,'
					AND estatus = 2
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @querycount_cancelaciones;
	PREPARE stmt FROM @querycount_cancelaciones;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @lo_porc_facturas = 0.00;
    SET @querycount_facturas = CONCAT(
					'
					SELECT
						IFNULL(COUNT(*), 0)
					INTO
						@lo_porc_facturas
					FROM ic_fac_tr_factura
					WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
					AND id_sucursal = ',pr_id_sucursal,'
					AND estatus != 2
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @querycount_facturas;
	PREPARE stmt FROM @querycount_facturas;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_porc_cancelaciones = (IFNULL(@lo_porc_cancelaciones, 0.00)/ IFNULL(@lo_porc_facturas, 0.00));

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
					AND id_sucursal = ',pr_id_sucursal,'
					AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @querycount_folios;
	PREPARE stmt FROM @querycount_folios;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_numero_folios = (@lo_numero_folios / DATE_FORMAT(NOW(),'%d'));

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		COUNT(*)
	INTO
		lo_efectividad_pnr
	FROM ic_gds_tr_general
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND id_sucursal = pr_id_sucursal
	AND DATE_FORMAT(fecha_recepcion, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
	AND fac_numero IS NOT NULL;

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
