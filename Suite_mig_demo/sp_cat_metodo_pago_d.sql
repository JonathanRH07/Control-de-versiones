DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_metodo_pago_d`(
	IN  pr_id_grupo_empresa         INT,
    IN  pr_id_metodo_pago 			INT,
    OUT pr_affected_rows	        INT,
   	OUT pr_message		            VARCHAR(500))
BEGIN
/*
	@nombre:		sp_cat_metodo_pago_d
	@fecha:			19/09/2016
	@descripcion:	SP para eliminar un método de pago
	@autor:			Alan Olivares
	@cambios:
*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		 SET pr_message = 'ERROR store sp_cat_metodo_pago_d';
         SET pr_affected_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;
	IF f_can_remove_row() THEN
		DELETE
			FROM
				ic_glob_tr_metodo_pago
			WHERE
				id_grupo_empresa = pr_id_grupo_empresa AND
				id_metodo_pago = pr_id_metodo_pago;

		SELECT
			ROW_COUNT()
		INTO
			pr_affected_rows
		FROM dual;

		SET pr_message = 'SUCCESS';

		COMMIT;
    ELSE
        SET pr_message = 'ERROR store sp_cat_metodo_pago_d';
        SET pr_affected_rows = 0;
		ROLLBACK;
    END IF;



END$$
DELIMITER ;
