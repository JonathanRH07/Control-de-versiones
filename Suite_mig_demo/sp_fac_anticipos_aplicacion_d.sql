DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_anticipos_aplicacion_d`(
    IN  pr_id_anticipos_aplicacion		INT(11),
    OUT pr_affect_rows      	 		INT,
    OUT pr_message 	         	 		VARCHAR(500))
BEGIN
/*
	@nombre:		sp_fac_anticipos_aplicacion_d
	@fecha:			23/03/2018
	@descripcion:	SP para eliminar registro en la tabla ic_fac_tr_anticipos_aplicacion
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


	DELETE
    FROM
		ic_fac_tr_anticipos_aplicacion
	WHERE
		id_anticipos_aplicacion = pr_id_anticipos_aplicacion;


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
