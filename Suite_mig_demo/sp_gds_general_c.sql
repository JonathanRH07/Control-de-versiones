DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_general_c`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_gds_general		INT,
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_general_c
	@fecha: 		25/06/2018
	@descripcion: 	SP para buscar un registro especifico en la tabla de ic_gds_tr_general
	@autor:  		Yazbek Kido
	@cambios:
*/


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_general_c';
	END ;



	SET @query = 'Select
							*
						FROM ic_gds_tr_general
						WHERE id_grupo_empresa = ? AND id_gds_generall = ?';
-- select @query;
    PREPARE stmt FROM @query;
	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @id_gds_general = pr_id_gds_general;

	EXECUTE stmt USING @id_grupo_empresa, @id_gds_general;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = '
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_gds_tr_general
						WHERE id_grupo_empresa = ? AND id_gds_generall = ?';

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa, @id_gds_general;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
