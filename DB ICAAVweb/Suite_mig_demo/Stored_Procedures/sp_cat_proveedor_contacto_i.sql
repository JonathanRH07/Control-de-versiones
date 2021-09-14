DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_contacto_i`(
	IN	pr_id_proveedor		INT,
	IN	pr_nombre 			VARCHAR(100),
	IN	pr_puesto 			VARCHAR(50),
	IN	pr_departamento		VARCHAR(50),
	IN	pr_email 			VARCHAR(50),
	IN	pr_telefono 		VARCHAR(20),
	IN	pr_extension 		VARCHAR(10),
    IN 	pr_id_usuario		INT,
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_proveedores_i2
		@fecha:			20/12/2016
		@descripcion:	SP para agregar contactos a Proveedores.
		@autor:			Griselda Medina Medina
		@cambios:
	*/

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_contacto_i';
		SET pr_affect_rows = 0;
	END;



	INSERT INTO ic_cat_tr_proveedor_contacto (
		id_proveedor,
		nombre,
		puesto,
		departamento,
		email,
		telefono,
		extension,
        id_usuario
		)
	VALUES
		(
		pr_id_proveedor,
		pr_nombre,
		pr_puesto,
		pr_departamento,
		pr_email,
		pr_telefono,
		pr_extension,
        pr_id_usuario
		);

	SET pr_inserted_id 	= @@identity;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

    #Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
