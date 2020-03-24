DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_pac_i`(
	IN 	pr_cve_pac 				CHAR(3),
	IN 	pr_nombre 				VARCHAR(45),
	IN 	pr_url_timbrado 		VARCHAR(500),
	IN 	pr_login_timbrado 		VARCHAR(45),
	IN 	pr_password_timbrado 	VARCHAR(45),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_glob_pac_i
	@fecha:			23/01/2017
	@descripcion:	SP para agregar registros en glo_pac
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_pac_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO ct_glob_tc_pac(
		cve_pac,
		nombre,
		url_timbrado,
		login_timbrado,
		password_timbrado
		)
	VALUES
		(
		pr_cve_pac,
		pr_nombre,
		pr_url_timbrado,
		pr_login_timbrado,
		pr_password_timbrado
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
