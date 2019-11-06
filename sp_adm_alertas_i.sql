DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_alertas_i`(
	IN  pr_id_grupo_empresa INT(11),
	IN  pr_id_usuario 		INT(11),
	IN  pr_usuarios 		TEXT,
	IN  pr_notificacion 	VARCHAR(255),
	IN  pr_hipervinculo 	INT(1),
    OUT pr_inserted_id		INT,
    OUT pr_affect_rows	    INT,
	OUT pr_message		    VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_alertas_i
	@fecha:			17/01/2018
	@descripcion:	SP para agregar registros en la tabla adm_alertas
	@autor:			Griselda Medina Medina
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_alertas_i';
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	INSERT INTO st_adm_tr_alertas
    (
		id_grupo_empresa,
		id_usuario,
		usuarios,
		notificacion,
		hipervinculo
	)
    VALUES
    (
		pr_id_grupo_empresa,
		pr_id_usuario,
		pr_usuarios,
		pr_notificacion,
		pr_hipervinculo
	);

	#Devuelve el numero de registros insertados
	SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;

	SET pr_inserted_id 	= @@identity;
	#Devuelve mensaje de ejecucion
	SET pr_message = 'SUCCESS';

	COMMIT;

END$$
DELIMITER ;
