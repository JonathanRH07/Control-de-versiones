DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_contraseña_valida_c`(
	IN	pr_id_usuario				INT(11),
    IN 	pr_password_actual			VARCHAR(256),
    IN 	pr_password_nueva			VARCHAR(256),
    OUT pr_message 	         		VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_usuario_contraseña_valida_c
	@fecha: 		11/09/2019
	@descripcion: 	SP para validar que la contraseña nueva sea diferente a la ya registrada
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

    DECLARE lo_count_pass			INT;
    DECLARE lo_password_usuario		VARCHAR(256);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_usuario_u';
	END;

	SELECT
		password_usuario,
		IFNULL(COUNT(*), 0)
	INTO
		lo_password_usuario,
		lo_count_pass
	FROM st_adm_tr_usuario
	WHERE id_usuario = pr_id_usuario
    AND password_usuario = pr_password_actual;

    IF lo_count_pass > 0 THEN
		IF lo_password_usuario = pr_password_nueva THEN
			SET pr_message = '-3'; -- CONTRASEÑA IGUAL QUE LA ANTERIOR
		ELSE
			SET pr_message = '1'; -- CONTRASEÑA CORRECTA
        END IF;
    ELSE
		SET pr_message = '-2'; -- CONTRASEÑA ACTUAL INCORRECTA
    END IF;
END$$
DELIMITER ;
