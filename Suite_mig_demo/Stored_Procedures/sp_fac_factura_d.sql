DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_d`(
	IN  pr_id_factura 		INT(11),
	OUT pr_affect_rows 		INT,
	OUT pr_message 			VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_factura_d
		@fecha 		: 08/03/2017
		@descripcion: SP para eliminar registros en la tabla de facturas
		@author 	: Griselda Medina Medina
		@cambios 	:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF f_can_remove_row() THEN

		DELETE FROM ic_fac_tr_factura
        WHERE id_factura = pr_id_factura;

		SELECT
			ROW_COUNT()
        INTO pr_affect_rows
        FROM dual;

		SET pr_message = 'SUCCESS';
        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_fac_factura_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;
END$$
DELIMITER ;
