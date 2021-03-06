DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_config_moneda_d`(
	IN  pr_moneda_empresa        INT(11),
    OUT pr_affect_rows      	 INT,
    OUT pr_message 	         	 VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_config_moneda_d
	@fecha: 		14/08/2017
	@descripcion: 	SP para eliminar registros en la tabla de config_monedas
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

		DELETE FROM st_adm_tr_config_moneda
		WHERE id_moneda_empresa = pr_moneda_empresa;

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
