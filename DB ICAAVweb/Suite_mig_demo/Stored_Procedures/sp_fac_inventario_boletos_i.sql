DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_inventario_boletos_i`(
	IN  pr_id_grupo_empresa		INT,
	IN  pr_id_proveedor			INT,
	IN  pr_id_sucursal			INT,
	IN  pr_consolidado			CHAR(1),
	IN  pr_fecha				DATE,
	IN  pr_bol_inicial			CHAR(15),
	IN  pr_bol_final			CHAR(15),
	IN  pr_descripcion			VARCHAR(80),
	IN  pr_id_usuario			INT,
	OUT pr_inserted_id			INT,
	OUT pr_affect_rows			INT,
	OUT pr_message				VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_inventario_boletos_i
		@fecha:			28/08/2017
		@descripcion:	SP para insertar registro en la tabla de ic_fac_tr_inventario_boletos
		@autor:			Griselda Medina Medina
		@cambios:
	*/
	DECLARE lo_descripcion varchar(100);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_inventario_boletos_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	IF pr_descripcion = 'null'  THEN
		SET lo_descripcion ='';
	ELSE
		SET lo_descripcion=pr_descripcion;
    END IF;

	INSERT INTO ic_fac_tr_inventario_boletos(
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

	SET pr_inserted_id 	= @@identity;
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	SET pr_message = 'SUCCESS';
	COMMIT;
END$$
DELIMITER ;
