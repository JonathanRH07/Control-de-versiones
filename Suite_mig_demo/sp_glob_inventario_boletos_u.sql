DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_inventario_boletos_u`(
	IN  pr_id_grupo_empresa			INT,
    IN  pr_id_inventario_boletos	INT,
	IN  pr_id_proveedor				INT,
	IN  pr_id_sucursal				INT,
	IN  pr_consolidado				CHAR(1),
	IN  pr_fecha					DATE,
	IN  pr_bol_inicial				CHAR(15),
	IN  pr_bol_final				CHAR(15),
	IN  pr_descripcion				VARCHAR(80),
	IN  pr_estatus    				ENUM('ACTIVO', 'INACTIVO'),
	IN  pr_id_usuario				INT,
	OUT pr_affect_rows      		INT,
	OUT pr_message		        	VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_glob_inventario_boletos_u
		@fecha:			28/08/2017
		@descripcion:	SP para actualizar registros en la tabla de ic_fac_tr_inventario_boletos
		@autor:			Griselda Medina Medina
		@cambios:
	*/

    # Declaración de variables.
    DECLARE lo_id_sucursal  	VARCHAR(200) DEFAULT '';
    DECLARE lo_consolidado  	VARCHAR(200) DEFAULT '';
    DECLARE lo_fecha  			VARCHAR(200) DEFAULT '';
    DECLARE lo_bol_inicial  	VARCHAR(200) DEFAULT '';
    DECLARE lo_bol_final  		VARCHAR(200) DEFAULT '';
    DECLARE lo_descripcion  	VARCHAR(200) DEFAULT '';
    DECLARE lo_id_proveedor  	VARCHAR(200) DEFAULT '';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_inventario_boletos_u';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

    START TRANSACTION;


    IF pr_id_sucursal > 0 THEN
		SET lo_id_sucursal = CONCAT('id_sucursal = "', pr_id_sucursal,'",');
	ELSE
		IF pr_consolidado  != '' and pr_consolidado = 'C' THEN
			SET lo_id_sucursal = CONCAT('id_sucursal = 0,');
		END IF;
    END IF;

	IF pr_consolidado  != '' THEN
		SET lo_consolidado = CONCAT('consolidado = "', pr_consolidado,'",');
	END IF;

    IF pr_fecha != '0000-00-00' THEN
		SET lo_fecha = CONCAT('fecha = "', pr_fecha,'",');
	END IF;

    IF pr_bol_inicial  != '' THEN
		SET lo_bol_inicial = CONCAT('bol_inicial = "', pr_bol_inicial,'",');
	END IF;

    IF pr_bol_final  != '' THEN
		SET lo_bol_final = CONCAT('bol_final = "', pr_bol_final,'",');
	END IF;

    IF pr_descripcion  != '' THEN
		SET lo_descripcion = CONCAT('descripcion = "', pr_descripcion,'",');
	END IF;

    IF pr_id_proveedor  != '' THEN
		SET lo_id_proveedor = CONCAT('id_proveedor = "', pr_id_proveedor,'",');
	END IF;

    SET @query = CONCAT('
			UPDATE  ic_glob_tr_inventario_boletos
				SET '
					,lo_id_sucursal
					,lo_consolidado
					,lo_fecha
					,lo_bol_inicial
					,lo_bol_final
					,lo_descripcion
                    ,lo_id_proveedor
					,' id_usuario=',pr_id_usuario
					,' , estatus = "',pr_estatus,'"'
					,' , fecha_mod  = sysdate()
			WHERE id_inventario_boletos = ? AND id_grupo_empresa=',pr_id_grupo_empresa,''
	);

	PREPARE stmt FROM @query;
	SET @id_inventario_boletos = pr_id_inventario_boletos;
	EXECUTE stmt USING @id_inventario_boletos;
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';

    IF pr_affect_rows = 0 THEN
		ROLLBACK;
	ELSE
		COMMIT;

	END IF;
END$$
DELIMITER ;
