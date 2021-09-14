DELIMITER $$
CREATE DEFINER=`suite_deve`@`%` PROCEDURE `sp_gds_cadenas_f`(
	IN  pr_id_gds_cadenas		INT(11),
	IN  pr_cve_cadena			CHAR(3),
	IN  pr_nombre				VARCHAR(80),
    IN  pr_consulta_gral		VARCHAR(200),
    IN  pr_ini_pag 				INT,
    IN  pr_fin_pag 				INT,
    IN  pr_order_by				VARCHAR(100),
    OUT pr_rows_tot_table		INT,
    OUT pr_message 				VARCHAR(500))
BEGIN
/*
	@nombre: 		sp_gds_cadenas_f
	@fecha: 		06/04/2018
	@descripcion: 	SP para filtrar registros en la tabla ic_gds_tr_cadenas
	@autor:  		Griselda Medina Medina
	@cambios:
*/
    # Declaración de variables.
	DECLARE lo_id_gds_cadenas 		VARCHAR(300) DEFAULT '';
	DECLARE lo_cve_cadena			VARCHAR(300) DEFAULT '';
	DECLARE lo_nombre				VARCHAR(300) DEFAULT '';
    DECLARE lo_order_by 			VARCHAR(300) DEFAULT '';
	DECLARE lo_consulta_gral  		VARCHAR(1000) DEFAULT '';

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET pr_message = 'ERROR store sp_gds_cadenas_f';
	END ;

	IF pr_id_gds_cadenas > 0 THEN
		SET lo_id_gds_cadenas = CONCAT(' AND id_gds_cadenas = ', pr_id_gds_cadenas, ' ');
	END IF;

    IF pr_cve_cadena != '' THEN
		SET lo_cve_cadena = CONCAT(' AND cve_cadena LIKE "%', pr_cve_cadena, '%" ');
	END IF;

    IF pr_nombre != '' THEN
		SET lo_nombre = CONCAT(' AND nombre LIKE "%', pr_nombre, '%" ');
	END IF;

    IF ( pr_consulta_gral !='' ) THEN
		SET lo_consulta_gral = CONCAT(' AND (cve_cadena LIKE "%'	, pr_consulta_gral, '%"
										OR nombre LIKE "%'		, pr_consulta_gral, '%" ) ');
	END IF;

	IF pr_order_by > '' THEN
		SET lo_order_by = CONCAT(' ORDER BY ', pr_order_by, ' ');
    END IF;

	SET @query = CONCAT('SELECT
							*
						FROM
							ic_gds_tr_cadenas
						WHERE true ',
							lo_id_gds_cadenas,
							lo_cve_cadena,
							lo_nombre,
                            lo_consulta_gral,
							lo_order_by,
						   ' LIMIT ?,?');
-- select @query;
    PREPARE stmt FROM @query;
    SET @ini = pr_ini_pag;
    SET @fin = pr_fin_pag;

	EXECUTE stmt USING  @ini, @fin;

	DEALLOCATE PREPARE stmt;

	# START count rows query
	SET @pr_rows_tot_table = '';
	SET @queryTotalRows = CONCAT('
					SELECT
						COUNT(*)
					INTO
						@pr_rows_tot_table
					FROM ic_gds_tr_cadenas
					WHERE true ',
						lo_id_gds_cadenas,
						lo_cve_cadena,
						lo_nombre,
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
