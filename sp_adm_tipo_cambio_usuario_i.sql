DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_tipo_cambio_usuario_i`(
	IN  pr_id_grupo_empresa 	int(11),
	IN  pr_clave_moneda 		varchar(10),
	IN  pr_tipo_cambio 			varchar(45),
	IN  pr_id_usuario 			int(11),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_tipo_cambio_usuario_i
	@fecha:			07/11/2017
	@descripcion:	SP para agregar registros en la tabla st_adm_tc_tipo_cambio_usuario
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_tipo_cambio_usuario_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO st_adm_tc_tipo_cambio_usuario(
		id_grupo_empresa,
		clave_moneda,
		tipo_cambio,
		id_usuario
		)
	VALUES
		(
		pr_id_grupo_empresa,
		pr_clave_moneda,
		pr_tipo_cambio,
		pr_id_usuario
		);

	#Devuelve el numero de registros insertados
	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';
	COMMIT;

END$$
DELIMITER ;
