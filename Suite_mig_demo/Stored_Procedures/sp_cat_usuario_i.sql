DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_usuario_i`(
	IN  pr_id_grupo_empresa		INT(11),
    IN 	pr_id_role				INT(11),
    IN  pr_usuario 	     		VARCHAR(100),
    IN  pr_password_usuario     VARCHAR(256),
	IN 	pr_nombre_usuario       VARCHAR(45),
	IN  pr_paterno_usuario      VARCHAR(45),
	IN 	pr_materno_usuario      VARCHAR(45),
	IN	pr_registra_usuario     VARCHAR(100),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_usuario_i
	@fecha: 		15/12/2016
	@descripcion: 	SP para insertar registro en catalogo usuarios.
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_cat_usuario_i';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

# Falta validar que el usuario no se este usando en otras tablas

	INSERT INTO  suite_mig_conf.st_adm_tr_usuario(
		id_grupo_empresa,
		id_role,
		usuario,
		password_usuario,
		nombre_usuario,
		paterno_usuario,
		materno_usuario,
		registra_usuario
		)
	VALUE
		(
		pr_id_grupo_empresa,
		pr_id_role,
		pr_usuario,
		SHA(pr_password_usuario),
		pr_nombre_usuario,
		pr_paterno_usuario,
		pr_materno_usuario,
		pr_registra_usuario
		);


	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
