DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_ventas_graf_participacion_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
    IN  pr_moneda_reporte					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_ventas_graf_participacion_c
	@fecha:			29/08/2019
	@descripcion:	Sp para consultar las ventas netas por cliente por mes
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE lo_moneda_reporte				VARCHAR(255);

    DECLARE lo_contador_fac_doc				INT;
    DECLARE lo_contador_notas_cred			INT;
    DECLARE lo_contador_nuevos_clientes		INT;
    DECLARE lo_mes_actual					DECIMAL(15,2);
    DECLARE lo_mes_anterior					DECIMAL(15,2);
    DECLARE lo_suma_crecimiento				DECIMAL(15,2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_ventas_graf_x_semestre_c';
	END ;

	/* DESARROLLO */

    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		IFNULL(COUNT(*), 0)
	INTO
		lo_contador_fac_doc
	FROM ic_fac_tr_factura
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND id_sucursal = pr_id_sucursal
	AND tipo_cfdi = 'I'
    AND estatus != 2
	AND DATE_FORMAT(fecha_factura, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		IFNULL(COUNT(*), 0)
	INTO
		lo_contador_notas_cred
	FROM ic_fac_tr_factura
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND id_sucursal = pr_id_sucursal
	AND tipo_cfdi = 'E'
    AND estatus != 2
	AND DATE_FORMAT(fecha_factura, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		IFNULL(COUNT(*), 0)
	INTO
		lo_contador_nuevos_clientes
	FROM ic_cat_tr_cliente
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND id_sucursal = pr_id_sucursal
	AND estatus = 1
	AND DATE_FORMAT(fecha_creacion, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* MES AÑO ACTUAL */
    SET @lo_mes_actual_ing = 0;
    SET @querytotact_ing = CONCAT(
						'
						SELECT
							IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))), 0.00)
						INTO
							@lo_mes_actual_ing
						FROM ic_fac_tr_factura fac
                        JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND id_sucursal = ',pr_id_sucursal,'
                        AND estatus != 2
                        AND tipo_cfdi = ''I''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @querytotact_ing;
	PREPARE stmt FROM @querytotact_ing;
	EXECUTE stmt;

	SET @lo_mes_actual_egr = 0;
    SET @querytotact_egr = CONCAT(
						'
						SELECT
							IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))), 0.00)
						INTO
							@lo_mes_actual_egr
						FROM ic_fac_tr_factura fac
                        JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND id_sucursal = ',pr_id_sucursal,'
                        AND estatus != 2
                        AND tipo_cfdi = ''E''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');

	-- SELECT @querytotact_egr;
	PREPARE stmt FROM @querytotact_egr;
	EXECUTE stmt;

    SET lo_mes_actual = (@lo_mes_actual_ing - @lo_mes_actual_egr);

    /* MES AÑO ANTERIOR */
    SET @lo_mes_anterior_ing = 0;
    SET @querytotant_ing = CONCAT(
						'
						SELECT
							IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))), 0.00)
						INTO
							@lo_mes_anterior_ing
						FROM ic_fac_tr_factura fac
                        JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND id_sucursal = ',pr_id_sucursal,'
                        AND estatus != 2
                        AND tipo_cfdi = ''I''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), ''%Y-%m'')');

	-- SELECT @querytotant_ing;
	PREPARE stmt FROM @querytotant_ing;
	EXECUTE stmt;

    SET @lo_mes_anterior_egr = 0;
    SET @querytotant_egr = CONCAT(
						'
						SELECT
							IFNULL(SUM((((tarifa_moneda_base',lo_moneda_reporte,') + (importe_markup',lo_moneda_reporte,')) - (descuento',lo_moneda_reporte,'))), 0.00)
						INTO
							@lo_mes_anterior_egr
						FROM ic_fac_tr_factura fac
                        JOIN ic_fac_tr_factura_detalle det ON
							fac.id_factura = det.id_factura
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND id_sucursal = ',pr_id_sucursal,'
                        AND estatus != 2
                        AND tipo_cfdi = ''E''
						AND DATE_FORMAT(fecha_factura, ''%Y-%m'') = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), ''%Y-%m'')');

	-- SELECT @querytotant_egr;
	PREPARE stmt FROM @querytotant_egr;
	EXECUTE stmt;

    SET lo_mes_anterior = (@lo_mes_anterior_ing - @lo_mes_anterior_egr);

    SET lo_suma_crecimiento = IFNULL(((((lo_mes_actual - lo_mes_anterior) / lo_mes_anterior)) * 100),0.00);

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		lo_contador_fac_doc,
		lo_contador_notas_cred,
		lo_contador_nuevos_clientes,
		lo_suma_crecimiento;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
