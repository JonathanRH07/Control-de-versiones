DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_forma_pago_d`(
	IN  pr_id_grupo_empresa         INT,
    IN  pr_id_forma_pago 			INT,
    OUT pr_affect_rows		        INT,
   	OUT pr_message		            VARCHAR(5000))
BEGIN
	/*
		@nombre 	: sp_cat_forma_pago_d
		@fecha 		: 19/09/2016
		@descripcion: SP para eliminar un método de pago
		@autor 		: Alan Olivares
		@cambios 	:
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
		ic_glob_tr_forma_pago
	WHERE
		id_grupo_empresa = pr_id_grupo_empresa
	AND id_forma_pago = pr_id_forma_pago;


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
