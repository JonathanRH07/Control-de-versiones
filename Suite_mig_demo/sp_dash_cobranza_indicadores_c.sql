DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_cobranza_indicadores_c`(
	IN  pr_id_grupo_empresa	INT,
    IN	pr_id_sucursal		INT,
    IN	pr_moneda_reporte	INT,
    OUT pr_message 			TEXT
)
BEGIN
/*
	@nombre:		sp_dash_cobranza_indicadores_c
	@fecha: 		2019/08/16
	@descripción: 	Sp para obtenber CxC pendientes de cobro
	@autor : 		David Roldan Solares
	@cambios:
*/
	DECLARE lo_pendxcobrar 		DECIMAL(18,2);
    DECLARE lo_total_atrasado 	DECIMAL(18,2);
    DECLARE lo_porc_atrasado	DECIMAL(6,2);
    DECLARE lo_total_cobrado 	DECIMAL(18,2);
    DECLARE lo_moneda_reporte   VARCHAR(100);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_dash_cobranza_indicadores_c';
	END ;

	IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = '/ tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = '/ tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = '';
    END IF;

	/* Pendiente por cobrar ************************************************/

    SET @lo_pendxcobrar = 0;
    SET @query_pendientes = CONCAT(
							'
							SELECT
								SUM(saldo_facturado',lo_moneda_reporte,') pendxcobrar
							INTO
								@lo_pendxcobrar
							FROM antiguedad_saldos
							WHERE estatus = ''ACTIVO''
							AND id_grupo_empresa = ',pr_id_grupo_empresa,'
							AND id_sucursal = ',pr_id_sucursal,'
							AND saldo_facturado != 0
							AND fecha_emision < SYSDATE()');

	-- SELECT @query_pendientes;
    PREPARE stmt FROM @query_pendientes;
	EXECUTE stmt;

    SET lo_pendxcobrar = @lo_pendxcobrar;

	/***Monto total atrasado************************************************/

    SET @lo_total_atrasado = 0;
    SET @query_total_atrasado = CONCAT(
								'
									SELECT
										(SUM(saldo_facturado',lo_moneda_reporte,') - SUM(por_vencer',lo_moneda_reporte,'))
									INTO
										@lo_total_atrasado
									FROM antiguedad_saldos
									WHERE estatus = ''ACTIVO''
									AND id_grupo_empresa = ',pr_id_grupo_empresa,'
									AND id_sucursal = ',pr_id_sucursal,'
									AND saldo_facturado != 0
									AND fecha_vencimiento <= NOW()');

    -- SELECT @query_total_atrasado;
    PREPARE stmt FROM @query_total_atrasado;
	EXECUTE stmt;

    SET lo_total_atrasado = @lo_total_atrasado;

	/***Porcentaje atrasado*************************************************/

    SELECT
		((lo_total_atrasado / lo_pendxcobrar) * 100)
	INTO
		lo_porc_atrasado
	FROM DUAL;

	/***Monto total cobrado*************************************************/

    SET @lo_total_cobrado = 0;
    SET @query_total_cobrado = CONCAT(
								'
                                SELECT
									IFNULL(SUM((detalle.importe_moneda_base',lo_moneda_reporte,') * -1), 0)
								INTO
									@lo_total_cobrado
								FROM ic_glob_tr_cxc cxc
								JOIN ic_glob_tr_cxc_detalle detalle ON
									cxc.id_cxc  = detalle.id_cxc
								WHERE cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
								AND cxc.id_sucursal = ',pr_id_sucursal,'
								AND detalle.estatus = ''ACTIVO''
								AND detalle.id_factura IS NULL
								AND cxc.estatus = ''ACTIVO''
								AND DATE_FORMAT(detalle.fecha, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')');


	-- SELECT @query_total_cobrado;
    PREPARE stmt FROM @query_total_cobrado;
	EXECUTE stmt;

    SET lo_total_cobrado = @lo_total_cobrado;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		lo_pendxcobrar pendxcobrar,
		lo_total_atrasado total_atrasado,
		lo_porc_atrasado porc_atrasado,
		lo_total_cobrado total_cobrado
	FROM dual;

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
