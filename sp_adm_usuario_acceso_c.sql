DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_acceso_c`(
	IN  pr_id_usuario				INT,
    OUT pr_message 	         		VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_usuario_acceso_c
	@fecha: 		23/08/2019
	@descripcion: 	SP para consultar registro en catalogo usuarios acceso.
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_grupo_empresa		INT;
    DECLARE lo_empresa				INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_usuario_acceso_c';
	END;

	/* SE OBTIENE EL GRUPO EMPRESA DEL USUARIO */
	SELECT
		id_grupo_empresa
	INTO
		lo_grupo_empresa
	FROM st_adm_tr_usuario
	WHERE id_usuario = pr_id_usuario;

    /* SE OBTIENE LA EMPRESA DEL USUARIO CONFORME SU GRUPO EMPRESA */
	SELECT
		id_empresa
	INTO
		lo_empresa
	FROM st_adm_tr_grupo_empresa
	WHERE id_grupo_empresa = lo_grupo_empresa;

	SELECT *
	FROM st_adm_tr_usuario_acceso
	WHERE id_usuario = pr_id_usuario
    AND id_empresa = lo_empresa
	AND estatus_acceso = 1;


	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
