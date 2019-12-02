DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_sucursal_u`(
	IN  pr_id_grupo_empresa		INT(11),
	IN	pr_id_usuario			INT(11),
	IN  pr_id_sucursal			INT(11),
	IN  pr_pertenece			INT(11),
	IN  pr_tipo 				ENUM('CORPORATIVO', 'SUCURSAL', 'INPLANT'),
	IN  pr_nombre 		   		VARCHAR(60),
	IN  pr_email          		VARCHAR(100),
	IN  pr_telefono 	   		VARCHAR(25),
	IN  pr_iva_local      		DOUBLE,
	IN  pr_iata_nacional      	VARCHAR(20),
	IN  pr_iata_internacional  	VARCHAR(20),
    IN	pr_id_zona_horaria		INT,
	IN  pr_estatus     	    	ENUM('ACTIVO', 'INACTIVO'),
	OUT pr_affect_rows	        INT,
	OUT pr_message		        VARCHAR(500)
)
BEGIN
		/*
			@nombre:		sp_cat_sucursal_u
			@fecha:			22/12/2016
			@descripcion:	SP para actualizar registro de catalogo Sucursales.
			@autor:			Griselda Medina Medina
			@cambios:
		*/

	# Declaración de variables.
	DECLARE  lo_id_sucursal			VARCHAR(200) DEFAULT '';
	DECLARE  lo_sucursal			VARCHAR(200) DEFAULT '';
	DECLARE  lo_tipo 				VARCHAR(200) DEFAULT '';
	DECLARE  lo_nombre 		   		VARCHAR(200) DEFAULT '';
	DECLARE  lo_email          		VARCHAR(200) DEFAULT '';
	DECLARE  lo_telefono 	   		VARCHAR(200) DEFAULT '';
	DECLARE  lo_iva_local      		VARCHAR(200) DEFAULT '';
	DECLARE  lo_iata_nacional      	VARCHAR(200) DEFAULT '';
	DECLARE  lo_iata_internacional  VARCHAR(200) DEFAULT '';
	DECLARE  lo_matriz				VARCHAR(200) DEFAULT '';
	DECLARE  lo_estatus     	    VARCHAR(200) DEFAULT '';
	DECLARE  lo_id_direccion		VARCHAR(200) DEFAULT '';
	DECLARE  lo_inserted_id 	    VARCHAR(200) DEFAULT '';
	DECLARE  lo_valida_dir 			INT;
	DECLARE  lo_valida_corp 	   	INT;
    DECLARE	 lo_id_zona_horaria		VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'SUCURSAL.MESSAGE_ERROR_UPDATE_SUCURSALES';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END ;

	START TRANSACTION;

	SET lo_sucursal=(select id_sucursal from ic_cat_tr_sucursal where tipo='CORPORATIVO' AND id_grupo_empresa=pr_id_grupo_empresa);

	SELECT f_valida_corp(pr_id_grupo_empresa)
		INTO lo_valida_corp;
	IF (lo_valida_corp > 0 AND pr_tipo='CORPORATIVO' AND pr_id_sucursal!= lo_sucursal ) THEN
		SET pr_message='SUCURSAL.CORPORATE_EXIST';
	ELSEIF pr_tipo='INPLANT' AND pr_pertenece = 0 THEN
		SET pr_message='SUCURSAL.BRANCH_MANDATORY';
	ELSE

	IF pr_id_sucursal > 0 THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = ', pr_id_sucursal,',');
	END IF;

	IF pr_tipo != '' THEN
		SET lo_tipo = CONCAT('tipo = "', pr_tipo,'",');
	END IF;

	IF pr_nombre != ' ' THEN
		SET lo_nombre = CONCAT('nombre= "', pr_nombre,'",');
	END IF;

	IF pr_email != ' ' THEN
		SET lo_email = CONCAT('email = "', pr_email,'",');
	END IF;

	IF pr_telefono != ' ' THEN
		SET lo_telefono = CONCAT('telefono  = "', pr_telefono,'",');
	END IF;

	IF pr_iva_local > -1 THEN
		SET lo_iva_local = CONCAT('iva_local = ', pr_iva_local ,',');
	END IF;

	IF pr_iata_nacional != ' ' THEN
		SET lo_iata_nacional = CONCAT('iata_nacional   = "', pr_iata_nacional,'",');
	END IF;

	IF pr_iata_internacional != ' ' THEN
		SET lo_iata_internacional = CONCAT('iata_internacional = "', pr_iata_internacional,'",');
	END IF;

    IF pr_id_zona_horaria > 0 THEN
		SET lo_id_zona_horaria = CONCAT('id_zona_horaria = ',pr_id_zona_horaria,',');
    END IF;

	CASE
		WHEN pr_tipo = 'CORPORATIVO' THEN
			SET lo_matriz = CONCAT('matriz = "1",');
		WHEN pr_tipo = 'SUCURSAL'    THEN
			SET lo_matriz = CONCAT('matriz = "0",');
		WHEN pr_tipo = 'INPLANT'     THEN
			SET lo_matriz = CONCAT('matriz = "I",');
		ELSE
			SET lo_matriz = '';
	END CASE;

	IF pr_estatus != ' ' THEN
		SET lo_estatus = CONCAT('estatus = "', pr_estatus, '",');
	END IF;

	# Actualiza registros en tabla.
	SET @query = CONCAT('UPDATE ic_cat_tr_sucursal SET '
							,lo_id_sucursal
							,lo_tipo
							,lo_nombre
							,lo_email
							,lo_telefono
							,lo_iva_local
							,lo_iata_nacional
							,lo_iata_internacional
                            ,lo_id_zona_horaria
							,lo_matriz
							,lo_estatus
							,' pertenece = ',pr_pertenece
							,' , id_usuario = ',pr_id_usuario
							,' , fecha_mod = sysdate()
						WHERE
								id_sucursal = ?
							AND id_grupo_empresa=',pr_id_grupo_empresa,''
);
	PREPARE stmt FROM @query;
	SET @id_sucursal = pr_id_sucursal;
	EXECUTE stmt USING @id_sucursal;

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	# Mensaje de ejecución.
	SET pr_message = 'SUCCESS';
	COMMIT;
END IF;
END$$
DELIMITER ;
