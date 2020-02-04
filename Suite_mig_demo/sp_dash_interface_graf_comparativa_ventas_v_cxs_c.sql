DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_interface_graf_comparativa_ventas_v_cxs_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_interface_graf_comparativa_ventas_v_cxs_c
	@fecha:			06/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_moneda					VARCHAR(100);
    DECLARE lo_suma_int_ventas			DECIMAL(13,2);
    DECLARE lo_suma_int_cxs				DECIMAL(13,2);
	DECLARE lo_sucursal					VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_interface_graf_comparativa_ventas_v_cxs_c';
	END ;

    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
        SET lo_moneda = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
        SET lo_moneda = '/tipo_cambio_usd';
	ELSE
		SET lo_moneda = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND gen.id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @lo_suma_int_ventas = 0;
    SET @query_int_ventas = CONCAT(
							'
							SELECT
								SUM(total_moneda_base)
							INTO
								@lo_suma_int_ventas
							FROM(
							SELECT
								SUM((tarifa_moneda_base',lo_moneda,') + (importe_markup',lo_moneda,') - (descuento',lo_moneda,')) total_moneda_base
							FROM ic_gds_tr_general gen
							JOIN ic_fac_tr_factura fac ON
								gen.fac_numero = fac.fac_numero
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_sucursal,'
                            AND pnr IS NOT NULL
							AND (pnr IS NOT NULL OR pnr != '''')
							AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
							GROUP BY gen.id_gds_generall) a');

    -- SELECT @query_int_ventas;
	PREPARE stmt FROM @query_int_ventas;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_suma_int_ventas = @lo_suma_int_ventas;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @lo_suma_int_cxs = 0;
    SET @query_int_cxs = CONCAT(
							'
                            SELECT
								SUM(lo_suma_int_cxs)
							INTO
								@lo_suma_int_cxs
							FROM(
                            SELECT
								SUM((tarifa_moneda_base',lo_moneda,') + (importe_markup',lo_moneda,') - (descuento',lo_moneda,')) lo_suma_int_cxs
							FROM ic_gds_tr_general gen
							JOIN ic_fac_tr_factura fac ON
								gen.fac_numero_cxs = fac.fac_numero
							JOIN ic_fac_tr_factura_detalle det ON
								fac.id_factura = det.id_factura
							WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
							',lo_sucursal,'
                            AND (pnr IS NOT NULL OR pnr != '''')
							AND fac.globalizador IS NOT NULL
							AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
							GROUP BY gen.id_gds_generall) a');

	-- SELECT @query_int_cxs;
	PREPARE stmt FROM @query_int_cxs;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_suma_int_cxs = @lo_suma_int_cxs;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		IFNULL(lo_suma_int_ventas, 0) lo_suma_int_ventas,
		IFNULL(lo_suma_int_cxs, 0) lo_suma_int_cxs;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
