DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_permiso_role_r`(
	IN  pr_id_role     		INT(11),
    OUT pr_affect_rows      INT,
    OUT pr_message 	        VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_permiso_role_r
	@fecha: 		17/01/2017
	@descripcion: 	SP para eliminar registros en la tabla st_adm_tr_permiso_role
    @author: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_permiso_role_r';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF suite_mig_demo.f_can_remove_row() THEN

		DELETE
		FROM
			st_adm_tr_permiso_role
		WHERE
			 id_role = pr_id_role;

		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		SET pr_message = 'SUCCESS';

        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_adm_permiso_role_r';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;
END$$
DELIMITER ;
