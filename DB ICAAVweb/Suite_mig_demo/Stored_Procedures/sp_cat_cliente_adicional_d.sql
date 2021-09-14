DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_adicional_d`(
	IN  pr_id_cliente_adicional      	INT(11),
    OUT pr_affect_rows      	 		INT,
    OUT pr_message 	         	 		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_cliente_adicional_d
	@fecha: 		25/01/2017
	@descripcion: 	SP para eliminar registros en la tabla cliente_adicional
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

		START TRANSACTION;

		DELETE FROM ic_cat_tr_cliente_adicional
		WHERE id_cliente_adicional = pr_id_cliente_adicional;

	IF code = '00000' THEN
		GET DIAGNOSTICS rows = ROW_COUNT;
		SET pr_message 	   = 'SUCCESS';
		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
        COMMIT;
	ELSE
        SET pr_message = CONCAT('FAILED, ERROR = ',code,', message = ',msg);
        SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
        ROLLBACK;
	END IF;
END$$
DELIMITER ;
