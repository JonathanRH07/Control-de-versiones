DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_notificaciones_i`(
	IN 	pr_id_grupo_empresa 	INT,
	IN 	pr_id_usuario 			INT,
    IN 	pr_id_tipo_notificacion INT,
    IN  pr_titulo				VARCHAR(255),
    IN  pr_adicional			VARCHAR(255),
    OUT pr_inserted_id			INT,
    OUT pr_affect_rows	    	INT,
	OUT pr_message		    	VARCHAR(500))
BEGIN
/*
	@nombre:		sp_adm_notificaciones_i
	@fecha:			13/10/2019
	@descripcion:	SP para agregar registros en la tabla st_adm_tr_notificaciones
	@autor:			Yazbek Quido
	@cambios:
*/
	DECLARE lo_inserted_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'NOTIFICATIONS.MESSAGE_ERROR_CREATE_NOTIFICATION';
		SET pr_affect_rows = 0;
        ROLLBACK;
	END;

		START TRANSACTION;

		INSERT INTO st_adm_tr_notificaciones (
			id_grupo_empresa,
			id_usuario,
            id_tipo_notificacion,
            titulo,
			adicional
			)
		VALUES
			(
			pr_id_grupo_empresa,
			pr_id_usuario,
			pr_id_tipo_notificacion,
            pr_titulo,
            pr_adicional
			);

		SET lo_inserted_id 	= @@identity;

		SET pr_inserted_id 	= lo_inserted_id;

		SELECT COUNT(*) INTO pr_affect_rows FROM st_adm_tr_notificaciones where id_notificacion=pr_inserted_id;
		#Devuelve mensaje de ejecucion
		SET pr_message = 'SUCCESS';
		COMMIT;
END$$
DELIMITER ;
