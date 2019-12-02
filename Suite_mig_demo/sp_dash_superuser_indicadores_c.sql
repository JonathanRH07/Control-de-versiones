DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_superuser_indicadores_c`(
	IN  pr_id_grupo_empresa	INT,
    IN	pr_id_sucursal		INT,
    IN	pr_moneda_reporte	INT,
    OUT pr_message 			TEXT
)
BEGIN
/*
	@nombre:		sp_dash_cobranza_graf_cobros_c
	@fecha: 		2019/08/16
	@descripción: 	Sp para obtenber grafica de sp_dash_superuser_indicadores_c por semestre
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE lo_tot_venta_t		TEXT;
    DECLARE lo_tot_dia_t		TEXT;
    DECLARE lo_cob_atraso_t		TEXT;
    DECLARE lo_tot_cobrado_t	TEXT;

    DECLARE lo_tot_venta		DECIMAL(16,2);
    DECLARE lo_tot_dia			DECIMAL(16,2);
    DECLARE lo_cob_atraso		DECIMAL(16,2);
    DECLARE lo_tot_cobrado		DECIMAL(16,2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_dash_superuser_indicadores_c';
	END ;

    /* ---------------------------------------------------------------------------------------------- */

	/* DESARROLLO */
    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_tot_venta_t   = '((tarifa_moneda_base + importe_markup) - descuento) / cxc.tipo_cambio_usd';
        SET lo_tot_dia_t     = '((tarifa_moneda_base + importe_markup) - descuento) / cxc.tipo_cambio_usd';
        SET lo_cob_atraso_t  = 'cxc.saldo_moneda_base / cxc.tipo_cambio_usd';
        SET lo_tot_cobrado_t = 'detalle.importe_moneda_base / cxc.tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_tot_venta_t   = '((tarifa_moneda_base + importe_markup) - descuento) / cxc.tipo_cambio_eur';
        SET lo_tot_dia_t     = '((tarifa_moneda_base + importe_markup) - descuento) / cxc.tipo_cambio_eur';
        SET lo_cob_atraso_t  = 'cxc.saldo_moneda_base / cxc.tipo_cambio_eur';
        SET lo_tot_cobrado_t = 'detalle.importe_moneda_base / cxc.tipo_cambio_eur';
	ELSE
		SET lo_tot_venta_t   = '((tarifa_moneda_base + importe_markup) - descuento)';
        SET lo_tot_dia_t     = '((tarifa_moneda_base + importe_markup) - descuento)';
        SET lo_cob_atraso_t  = 'cxc.saldo_moneda_base';
        SET lo_tot_cobrado_t = 'detalle.importe_moneda_base';
    END IF;

    /* ---------------------------------------------------------------------------------------------- */

    SET @querytv_ing = CONCAT('
						SELECT
							IFNULL(SUM(',lo_tot_venta_t,'), 0)
						INTO
							@lo_tot_venta_ing
						FROM ic_fac_tr_factura cxc
                        JOIN ic_fac_tr_factura_detalle det ON
							cxc.id_factura = det.id_factura
						WHERE cxc.estatus != 2
						AND cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND cxc.id_sucursal = ',pr_id_sucursal,'
                        AND tipo_cfdi = ''I''
						AND DATE_FORMAT(cxc.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
    ');

    PREPARE stmt FROM @querytv_ing;
	EXECUTE stmt;

    SET @querytv_egr = CONCAT('
						SELECT
							IFNULL(SUM(',lo_tot_venta_t,'), 0)
						INTO
							@lo_tot_venta_egr
						FROM ic_fac_tr_factura cxc
                        JOIN ic_fac_tr_factura_detalle det ON
							cxc.id_factura = det.id_factura
						WHERE cxc.estatus != 2
						AND cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND cxc.id_sucursal = ',pr_id_sucursal,'
                        AND tipo_cfdi = ''E''
						AND DATE_FORMAT(cxc.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
    ');

    PREPARE stmt FROM @querytv_egr;
	EXECUTE stmt;

    SET @lo_tot_venta = (@lo_tot_venta_ing - @lo_tot_venta_egr);

    /* ---------------------------------------------------------------------------------------------- */

    SET @querytd_ing = CONCAT('
						SELECT
							IFNULL(SUM(',lo_tot_dia_t,'), 0)
						INTO
							@lo_tot_dia_ing
						FROM ic_fac_tr_factura cxc
                        JOIN ic_fac_tr_factura_detalle det ON
							cxc.id_factura = det.id_factura
						WHERE cxc.estatus != 2
						AND cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND cxc.id_sucursal = ',pr_id_sucursal,'
                        AND tipo_cfdi = ''I''
						AND cxc.fecha_factura = DATE_FORMAT(NOW(), ''%Y-%m-%d'')
    ');

    PREPARE stmt FROM @querytd_ing;
	EXECUTE stmt;

    SET @querytd_egr = CONCAT('
						SELECT
							IFNULL(SUM(',lo_tot_dia_t,'), 0)
						INTO
							@lo_tot_dia_egr
						FROM ic_fac_tr_factura cxc
                        JOIN ic_fac_tr_factura_detalle det ON
							cxc.id_factura = det.id_factura
						WHERE cxc.estatus != 2
						AND cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND cxc.id_sucursal = ',pr_id_sucursal,'
                        AND tipo_cfdi = ''E''
						AND cxc.fecha_factura = DATE_FORMAT(NOW(), ''%Y-%m-%d'')
    ');

    PREPARE stmt FROM @querytd_egr;
	EXECUTE stmt;

    SET @lo_tot_dia = (@lo_tot_dia_ing - @lo_tot_dia_egr);

    /* ---------------------------------------------------------------------------------------------- */

    SET @queryca = CONCAT('
						SELECT
							IFNULL(SUM(',lo_cob_atraso_t,'), 0)
						INTO
							@lo_cob_atraso
						FROM ic_glob_tr_cxc cxc
						WHERE estatus = ''ACTIVO''
						AND id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND id_sucursal = ',pr_id_sucursal,'
						AND saldo_moneda_base != 0
                        AND fecha_vencimiento <= NOW()
						AND DATE_FORMAT(fecha_vencimiento, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
    ');

    PREPARE stmt FROM @queryca;
	EXECUTE stmt;

    /* ---------------------------------------------------------------------------------------------- */

    SET @querytc = CONCAT('
						SELECT
							IFNULL(SUM(',lo_tot_cobrado_t,' * -1), 0)
						INTO
							@lo_tot_cobrado
						FROM ic_glob_tr_cxc cxc
						JOIN ic_glob_tr_cxc_detalle detalle ON
							cxc.id_cxc  = detalle.id_cxc
						WHERE cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND cxc.id_sucursal = ',pr_id_sucursal,'
						AND detalle.estatus = ''ACTIVO''
						AND detalle.id_factura IS NULL
						AND cxc.estatus = ''ACTIVO''
						AND DATE_FORMAT(detalle.fecha, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						');

    PREPARE stmt FROM @querytc;
	EXECUTE stmt;

    /* ---------------------------------------------------------------------------------------------- */

    SELECT
		@lo_tot_venta,
        @lo_tot_dia,
		@lo_cob_atraso,
        @lo_tot_cobrado;

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
