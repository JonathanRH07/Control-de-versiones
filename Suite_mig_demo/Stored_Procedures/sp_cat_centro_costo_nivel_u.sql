DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_centro_costo_nivel_u`(
	IN  pr_id_centro_costo_nivel	INT(11),
	IN  pr_id_cliente 				INT(11),
	IN  pr_nivel 					SMALLINT(6),
	IN  pr_descripcion 				VARCHAR(30),
	IN  pr_estatus 					ENUM('ACTIVO','INACTIVO'),
	IN  pr_id_usuario 				INT(11),
    OUT pr_affect_rows	        	INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_centro_costo_nivel_u
	@fecha:			17/03/2017
	@descripcion:	SP para actualizar registro en centro_costo_nivel
	@autor:			Griselda Medina Medina
	@cambios:
*/
	#Declaracion de variables.
	DECLARE	lo_id_cliente		VARCHAR(200) DEFAULT '';
	DECLARE	lo_nivel			VARCHAR(200) DEFAULT '';
	DECLARE	lo_descripcion 		VARCHAR(200) DEFAULT '';
	DECLARE	lo_estatus			VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_centro_costo_nivel_u';
		ROLLBACK;
	END;



	IF pr_id_cliente > 0 THEN
		SET lo_id_cliente = CONCAT('id_cliente = ', pr_id_cliente, ',');
	END IF;

    IF pr_nivel > 0 THEN
		SET lo_nivel = CONCAT('nivel = ', pr_nivel, ',');
	END IF;

	IF pr_descripcion != '' THEN
		SET lo_descripcion = CONCAT('descripcion = "', pr_descripcion, '",');
	END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT(' estatus= "', pr_estatus, '",');
	END IF;

	SET @query = CONCAT('UPDATE ic_cat_tr_centro_costo_nivel
						SET ',
							lo_id_cliente,
							lo_nivel,
							lo_descripcion,
							lo_estatus,
							' id_usuario=',pr_id_usuario ,
							' , fecha_mod = sysdate()
						WHERE id_centro_costo_nivel = ?');

	PREPARE stmt FROM @query;

	SET @id_centro_costo_nivel= pr_id_centro_costo_nivel;
	EXECUTE stmt USING @id_centro_costo_nivel;

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
