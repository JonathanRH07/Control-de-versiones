DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `sp_adm_empresa_usuario_d`(
	IN pr_id_empresa			INT,
    IN pr_id_usuario			INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	        	VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_adm_empresa_usuario_d
	@fecha: 		31/01/2019
	@descripcion: 	SP para eliminar registros en la tabla st_adm_tr_empresa_usuario
    @author: 		Jonathan Ramirez
	@cambios:
*/

    DECLARE code 				CHAR(5) DEFAULT '00000';
	DECLARE msg 				TEXT;
	DECLARE rows 				INT;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
	END;

        DELETE FROM st_adm_tr_empresa_usuario
		WHERE id_empresa = pr_id_empresa
		AND id_usuario = pr_id_usuario;

	IF code = '00000' THEN
	GET DIAGNOSTICS rows = ROW_COUNT;
		SET pr_message 	   = 'SUCCESS';
		SELECT ROW_COUNT() INTO pr_affect_rows FROM DUAL;
	ELSE
        SET pr_message = CONCAT('FAILED, ERROR = ',code,', message = ',msg);
        SELECT ROW_COUNT() INTO pr_affect_rows FROM DUAL;
	END IF;

END$$
DELIMITER ;
