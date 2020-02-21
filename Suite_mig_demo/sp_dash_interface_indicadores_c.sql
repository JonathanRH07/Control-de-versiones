DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_interface_indicadores_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    -- IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_interface_indicadores_c
	@fecha:			05/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_no_pnr_recibidos			INT;
    DECLARE lo_no_pnr_facturados		INT;
    DECLARE lo_no_pnr_error				INT;
    DECLARE lo_no_pnr_porc_efec			DECIMAL(5,2);
    DECLARE lo_sucursal					VARCHAR(200) DEFAULT '';


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_reportes_indicadores_c';
	END;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		COUNT(*)
	INTO
		lo_no_pnr_recibidos
	FROM ic_gds_tr_general
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND DATE_FORMAT(fecha_recepcion, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m');

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @query_pnr_fac = CONCAT(
				'
				SELECT
					COUNT(*)
				INTO
					@lo_no_pnr_facturados
				FROM ic_gds_tr_general
				WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
				AND DATE_FORMAT(fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND fac_numero IS NOT NULL');

	-- SELECT @query_pnr_fac;
	PREPARE stmt FROM @query_pnr_fac;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_no_pnr_facturados = @lo_no_pnr_facturados;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		COUNT(*)
	INTO
		lo_no_pnr_error
	FROM(
	SELECT *
	FROM ic_gds_tr_general a
	JOIN ic_gds_tr_errores b ON
		a.id_gds_generall = b.id_gds_general
	WHERE a.id_grupo_empresa = pr_id_grupo_empresa
	AND DATE_FORMAT(a.fecha_recepcion, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
	GROUP BY b.id_gds_general) a;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET lo_no_pnr_porc_efec = ((lo_no_pnr_facturados/lo_no_pnr_recibidos));

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		lo_no_pnr_recibidos,
        lo_no_pnr_facturados,
        lo_no_pnr_error,
        lo_no_pnr_porc_efec;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
