DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_contraseña_u`(
	IN	pr_id_usuario				INT(11),
    IN 	pr_password_usuario			VARCHAR(256),
	OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_usuario_contraseña_u
	@fecha: 		22/07/2019
	@descripcion: 	SP para actualizar registro en catalogo usuarios.
	@autor: 		Jonathan Ramirez Hernandez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		SET pr_message = 'ERROR store sp_cat_usuario_u';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;

	UPDATE st_adm_tr_usuario
	SET primer_ingreso = 0
	WHERE id_usuario = pr_id_usuario;

	UPDATE st_adm_tr_usuario
	SET password_usuario = pr_password_usuario,
		id_usuario_mod = pr_id_usuario
	WHERE id_usuario = pr_id_usuario;

	/* REGRESA EL NUMERO DE REGISTROS ACTUALIZADOS */
	SET pr_affect_rows = @@identity;

	IF pr_affect_rows > 0 THEN
		SET pr_affect_rows = 1;
	ELSE
		SET pr_affect_rows = 0;
	END IF;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
