DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_alertas_d`(
	IN  pr_id_alertas     		INT(11),
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_alertas_d
	@fecha: 		17/01/2018
	@descripcion: 	SP para eliminar registros en la tabla adm_alertas
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
		SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

	DELETE FROM st_adm_tr_alertas
	WHERE id_alertas = pr_id_alertas;

    IF code = '00000' THEN
		GET DIAGNOSTICS rows = ROW_COUNT;
        SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		SET pr_message 	   = 'SUCCESS';
		COMMIT;
	ELSE
        SET pr_message = CONCAT('FAILED, ERROR = ',code,', message = ',msg);
        SET pr_affect_rows = 0;
        ROLLBACK;
	END IF;
END$$
DELIMITER ;
