DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_indicadores2_c`(
	IN	pr_id_grupo_empresa					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_indicadores_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_usuarios_conectados			INT;
    DECLARE lo_capacidad					INT;
    DECLARE lo_fecha_compra					DATE;
    DECLARE lo_folios_disponibles			INT;
    DECLARE lo_id_empresa					INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_ventas_indicadores_c';
	END;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		IFNULL(COUNT(*), 0)
	INTO
		lo_usuarios_conectados
	FROM suite_mig_conf.st_adm_tr_usuario
	WHERE id_grupo_empresa = pr_id_grupo_empresa
	AND inicio_sesion = 1
	AND estatus_usuario = 1;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		id_empresa
	INTO
		lo_id_empresa
	FROM suite_mig_conf.st_adm_tr_grupo_empresa
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

    SELECT
		CASE
			WHEN id_tipo_paquete = 1 THEN
				'150'
			WHEN id_tipo_paquete = 2 THEN
				'500'
			WHEN id_tipo_paquete = 3 THEN
				'1'
			WHEN id_tipo_paquete = 4 THEN
				'2'
		END
	INTO
		lo_capacidad
	FROM suite_mig_conf.st_adm_tr_empresa
	WHERE id_empresa = lo_id_empresa;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		MAX(fecha)
	INTO
		lo_fecha_compra
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		IFNULL(SUM(no_folios_disponibles), 0)
	INTO
		lo_folios_disponibles
	FROM ic_fac_tr_folios
	WHERE id_grupo_empresa = pr_id_grupo_empresa;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT
		lo_usuarios_conectados,
        lo_capacidad,
        lo_fecha_compra,
        lo_folios_disponibles;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
