DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_reportes_indicadores_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_reportes_indicadores_c
	@fecha:			01/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_moneda					VARCHAR(100);
    DECLARE lo_moneda2					VARCHAR(100) DEFAULT '';
    DECLARE lo_monto_total_ventas		DECIMAL(15,2);
    DECLARE lo_comision_neta_ing		DECIMAL(15,2);
    DECLARE lo_comision_neta_egr		DECIMAL(15,2);
	DECLARE lo_comision_neta			DECIMAL(15,2);
    DECLARE lo_pendxcobrar				DECIMAL(15,2);
	DECLARE lo_no_transacciones			INT;
    DECLARE lo_importe					DECIMAL(15,2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_reportes_indicadores_c';
	END;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
        SET lo_moneda = '/tipo_cambio_usd';
        SET lo_moneda2 = '/fac.tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
        SET lo_moneda = '/tipo_cambio_usd';
        SET lo_moneda2 = '/fac.tipo_cambio_eur';
	ELSE
		SET lo_moneda = '';
    END IF;

	/* ~~~~~~~~~~~~~~~~~~~~ MONTO TOTAL DE VENTAS ~~~~~~~~~~~~~~~~~~~~ */
    SET @lo_monto_total_ventas_ing = 0;
    SET @querymonto_ing = CONCAT(
						'
                        SELECT
							IFNULL(SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')), 0)
						INTO
							@lo_monto_total_ventas_ing
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND fac.estatus != 2
						AND fac.tipo_cfdi = ''I''
						AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						AND fac.estatus != 2');

    -- SELECT @querymonto_ing;
	PREPARE stmt FROM @querymonto_ing;
	EXECUTE stmt;

	SET @lo_monto_total_ventas_egr = 0;
    SET @querymonto_egr = CONCAT(
						'
                        SELECT
							IFNULL(SUM(((det.tarifa_moneda_base',lo_moneda,') + (det.importe_markup',lo_moneda,')) - (det.descuento',lo_moneda,')), 0)
                        INTO
							@lo_monto_total_ventas_egr
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND fac.estatus != 2
						AND fac.tipo_cfdi = ''E''
						AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						AND fac.estatus != 2');

    -- SELECT @querymonto_egr;
	PREPARE stmt FROM @querymonto_egr;
	EXECUTE stmt;

    SET lo_monto_total_ventas = (@lo_monto_total_ventas_ing - @lo_monto_total_ventas_egr);

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	/* ~~~~~~~~~~~~~~~~~~~~ COMISIONES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* COMISION INGRESOS */
    SET @lo_comision_neta_ing = 0;
    SET @querycomising = CONCAT(
						'
						SELECT
							IFNULL(SUM(comision_agencia',lo_moneda2,'), 0)
						INTO
							@lo_comision_neta_ing
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle fac_det ON
							fac.id_factura = fac_det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                        AND fac.id_sucursal = ',pr_id_sucursal,'
                        AND fac.estatus != 2
						AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') >=  DATE_FORMAT(NOW(), ''%Y-%m'')
						AND fac.tipo_cfdi =  ''I'''
						);

	-- SELECT @querycomising;
	PREPARE stmt FROM @querycomising;
	EXECUTE stmt;

    SET lo_comision_neta_ing = @lo_comision_neta_ing;


    /* COMISION EGRESOS */
    SET @lo_comision_neta_egr = 0;
	SET @querycomisegr = CONCAT(
						'
						SELECT
							IFNULL(SUM(comision_agencia',lo_moneda2,'), 0)
						INTO
							@lo_comision_neta_egr
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_factura_detalle fac_det ON
							fac.id_factura = fac_det.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
                        AND fac.id_sucursal = ',pr_id_sucursal,'
                        AND fac.estatus != 2
						AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') >= DATE_FORMAT(NOW(), ''%Y-%m'')
						AND fac.tipo_cfdi =  ''E''');

	-- SELECT @querycomisegr;
	PREPARE stmt FROM @querycomisegr;
	EXECUTE stmt;

    SET lo_comision_neta_egr = @lo_comision_neta_egr;

    SET lo_comision_neta = (IFNULL(lo_comision_neta_ing,0) - IFNULL(lo_comision_neta_egr,0));

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* ~~~~~~~~~~~~~~~~~~~~ CXC ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @lo_pendxcobrar = 0;
    SET @querycxcrep = CONCAT(
						'
                        SELECT
							SUM(saldo_facturado',lo_moneda,') pendxcobrar
						INTO
							@lo_pendxcobrar
						FROM antiguedad_saldos
						WHERE estatus = 1
						AND id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND id_sucursal = ',pr_id_sucursal,'
						AND saldo_facturado != 0
						AND fecha_emision < NOW()');

	-- SELECT @querycxcrep;
	PREPARE stmt FROM @querycxcrep;
	EXECUTE stmt;

	SET lo_pendxcobrar = @lo_pendxcobrar;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* ~~~~~~~~~~~~~~~~~~~~ TARJETAS CORPORATIVAS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @lo_no_transacciones = 0;
    SET @lo_importe = 0;
    SET @querytarjetas = CONCAT(
						'
                        SELECT
							IFNULL(COUNT(*), 0),
							IFNULL(SUM(total_moneda_base',lo_moneda,'), 0)
						INTO
							@lo_no_transacciones,
                            @lo_importe
						FROM ic_fac_tr_factura fac
						JOIN ic_fac_tr_compras_x_servicio tar ON
							fac.id_factura = tar.id_factura
						WHERE fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND fac.id_sucursal = ',pr_id_sucursal,'
						AND fac.estatus != 2
						AND id_tc_corporativa != 0
						AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @querytarjetas;
	PREPARE stmt FROM @querytarjetas;
	EXECUTE stmt;

	SET lo_no_transacciones = @lo_no_transacciones;
    SET lo_importe = @lo_importe;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		lo_monto_total_ventas,
        lo_comision_neta,
        lo_pendxcobrar,
        lo_no_transacciones,
        lo_importe;


    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
