DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_interface_graf_x_producto_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    -- IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_interface_graf_x_producto_c
	@fecha:			05/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_contador_x_vuelos		INT DEFAULT 0;
    DECLARE lo_contador_x_hoteles		INT DEFAULT 0;
    DECLARE lo_contador_x_autos			INT DEFAULT 0;
    DECLARE lo_contador_otros			INT DEFAULT 0;
    DECLARE lo_sucursal					VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_superuser_graf_x_dia_c';
	END ;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		matriz
	INTO
		@lo_es_matriz
	FROM ic_cat_tr_sucursal
	WHERE id_sucursal = pr_id_sucursal;

    IF @lo_es_matriz = 0 THEN
		SET lo_sucursal = CONCAT('AND gen.id_sucursal = ',pr_id_sucursal,'');
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* VUELOS */
    SET @query_vuelos = CONCAT(
				'
                SELECT
					IFNULL(COUNT(*), 0)
				INTO
					@lo_contador_x_vuelos
				FROM(
				SELECT
					gen.*
				FROM ic_gds_tr_general gen
				JOIN ic_gds_tr_vuelos vuelos ON
					gen.id_gds_generall = vuelos.id_gds_general
				WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
				AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				GROUP BY gen.id_gds_generall) a');

	-- SELECT @query_vuelos;
	PREPARE stmt FROM @query_vuelos;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_contador_x_vuelos = IFNULL(@lo_contador_x_vuelos, 0);

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	/* HOTELES */
    SET @query_hoteles = CONCAT(
				'
				SELECT
					COUNT(*)
				INTO
					@lo_contador_x_hoteles
				FROM(
				SELECT
					gen.*
				FROM ic_gds_tr_general gen
				JOIN ic_gds_tr_hoteles hoteles ON
					gen.id_gds_generall = hoteles.id_gds_general
				WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
				',lo_sucursal,'
				AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
				GROUP BY gen.id_gds_generall) b');

	-- SELECT @query_hoteles;
	PREPARE stmt FROM @query_hoteles;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_contador_x_hoteles = IFNULL(@lo_contador_x_hoteles, 0);

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* AUTOS */
    SET @query_autos = CONCAT(
						'
						SELECT
							IFNULL(COUNT(*), 0)
						INTO
							@lo_contador_x_autos
						FROM(
						SELECT
							gen.*
						FROM ic_gds_tr_general gen
						JOIN ic_gds_tr_autos autos ON
							gen.id_gds_generall = autos.id_gds_general
						WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
						',lo_sucursal,'
						AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
						GROUP BY gen.id_gds_generall) c');

    	-- SELECT @query_autos;
	PREPARE stmt FROM @query_autos;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET lo_contador_x_autos = IFNULL(@lo_contador_x_autos, 0);

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* OTROS */
    SET @query_autos = CONCAT(
					'
					SELECT
						IFNULL(COUNT(*), 0)
					INTO
						@lo_contador_otros
					FROM(
					SELECT
						gen.*
					FROM ic_gds_tr_general gen
					LEFT JOIN ic_gds_tr_vuelos vuelos ON
						gen.id_gds_generall = vuelos.id_gds_general
					LEFT JOIN ic_gds_tr_hoteles hoteles ON
						gen.id_gds_generall = hoteles.id_gds_general
					LEFT JOIN ic_gds_tr_autos autos ON
						gen.id_gds_generall = autos.id_gds_general
					WHERE gen.id_grupo_empresa = ',pr_id_grupo_empresa,'
					',lo_sucursal,'
					AND DATE_FORMAT(gen.fecha_recepcion, ''%Y-%m'') = DATE_FORMAT(NOW(), ''%Y-%m'')
					AND vuelos.id_gds_general IS NULL
					AND hoteles.id_gds_general IS NULL
					AND autos.id_gds_general IS NULL) d');

	SET lo_contador_otros = IFNULL(@lo_contador_otros, 0);

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		lo_contador_x_vuelos,
        lo_contador_x_hoteles,
        lo_contador_x_autos,
        lo_contador_otros;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
