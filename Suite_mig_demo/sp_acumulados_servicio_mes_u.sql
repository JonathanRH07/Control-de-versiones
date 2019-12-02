DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_acumulados_servicio_mes_u`(
	 IN  pr_fecha					VARCHAR(7),
	 OUT pr_message					VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_rep_tr_acumulados_mes_u
	@fecha:			2019/02/22
	@descripcion:	SP para actualizar registros en la tabla de acumulados
	@autor:			Jonathan Ramirez Hernandez
	@cambios:
*/
	DECLARE lo_id_servicio					INT;
    DECLARE lo_monto_moneda_base_ing		DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_monto_usd_ing				DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_monto_eur_ing				DECIMAL(15,2) DEFAULT 0;
	DECLARE lo_monto_moneda_base_egre		DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_monto_usd_egre				DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_monto_eur_egre				DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_venta_neta_moneda_base		DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_venta_neta_usd				DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_venta_neta_eur				DECIMAL(15,2) DEFAULT 0;
    DECLARE lo_acumulado_moneda_base		DECIMAL(15,2);
	DECLARE	lo_acumulado_usd				DECIMAL(15,2);
	DECLARE lo_acumulado_eur				DECIMAL(15,2);
	DECLARE lo_id_grupo_empresa				INT;
    DECLARE lo_id_sucursal					INT;
    DECLARE lo_cve_servicio					VARCHAR(45);
	DECLARE lo_descripcion					VARCHAR(150);
	DECLARE lo_contador_total				INT;
    DECLARE lo_contador_total_2				INT;

    DECLARE cu_cliente CURSOR FOR
	SELECT
		id_servicio
	FROM ic_fac_tr_factura_detalle
    GROUP BY id_servicio;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_tr_acumulados_servicio_mes_u';
        ROLLBACK;
	END ;

	DECLARE CONTINUE HANDLER FOR
	NOT FOUND SET @hecho = TRUE;

    DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_ingreso;
	DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_egreso;
	DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_total;
    DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_total_2;

    OPEN cu_cliente;

		loop_obtidcliente: LOOP

           FETCH cu_cliente INTO lo_id_servicio;

           IF @hecho THEN
				LEAVE loop_obtidcliente;
		   END IF;

             DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_ingreso;
             DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_egreso;
			 DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_total;
			 DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_total_2;

			SELECT
				id_grupo_empresa,
				cve_servicio,
				descripcion
			INTO
				lo_id_grupo_empresa,
				lo_cve_servicio,
				lo_descripcion
			FROM ic_cat_tc_servicio
			WHERE id_servicio = lo_id_servicio;

            /* -------------------------------------------------------- */
			/* INGRESO */
			SET @query1 = CONCAT('
									CREATE TABLE tmp_factura_acumulado_servicio_ingreso
									SELECT
										id_grupo_empresa,
										id_servicio,
                                        id_sucursal,
										SUM(monto_moneda_base) monto_moneda_base,
										SUM(monto_usd) monto_usd,
										SUM(monto_eur) monto_eur,
										fecha
									FROM (SELECT
											fac.id_grupo_empresa,
											det.id_servicio,
											fac.id_sucursal,
											IFNULL(SUM(tarifa_moneda_base + importe_markup - descuento),0) monto_moneda_base,
											CASE
												WHEN fac.id_moneda = 149 THEN
													IFNULL(SUM(tarifa_moneda_facturada + importe_markup - descuento),0)
												ELSE
													IFNULL(SUM((tarifa_moneda_base + importe_markup - descuento) / fac.tipo_cambio_usd),0)
											END monto_usd,
											CASE
												WHEN fac.id_moneda = 49 THEN
													IFNULL(SUM(tarifa_moneda_facturada + importe_markup - descuento),0)
												ELSE
													IFNULL(SUM((tarifa_moneda_base + importe_markup - descuento) / fac.tipo_cambio_usd),0)
											END monto_eur,
											DATE_FORMAT(fecha_factura, ''%Y-%m'') fecha
										FROM ic_fac_tr_factura_detalle det
										JOIN ic_fac_tr_factura fac ON
											det.id_factura = fac.id_factura
										WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = ''',pr_fecha,'''
										AND det.id_servicio = ',lo_id_servicio,'
										AND tipo_cfdi = ''I''
                                        AND fac.estatus != ''CANCELADA''
										GROUP BY det.id_factura) tabla
                                        GROUP BY tabla.id_servicio;');

			-- SELECT @query1;
			PREPARE stmt FROM @query1;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

           /* -------------------------------------------------------- */

			/* EGRESO */
            SET @query2 = CONCAT('
									CREATE TABLE tmp_factura_acumulado_servicio_egreso
									SELECT
										id_grupo_empresa,
										id_servicio,
                                        id_sucursal,
										SUM(monto_moneda_base) monto_moneda_base,
										SUM(monto_usd) monto_usd,
										SUM(monto_eur) monto_eur,
										fecha
									FROM (SELECT
											fac.id_grupo_empresa,
											det.id_servicio,
											fac.id_sucursal,
											IFNULL(SUM(tarifa_moneda_base + importe_markup - descuento),0) monto_moneda_base,
											CASE
												WHEN fac.id_moneda = 149 THEN
													IFNULL(SUM(tarifa_moneda_facturada + importe_markup - descuento),0)
												ELSE
													IFNULL(SUM((tarifa_moneda_base + importe_markup - descuento) / fac.tipo_cambio_usd),0)
											END monto_usd,
											CASE
												WHEN fac.id_moneda = 49 THEN
													IFNULL(SUM(tarifa_moneda_facturada + importe_markup - descuento),0)
												ELSE
													IFNULL(SUM((tarifa_moneda_base + importe_markup - descuento) / fac.tipo_cambio_usd),0)
											END monto_eur,
											DATE_FORMAT(fecha_factura, ''%Y-%m'') fecha
										FROM ic_fac_tr_factura_detalle det
										JOIN ic_fac_tr_factura fac ON
											det.id_factura = fac.id_factura
									WHERE DATE_FORMAT(fecha_factura, ''%Y-%m'') = ''',pr_fecha,'''
									AND det.id_servicio = ',lo_id_servicio,'
									AND tipo_cfdi = ''E''
                                    AND fac.estatus != ''CANCELADA''
									GROUP BY det.id_factura) tabla
                                    GROUP BY tabla.id_servicio;');

			-- SELECT @query2;
			PREPARE stmt FROM @query2;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

            /*-------------------------------------------------------------------*/
            START TRANSACTION;

			CREATE TABLE tmp_factura_acumulado_servicio_total
			SELECT
				lo_id_grupo_empresa,
				lo_id_servicio,
                acu_ing.id_sucursal,
                lo_cve_servicio,
                lo_descripcion,
				IFNULL(acu_ing.monto_moneda_base,0) monto_moneda_base_ing,
				IFNULL(acu_ing.monto_usd,0) monto_usd_ing,
				IFNULL(acu_ing.monto_eur,0) monto_eur_ing,
				IFNULL(acu_egre.monto_moneda_base,0) monto_moneda_base_egre,
				IFNULL(acu_egre.monto_usd,0) monto_usd_egre,
				IFNULL(acu_egre.monto_eur,0) monto_eur_egre,
				CASE
					WHEN acu_ing.monto_moneda_base IS NULL THEN
						IFNULL(acu_egre.monto_moneda_base,0)
					WHEN acu_egre.monto_moneda_base IS NULL THEN
						IFNULL(acu_ing.monto_moneda_base,0)
					ELSE
						IFNULL((acu_ing.monto_moneda_base - acu_egre.monto_moneda_base),0)
				END venta_neta_moneda_base,
				CASE
					WHEN acu_ing.monto_usd IS NULL THEN
						IFNULL(acu_egre.monto_usd,0)
					WHEN acu_egre.monto_usd IS NULL THEN
						IFNULL(acu_ing.monto_usd,0)
					ELSE
						(acu_ing.monto_usd - acu_egre.monto_usd)
				END venta_neta_usd,
				CASE
					WHEN acu_ing.monto_eur IS NULL THEN
						IFNULL(acu_egre.monto_eur,0)
					WHEN acu_egre.monto_eur IS NULL THEN
						IFNULL(acu_ing.monto_eur,0)
					ELSE
						(acu_ing.monto_eur - acu_egre.monto_eur)
				END venta_neta_eur,
				pr_fecha
			FROM tmp_factura_acumulado_servicio_ingreso acu_ing
			LEFT JOIN tmp_factura_acumulado_servicio_egreso acu_egre ON
				acu_ing.id_servicio = acu_egre.id_servicio;

			CREATE TABLE tmp_factura_acumulado_servicio_total_2
			SELECT
				lo_id_grupo_empresa,
				lo_id_servicio,
                acu_ing.id_sucursal,
                lo_cve_servicio,
                lo_descripcion,
				IFNULL(acu_ing.monto_moneda_base,0) monto_moneda_base_ing,
				IFNULL(acu_ing.monto_usd,0) monto_usd_ing,
				IFNULL(acu_ing.monto_eur,0) monto_eur_ing,
				IFNULL(acu_egre.monto_moneda_base,0) monto_moneda_base_egre,
				IFNULL(acu_egre.monto_usd,0) monto_usd_egre,
				IFNULL(acu_egre.monto_eur,0) monto_eur_egre,
				CASE
					WHEN acu_ing.monto_moneda_base IS NULL THEN
						IFNULL(acu_egre.monto_moneda_base,0)
					WHEN acu_egre.monto_moneda_base IS NULL THEN
						IFNULL(acu_ing.monto_moneda_base,0)
					ELSE
						IFNULL((acu_ing.monto_moneda_base - acu_egre.monto_moneda_base),0)
				END venta_neta_moneda_base,
				CASE
					WHEN acu_ing.monto_usd IS NULL THEN
						IFNULL(acu_egre.monto_usd,0)
					WHEN acu_egre.monto_usd IS NULL THEN
						IFNULL(acu_ing.monto_usd,0)
					ELSE
						(acu_ing.monto_usd - acu_egre.monto_usd)
				END venta_neta_usd,
				CASE
					WHEN acu_ing.monto_eur IS NULL THEN
						IFNULL(acu_egre.monto_eur,0)
					WHEN acu_egre.monto_eur IS NULL THEN
						IFNULL(acu_ing.monto_eur,0)
					ELSE
						(acu_ing.monto_eur - acu_egre.monto_eur)
				END venta_neta_eur,
				pr_fecha
			FROM tmp_factura_acumulado_servicio_ingreso acu_ing
			RIGHT JOIN tmp_factura_acumulado_servicio_egreso acu_egre ON
				acu_ing.id_servicio = acu_egre.id_servicio
			WHERE acu_ing.id_servicio IS NULL;

			SELECT
				COUNT(*)
			INTO
				lo_contador_total
			FROM tmp_factura_acumulado_servicio_total;

            SELECT
				COUNT(*)
			INTO
				lo_contador_total_2
			FROM tmp_factura_acumulado_servicio_total_2;

			IF lo_contador_total_2 = 0 THEN

				INSERT INTO ic_rep_tr_acumulado_servicio (id_grupo_empresa, id_servicio, id_sucursal, cve_servicio, descripcion, monto_moneda_base, monto_usd, monto_eur, egresos_moneda_base, egresos_usd, egresos_eur, venta_neta_moneda_base, venta_neta_usd, venta_neta_eur, fecha)
				SELECT *
				FROM tmp_factura_acumulado_servicio_total;

            ELSEIF lo_contador_total_2 > 0 THEN

				INSERT INTO ic_rep_tr_acumulado_servicio (id_grupo_empresa, id_servicio, id_sucursal, cve_servicio, descripcion, monto_moneda_base, monto_usd, monto_eur, egresos_moneda_base, egresos_usd, egresos_eur, venta_neta_moneda_base, venta_neta_usd, venta_neta_eur, fecha)
				SELECT *
				FROM tmp_factura_acumulado_servicio_total
				UNION
				SELECT *
				FROM tmp_factura_acumulado_servicio_total_2;

            END IF;

           /*-------------------------------------------------------------------*/

			COMMIT;

        END LOOP loop_obtidcliente;

    CLOSE cu_cliente;

	DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_ingreso;
	DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_egreso;
	DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_total;
    DROP TABLE IF EXISTS tmp_factura_acumulado_servicio_total_2;

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
