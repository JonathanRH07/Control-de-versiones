DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_contacto_i`(
	IN	pr_id_cliente		INT,
	IN	pr_nombre 			VARCHAR(100),
	IN	pr_puesto 			VARCHAR(50),
	IN	pr_departamento		VARCHAR(50),
	IN	pr_mail 			VARCHAR(50),
	IN	pr_telefono 		VARCHAR(20),
	IN	pr_extension 		VARCHAR(6),
    IN 	pr_fecha_cumple		DATE,
    IN 	pr_id_usuario		INT,
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_contacto_i
	@fecha:			04/01/2017
	@descripcion:	SP para agregar contactos a Clientes.
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_contacto_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;


	INSERT INTO ic_cat_tr_cliente_contacto (
		id_cliente,
		nombre,
		puesto,
		departamento,
		mail,
		telefono,
		extension,
		fecha_cumple,
		id_usuario
		)
	VALUES
		(
		 pr_id_cliente,
		 pr_nombre,
		 pr_puesto,
		 pr_departamento,
		 pr_mail,
		 pr_telefono,
		 pr_extension,
		 pr_fecha_cumple,
		 pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';


END$$
DELIMITER ;
