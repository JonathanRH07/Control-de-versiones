DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_inventario_boletos_i`(
	IN  pr_id_grupo_empresa		INT,
	IN  pr_id_proveedor			INT,
	IN  pr_id_sucursal			INT,
	IN  pr_consolidado			CHAR(1),
	IN  pr_fecha				DATE,
	IN  pr_bol_inicial			CHAR(25),
	IN  pr_bol_final			CHAR(25),
	IN  pr_descripcion			VARCHAR(80),
	IN  pr_id_usuario			INT,
	OUT pr_inserted_id			INT,
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_inventario_boletos_i
	@fecha:			28/08/2017
	@descripcion:	SP para insertar registro en la tabla de ic_glob_tr_inventario_boletos
	@autor:			Griselda Medina Medinas
	@cambios:
*/

	DECLARE lo_descripcion 		VARCHAR(100);
    DECLARE lo_contador			INT(15) DEFAULT 0;
    DECLARE	lo_iterador			INT(15) DEFAULT 0;
    DECLARE lo_cadena			LONGTEXT DEFAULT '';
    DECLARE lo_cadena_res		LONGTEXT DEFAULT '';
    DECLARE lo_last_id			INT;

    DECLARE lo_longitud 		INT;
    DECLARE lo_valida_ceros 	VARCHAR(1);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_inventario_boletos_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_descripcion IS NULL THEN
		SET lo_descripcion ='';
	ELSE
		SET lo_descripcion = pr_descripcion;
    END IF;

    SELECT
		(pr_bol_final - pr_bol_inicial)
	INTO
		lo_contador
	FROM DUAL;

    SELECT
		LENGTH(pr_bol_inicial)
	INTO
		lo_longitud
	FROM DUAL;

    SELECT
		SUBSTRING(pr_bol_inicial,(lo_longitud - 1),'1')
	INTO
		lo_valida_ceros
	FROM DUAL;

	INSERT INTO ic_glob_tr_inventario_boletos(
			id_grupo_empresa,
			id_proveedor,
			id_sucursal,
			consolidado,
			fecha,
			bol_inicial,
			bol_final,
			descripcion,
			id_usuario
		) VALUES (
			pr_id_grupo_empresa,
			pr_id_proveedor,
			pr_id_sucursal,
			pr_consolidado,
			pr_fecha,
			pr_bol_inicial,
			pr_bol_final,
			lo_descripcion,
			pr_id_usuario
	);

    SELECT
		LAST_INSERT_ID()
	INTO
		lo_last_id
	FROM DUAL;


	IF lo_valida_ceros = '0' THEN

		WHILE lo_iterador <= lo_contador DO

			SET lo_cadena = CONCAT(' (',pr_id_grupo_empresa,', ',pr_id_proveedor,', ', lo_last_id,', ',pr_id_sucursal,',NULL ,''INV'',''',LPAD(pr_bol_inicial,lo_longitud,'0'),''', ',pr_id_usuario,',SYSDATE()),');
			SET lo_cadena_res = CONCAT(lo_cadena_res,lo_cadena);
			SET pr_bol_inicial = pr_bol_inicial + 1;
			SET lo_iterador = lo_iterador + 1;

		END WHILE;

    ELSE

        WHILE lo_iterador <= lo_contador DO

			SET lo_cadena = CONCAT(' (',pr_id_grupo_empresa,', ',pr_id_proveedor,', ', lo_last_id,', ',pr_id_sucursal,',NULL ,''INV'',''',LPAD(pr_bol_inicial,15,' '),''', ',pr_id_usuario,',SYSDATE()),');
			SET lo_cadena_res = CONCAT(lo_cadena_res,lo_cadena);
			SET pr_bol_inicial = pr_bol_inicial + 1;
			SET lo_iterador = lo_iterador + 1;

		END WHILE;

    END IF;

    SET lo_cadena_res = (SELECT CONCAT(SUBSTRING(lo_cadena_res, 1, LENGTH(lo_cadena_res)-1),';'));

    SET @query = CONCAT('INSERT INTO ic_glob_tr_boleto ','
						','(
							id_grupo_empresa,
							id_proveedor,
							id_inventario,
							id_sucursal,
							id_factura_detalle,
							origen,
							numero_bol,
							id_usuario,
							fecha_emision
							)','
						','VALUES ',
						lo_cadena_res);

    -- SELECT @query;
    PREPARE stmt FROM @query;
	EXECUTE stmt;

	SET pr_inserted_id 	= lo_last_id;

    SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
    FROM DUAL;

	SET pr_message = 'SUCCESS';
	COMMIT;

END$$
DELIMITER ;
