DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_notificaciones_d`(
	IN  pr_id_usuario			INT,
	IN  pr_id_notificacion    	INT(11),
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_mensajes_usuarios_d
	@fecha: 		05/08/2019
	@descripcion: 	SP para eliminar registros en la tabla de st_adm_tr_alertas_usuarios
    @author: 		Yazbek Quido
	@cambios:
*/
	DECLARE code 	CHAR(5) DEFAULT '00000';
	DECLARE msg 	TEXT;
	DECLARE rows 	INT;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
	END;

    IF pr_id_notificacion > 0 THEN

		DELETE FROM st_adm_tr_notificaciones
		WHERE id_notificacion = pr_id_notificacion;
	ELSE
		DELETE FROM st_adm_tr_notificaciones
		WHERE id_usuario = pr_id_usuario;
    END IF;

	IF code = '00000' THEN
	GET DIAGNOSTICS rows = ROW_COUNT;
		SET pr_message 	   = 'SUCCESS';
		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	ELSE
        SET pr_message = CONCAT('FAILED, ERROR = ',code,', message = ',msg);
        SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	END IF;
END$$
DELIMITER ;
