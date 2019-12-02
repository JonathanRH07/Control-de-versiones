DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_cliente_contable_d`(
	IN  pr_id_cliente_contable      INT(11),
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_cliente_contable_d
	@fecha: 		04/01/2017
	@descripcion: 	SP para eliminar registros en la tabla cliente_contable
	@author: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_cliente_contable_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF f_can_remove_row() THEN

		DELETE
		FROM
			ic_cat_tr_cliente_contable
		WHERE
			id_cliente_contable = pr_id_cliente_contable
		;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		SET pr_message = 'SUCCESS';
        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_cat_cliente_contable_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;

END$$
DELIMITER ;
