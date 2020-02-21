DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_interface_contenido_pnr_x_vendedor_c`(
	IN	pr_id_grupo_empresa					INT,
    IN	pr_id_sucursal						INT,
	IN  pr_ini_pag							INT,
    IN  pr_fin_pag							INT,
    OUT pr_rows_tot_table					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_interface_contenido_pnr_x_vendedor_c
	@fecha:			06/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_sucursal						VARCHAR(200) DEFAULT '';
    DECLARE lo_sucursal2					VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_interface_graf_x_gds_c';
	END ;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    DROP TABLE IF EXISTS tmp_count_recibidos;
    DROP TABLE IF EXISTS tmp_count_facturados;
    DROP TABLE IF EXISTS tmp_count_error;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND gen.id_sucursal = ',pr_id_sucursal,'');
        SET lo_sucursal2 = CONCAT('AND a.id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	/* RECIBIDOS */
    SET @query_recibidos = CONCAT(
						'
						CREATE TEMPORARY TABLE tmp_count_recibidos
						SELECT
							id_vendedor,
							nombre,
							COUNT(*) contador
						FROM ic_gds_tr_general gen
						JOIN ic_cat_tr_vendedor vend ON
							gen.cve_vendedor_tit = vend.clave
						WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						GROUP BY gen.cve_vendedor_tit');

		-- SELECT @query_recibidos;
		PREPARE stmt FROM @query_recibidos;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* FACTURADOS */
    SET @query_facturados = CONCAT(
				'
                CREATE TEMPORARY TABLE tmp_count_facturados
				SELECT
					id_vendedor,
					nombre,
					COUNT(*) contador
				FROM ic_gds_tr_general gen
				JOIN ic_cat_tr_vendedor vend ON
					gen.cve_vendedor_tit = vend.clave
				WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
				AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				AND gen.fac_numero IS NOT NULL
				GROUP BY gen.cve_vendedor_tit');

	-- SELECT @query_facturados;
	PREPARE stmt FROM @query_facturados;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* ERROR */
    SET @query_error = CONCAT(
						'
						CREATE TEMPORARY TABLE tmp_count_error
						SELECT
							id_vendedor,
							nombre,
							COUNT(*) contador
						FROM(
						SELECT
							id_vendedor,
							nombre,
							COUNT(*),
							a.cve_vendedor_tit
						FROM ic_gds_tr_general a
						JOIN ic_gds_tr_errores b ON
							a.id_gds_generall = b.id_gds_general
						JOIN ic_cat_tr_vendedor vend ON
							a.cve_vendedor_tit = vend.clave
						WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal2,'
						AND DATE_FORMAT(a.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						GROUP BY 1, b.id_gds_general)a
						GROUP BY cve_vendedor_tit');

	-- SELECT @query_error;
	PREPARE stmt FROM @query_error;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		a.nombre nombre_vendedor,
		IFNULL(a.contador, 0) recibidos,
		IFNULL(b.contador, 0) facturados,
		IFNULL(c.contador, 0) error
	FROM tmp_count_recibidos a
	LEFT JOIN tmp_count_facturados b ON
		a.id_vendedor = b.id_vendedor
	LEFT JOIN tmp_count_error c ON
		a.id_vendedor = c.id_vendedor
	LIMIT pr_ini_pag, pr_fin_pag;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		COUNT(*)
	INTO
		pr_rows_tot_table
	FROM tmp_count_recibidos a
	LEFT JOIN tmp_count_facturados b ON
		a.id_vendedor = b.id_vendedor
	LEFT JOIN tmp_count_error c ON
		a.id_vendedor = c.id_vendedor;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
