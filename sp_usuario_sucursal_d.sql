DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_usuario_sucursal_d`(
	IN  pr_id_usuario    	INT(11),
    IN  pr_id_sucursal    	INT(11),
    OUT pr_affect_rows      INT,
    OUT pr_message 	        VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_usuario_d
	@fecha: 		17/01/2017
	@descripcion: 	SP para eliminar registros en la tabla st_adm_tr_usuario
    @author: 		Griselda Medina Medina
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

	DELETE
		FROM
			st_adm_tr_usuario_sucursal
		WHERE
			 id_usuario	= pr_id_usuario AND id_sucursal =pr_id_sucursal;

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
