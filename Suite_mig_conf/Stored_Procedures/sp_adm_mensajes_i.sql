DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_mensajes_i`(
	IN 	pr_id_grupo_empresa 	INT,
	IN 	pr_id_usuario 			INT,
    IN  pr_mensaje				VARCHAR(255),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_mensajes_i
	@fecha:			25/07/2019
	@descripcion:	SP para agregar registros en la tabla st_adm_tr_alertas
	@autor:			Yazbek Quido
	@cambios:
*/
	DECLARE lo_inserted_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'MESSAGES.MESSAGE_ERROR_CREATE_MESSAGE';
		SET pr_affect_rows = 0;
	END;

		INSERT INTO st_adm_tr_alertas (
			id_grupo_empresa,
			id_usuario,
			notificacion
			)
		VALUES
			(
			pr_id_grupo_empresa,
			pr_id_usuario,
			pr_mensaje
			);

		SET lo_inserted_id 	= @@identity;

		SET pr_inserted_id 	= lo_inserted_id;

		SELECT COUNT(*) INTO pr_affect_rows FROM st_adm_tr_alertas where id_alertas=pr_inserted_id;
		#Devuelve mensaje de ejecucion
		SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
