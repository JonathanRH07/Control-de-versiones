DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_proveedor_aero_d`(
	IN  pr_id_proveedor_aero      	INT(11),
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_cat_proveedor_aero_d
	@fecha: 		23/01/2017
	@descripcion: 	SP para eliminar registros en la tabla proveedor_aero
    @author: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_cat_proveedor_aero_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF f_can_remove_row() THEN

		DELETE
		FROM
			ic_cat_tr_proveedor_aero
		WHERE
			id_proveedor_aero = pr_id_proveedor_aero;

		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		SET pr_message = 'SUCCESS';

        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_cat_proveedor_aero_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;
END$$
DELIMITER ;
