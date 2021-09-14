DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_mailing_list_d`(
	IN  pr_id_gds_mailing_list      INT,
    IN	pr_id_grupo_empresa			INT,
    OUT pr_affect_rows      	 	INT,
    OUT pr_message 	         	 	VARCHAR(500)
)
BEGIN
/*
	@nombre: 		sp_gds_mailing_list_d
	@fecha: 		13/01/2017
	@descripcion: 	SP para eliminar registros en la tabla ic_gds_tr_mailing_list
    @author: 		David Roldan Solares
	@cambios:
*/

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_gds_mailing_list_d';
        SET pr_affect_rows = 0;
		ROLLBACK;
	END;

	START TRANSACTION;

    DELETE FROM	ic_gds_tr_mailing_list
	WHERE id_gds_mailing_list = pr_id_gds_mailing_list
    AND id_grupo_empresa = pr_id_grupo_empresa;

	SELECT
		ROW_COUNT()
	INTO
		pr_affect_rows
	FROM dual;

		SET pr_message = 'SUCCESS';

    COMMIT;
END$$
DELIMITER ;
