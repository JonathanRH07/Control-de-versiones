DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_usuario_d`(
	IN  pr_id_grupo_empresa 	INT(11),
    IN  pr_id_usuario    		INT(11),
    OUT pr_affect_rows      	INT,
    OUT pr_message 	        	VARCHAR(500))
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

	/*
	DELETE FROM st_adm_tr_usuario
	WHERE id_usuario = pr_id_usuario
    AND id_grupo_empresa = pr_id_grupo_empresa;
	*/

    SELECT inicio_sesion into @inicio_sesion FROM
			suite_mig_conf.st_adm_tr_usuario
            where id_usuario = pr_id_usuario;

	IF @inicio_sesion = 1 THEN
		SET pr_message = 'USERS.MESSAGE_ERROR_LOGGUED_USERS';
        SET pr_affect_rows = 0;
	ELSE

		UPDATE suite_mig_conf.st_adm_tr_usuario
		SET estatus_usuario = 3
		WHERE id_usuario = pr_id_usuario
		AND id_grupo_empresa = pr_id_grupo_empresa;

		IF code = '00000' THEN
			GET DIAGNOSTICS rows = ROW_COUNT;
			SET pr_message 	   = 'SUCCESS';
			SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		ELSE
			SET pr_message = CONCAT('FAILED, ERROR = ',code,', message = ',msg);
			SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		END IF;
	END IF;
END$$
DELIMITER ;
