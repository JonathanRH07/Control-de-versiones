DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dash_administrador_contenido_usuarios_ult_conexion_c`(
	IN	pr_id_grupo_empresa					INT,
	IN  pr_ini_pag							INT,
    IN  pr_fin_pag							INT,
    OUT pr_rows_tot_table					INT,
    OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_dash_administrador_contenido_usuarios_ult_conexion_c
	@fecha:			08/09/2019
	@descripcion:	SP para llenar el primer recudro de los dashboards de ventas.
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_dash_administrador_contenido_usuarios_conectados_c';
	END;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @queryult = CONCAT(
					'
                    SELECT
						usuario,
						nombre_usuario,
						apellidos_usuario,
						fecha_ultima_conexion
					FROM(
						SELECT
							usuario,
							nombre_usuario,
							CONCAT(paterno_usuario, '' '', materno_usuario) apellidos_usuario,
							DATE_FORMAT(fecha_ult_conexion, ''%Y-%m-%d'') fecha_ultima_conexion,
							fecha_ult_conexion
						FROM suite_mig_conf.st_adm_tr_usuario
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						HAVING DATEDIFF(fecha_ult_conexion, NOW()) <= -5) a
					LIMIT ',pr_ini_pag,',',pr_fin_pag);

    -- SELECT @queryult;
	PREPARE stmt FROM @queryult;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SET @pr_rows_tot_table = 0;
    SET @queryult_rows = CONCAT(
					'
                    SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM(
						SELECT
							usuario,
							nombre_usuario,
							CONCAT(paterno_usuario, '' '', materno_usuario) apellidos_usuario,
							DATE_FORMAT(fecha_ult_conexion, ''%Y-%m-%d'') fecha_ultima_conexion,
							fecha_ult_conexion
						FROM suite_mig_conf.st_adm_tr_usuario
						WHERE id_grupo_empresa = ',pr_id_grupo_empresa,'
						HAVING DATEDIFF(fecha_ult_conexion, NOW()) <= -5) a');

    -- SELECT @queryult_rows;
	PREPARE stmt FROM @queryult_rows;
	EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET pr_rows_tot_table = @pr_rows_tot_table;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
