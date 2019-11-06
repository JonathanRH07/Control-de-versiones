DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_i`(
	IN  pr_id_grupo_empresa		INT(11),
    IN  pr_id_empresa			INT(11),
    IN 	pr_id_role				INT(11),
    IN  pr_usuario 	     		VARCHAR(100),
    IN  pr_password_usuario     VARCHAR(256),
	IN 	pr_nombre_usuario       VARCHAR(45),
	IN  pr_paterno_usuario      VARCHAR(45),
	IN 	pr_materno_usuario      VARCHAR(45),
	IN	pr_registra_usuario     VARCHAR(100),
    IN	pr_id_usuario_mod       INT(11),
    IN	pr_correo               VARCHAR(100),
	IN 	pr_hora_acceso_ini		VARCHAR(10),
    IN	pr_hora_acceso_fin		VARCHAR(10),
    IN 	pr_acceso_ip			VARCHAR(1),
    IN 	pr_acceso_horario		VARCHAR(1),
    IN  pr_id_idioma			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_usuario_i
	@fecha: 		15/12/2016s
	@descripcion: 	SP para insertar registro en catalogo usuarios.
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE lo_inserted_id 			INT;
    DECLARE lo_hora_acceso_ini		VARCHAR(10);
    DECLARE lo_hora_acceso_fin		VARCHAR(10);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'USERS.MESSAGE_ERROR_CREATE_USUARIOS';
        SET pr_affect_rows = 0;
	END;

	IF pr_acceso_horario != 0 THEN
		SET lo_hora_acceso_ini = pr_hora_acceso_ini;
        SET lo_hora_acceso_fin = pr_hora_acceso_fin;
	ELSE
		SET lo_hora_acceso_ini = NULL;
        SET lo_hora_acceso_fin = NULL;
	END IF;

	# Falta validar que el usuario no se este usando en otras tablas
	INSERT INTO suite_mig_conf.st_adm_tr_usuario
	(
		id_grupo_empresa,
		id_role,
		id_idioma,
		usuario,
		password_usuario,
		nombre_usuario,
		paterno_usuario,
		materno_usuario,
		registra_usuario,
		correo,
		hora_acceso_ini,
		hora_acceso_fin,
		acceso_ip,
		acceso_horario,
		id_usuario_mod
	)
	VALUES
	(
		pr_id_grupo_empresa,
		pr_id_role,
		pr_id_idioma,
		pr_usuario,
		pr_password_usuario,
		pr_nombre_usuario,
		pr_paterno_usuario,
		pr_materno_usuario,
		pr_registra_usuario,
		pr_correo,
		lo_hora_acceso_ini,
		lo_hora_acceso_fin,
		pr_acceso_ip,
		pr_acceso_horario,
		pr_id_usuario_mod
	);

	SET lo_inserted_id 	= @@identity;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	/*CALL sp_adm_empresa_usuario_i(
		pr_id_empresa,
		lo_inserted_id,
		pr_inserted_id,
		pr_affect_rows,
		pr_message
		);*/

	SET pr_inserted_id=lo_inserted_id;
	# Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

END$$
DELIMITER ;
