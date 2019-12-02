DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_hoteles_d`(
	IN  pr_id_gds_hoteles 	INT(11),
    OUT pr_affect_rows 		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre: 		sp_gds_autos_d
		@fecha: 		19/09/2017
		@descripcion: 	SP para eliminar registros en la tabla de gds_autos
		@author: 		Griselda Medina Medina
		@cambios:
	*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_autos_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF f_can_remove_row() THEN
		DELETE FROM ic_gds_tr_hoteles WHERE id_gds_hoteles = pr_id_gds_hoteles;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		SET pr_message = 'SUCCESS';
        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_gds_autos_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;
END$$
DELIMITER ;
