DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_analisis_f`(
	IN  pr_id_grupo_empresa		INT(11),
	IN  pr_id_gds_general 		INT,
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_autos_f
	@fecha: 		29/07/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_autos
	@autor:  		Yazbek Kido
	@cambios:
*/
    # Declaración de variables.
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
    DECLARE lo_id_gds_general		VARCHAR(300) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
        SET pr_message = 'ERROR store sp_gds_analisis_f';
	END ;

    IF pr_id_gds_general > 0 THEN
		SET lo_id_gds_general = CONCAT(' AND analisis.id_gds_general = ', pr_id_gds_general,' ');
    END IF;

    IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;


	SET @query = CONCAT('SELECT
							analisis.*
						FROM ic_gds_tr_analisis analisis
                        INNER JOIN ic_gds_tr_general general ON
							general.id_gds_generall = analisis.id_gds_general
						WHERE general.id_grupo_empresa = ?',
							lo_id_gds_general,
							lo_order_by,
						   ' LIMIT ?,?');
-- select @query;
    PREPARE stmt FROM @query;
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
                    FROM ic_gds_tr_analisis analisis
					INNER JOIN ic_gds_tr_general general ON
						general.id_gds_generall = analisis.id_gds_general
					WHERE general.id_grupo_empresa = ?',
						lo_id_gds_general
					);

	PREPARE stmt
	FROM @queryTotalRows;
	EXECUTE stmt USING @id_grupo_empresa;
	DEALLOCATE PREPARE stmt;
	SET pr_rows_tot_table = @pr_rows_tot_table;

	# Mensaje de ejecucion.
	SET pr_message   = 'SUCCESS';
END$$
DELIMITER ;
