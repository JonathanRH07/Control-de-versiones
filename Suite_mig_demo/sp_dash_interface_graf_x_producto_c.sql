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

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_superuser_graf_x_dia_c';
	END ;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* VUELOS */
	SELECT
		IFNULL(COUNT(*), 0)
	INTO
		lo_contador_x_vuelos
	FROM(
    SELECT
		gen.*
	FROM ic_gds_tr_general gen
	JOIN ic_gds_tr_vuelos vuelos ON
		gen.id_gds_generall = vuelos.id_gds_general
	WHERE gen.id_grupo_empresa = pr_id_grupo_empresa
	AND gen.id_sucursal = pr_id_sucursal
	AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
	GROUP BY gen.id_gds_generall) a;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	/* HOTELES */
    SELECT
		COUNT(*)
	INTO
		lo_contador_x_hoteles
	FROM(
	SELECT
		gen.*
	FROM ic_gds_tr_general gen
	JOIN ic_gds_tr_hoteles hoteles ON
		gen.id_gds_generall = hoteles.id_gds_general
	WHERE gen.id_grupo_empresa = pr_id_grupo_empresa
	AND gen.id_sucursal = pr_id_sucursal
	AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = '2019-08'
	GROUP BY gen.id_gds_generall) b;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* AUTOS */
    SELECT
		IFNULL(COUNT(*), 0)
	INTO
		lo_contador_x_autos
	FROM(
	SELECT
		gen.*
	FROM ic_gds_tr_general gen
	JOIN ic_gds_tr_autos autos ON
		gen.id_gds_generall = autos.id_gds_general
	WHERE gen.id_grupo_empresa = pr_id_grupo_empresa
	AND gen.id_sucursal = pr_id_sucursal
	AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
	GROUP BY gen.id_gds_generall) c;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /* OTROS */
	SELECT
		IFNULL(COUNT(*), 0)
	INTO
		lo_contador_otros
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
	WHERE gen.id_grupo_empresa = pr_id_grupo_empresa
	AND gen.id_sucursal = pr_id_sucursal
	AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
	AND vuelos.id_gds_general IS NULL
	AND hoteles.id_gds_general IS NULL
	AND autos.id_gds_general IS NULL) d;

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
