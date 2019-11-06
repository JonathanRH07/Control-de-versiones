DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_busqueda_b`(
	IN	pr_id_usuario				INT,
    OUT pr_rows_tot_table			INT,
	OUT pr_message					VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_adm_usuario_busqueda_b
	@fecha:			10/10/2018
	@descripcion:	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_role_b';
	END ;

    SELECT
		id_usuario,
		id_grupo_empresa,
		usuario,
		nombre_usuario,
		paterno_usuario,
		materno_usuario,
		correo
	FROM st_adm_tr_usuario
	WHERE id_usuario = pr_id_usuario;

	SET pr_message 			= 'SUCCESS';
END$$
DELIMITER ;
