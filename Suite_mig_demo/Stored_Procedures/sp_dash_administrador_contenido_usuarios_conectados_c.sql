DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_contenido_usuarios_conectados_c`(
	IN	pr_id_grupo_empresa					INT,
	IN  pr_ini_pag							INT,
    IN  pr_fin_pag							INT,
    OUT pr_rows_tot_table					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_contenido_usuarios_conectados_c
	@fecha:			31/08/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_contenido_usuarios_conectados_c';
	END;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @queryusus = CONCAT(
				'
				SELECT
					usuario,
					nombre_usuario,
					CONCAT(paterno_usuario,'' '', materno_usuario) apellidos_usuario
				FROM suite_mig_conf.st_adm_tr_usuario
				WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
				AND inicio_sesion = 1
				AND estatus_usuario = 1
                LIMIT ',pr_ini_pag,',',pr_fin_pag);

	-- SELECT @queryusus;
	PREPARE stmt FROM @queryusus;
	EXECUTE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @pr_rows_tot_table = 0;
    SET @querycount = CONCAT(
						'
                        SELECT
							COUNT(*)
						INTO
							@pr_rows_tot_table
						FROM suite_mig_conf.st_adm_tr_usuario
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						AND inicio_sesion = 1
						AND estatus_usuario = 1');

	-- SELECT @querycount;
	PREPARE stmt FROM @querycount;
	EXECUTE stmt;

    SET pr_rows_tot_table = @pr_rows_tot_table;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
