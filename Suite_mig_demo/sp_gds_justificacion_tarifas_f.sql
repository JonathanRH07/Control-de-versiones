DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_justificacion_tarifas_f`(
	IN  pr_id_gds_justificacion_tarifas 	INT(11),
	IN  pr_cve_justificacion				CHAR(10),
	IN  pr_desc_corta						VARCHAR(50),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 							INT,
    IN  pr_fin_pag 							INT,
    IN  pr_order_by							VARCHAR(100),
    OUT pr_rows_tot_table					INT,
    OUT pr_message 							VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_justificacion_tarifas_f
	@fecha: 		06/04/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_justificacion_tarifas
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_id_gds_justificacion_tarifas 	VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_justificacion				VARCHAR(300) DEFAULT '';
	DECLARE lo_desc_corta						VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 						VARCHAR(300) DEFAULT '';
    DECLARE lo_consulta_gral  					VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_justificacion_tarifas_f';
	END ;

	IF pr_id_gds_justificacion_tarifas > 0 THEN
		SET lo_id_gds_justificacion_tarifas = CONCAT(' AND id_gds_justificacion_tarifas = ', pr_id_gds_justificacion_tarifas, ' ');
	END IF;

	IF pr_cve_justificacion != '' THEN
		SET lo_cve_justificacion = CONCAT(' AND cve_justificacion LIKE "%', pr_cve_justificacion, '%" ');
	END IF;

	IF pr_desc_corta != '' THEN
		SET lo_desc_corta = CONCAT(' AND desc_corta LIKE "%', pr_desc_corta, '%" ');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (cve_justificacion LIKE "%'	, pr_consulta_gral, '%"
										OR desc_corta LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	SET @query = CONCAT('SELECT
							*
						FROM
							ic_gds_tr_justificacion_tarifas
						WHERE true ',
							lo_id_gds_justificacion_tarifas,
							lo_cve_justificacion,
							lo_desc_corta,
                            lo_consulta_gral,
							lo_order_by,
						   ' LIMIT ?,?');
-- select @query;
    PREPARE stmt FROM @query;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING @ini, @fin;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_gds_tr_justificacion_tarifas
					WHERE true ',
						lo_id_gds_justificacion_tarifas,
						lo_cve_justificacion,
						lo_desc_corta,
                        lo_consulta_gral
						);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
