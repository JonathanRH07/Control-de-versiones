DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_session_d`(
	IN  pr_id_usuario	     		INT(11),
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_adm_usuario_session_d
	@fecha: 		28/12/2020
	@descripcion: 	SP para eliminar los registros de la tabla st_adm_tr_usuario_sesion
	@autor: 		Yazbek Kido
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

	DELETE FROM st_adm_tr_usuario_sesion
	WHERE id_usuario = pr_id_usuario;

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
