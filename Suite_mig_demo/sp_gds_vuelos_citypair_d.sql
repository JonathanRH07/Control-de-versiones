DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_vuelos_citypair_d`(
	IN  pr_id_gds_vuelos	      	INT(11),
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_vuelos_citypair_d
	@fecha: 		19/09/2017
	@descripcion: 	SP para eliminar registros en la tabla de gds_vuelos_citypair
    @author: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_vuelos_citypair_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF f_can_remove_row() THEN

		DELETE
		FROM
			ic_gds_tr_vuelos_citypair
		WHERE
			id_gds_vuelos = pr_id_gds_vuelos;

		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		SET pr_message = 'SUCCESS';

        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_gds_vuelos_citypair_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;
END$$
DELIMITER ;
