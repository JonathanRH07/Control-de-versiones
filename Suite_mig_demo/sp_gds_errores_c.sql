DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_errores_c`(
	IN  pr_id_gds_general		INT,
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_errores_c
	@fecha: 		27/06/2018
	@descripcion: 	SP para buscar los errores que concidan con id_gds_general
	@autor:  		Yazbek Kido
	@cambios:
*/


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_errores_c';
	END ;

	SET @query = concat('Select * FROM ic_gds_tr_errores WHERE id_gds_general = ', pr_id_gds_general ,' ');

-- select @query;
    PREPARE stmt FROM @query;
	EXECUTE stmt;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = concat('Select COUNT(*) INTO @pr_rows_tot_table FROM ic_gds_tr_errores WHERE id_gds_general = ', pr_id_gds_general ,' ');


	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
