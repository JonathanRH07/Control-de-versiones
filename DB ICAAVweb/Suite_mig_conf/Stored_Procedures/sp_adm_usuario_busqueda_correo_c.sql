DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_busqueda_correo_c`(
	IN 	pr_correo						CHAR(50),
    IN 	pr_usuario						VARCHAR(256),
    OUT pr_message						VARCHAR(5000)
)
BEGIN
/*
	@nombre:		sp_adm_usuario_busqueda_correo_c
	@fecha:			18/07/2019
	@descripcion:	SP para buscar correo y contraseña en la tabla usuarios
	@autor:			Jonathan Ramirez
	@cambios:
*/

    DECLARE lo_id_usuario				INT DEFAULT '-1';
    DECLARE lo_id_grupo_empresa			INT;
    DECLARE lo_inicio_sesion			INT;
    DECLARE lo_acceso_horario			INT;
    DECLARE lo_estatus_usuario			INT;
    DECLARE lo_hora_acceso_ini			TIME;
	DECLARE lo_hora_acceso_fin			TIME;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_adm_usuario_sucursal_b';
	END ;

    /*
    -1) NO ENCONTRADO
    -2) TIENE SESION ACTIVA
    -3) NO TIENE LICENCIA ACTIVA
    -4) TIENE RESTRICCION DE HORARIO
    */

    /* VALIDAMOS QUE EXISTA USUARIO CON EL CORREO INGRESADO */
    SELECT
		id_usuario,
        id_grupo_empresa,
        inicio_sesion,
        acceso_horario,
        estatus_usuario,
        hora_acceso_ini,
        hora_acceso_fin
	INTO
		lo_id_usuario,
        lo_id_grupo_empresa,
        lo_inicio_sesion,
        lo_acceso_horario,
        lo_estatus_usuario,
        lo_hora_acceso_ini,
        lo_hora_acceso_fin
	FROM st_adm_tr_usuario
	WHERE correo = pr_correo
	AND usuario = pr_usuario;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    IF lo_id_usuario != '-1' THEN
		IF lo_estatus_usuario != 3 THEN
			IF lo_inicio_sesion = 0 THEN
				IF lo_acceso_horario = 0 THEN
					SET lo_id_usuario = lo_id_usuario;
                ELSE
					IF NOW() >= lo_hora_acceso_ini AND NOW() <= lo_hora_acceso_fin THEN
						SET lo_id_usuario = lo_id_usuario;
					ELSE
						SET lo_id_usuario = '-4';
                    END IF;
                END IF;
			ELSE
				SET lo_id_usuario = '-2';
            END IF;
        ELSE
			SET lo_id_usuario = '-3';
        END IF;
    END IF;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    SELECT lo_id_usuario id_usuario;

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';
END$$
DELIMITER ;
