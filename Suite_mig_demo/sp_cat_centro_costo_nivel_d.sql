DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_centro_costo_nivel_d`(
	IN  pr_id_centro_costo_nivel      	INT(11),
    OUT pr_affect_rows      	 		INT,
    OUT pr_message 	         	 		VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_centro_costo_nivel_d
	@fecha: 		04/01/2017
	@descripcion: 	SP para eliminar registros en la tabla centro_costo_nivel
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

		DELETE FROM ic_cat_tr_centro_costo_nivel
		WHERE id_centro_costo_nivel = pr_id_centro_costo_nivel;

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
