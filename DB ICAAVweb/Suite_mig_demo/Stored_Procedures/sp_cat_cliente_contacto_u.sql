DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_contacto_u`(
	IN	pr_id_cliente_contacto	INT(11),
    IN	pr_id_cliente			INT,
	IN	pr_nombre 				VARCHAR(100),
	IN	pr_puesto 				VARCHAR(50),
	IN	pr_departamento			VARCHAR(50),
	IN	pr_mail 				VARCHAR(50),
	IN	pr_telefono 			VARCHAR(20),
	IN	pr_extension 			VARCHAR(6),
    IN 	pr_fecha_cumple			DATE,
    IN 	pr_estatus 				ENUM('ACTIVO', 'INACTIVO'),
    IN 	pr_id_usuario			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_contacto_u
	@fecha:			04/01/2017
	@descripcion:	SP para actualizar registro en Clientes Contacto
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE	lo_id_cliente		VARCHAR(200) DEFAULT '';
	DECLARE	lo_nombre 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_puesto 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_departamento		VARCHAR(200) DEFAULT '';
	DECLARE	lo_mail 			VARCHAR(200) DEFAULT '';
	DECLARE	lo_telefono 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_extension 		VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha_cumple		VARCHAR(200) DEFAULT '';
    DECLARE lo_estatus 			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_contacto_u';
		ROLLBACK;
	END;


	IF pr_id_cliente > 0 THEN
		SET lo_id_cliente = CONCAT('id_cliente = ', pr_id_cliente, ',');
	END IF;

	IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT('nombre = "', pr_nombre, '",');
	END IF;

    IF pr_puesto  != '' THEN
		SET lo_puesto = CONCAT('puesto = "', pr_puesto, '",');
	END IF;

	IF pr_departamento != '' THEN
		SET lo_departamento = CONCAT('departamento = "', pr_departamento, '",');
	END IF;

	IF pr_mail  != '' THEN
		SET lo_mail = CONCAT('mail = "', pr_mail, '",');
	END IF;

	IF pr_telefono != '' THEN
		SET lo_telefono = CONCAT('telefono = "', pr_telefono, '",');
	END IF;

	IF pr_extension  != '' THEN
		SET lo_extension = CONCAT('extension = "', pr_extension, '",');
	END IF;

	SET lo_fecha_cumple = CONCAT('fecha_cumple = "', pr_fecha_cumple, '",');

    IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;

	SET @query = CONCAT('UPDATE ic_cat_tr_cliente_contacto
							SET ',
								lo_id_cliente,
								lo_nombre,
								lo_puesto,
								lo_departamento,
								lo_mail,
								lo_telefono,
								lo_extension,
								lo_fecha_cumple,
								lo_estatus,
                                ' id_usuario=',pr_id_usuario ,
								' , fecha_mod = sysdate()
							WHERE id_cliente_contacto = ?');

	PREPARE stmt FROM @query;

	SET @id_cliente_contacto= pr_id_cliente_contacto;
	EXECUTE stmt USING @id_cliente_contacto;

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	# Mensaje de ejecucion.
	SET pr_message = 'SUCCESS';


END$$
DELIMITER ;
