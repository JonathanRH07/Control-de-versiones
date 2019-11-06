DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_recuperacion_i`(
	IN 	pr_id_usuario					INT,
    IN 	pr_correo						CHAR(50),
    IN  pr_token						VARCHAR(255),
    OUT pr_message						VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_adm_usuario_recuperacion_i
	@fecha:			18/07/2019
	@descripcion:	SP para insertar datos del usuario para reperacion de contraseña
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_sucursal_b';
        ROLLBACK;
	END ;

    START TRANSACTION;

	INSERT INTO st_adm_tr_usuario_recuperacion
	(
		id_usuario,
		correo,
		token,
		fecha_limite
	)
	VALUES
	(
		pr_id_usuario,
		pr_correo,
		SHA(pr_token),
		DATE_ADD(SYSDATE(), INTERVAL 10 MINUTE)
	);

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
    COMMIT;
END$$
DELIMITER ;
