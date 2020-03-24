DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_remarks_cliente_d`(
	IN  pr_id_remarks_cliente	INT,
    IN  pr_id_grupo_empresa		INT,
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(5000)
)
BEGIN
/*
	@nombre: 		sp_gds_remarks_cliente_d
	@fecha: 		09/04/2018
	@descripcion: 	SP para eliminar registros en ic_gds_tr_remarks_cliente
	@autor: 		David roldan Solares
	@cambios:
*/
	DECLARE code 	CHAR(5) DEFAULT '00000';
	DECLARE msg 	TEXT;
	DECLARE rows 	INT;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
        ROLLBACK;
	END;

	START TRANSACTION;

	DELETE FROM
		ic_gds_tr_remarks_cliente
	WHERE id_remarks_cliente = pr_id_remarks_cliente
    AND	  id_grupo_empresa	 = pr_id_grupo_empresa;

	IF code = '00000' THEN
	GET DIAGNOSTICS rows = ROW_COUNT;
		SET pr_message 	   = 'SUCCESS';
		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		COMMIT;
	ELSE
        SET pr_message = CONCAT('FAILED, ERROR = ',code,', message = ',msg);
        SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
	END IF;


END$$
DELIMITER ;
