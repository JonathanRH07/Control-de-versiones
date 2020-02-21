DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_grupo_fit_d`(
	IN  pr_id_grupo_empresa			INT(11),
    IN  pr_id_grupo_fit      		INT(11),
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_grupo_fit_d
	@fecha: 		14/09/2016
	@descripcion: 	Eliminación del catálogo de grupos F.I.T.
    @author: 		Alan Olivares
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
		ic_fac_tc_grupo_fit
	WHERE
		id_grupo_fit = pr_id_grupo_fit
	AND id_grupo_empresa = pr_id_grupo_empresa;


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
