DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_valida_contraseña_c`(
	IN 	pr_id_usuario					INT,
    IN 	pr_password_usuario				VARCHAR(256),
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_adm_usuario_valida_contraseña_c
	@fecha:			23/07/2019
	@descripcion:	SP para validar la contraseña del usuario en la tabla usuarios
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_count					INT DEFAULT 0;
    DECLARE lo_message					CHAR(2);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_valida_contraseña_c';
	END ;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	SELECT
		COUNT(*)
	INTO
		lo_count
	FROM st_adm_tr_usuario
	WHERE id_usuario = pr_id_usuario
	AND password_usuario = pr_password_usuario;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	IF lo_count = 0 THEN
		SET lo_message = '-1';
	ELSE
		SET lo_message = '1';
    END IF;

    SELECT lo_message;

	/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
