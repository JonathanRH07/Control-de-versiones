DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_interface_graf_x_gds_c`(
	IN	pr_id_grupo_empresa				INT,
    IN	pr_id_sucursal					INT,
    -- IN  pr_moneda_reporte				INT,
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_interface_graf_x_gds_c
	@fecha:			06/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_dash_interface_graf_x_gds_c';
	END ;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		gds.nombre nombre_gds,
		CASE
			WHEN gen.cve_gds = 'WS' THEN
				COUNT(*)
			WHEN gen.cve_gds = 'AM' THEN
				COUNT(*)
			WHEN gen.cve_gds = 'SA' THEN
				COUNT(*)
		END contador_pnrs
	FROM ic_gds_tr_general gen
	JOIN ic_cat_tc_gds gds ON
		gen.cve_gds = gds.cve_gds
	WHERE gen.id_grupo_empresa = pr_id_grupo_empresa
	AND gen.id_sucursal = pr_id_sucursal
	AND DATE_FORMAT(gen.fecha_recepcion, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m')
	GROUP BY gen.cve_gds;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
