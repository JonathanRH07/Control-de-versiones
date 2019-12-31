DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_ventas_top_tipo_proveedor_c`(
	IN  pr_id_grupo_empresa						INT,
    IN	pr_id_moneda							INT,
    IN	pr_id_sucursal							INT,
    IN	pr_fecha								VARCHAR(7),
	OUT pr_rows_tot_table 						INT,
	OUT pr_message 	  							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_rep_ventas_top_tipo_proveedor_c
	@fecha:			2019/06/20
	@descripcion:	Sp para consultar el top 10  de ventas por clientes por mes |REPORTE VENTAS|
	@autor: 		Jonathan Ramirez Hernandez
	@
*/

	DECLARE lo_sucursal							VARCHAR(100) DEFAULT '';
	DECLARE lo_moneda_reporte_ing				TEXT;
    DECLARE lo_moneda_reporte_egr				TEXT;
    DECLARE lo_moneda_reporte_neto				TEXT;
    DECLARE lo_moneda_reporte_acu				TEXT;


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_ventas_top_tipo_proveedor_c';
	END ;

    /* Desarrollo */
    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	DROP TEMPORARY TABLE IF EXISTS tmp_top_tipo_proveedor;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    /* VALIDAR MONEDA DEL REPORTE */
    IF pr_id_moneda = 149 THEN
		SET lo_moneda_reporte_ing = 'monto_usd';
        SET lo_moneda_reporte_egr = 'egresos_usd';
        SET lo_moneda_reporte_neto = 'venta_neta_usd';
        SET lo_moneda_reporte_acu = 'acumulado_usd';
	ELSEIF pr_id_moneda = 49 THEN
		SET lo_moneda_reporte_ing = 'monto_eur';
        SET lo_moneda_reporte_egr = 'egresos_eur';
        SET lo_moneda_reporte_neto = 'venta_neta_eur';
        SET lo_moneda_reporte_acu = 'acumulado_eur';
	ELSE
		SET lo_moneda_reporte_ing = 'monto_moneda_base';
		SET lo_moneda_reporte_egr = 'egresos_moneda_base';
        SET lo_moneda_reporte_neto = 'venta_neta_moneda_base';
        SET lo_moneda_reporte_acu = 'acumulado_moneda_base';
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    /* VALIDAR SUCURSAL EN CASO DE SER CORPORATIVO */
	SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF pr_id_sucursal > 0 THEN
		IF @lo_es_matriz = 0 THEN
			SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal,'');
		END IF;
    END IF;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

    SET @query = CONCAT('
				CREATE TEMPORARY TABLE tmp_top_tipo_proveedor
				SELECT
					tip_prov.cve_tipo_proveedor clave,
					tip_prov.desc_tipo_proveedor nombre,
					IFNULL(',lo_moneda_reporte_ing,', 0) venta_mes,
					IFNULL(',lo_moneda_reporte_egr,', 0) devoluciones_mes,
					IFNULL(',lo_moneda_reporte_neto,', 0) neto_mes,
					IFNULL(',lo_moneda_reporte_acu,', 0) neto_acumulado
				FROM ic_rep_tr_acumulado_tipo_proveedor acu
				JOIN ic_cat_tc_tipo_proveedor tip_prov ON
					acu.id_tipo_proveedor = tip_prov.id_tipo_proveedor
				WHERE acu.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
				AND acu.fecha =  ''',pr_fecha,'''
				GROUP BY acu.id_tipo_proveedor
				ORDER BY neto_mes DESC
				LIMIT 10'
				);

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    SELECT *
    FROM tmp_top_tipo_proveedor;

    /* ~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~* */

	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
