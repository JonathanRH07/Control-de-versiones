DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_envio_fac_u`(
	IN 	pr_id_cliente_envio_fac	INT,
    IN 	pr_id_cliente 			INT,
    IN 	pr_nombre 				VARCHAR(100),
    IN 	pr_mail 				VARCHAR(255),
    IN 	pr_estatus 				ENUM('ACTIVO', 'INACTIVO'),
    IN 	pr_id_usuario 			INT,
    OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_cliente_envio_fac_u
	@fecha:			05/01/2017
	@descripcion:	SP para actualizar registros en Cliente_envio_fac
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE lo_id_cliente 	VARCHAR(200) DEFAULT '';
	DECLARE lo_nombre 		VARCHAR(200) DEFAULT '';
	DECLARE lo_mail 		VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus 		VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_envio_fac_u';
		ROLLBACK;
	END;



	IF pr_id_cliente > 0 THEN
		SET lo_id_cliente = CONCAT('id_cliente = ', pr_id_cliente, ',');
	END IF;

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT('nombre = "', pr_nombre, '",');
	END IF;

    IF pr_mail != '' THEN
		SET lo_mail = CONCAT('mail = "', pr_mail, '",');
	END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;

   SET @query = CONCAT('UPDATE ic_cat_tr_cliente_envio_fac
						SET ',
							lo_id_cliente,
							lo_nombre,
							lo_mail,
							lo_estatus,
							' id_usuario=',pr_id_usuario ,
							' , fecha_mod = sysdate()
						WHERE id_cliente_envio_fac = ?');

	PREPARE stmt FROM @query;

	SET @id_cliente_envio_fac= pr_id_cliente_envio_fac;
	EXECUTE stmt USING @id_cliente_envio_fac;

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
