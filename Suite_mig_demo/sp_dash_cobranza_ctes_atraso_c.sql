DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_cobranza_ctes_atraso_c`(
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
	@nombre:		sp_dash_cobranza_graf_cobros_c
	@fecha: 		2019/08/29
	@descripción: 	Sp para obtenber grafica de cobros por semestre
	@autor : 		David Roldan Solares
	@cambios:
*/

	DECLARE lo_tot_cxc 						TEXT;
    DECLARE lo_tot_atraso					TEXT;
    DECLARE lo_poc_atraso					TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_dash_cobranza_graf_estimacion_c';
	END ;

    /* DESARROLLO */
    /* VALIDAMOS LA MONEDA DEL REPORTE */

    IF pr_moneda_reporte = 149 THEN
		SET lo_tot_cxc = '/tipo_cambio_usd';
		SET lo_tot_atraso = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_tot_cxc = '/tipo_cambio_eur';
		SET lo_tot_atraso = '/tipo_cambio_eur';
	ELSE
		SET lo_tot_cxc = '';
		SET lo_tot_atraso = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_clientes_atraso;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET @queryac = CONCAT('
					CREATE TEMPORARY TABLE tmp_clientes_atraso
					SELECT
						ant.razon_social cliente,
						((SUM(vencimiento_uno ) + SUM(vencimiento_dos ) + SUM(vencimiento_tres ) + SUM(vencimiento_cuatro ) + SUM(vencimiento_cinco ) + SUM(vencimiento_seis ) + SUM(vencimiento_siete) + SUM(por_vencer))',lo_tot_cxc,') total_cxc,
						((SUM(vencimiento_uno ) + SUM(vencimiento_dos ) + SUM(vencimiento_tres ) + SUM(vencimiento_cuatro ) + SUM(vencimiento_cinco ) + SUM(vencimiento_seis ) + SUM(vencimiento_siete))',lo_tot_atraso,') total_atrasado
					FROM antiguedad_saldos ant
					WHERE ant.estatus = ''ACTIVO''
					AND ant.id_grupo_empresa = ',pr_id_grupo_empresa,'
					AND ant.id_sucursal = ',pr_id_sucursal,'
					AND saldo_facturado != 0
					AND ant.fecha_emision <= NOW()
					GROUP BY ant.id_cliente');

	-- SELECT @queryac;
    PREPARE stmt FROM @queryac;
	EXECUTE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		SUM(total_atrasado)
	INTO
		@lo_total_atrasado
	FROM tmp_clientes_atraso;

    SELECT
		cliente,
		total_cxc,
		total_atrasado,
		TRUNCATE((total_atrasado / @lo_total_atrasado) * 100,2) porc_atraso
	FROM tmp_clientes_atraso
    ORDER BY 3 DESC
    LIMIT pr_ini_pag,pr_fin_pag;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		COUNT(*)
	INTO
		pr_rows_tot_table
	FROM tmp_clientes_atraso;

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
