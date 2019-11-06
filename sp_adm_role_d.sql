DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_role_d`(
	IN  pr_id_role     		INT(11),
    OUT pr_affect_rows      INT,
    OUT pr_message 	        VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_role_d
	@fecha: 		17/01/2017
	@descripcion: 	SP para eliminar registros en la tabla st_adm_tc_role
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
			st_adm_tc_role
		WHERE
			 id_role	= pr_id_role;

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
