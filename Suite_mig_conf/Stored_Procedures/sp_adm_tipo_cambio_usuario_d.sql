DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_adm_tipo_cambio_usuario_d`(
	IN  pr_id_tipo_cambio_usuario	INT(11),
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_adm_config_moneda_d
	@fecha: 		14/08/2017
	@descripcion: 	SP para eliminar registros en la tabla de config_monedas
    @author: 		Griselda Medina Medina
	@cambios:
*/
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_adm_tipo_cambio_usuario_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;
	START TRANSACTION;

	IF suite_mig_demo.f_can_remove_row() THEN

		DELETE
		FROM
			st_adm_tc_tipo_cambio_usuario
		WHERE
			id_tipo_cambio_usuario = pr_id_tipo_cambio_usuario;

		SELECT
			ROW_COUNT()
		INTO
			pr_affect_rows
		FROM dual;

		SET pr_message = 'SUCCESS';

        COMMIT;
    ELSE
        # Mensaje de error.
        SET pr_message = 'ERROR store sp_adm_tipo_cambio_usuario_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
    END IF;
END$$
DELIMITER ;
