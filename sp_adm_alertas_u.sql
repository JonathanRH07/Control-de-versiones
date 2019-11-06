DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_alertas_u`(
	IN  pr_id_alertas 			INT(11),
	IN  pr_id_grupo_empresa 	INT(11),
	IN  pr_id_usuario 			INT(11),
	IN  pr_usuarios 			TEXT,
	IN  pr_notificacion 		VARCHAR(255),
	IN  pr_hipervinculo 		INT(1),
	IN  pr_estatus 				ENUM('ACTIVO','INACTIVO'),
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_alertas_u
	@fecha:			17/01/2018
	@descripcion:	SP para actualizar registros en la tabla adm_alertas
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_grupo_empresa 	VARCHAR(200) DEFAULT '';
	DECLARE lo_id_usuario			VARCHAR(200) DEFAULT '';
    DECLARE lo_usuarios				VARCHAR(200) DEFAULT '';
    DECLARE lo_notificacion			VARCHAR(200) DEFAULT '';
    DECLARE lo_hipervinculo			VARCHAR(200) DEFAULT '';
    DECLARE lo_estatus				VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_alertas_u';
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_id_grupo_empresa > 0 THEN
		SET lo_id_grupo_empresa = CONCAT('id_grupo_empresa = ', pr_id_grupo_empresa, ',');
	END IF;

    IF pr_id_usuario > 0 THEN
		SET lo_id_usuario = CONCAT('id_usuario = "', pr_id_usuario, '",');
	END IF;

    IF pr_usuarios > 0 THEN
		SET lo_usuarios = CONCAT('usuarios = "', pr_usuarios, '",');
	END IF;

    IF pr_notificacion != '' THEN
		SET lo_notificacion = CONCAT('notificacion = "', pr_notificacion, '",');
	END IF;

    IF pr_hipervinculo > 0 THEN
		SET lo_hipervinculo = CONCAT('hipervinculo = "', pr_hipervinculo, '",');
	END IF;

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;


	SET @query = CONCAT('UPDATE st_adm_tr_alertas
							SET ',
								lo_id_grupo_empresa,
                                lo_id_usuario,
                                lo_usuarios,
                                lo_notificacion,
                                lo_hipervinculo,
                                lo_estatus,
                                ' id_usuario=',pr_id_usuario ,
								' , fecha_alta = sysdate()
								 WHERE id_alertas = ?'
	);

	PREPARE stmt FROM @query;
	SET @id_alertas= pr_id_alertas;
	EXECUTE stmt USING @id_alertas;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';

	COMMIT;
END$$
DELIMITER ;
