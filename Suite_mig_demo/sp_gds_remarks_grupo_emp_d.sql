DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_remarks_grupo_emp_d`(
    IN  pr_id_remarks_grupo_emp	INT(11),
    IN  pr_id_grupo_empresa		INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(5000)
)
BEGIN
/*
	@nombre: 		sp_gds_remarks_grupo_emp_d
	@fecha: 		12/04/2018
	@descripcion: 	Eliminación del catálogo de ic_gds_tr_remarks_grupo_emp
    @autor: 		David Roldan Solares
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
    FROM ic_gds_tr_remarks_grupo_emp
	WHERE id_remarks_grupo_emp = pr_id_remarks_grupo_emp
    AND   id_grupo_empresa     = pr_id_grupo_empresa;

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
