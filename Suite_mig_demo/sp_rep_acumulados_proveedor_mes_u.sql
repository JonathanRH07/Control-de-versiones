DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_rep_acumulados_proveedor_mes_u`(
	 IN  pr_fecha							VARCHAR(7),
	 OUT pr_message							VARCHAR(500)
)
BEGIN
/*
    @nombre:		sp_rep_acumulados_proveedor_mes_u
	@fecha:			2019/02/22
	@descripcion:	SP para actualizar registros en la tabla de acumulados
	@autor:			Jonathan Ramirez Hernandez
	@cambios:
*/
	DECLARE lo_id_proveedor 				INT;
    DECLARE lo_acu_id_proveedor 			INT;
    DECLARE lo_acumulado_moneda_base		DECIMAL(15,2);
	DECLARE	lo_acumulado_usd				DECIMAL(15,2);
	DECLARE lo_acumulado_eur				DECIMAL(15,2);
    DECLARE lo_fecha_val					VARCHAR(4);
    DECLARE lo_fecha_1						VARCHAR(4);
	DECLARE lo_fecha						VARCHAR(7);

    DECLARE cu_proveedor CURSOR FOR
	SELECT
		DISTINCT(id_proveedor)
	FROM ic_rep_tr_acumulado_proveedor;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_rep_acumulados_proveedor_mes_u';
        ROLLBACK;
	END ;

	DECLARE CONTINUE HANDLER FOR
	NOT FOUND SET @hecho = TRUE;

     SET lo_fecha_val = SUBSTRING(pr_fecha,6,1);

	IF lo_fecha_val = '0' THEN
		SET lo_fecha_1 = (SUBSTRING(pr_fecha,7,2) - 1);
        SET lo_fecha = CONCAT(SUBSTRING(pr_fecha,1,6),lo_fecha_1);
	ELSE
		SET lo_fecha_1 = (SUBSTRING(pr_fecha,6,2) - 1);
        IF lo_fecha_1 = '9' THEN
			SET lo_fecha = CONCAT(SUBSTRING(pr_fecha,1,5),'0',lo_fecha_1);
		ELSE
			SET lo_fecha = CONCAT(SUBSTRING(pr_fecha,1,5),lo_fecha_1);
		END IF;
	END IF;

	-- SET lo_fecha = SUBSTRING(pr_fecha,1,4);
    DROP TEMPORARY TABLE IF EXISTS tmp_factura_acumulado_proveedor;

    OPEN cu_proveedor;

		loop_obtidproveedor: LOOP

           FETCH cu_proveedor INTO lo_id_proveedor;

           IF @hecho THEN
				LEAVE loop_obtidproveedor;
		   END IF;

             DROP TEMPORARY TABLE IF EXISTS tmp_factura_acumulado_proveedor;

			/* -------------------------------------------------------- */

            SET @queryacumulado = CONCAT('CREATE TEMPORARY TABLE tmp_factura_acumulado_proveedor
											SELECT
												id_proveedor,
												IFNULL(acumulado_moneda_base,0) acumulado_moneda_base,
												IFNULL(acumulado_usd,0) acumulado_usd,
												IFNULL(acumulado_eur,0) acumulado_eur
											FROM ic_rep_tr_acumulado_proveedor
											WHERE fecha >= ''',lo_fecha,'''
                                            AND fecha <= ''',pr_fecha,'''
											AND id_proveedor = ',lo_id_proveedor,'
											ORDER BY fecha ASC');

            -- SELECT @queryacumulado;
			PREPARE stmt FROM @queryacumulado;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

            /*-------------------------------------------------------------------*/

            SELECT
				id_proveedor,
				IFNULL(SUM(acumulado_moneda_base),0) acumulado_moneda_base,
				IFNULL(SUM(acumulado_usd),0) acumulado_usd,
				IFNULL(SUM(acumulado_eur),0) acumulado_usd
			INTO
				lo_acu_id_proveedor,
				lo_acumulado_moneda_base,
                lo_acumulado_usd,
                lo_acumulado_eur
			FROM tmp_factura_acumulado_proveedor;

            START TRANSACTION;

			IF SUBSTRING(pr_fecha,6,2) = '01' THEN
				UPDATE ic_rep_tr_acumulado_proveedor
				SET acumulado_moneda_base = venta_neta_moneda_base,
					acumulado_usd = venta_neta_usd,
					acumulado_eur = venta_neta_eur
				WHERE fecha = pr_fecha
				AND id_proveedor = lo_id_proveedor
                AND acumulado_moneda_base = 0
                AND acumulado_usd = 0
                AND acumulado_eur = 0;
           ELSE
				UPDATE ic_rep_tr_acumulado_proveedor
				SET acumulado_moneda_base = (acumulado_moneda_base + venta_neta_moneda_base + lo_acumulado_moneda_base),
					acumulado_usd = (acumulado_usd + venta_neta_usd + lo_acumulado_usd),
					acumulado_eur = (acumulado_eur + venta_neta_eur + lo_acumulado_eur)
				WHERE fecha = pr_fecha
				AND id_proveedor = lo_acu_id_proveedor
				AND acumulado_moneda_base = 0
                AND acumulado_usd = 0
                AND acumulado_eur = 0;
           END IF;

		   COMMIT;

           /*-------------------------------------------------------------------*/

        END LOOP loop_obtidproveedor;

    CLOSE cu_proveedor;

    SET lo_acumulado_moneda_base = 0;
	SET lo_acumulado_usd = 0;
	SET lo_acumulado_eur = 0;

    DROP TEMPORARY TABLE IF EXISTS tmp_factura_acumulado_proveedor;

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
