DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_reportes_graf_cobranza_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_reportes_graf_cobranza_c
	@fecha:			01/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_moneda					VARCHAR(100);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_reportes_graf_cobranza_c';
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

	SET @query = CONCAT(
				'
				SELECT
					detalle.fecha fecha_vencimiento,
					SUM((detalle.importe_moneda_base * -1)',lo_moneda,') total_dia
				FROM ic_glob_tr_cxc AS cxc
				JOIN ic_glob_tr_cxc_detalle AS detalle ON
					cxc.id_cxc  = detalle.id_cxc
				WHERE cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
                AND cxc.id_sucursal = ',pr_id_sucursal,'
				AND detalle.id_factura IS NULL
				AND cxc.estatus = ''ACTIVO''
				AND detalle.estatus = ''ACTIVO''
				AND DATE_FORMAT(detalle.fecha, ''%Y-%m'') >= DATE_FORMAT(NOW(), ''%Y-%m'')
				AND detalle.fecha <= NOW()
				GROUP BY 1
				ORDER BY detalle.fecha');

	-- SELECT @query;
	PREPARE stmt FROM @query;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
