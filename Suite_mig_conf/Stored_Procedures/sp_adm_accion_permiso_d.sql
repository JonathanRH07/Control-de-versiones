DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_accion_permiso_d`(
	IN  pr_id_accion_permiso    INT(11),
    OUT pr_affect_rows        	INT,
    OUT pr_message             	VARCHAR(500))
BEGIN
 /*
	@nombre:   sp_admin_accion_permiso_d
	@fecha:   17/01/2017
	@descripcion:  SP para eliminar registros en la tabla st_adm_tc_accion_permiso
	@author:   Griselda Medina Medina
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

	DELETE FROM st_adm_tc_accion_permiso
	WHERE id_accion_permiso = pr_id_accion_permiso;

    IF code = '00000' THEN
		GET DIAGNOSTICS rows = ROW_COUNT;
		SET pr_message 	   = 'SUCCESS';
		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		COMMIT;
	ELSE
        SET pr_message = CONCAT('FAILED, ERROR = ',code,', message = ',msg);
        SET pr_affect_rows = 0;
        ROLLBACK;
	END IF;

END$$
DELIMITER ;
