DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_valida_olvide_mi_contraseña_c`(
	IN 	pr_id_usuario					INT,
    IN 	pr_password_usuario				VARCHAR(256),
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_usuario_valida_olvide_mi_contraseña_c
	@fecha:			23/07/2019
	@descripcion:	SP para validar la contraseña del usuario en la tabla usuarios
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_count					INT DEFAULT 0;
    DECLARE lo_message					CHAR(2);
    DECLARE lo_password_usuario			VARCHAR(256);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_valida_contraseña_c';
	END ;

    /*
    1) USUARIO EXISTE Y LA NUEVA CONTRASEÑA ES DIFERENTE
    -4) USUARIO EXISTE Y LA NUEVA CONTRASEÑA ES IGUAL A LA NUEVA
    */

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		password_usuario
	INTO
		lo_password_usuario
	FROM st_adm_tr_usuario
	WHERE id_usuario = pr_id_usuario;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	IF lo_password_usuario = pr_password_usuario THEN
		SET lo_message = '-4';
	ELSE
		SET lo_message = '1';
	END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT lo_message;

    # Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
