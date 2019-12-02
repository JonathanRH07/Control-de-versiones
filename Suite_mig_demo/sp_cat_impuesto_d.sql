DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_impuesto_d`(
	IN  pr_id_grupo_empresa			INT(11),
	IN  pr_id_impuesto				INT(11),
	OUT pr_affect_rows				INT,
	OUT pr_message 				 	VARCHAR(5000))
BEGIN
	/*
		@nombre: 		sp_cat_impuesto_d
		@fecha: 		28/10/2017
		@descripcion: 	Eliminación de registros del catálogo de impuestos.
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
		ic_cat_tr_impuesto
	WHERE
		id_impuesto = pr_id_impuesto
	AND id_grupo_empresa = pr_id_grupo_empresa
	;


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
