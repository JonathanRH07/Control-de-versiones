DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_fac_factura_detalle_imp_d`(
	IN  pr_id_factura_detalle_imp    	INT(11),
	OUT pr_affect_rows      	 		INT,
	OUT pr_message 	         	 		VARCHAR(500))
BEGIN
	/*
		@nombre 	: sp_fac_factura_detalle_imp_d
		@fecha 		: 13/03/2017
		@descripcion: SP para eliminar registros en la tabla de factura_detalle_imp
		@author 	: Griselda Medina Medina
		@cambios 	:
	*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_fac_factura_detalle_imp_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF f_can_remove_row() THEN

		DELETE FROM
			ic_fac_tr_factura_detalle_imp
		WHERE
			id_factura_detalle_imp = pr_id_factura_detalle_imp;

		SELECT
			ROW_COUNT()
            INTO pr_affect_rows
		FROM dual;
		SET pr_message = 'SUCCESS';
        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_fac_factura_detalle_imp_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;
END$$
DELIMITER ;
