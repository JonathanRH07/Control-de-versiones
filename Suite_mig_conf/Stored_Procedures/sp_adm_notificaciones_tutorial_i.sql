DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_notificaciones_tutorial_i`(
	IN 	pr_nombre_video 			VARCHAR(255),
	IN 	pr_enlace_video 			TEXT,
	IN 	pr_modulo 					VARCHAR(60),
	IN 	pr_descripcion 				LONGTEXT,
	IN 	pr_estatus 					ENUM('ACTIVO','INACTIVO'),
	OUT pr_inserted_id				INT,
    OUT pr_affect_rows      		INT,
    OUT pr_message 	         		VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_notificaciones_tutorial_i
	@fecha: 		17/03/2019
	@descripcion: 	SP para insertar registros en la tabla de notificaciones cada vez que se ingrese un video nuevo
	@autor: 		Antonio Hernández
	@cambios:
*/

	DECLARE lo_nombre_video     	TEXT DEFAULT '';
    DECLARE lo_fecha_publicion  	DATETIME DEFAULT NOW();
    DECLARE lo_estatus            	TEXT DEFAULT 'ACTIVO';
	DECLARE lo_id_usuario        	INT;
    DECLARE lo_id_grupo_empresa 	INT;
	DECLARE done 					INT DEFAULT FALSE;

    DECLARE usuarios CURSOR FOR
	SELECT
		id_usuario,
		id_grupo_empresa
	FROM st_adm_tr_usuario
    WHERE estatus_usuario = 1;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_notificaciones_tutorial_i';
        SET pr_affect_rows = 0;
	END;

    /* ------------------------------------------------------------------------------------------------------------------------------------------- */

	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = TRUE;
	OPEN usuarios;
        bucle: LOOP
            FETCH usuarios INTO lo_id_usuario, lo_id_grupo_empresa;

            IF done != TRUE THEN
                CALL sp_adm_notificaciones_i
                    (lo_id_grupo_empresa,
                    lo_id_usuario,
                    1,
                    lo_nombre_video,
                    NULL,
                    @pr_inserted_id,
                    @pr_affect_rows,
                    @pr_message);
            ELSE
                LEAVE bucle;
            END IF;

		END LOOP;
	CLOSE usuarios;

    IF pr_estatus != '' THEN
        SET lo_estatus = pr_estatus;
    END IF;

    INSERT INTO st_adm_tc_tutoriales
	(
		nombre_video,
        enlace_video,
        modulo,
        fecha_publicacion,
        descripcion,
        estatus
	)
	VALUES
	(
		lo_nombre_video,
        pr_enlace_video,
        pr_modulo,
        lo_fecha_publicion,
        pr_descripcion,
        lo_estatus
	);


    /* ------------------------------------------------------------------------------------------------------------------------------------------- */

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	#Devuelve el id insertado
    SET pr_inserted_id 	= @@identity;

	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
