DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_glob_aerolinea_c`(
	IN  pr_clave_aerolinea			CHAR(5),
    IN  pr_nombre_aerolinea			VARCHAR(255),
	IN  pr_ini_pag					INT(11),
	IN  pr_fin_pag					INT(11),
    OUT pr_rows_tot_table  			INT,
	OUT	pr_message 					VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_glob_aerolinea_c
	@fecha: 		20/02/2017
	@descripcion: 	SP para consultar las aerolineas
	@autor: 		Griselda Meidna Medina
	@cambios:
*/

	DECLARE  lo_clave_aerolinea			VARCHAR(1000) DEFAULT '';
	DECLARE  lo_nombre_aerolinea		VARCHAR(1000) DEFAULT '';
    DECLARE  lo_limit					VARCHAR(30) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET pr_message = 'ERROR store sp_glob_aerolinea_c';
	END ;

    IF pr_clave_aerolinea != '' THEN
		SET lo_clave_aerolinea  = CONCAT(' AND clave_aerolinea  LIKE "%', pr_clave_aerolinea  ,'%"');
	END IF;

	IF pr_nombre_aerolinea != '' THEN
		SET lo_nombre_aerolinea  = CONCAT(' AND nombre_aerolinea LIKE "%', pr_nombre_aerolinea  ,'%"');
	END IF;

    IF pr_fin_pag > 0 THEN
		SET lo_limit  = CONCAT(' LIMIT ',pr_ini_pag, ',',pr_fin_pag);
	END IF;

	SET @query = CONCAT('SELECT
							*
							, CONCAT(clave_aerolinea," - ",nombre_aerolinea) AS concat_a
						FROM
							ct_glob_tc_aerolinea
						WHERE
							estatus = 1 ',
                            lo_clave_aerolinea,
                            lo_nombre_aerolinea,
                            lo_limit
						);

	PREPARE stmt FROM @query;
    EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

    # START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
						SELECT
							count(*)
						INTO
							@pr_rows_tot_table
						FROM
							ct_glob_tc_aerolinea
						WHERE
							estatus = 1 ',
                            lo_clave_aerolinea,
                            lo_nombre_aerolinea
	);

    PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	# Mensaje de ejecución.
	SET pr_rows_tot_table = @pr_rows_tot_table;
	SET pr_message = 'SUCCESS';

END$$
DELIMITER ;
