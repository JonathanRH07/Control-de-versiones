DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_help_get_row_count_params`(
	IN  pr_table 				VARCHAR(45),
    IN  pr_id_grupo_empresa     INT(11),
    IN 	pr_extra_where 			TEXT,
    OUT pr_row_count 	     	INT,
    OUT pr_message 	         	VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_help_get_row_count_params
	@fecha: 		13/09/2016
	@descripcion:
    @autor: 		Alan Olivares
	@cambios:
*/
	DECLARE lo_id_grupo_empresa			VARCHAR(100);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_help_get_row_count_params';
        SET pr_row_count = 0;
		ROLLBACK;
	END;

    IF pr_id_grupo_empresa > 0 THEN
		SET lo_id_grupo_empresa = CONCAT(' id_grupo_empresa = ', pr_id_grupo_empresa, ' AND ');
    ELSE
		SET lo_id_grupo_empresa = '';
    END IF;

	SET @pr_rows_tot_table = 0;


	SET @queryTotalRows = CONCAT('
			 SELECT
			  COUNT(*)
			 INTO
			  @pr_rows_tot_table
			 FROM ',pr_table,'
			 WHERE ',lo_id_grupo_empresa,
             pr_extra_where);


	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	SET pr_row_count = @pr_rows_tot_table;

END$$
DELIMITER ;
