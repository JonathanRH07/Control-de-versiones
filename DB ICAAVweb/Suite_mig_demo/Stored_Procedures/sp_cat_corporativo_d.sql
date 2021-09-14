DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_corporativo_d`(
	IN  pr_id_grupo_empresa      	INT(11),
    IN  pr_id_corporativo      		INT(11),
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(5000))
BEGIN
/*
	@nombre: 		sp_cat_corporativo_d
	@fecha: 		09/09/2016
	@descripcion: 	Eliminación del catálogo de corporativos
    @autor: 		Alan Olivares
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
		ic_cat_tr_corporativo
	WHERE
		id_grupo_empresa = pr_id_grupo_empresa
	AND id_corporativo = pr_id_corporativo;

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
