DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_reportes_graf_cxs_x_servicio_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_reportes_graf_cxs_x_servicio_c
	@fecha:			01/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_moneda					VARCHAR(100);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_reportes_graf_cxs_x_servicio_c';
	END;

	/* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
        SET lo_moneda = '/tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
        SET lo_moneda = '/tipo_cambio_usd';
	ELSE
		SET lo_moneda = '';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* DESARROLLO */
    SET @query = CONCAT(
						'
                        SELECT
							serv.descripcion,
							COUNT(*) no_cargos,
							IFNULL(SUM(tarifa_moneda_base',lo_moneda,') + SUM(importe_markup',lo_moneda,') - SUM(descuento',lo_moneda,'), 0) total
						FROM ic_cat_tc_servicio serv
						JOIN ic_fac_tr_factura_detalle det ON
							serv.id_servicio = det.id_servicio
						JOIN ic_fac_tr_factura fac ON
							det.id_factura = fac.id_factura
						WHERE serv.id_producto = 5
						AND fac.id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND serv.estatus = 1','
                        AND fac.id_sucursal = ',pr_id_sucursal,'
						AND DATE_FORMAT(fac.fecha_factura, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						GROUP BY serv.descripcion'
						);

    -- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
