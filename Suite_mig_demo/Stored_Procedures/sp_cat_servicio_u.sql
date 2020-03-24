DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_servicio_u`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_usuario			INT(11),
	IN  pr_id_servicio	    	INT(11),
	IN  pr_id_producto			INT(11),
    IN  pr_id_unidad_medida		INT,
	IN  pr_c_ClaveProdServ		CHAR(10),
	IN  pr_alcance				ENUM('NACIONAL','INTERNACIONAL'),
	IN  pr_descripcion			VARCHAR(150),
	IN  pr_valida_adicis		ENUM('SI','NO'),
	IN  pr_estatus			    ENUM('ACTIVO', 'INACTIVO'),
	OUT pr_affect_rows      	INT,
	OUT pr_message 	        	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_cat_servicio_u
		@fecha:			28/11/2016
		@descripcion: 	SP para actualizar registros de catalogo Servicios.
		@autor: 		Griselda Medina Medina
		@cambios:
	*/

    DECLARE 	lo_id_producto			VARCHAR(100) DEFAULT '';
    DECLARE 	lo_id_unidad_medida		VARCHAR(100) DEFAULT '';
	DECLARE 	lo_c_ClaveProdServ		VARCHAR(100) DEFAULT '';
    DECLARE 	lo_alcance				VARCHAR(100) DEFAULT '';
    DECLARE 	lo_descripcion			VARCHAR(150) DEFAULT '';
    DECLARE 	lo_valida_adicis		VARCHAR(100) DEFAULT '';
	DECLARE  	lo_estatus			    VARCHAR(100) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'SERVICIOS.MESSAGE_SUCCESS_UPDATE_SERVICIOS';
        SET pr_affect_rows = 0;
	END;


	IF pr_id_producto > 0 THEN
		SET lo_id_producto = CONCAT('id_producto  = "', pr_id_producto , '",');
	END IF;

    IF pr_id_unidad_medida > 0 THEN
		SET lo_id_unidad_medida = CONCAT('id_unidad_medida  = ', pr_id_unidad_medida , ',');
	END IF;

    IF pr_c_ClaveProdServ > 0 THEN
		SET lo_c_ClaveProdServ = CONCAT('c_ClaveProdServ  = "', pr_c_ClaveProdServ , '",');
	END IF;

	IF pr_alcance != '' THEN
		SET lo_alcance = CONCAT('alcance = "', pr_alcance, '",');
	END IF;

	IF pr_descripcion != '' THEN
		SET lo_descripcion= CONCAT('descripcion = "', pr_descripcion, '",');
	END IF;

	IF pr_valida_adicis != '' THEN
		SET lo_valida_adicis = CONCAT('valida_adicis = "', pr_valida_adicis, '",');
	END IF;

	IF pr_estatus != '' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;


	# Actialización en tabla.
	SET @query = CONCAT('UPDATE ic_cat_tc_servicio
							SET ',
							lo_id_producto,
                            lo_id_unidad_medida,
							lo_c_ClaveProdServ,
							lo_alcance,
							lo_descripcion,
							lo_valida_adicis,
							lo_estatus,
							' id_usuario = ',pr_id_usuario,
							' , fecha_mod = sysdate()
						WHERE
							    id_servicio = ?
							AND id_grupo_empresa = ',pr_id_grupo_empresa,''
	);
	PREPARE stmt FROM @query;
    SET @id_servicio = pr_id_servicio;
    EXECUTE stmt USING @id_servicio;

	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM DUAL;

	SET pr_message = 'SUCCESS'; # Mensaje de ejecución.
END$$
DELIMITER ;
