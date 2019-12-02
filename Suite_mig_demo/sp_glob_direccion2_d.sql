DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_direccion2_d`(
	IN  pr_id_direccion      	INT(11))
BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK;
	END;
	START TRANSACTION;

	IF f_can_remove_row() THEN

		DELETE FROM ct_glob_tc_direccion WHERE
        id_direccion = pr_id_direccion;

        COMMIT;

    ELSE
        # Mensaje de error.
		ROLLBACK;
    END IF;


END$$
DELIMITER ;
