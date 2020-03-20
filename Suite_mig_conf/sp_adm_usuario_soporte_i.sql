DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_usuario_soporte_i`(
    IN  pr_usuario 	     		VARCHAR(100),
    IN  pr_password_usuario     VARCHAR(256),
	IN 	pr_nombre_usuario       VARCHAR(45),
	IN  pr_paterno_usuario      VARCHAR(45),
	IN 	pr_materno_usuario      VARCHAR(45),
	IN	pr_registra_usuario     VARCHAR(100),
    IN	pr_id_usuario_mod       INT(11),
    IN	pr_correo               VARCHAR(100),
    IN  pr_id_idioma			INT,
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_usuario_soporte_i
	@fecha: 		02/03/2020
	@descripcion: 	SP para insertar registro de tipo soporte en catalogo usuarios.
	@autor: 		Jonathan Ramirez
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR sp_adm_usuario_soporte_i';
        SET pr_affect_rows = 0;
	END;

    /* *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~ */

    INSERT INTO suite_mig_conf.st_adm_tr_usuario
	(
		id_grupo_empresa,
        id_role,
        id_estilo_empresa,
		id_idioma,
		usuario,
		password_usuario,
		nombre_usuario,
		paterno_usuario,
		materno_usuario,
		registra_usuario,
		correo,
        tipo_usuario,
		id_usuario_mod
	)
	VALUES
	(
		18,
        1,
        1,
		pr_id_idioma,
		pr_usuario,
		SHA2(pr_password_usuario,256),
		pr_nombre_usuario,
		pr_paterno_usuario,
		pr_materno_usuario,
		pr_registra_usuario,
		pr_correo,
        2,
		pr_id_usuario_mod
	);

    SET pr_inserted_id = @@identity;

    /* *~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~ */

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';
END$$
DELIMITER ;
