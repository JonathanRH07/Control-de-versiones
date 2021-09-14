DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_contacto_d`(
	IN  pr_id_proveedor_contacto    INT(11),
    OUT pr_affect_rows         		INT,
    OUT pr_message              	VARCHAR(500))
BEGIN

	DECLARE code 	CHAR(5) DEFAULT '00000';
	DECLARE msg 	TEXT;
	DECLARE rows 	INT;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
	END;

		DELETE FROM ic_cat_tr_proveedor_contacto
		WHERE id_proveedor_contacto = pr_id_proveedor_contacto;

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
