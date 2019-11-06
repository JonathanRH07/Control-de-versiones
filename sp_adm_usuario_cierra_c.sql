DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_cierra_c`(
	IN 	pr_id_usuario					INT,
	OUT pr_message						VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_adm_usuario_cierre_c
	@fecha:			06/06/2019
	@descripcion:	SP para deslogear usuarios
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_sucursal_b';
		ROLLBACK;
	END ;

    START TRANSACTION;

    /* MODIFICA EL CAMPO inicio_sesion A 0 CUANDO SE EJECUTA EL METODO DE LOGOUT */
	UPDATE st_adm_tr_usuario
	SET inicio_sesion = 0
	WHERE id_usuario = pr_id_usuario;

	/* ACTUALIZAR LA HORA DE DESBLOQUEO */
	UPDATE st_adm_tr_usuario
	SET fecha_desbloqueo = NULL,
		intentos_ingreso = 0
	WHERE id_usuario = pr_id_usuario;

    SELECT 'SUCCES';

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
    COMMIT;
END$$
DELIMITER ;
