DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cupon_d`(
	IN  pr_id_gds_cupon 	INT(11),
    OUT pr_affect_rows 		INT,
    OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre:		sp_gds_cupon_d
		@fecha:			26/09/2017
		@descripcion:	SP para eliminar registros en la tabla de gds_cupon
		@autor: 		Shani Glez
		@cambios:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_cupon_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF f_can_remove_row() THEN
		DELETE FROM ic_gds_tr_cupon WHERE id_gds_cupon = pr_id_gds_cupon;

		SELECT ROW_COUNT() INTO pr_affect_rows FROM dual;
		SET pr_message = 'SUCCESS';
        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_gds_cupon_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;
END$$
DELIMITER ;
