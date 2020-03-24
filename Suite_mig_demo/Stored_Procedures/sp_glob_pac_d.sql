DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_pac_d`(
	IN  pr_id_pac      			INT(11),
    OUT pr_affect_rows      	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_glob_pac_d
	@fecha: 		23/01/2017
	@descripcion: 	SP para eliminar registros en la tabla glob_pac
    @author: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_pac_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF f_can_remove_row() THEN

		DELETE
		FROM
			ct_glob_tc_pac
		WHERE
			id_pac = pr_id_pac;

		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		SET pr_message = 'SUCCESS';

        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_glob_pac_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;

END$$
DELIMITER ;
