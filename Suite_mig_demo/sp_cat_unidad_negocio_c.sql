DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_cat_unidad_negocio_c`(
	IN  pr_id_grupo_empresa			INT,
    IN  pr_id_unidad_negocio		INT,
    IN  pr_cve_unidad_negocio		VARCHAR(45),
    IN  pr_desc_unidad_negocio		VARCHAR(45),
	IN  pr_estatus_unidad_negocio	ENUM('ACTIVO', 'INACTIVO'),
    IN  pr_ini_pag 					INT,
    IN  pr_fin_pag 					INT,
    IN  pr_order_by					VARCHAR(30),
    OUT pr_rows_tot_table  			INT,
    OUT pr_message 					VARCHAR(500))
BEGIN
/*
    @nombre:		sp_cat_unidad_negocio_c
	@fecha:			04/08/2016
	@descripción : 	Stored procedure to check records catalog business unit .
	@autor : 		Odeth Negrete
	@cambios:   	19/08/2016  - Alan Olivares
*/

	DECLARE lo_id_unidad_negocio 	VARCHAR(100);
    DECLARE lo_ver_estatus			VARCHAR(100);
    DECLARE lo_cve_unidad_negocio 	VARCHAR(200);
	DECLARE lo_desc_unidad_negocio 	VARCHAR(200);
    DECLARE lo_order_by 			VARCHAR(200);


	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_cat_unidad_negocio_c';
	END ;

    IF pr_id_unidad_negocio > 0 THEN
		SET lo_id_unidad_negocio = CONCAT(' AND id_unidad_negocio =  ', pr_id_unidad_negocio);
	ELSE
		SET lo_id_unidad_negocio = ' ';
    END IF;

	IF pr_estatus_unidad_negocio != '' THEN
		SET lo_ver_estatus = CONCAT(' AND estatus_unidad_negocio =  "', pr_estatus_unidad_negocio, '" ');
	ELSE
		SET lo_ver_estatus = ' ';
    END IF;

    IF pr_cve_unidad_negocio != '' AND pr_desc_unidad_negocio = pr_cve_unidad_negocio THEN
		SET lo_cve_unidad_negocio = CONCAT(' AND (cve_unidad_negocio LIKE "%', pr_cve_unidad_negocio
								, '%"  OR desc_unidad_negocio LIKE "%', pr_desc_unidad_negocio, '%" ) ');
		SET lo_desc_unidad_negocio = '';
    ELSE

		IF pr_cve_unidad_negocio != '' THEN
			SET lo_cve_unidad_negocio = CONCAT(' AND cve_unidad_negocio LIKE "%', pr_cve_unidad_negocio, '%" ');
		ELSE
			SET lo_cve_unidad_negocio = ' ';
		END IF;

		IF pr_desc_unidad_negocio != '' THEN
			SET lo_desc_unidad_negocio= CONCAT(' AND desc_unidad_negocio LIKE "%', pr_desc_unidad_negocio, '%" ');
		ELSE
			SET lo_desc_unidad_negocio= ' ';
		END IF;
	END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
	ELSE
		SET lo_order_by = ' ';
    END IF;



    SET @query = CONCAT('SELECT
								id_unidad_negocio,
								cve_unidad_negocio,
								desc_unidad_negocio,
                                estatus_unidad_negocio
						   FROM
								ic_cat_tc_unidad_negocio
							WHERE id_grupo_empresa = ?',
								lo_id_unidad_negocio,
								lo_ver_estatus,
								lo_cve_unidad_negocio,
								lo_desc_unidad_negocio,
								lo_order_by,
								' LIMIT ?,?');

    PREPARE stmt FROM @query;

	SET @id_grupo_empresa = pr_id_grupo_empresa;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @id_grupo_empresa, @ini, @fin;

	DEALLOCATE PREPARE stmt;
	#END main query

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_cat_tc_unidad_negocio
					WHERE id_grupo_empresa = ? ',
						lo_id_unidad_negocio,
						lo_ver_estatus,
						lo_cve_unidad_negocio,
						lo_desc_unidad_negocio);

	PREPARE stmt FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;

	SET pr_rows_tot_table = @pr_rows_tot_table;
     # Mensaje de ejecución.
	SET pr_message 	   = 'SUCCESS';
END$$
DELIMITER ;
