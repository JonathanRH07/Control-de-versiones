DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_vendedor_u`(
	IN  pr_id_grupo_empresa      INT(11),
    IN	pr_id_usuario 			 INT(11),
    IN  pr_id_vendedor			 INT(11),
    IN  pr_nombre			     VARCHAR(90),
    IN  pr_id_sucursal			 INT(11),
    IN  pr_email			  	 VARCHAR (100),
    IN  pr_id_comision           INT(11),
    IN  pr_id_comision_aux		 INT(11),
	IN  pr_estatus	 			 ENUM('ACTIVO', 'INACTIVO'),
	OUT pr_affect_rows      	 INT,
	OUT pr_message 	         	 VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_vendedor_u
	@fecha: 		21/10/2016
	@descripcion: 	SP para actualizar registro de catalogo Vendedores.
	@autor: 		Odeth Negrete
	@cambios:
*/

	DECLARE lo_nombre				VARCHAR(200) DEFAULT '';
    DECLARE lo_id_sucursal 			VARCHAR(200) DEFAULT '';
    DECLARE lo_id_comision			VARCHAR(200) DEFAULT '';
    DECLARE lo_id_comision_aux 		VARCHAR(200) DEFAULT '';
	DECLARE lo_email 				VARCHAR(200) DEFAULT '';
	DECLARE lo_estatus				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'VENDEDORES.MESSAGE_ERROR_UPDATE_VENDEDORES';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	# Actualización de nombre.
	IF pr_nombre != '' THEN
		SET lo_nombre= CONCAT(' nombre =  "', pr_nombre, '",');
	END IF;

		 # Se actualiza id de sucursal.
	IF pr_id_sucursal> 0 THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = "' , pr_id_sucursal,'",');
	END IF;

	  # Se actualiza id de comisión.
	IF pr_id_comision  > 0 THEN
		SET lo_id_comision = CONCAT('id_comision = "' , pr_id_comision,'",');
	END IF;

	  # Se actualiza id de comisión auxiliar.
	IF pr_id_comision_aux > 0 THEN
		SET lo_id_comision_aux = CONCAT('id_comision_aux = "' , pr_id_comision_aux,'",');
	END IF;

	# Actualización del email.
	IF pr_email != '' THEN
		SET lo_email= CONCAT(' email =  "', pr_email, '",');
	END IF;

	IF pr_estatus!= '' THEN
		SET lo_estatus = CONCAT('estatus =  "', pr_estatus, '",');
	END IF;

	# Actualización en la tabla.
	SET @query = CONCAT('
					UPDATE ic_cat_tr_vendedor
					SET ',
						lo_nombre,
						lo_id_sucursal,
						lo_email,
						lo_id_comision,
						lo_id_comision_aux,
						lo_estatus,
						' id_usuario=',pr_id_usuario,
						' , fecha_mod  = sysdate()
					WHERE id_vendedor = ?
					AND
					id_grupo_empresa=',pr_id_grupo_empresa,''
	);
	PREPARE stmt FROM @query;
	SET @id_vendedor = pr_id_vendedor;
	EXECUTE stmt USING @id_vendedor;

	#Devuelve el numero de registros afectados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM DUAL;

    # Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
