DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_permiso_role_i`(
	IN 	pr_id_role 			INT(11),
	IN 	pr_id_tipo_permiso 	INT(11),
	IN 	pr_id_submodulo 	INT(11),
    IN  pr_id_usuario		INT(11),
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_permiso_role_i
	@fecha:			17/01/2017
	@descripcion:	SP para agregar registros en la tabla st_adm_tr_permiso_role
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_permiso_role_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO suite_mig_conf.st_adm_tr_permiso_role (
		id_role,
        id_tipo_permiso,
        id_submodulo,
        id_usuario
		)
	VALUES
		(
		pr_id_role,
        pr_id_tipo_permiso,
        pr_id_submodulo,
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