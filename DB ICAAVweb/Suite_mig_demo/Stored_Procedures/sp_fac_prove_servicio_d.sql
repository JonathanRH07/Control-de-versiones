DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_prove_servicio_d`(
	IN  pr_id_prove_servicio			INT,
	OUT pr_affected_rows				INT,
	OUT pr_message						VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_fac_prove_servicio_d
		@fecha:			16/03/2017
		@descripcion:	SP para eliminar registro de Proveedor-Servicio
		@autor:			Griselda Medina Medina
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

		DELETE FROM ic_fac_tr_prove_servicio
        WHERE id_prove_servicio = pr_id_prove_servicio ;

	IF code = '00000' THEN
		GET DIAGNOSTICS rows = ROW_COUNT;
		SET pr_message 	   = 'SUCCESS';
		SELECT ROW_COUNT() INTO pr_affected_rows FROM dual;
	ELSE
        SET pr_message = CONCAT('FAILED, ERROR = ',code,', message = ',msg);
        SELECT ROW_COUNT() INTO pr_affected_rows FROM dual;
	END IF;
END$$
DELIMITER ;
