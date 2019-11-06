DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_recuperacion_c`(
	IN 	pr_id_usuario						INT,
    IN 	pr_token							VARCHAR(256),
	OUT pr_message							VARCHAR(500)
)
BEGIN
/*
	@nombre:		sp_adm_usuario_recuperacion_c
	@fecha:			022/07/2019
	@descripcion:	SP para buscar usuarios en la tabla recuperacion de contraseña
	@autor:			Jonathan Ramirez
	@cambios:
*/

	DECLARE lo_mensaje						VARCHAR(10);
	DECLARE lo_contador_exist				INT DEFAULT 0;
    DECLARE lo_contador_fecha_min			INT DEFAULT 0;
    DECLARE lo_contador_fecha_max			INT DEFAULT 0;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_recuperacion_c';
	END ;

    /* VALIDAR SI EXISTE LA PETICION */
	SELECT
		COUNT(*)
	INTO
		lo_contador_exist
	FROM suite_mig_conf.st_adm_tr_usuario_recuperacion
	WHERE id_usuario = pr_id_usuario
	AND token = SHA(pr_token);

    IF lo_contador_exist > 0 THEN
		/* VALIDAR QUE LA PETICION ESTE EN TIEMPO */
        SELECT
			COUNT(*)
		INTO
			lo_contador_fecha_min
		FROM suite_mig_conf.st_adm_tr_usuario_recuperacion
		WHERE id_usuario = pr_id_usuario
		AND token = SHA(pr_token)
		AND TIMEDIFF(NOW(),fecha_limite) < 0;

        /* VALIDAR QUE LA PETICIION ESTE FUERA DE TIEMPO */
		SELECT
			COUNT(*)
		INTO
			lo_contador_fecha_max
		FROM suite_mig_conf.st_adm_tr_usuario_recuperacion
		WHERE id_usuario = pr_id_usuario
		AND token = SHA(pr_token)
		AND TIMEDIFF(NOW(),fecha_limite) > 0;

        /* SI LA PETICION ESTA EN TIEMPO SE MANDA MENSAJE "si existe y esta dentro del limite de tiempo" */
        IF lo_contador_fecha_min > 0 THEN
			SET lo_mensaje = '1';
		/* SI LA PETICION ESTA FUERA DE TIEMPO SE MANDA MENSAJE "si existe y esta fuera del limite de tiempo" */
		ELSEIF lo_contador_fecha_max > 0 THEN
			SET lo_mensaje = '-2';
        END IF;
    ELSE
		/* SI NO EXISTE PETICION SE MANDA MENSAJE "no existe" */
        SET lo_mensaje = '-1';
    END IF;

	SELECT lo_mensaje;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
