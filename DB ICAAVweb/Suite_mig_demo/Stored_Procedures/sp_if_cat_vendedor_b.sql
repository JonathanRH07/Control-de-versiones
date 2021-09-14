DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_if_cat_vendedor_b`(
	IN  pr_id_grupo_empresa  INT,
	IN  pr_consulta_gral  VARCHAR(200),
	IN  pr_ini_pag		  INT(11),
	IN  pr_fin_pag		  INT(11),
	IN  pr_order_by		  VARCHAR(100),
	OUT pr_rows_tot_table INT,
	OUT pr_message		  VARCHAR(5000)
)
BEGIN
/*
	@nombre: 		sp_if_cat_vendedor_b
	@fecha: 		09/04/2018
	@descripcion: 	SP para buscar registros en qualquier campo por texto o carácter Alfanumérico en la tabla ic_if_tr_cat_vendedor
	@autor:  		David Roldan Solares
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_consulta_gral  			VARCHAR(1000) DEFAULT '';
	DECLARE lo_order_by 				VARCHAR(200) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_if_cat_vendedor_b';
	END ;

    # Busqueda General
	# Realiza la Buqueda en qualquier campo por texto o carácter Alfanumérico
    IF ( pr_consulta_gral != '' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (nombre LIKE "%'		, pr_consulta_gral, '%"
										OR cve_gds_sa LIKE "%'		, pr_consulta_gral, '%"
                                        OR cve_gds_am LIKE "%'		, pr_consulta_gral, '%"
                                        OR cve_gds_ws LIKE "%'		, pr_consulta_gral, '%"
                                        OR cve_gds_ap LIKE "%'		, pr_consulta_gral, '%"
                                        ) ');
	END IF;

	# Busqueda por ORDER BY
	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	END IF;

    SET @query = CONCAT('SELECT *
						 FROM ic_cat_tr_vendedor
                         WHERE id_grupo_empresa = ? ',
                         lo_consulta_gral,
                         pr_order_by,
                         ' LIMIT ?,?;');

	PREPARE stmt
	FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;

    # START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_cat_tr_vendedor
                         WHERE id_grupo_empresa = ? ',
                         lo_consulta_gral);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
    # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
