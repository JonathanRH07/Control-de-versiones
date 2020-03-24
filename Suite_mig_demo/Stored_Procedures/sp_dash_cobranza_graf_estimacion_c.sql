DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_cobranza_graf_estimacion_c`(
	IN  pr_id_grupo_empresa	INT,
    IN	pr_id_sucursal		INT,
    IN	pr_moneda_reporte	INT,
    OUT pr_message 			TEXT
)
BEGIN
/*
	@nombre:		sp_dash_cobranza_graf_cobros_c
	@fecha: 		2019/08/16
	@descripción: 	Sp para obtenber grafica de cobros por semestre
	@autor : 		David Roldan Solares
	@cambios:
*/

    DECLARE lo_moneda_reporte 	TEXT;
    DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_dash_cobranza_graf_estimacion_c';
	END ;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* DESARROLLO */
    /* VALIDAMOS LA MONEDA DEL REPORTE */
    IF pr_moneda_reporte = 149 THEN
		SET lo_moneda_reporte = 'cxc.saldo_moneda_base / cxc.tipo_cambio_usd';
	ELSEIF pr_moneda_reporte = 49 THEN
		SET lo_moneda_reporte = 'cxc.saldo_moneda_base / cxc.tipo_cambio_eur';
	ELSE
		SET lo_moneda_reporte = 'cxc.saldo_moneda_base';
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND cxc.id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @queryac = CONCAT('
						SELECT
							DATE_FORMAT(cxc.fecha_vencimiento,''%m'') mes,
							DATE_FORMAT(cxc.fecha_vencimiento,''%d'') dia,
							SUM(',lo_moneda_reporte,') total_dia
						FROM ic_glob_tr_cxc cxc
						WHERE cxc.estatus = ''ACTIVO''
						AND cxc.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,
						' AND cxc.fecha_vencimiento >= SYSDATE()
                        AND saldo_moneda_base != 0
						AND cxc.fecha_vencimiento <= DATE_ADD(SYSDATE(), INTERVAL 100 DAY)
						GROUP BY DATE_FORMAT(cxc.fecha_vencimiento,''%d'')
                        ORDER BY 1, 2 ASC');

	-- SELECT @queryac;
    PREPARE stmt FROM @queryac;
	EXECUTE stmt;

    SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
