DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_contacto_u`(
	IN	pr_id_proveedor_contacto	INT(11),
    IN 	pr_id_proveedor				INT(11),
    IN 	pr_nombre					VARCHAR(100),
    IN 	pr_puesto					VARCHAR(50),
    IN 	pr_departamento 			VARCHAR(50),
    IN 	pr_email					VARCHAR(50),
    IN 	pr_telefono 				VARCHAR(20),
    IN 	pr_extension 				VARCHAR(10),
    IN 	pr_id_usuario				INT,
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_proveedor_contacto_u
		@fecha:			27/12/2016
		@descripcion:	SP para actualizar registro en Proveedor Contacto
		@autor:			Griselda Medina Medina
		@cambios:
	*/

	#Declaracion de variables.
	DECLARE		lo_id_proveedor			VARCHAR(200) DEFAULT '';
    DECLARE 	lo_nombre				VARCHAR(200) DEFAULT '';
    DECLARE 	lo_puesto				VARCHAR(200) DEFAULT '';
    DECLARE 	lo_departamento 		VARCHAR(200) DEFAULT '';
    DECLARE 	lo_email				VARCHAR(200) DEFAULT '';
    DECLARE 	lo_telefono 			VARCHAR(200) DEFAULT '';
    DECLARE 	lo_extension 			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_contacto_u';
	END;


	# Actualización el estatus.
	IF pr_id_proveedor > 0 THEN
		SET lo_id_proveedor = CONCAT('id_proveedor = ', pr_id_proveedor, ',');
	END IF;

    IF pr_nombre  != '' THEN
		SET lo_nombre = CONCAT('nombre = "', pr_nombre, '",');
	END IF;

	IF pr_puesto != '' THEN
		SET lo_puesto = CONCAT('puesto = "', pr_puesto, '",');
	END IF;

	IF pr_departamento  != '' THEN
		SET lo_departamento = CONCAT('departamento = "', pr_departamento, '",');
	END IF;

	IF pr_email != '' THEN
		SET lo_email = CONCAT('email = "', pr_email, '",');
	END IF;

	IF pr_telefono  != '' THEN
		SET lo_telefono = CONCAT('telefono = "', pr_telefono, '",');
	END IF;

	IF pr_extension != '' THEN
		SET lo_extension = CONCAT('extension = "', pr_extension, '",');
	END IF;

	SET @query = CONCAT('
					UPDATE ic_cat_tr_proveedor_contacto
					SET ',
						lo_id_proveedor,
						lo_nombre,
						lo_puesto,
						lo_departamento,
						lo_email,
						lo_telefono,
						lo_extension,
						' id_usuario=',pr_id_usuario ,
						' , fecha_mod = sysdate()
					WHERE id_proveedor_contacto = ?'
	);
	PREPARE stmt FROM @query;
	SET @id_proveedor_contacto= pr_id_proveedor_contacto;
	EXECUTE stmt USING @id_proveedor_contacto;


	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual; 	#Devuelve el numero de registros insertados
	SET pr_message = 'SUCCESS'; 	# Mensaje de ejecucion.
END$$
DELIMITER ;
