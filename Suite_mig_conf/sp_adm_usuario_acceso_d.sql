DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_acceso_d`(
	IN  pr_id_usuario_acceso	     	INT(11),
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_adm_usuario_acceso_d
	@fecha: 		02/12/2019
	@descripcion: 	Sirve para eliminar registros en la tabla de st_adm_tr_usuario_acceso
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

	DELETE FROM st_adm_tr_usuario_acceso
	WHERE id_usuario_acceso = pr_id_usuario_acceso;

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
