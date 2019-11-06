DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_empresa_usuario_i`(
	IN  pr_id_empresa    		INT(11),
    IN  pr_id_usuario 	     	VARCHAR(100),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_empresa_usuario_i
	@fecha: 		15/12/2016s
	@descripcion: 	SP para insertar registro en catalogo usuarios.
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_adm_empresa_usuario_i';
        SET pr_affect_rows = 0;
	END;


# Falta validar que el usuario no se este usando en otras tablas

	INSERT INTO  suite_mig_conf.st_adm_tr_empresa_usuario(
		id_empresa,
		id_usuario
	) VALUE (
		pr_id_empresa,
		pr_id_usuario
	);


	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	SET pr_inserted_id 	= @@identity;
	 # Mensaje de ejecución.
	SET pr_message 		= 'SUCCESS';

END$$
DELIMITER ;
