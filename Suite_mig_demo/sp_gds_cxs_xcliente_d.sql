DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cxs_xcliente_d`(
	IN  pr_id_cxs_xcliente     	INT(11),
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_gds_cxs_xcliente_b
	@fecha: 		05/04/2018
	@descripcion: 	Sirve para eliminar registros en la tabla ic_gds_tr_cxs_xcliente
    @autor: 		Griselda Medina Medina
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


	DELETE FROM
		ic_gds_tr_cxs_xcliente
	WHERE
	id_cxs_xcliente = pr_id_cxs_xcliente;

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
