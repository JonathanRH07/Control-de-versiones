DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_usuario_sucursal_i`(
	IN  pr_id_usuario		    INT(11),
    IN 	pr_id_sucursal		    INT(11),
    IN	pr_id_usuario_mod       VARCHAR(100),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_glob_usuario_sucursal_i
	@fecha: 		15/12/2016s
	@descripcion: 	SP para insertar registro en catalogo usuarios.
	@autor: 		Griselda Medina Medina
	@cambios:

*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION

	BEGIN
		SET pr_message = 'ERROR store sp_glob_usuario_sucursal_i';
        SET pr_affect_rows = 0;
	END;


	# Falta validar que el usuario no se este usando en otras tablas

	INSERT INTO  suite_mig_conf.st_adm_tr_usuario_sucursal(
		id_usuario,
		id_sucursal,
        id_usuario_mod
	) VALUE (
		pr_id_usuario,
		pr_id_sucursal,
		pr_id_usuario_mod
	);

	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual; #Devuelve el numero de registros insertados
	SET pr_inserted_id 	= @@identity;
	SET pr_message = 'SUCCESS'; # Mensaje de ejecución.

END$$
DELIMITER ;
