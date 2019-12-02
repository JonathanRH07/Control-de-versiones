DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_d`(
	IN  pr_id_grupo_empresa     INT(11),
    IN  pr_id_cliente      		INT(11),
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_fac_clientes_d
		@fecha: 		03/01/2017
		@descripcion: 	SP para eliminar registros en la tabla de clientes.
		@autor: 		Griselda Medina Medina.
		@cambios:
	*/

	DECLARE lo_direccion 	INT;
    DECLARE code 			CHAR(5) DEFAULT '00000';
	DECLARE msg 			TEXT;
	DECLARE rows 			INT;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
	END;


	SELECT
		id_direccion
	INTO
		lo_direccion
	FROM ic_cat_tr_cliente
    WHERE id_cliente = pr_id_cliente;

	DELETE FROM ct_glob_tc_direccion
    WHERE id_direccion = lo_direccion;


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
